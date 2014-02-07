 
 require "AppWarp.WarpTypes"
 require "AppWarp.WarpConfig"
 require "AppWarp.WarpUtilities"
 local WarpClient = {}
 
 local Channel = require "AppWarp.WarpChannel"
 local LookupChannel = require "AppWarp.LookupChannel"
 
 local JSON = require "AppWarp.JSON"
 local RequestBuilder = require "AppWarp.WarpRequestBuilder"
 local sessionId = nil;
 local RecoveryTime = 0; 
 local _connectionState = WarpConnectionState.DISCONNECTED; 
 local _username
 local LookupDone = false;
 
 local RequestListenerTable = {}
 local NotificationListenerTable = {}
 
 local lastSendTime = 0
 
 function WarpClient.addRequestListener(request, listener)
   if(listener == nil) then
     return "bad parameter"
   end   
   RequestListenerTable[request] = listener
 end
 
 function WarpClient.addNotificationListener(notification, listener)
   if(listener == nil) then
     return "bad parameter"
   end   
   NotificationListenerTable[notification] = listener
 end 
 
 local function handleAuthResponse(resultCode, payLoadTable)
    if(resultCode == WarpResponseResultCode.SUCCESS) then -- Success
      WarpConfig.session_id = tonumber(payLoadTable['sessionid']);
      _connectionState = WarpConnectionState.CONNECTED;
    else
      _connectionState = WarpConnectionState.DISCONNECTED;
      Channel.socket_close()
    end   
    fireConnectionEvent(resultCode)    
  end
    
 local function onNotify(notifyType, payLoad)
    if(notifyType == WarpNotifyTypeCode.UPDATE_PEERS) then
      if(NotificationListenerTable.onUpdatePeersReceived ~= nil) then
        NotificationListenerTable.onUpdatePeersReceived(payLoad)
      end      
      return
    end    
    local payLoadTable = JSON:decode(payLoad); 
    if((notifyType == WarpNotifyTypeCode.CHAT) and (NotificationListenerTable.onChatReceived ~= nil)) then      
      NotificationListenerTable.onChatReceived(payLoadTable['sender'], payLoadTable['chat'], payLoadTable['id'], payLoadTable['isLobby'] ~= nil)
    elseif((notifyType == WarpNotifyTypeCode.PRIVATE_CHAT) and (NotificationListenerTable.onPrivateChatReceived ~= nil)) then
      NotificationListenerTable.onPrivateChatReceived(payLoadTable['sender'], payLoadTable['chat'])      
    elseif((notifyType == WarpNotifyTypeCode.USER_JOINED_ROOM) and (NotificationListenerTable.onUserJoinedRoom ~= nil)) then
      NotificationListenerTable.onUserJoinedRoom(payLoadTable['user'], payLoadTable['id'])   
    elseif((notifyType == WarpNotifyTypeCode.USER_LEFT_ROOM) and (NotificationListenerTable.onUserLeftRoom ~= nil)) then
      NotificationListenerTable.onUserLeftRoom(payLoadTable['user'], payLoadTable['id'])   
    elseif((notifyType == WarpNotifyTypeCode.USER_JOINED_LOBBY) and (NotificationListenerTable.onUserJoinedLobby ~= nil)) then
      NotificationListenerTable.onUserJoinedLobby(payLoadTable['user'])   
    elseif((notifyType == WarpNotifyTypeCode.USER_LEFT_LOBBY) and (NotificationListenerTable.onUserLeftLobby ~= nil)) then
      NotificationListenerTable.onUserLeftLobby(payLoadTable['user'])   
    elseif((notifyType == WarpNotifyTypeCode.ROOM_CREATED) and (NotificationListenerTable.onRoomCreated ~= nil)) then
      NotificationListenerTable.onRoomCreated(payLoadTable['id'], payLoadTable['name'], payLoadTable['maxUsers'])  
    elseif((notifyType == WarpNotifyTypeCode.ROOM_DELETED) and (NotificationListenerTable.onRoomDeleted ~= nil)) then
      NotificationListenerTable.onRoomDeleted(payLoadTable['id'], payLoadTable['name']) 
    elseif((notifyType == WarpNotifyTypeCode.GAME_STARTED) and (NotificationListenerTable.onGameStarted ~= nil)) then
      NotificationListenerTable.onGameStarted(payLoadTable['sender'], payLoadTable['id'], payLoadTable['nextTurn'])
    elseif((notifyType == WarpNotifyTypeCode.GAME_STOPPED) and (NotificationListenerTable.onGameStopped ~= nil)) then
      NotificationListenerTable.onGameStopped(payLoadTable['sender'], payLoadTable['id']) 
    elseif((notifyType == WarpNotifyTypeCode.MOVE_COMPLETED) and (NotificationListenerTable.onMoveCompleted ~= nil)) then
      NotificationListenerTable.onMoveCompleted(payLoadTable['sender'], payLoadTable['id'], payLoadTable['nextTurn'], payLoadTable['moveData'])        
    elseif((notifyType == WarpNotifyTypeCode.ROOM_PROPERTY_CHANGE) and (NotificationListenerTable.onUserChangedRoomProperty ~= nil)) then
      NotificationListenerTable.onUserChangedRoomProperty(payLoadTable['sender'], payLoadTable['id'], JSON:decode(payLoadTable['properties']), JSON:decode(payLoadTable['lockProperties']))      
    end           
 end
 
 local function onResponse(requestType, resultCode, payLoad)
   
   local payLoadTable = {}
   if(resultCode == WarpResponseResultCode.SUCCESS) then
      payLoadTable = JSON:decode(payLoad);  
   end    
   if(requestType == WarpRequestTypeCode.AUTH) then
     handleAuthResponse(resultCode, payLoadTable);
   elseif(requestType == WarpRequestTypeCode.JOIN_ROOM) then
     if(RequestListenerTable.onJoinRoomDone ~= nil) then
      RequestListenerTable.onJoinRoomDone(resultCode, payLoadTable['id']); 
    end    
   elseif(requestType == WarpRequestTypeCode.SUBSCRIBE_ROOM) then
     if(RequestListenerTable.onSubscribeRoomDone ~= nil) then
      RequestListenerTable.onSubscribeRoomDone(resultCode, payLoadTable['id']);
     end 
   elseif(requestType == WarpRequestTypeCode.UNSUBSCRIBE_ROOM) then
     if(RequestListenerTable.onUnsubscribeRoomDone ~= nil) then
      RequestListenerTable.onUnsubscribeRoomDone(resultCode, payLoadTable['id']);
     end
   elseif(requestType == WarpRequestTypeCode.LEAVE_ROOM) then     
     if(RequestListenerTable.onLeaveRoomDone ~= nil) then
      RequestListenerTable.onLeaveRoomDone(resultCode, payLoadTable['id']);
     end    
   elseif(requestType == WarpRequestTypeCode.JOIN_LOBBY) then     
     if(RequestListenerTable.onJoinLobbyDone ~= nil) then
      RequestListenerTable.onJoinLobbyDone(resultCode);
     end   
   elseif(requestType == WarpRequestTypeCode.LEAVE_LOBBY) then     
     if(RequestListenerTable.onLeaveLobbyDone ~= nil) then
      RequestListenerTable.onLeaveLobbyDone(resultCode);
     end   
   elseif(requestType == WarpRequestTypeCode.SUBSCRIBE_LOBBY) then     
     if(RequestListenerTable.onSubscribeLobbyDone ~= nil) then
      RequestListenerTable.onSubscribeLobbyDone(resultCode);
     end   
   elseif(requestType == WarpRequestTypeCode.UNSUBSCRIBE_LOBBY) then     
     if(RequestListenerTable.onUnsubscribeLobbyDone ~= nil) then
      RequestListenerTable.onUnsubscribeLobbyDone(resultCode);
     end   
   elseif(requestType == WarpRequestTypeCode.CREATE_ROOM) then     
     if(RequestListenerTable.onCreateRoomDone ~= nil) then
      RequestListenerTable.onCreateRoomDone(resultCode, payLoadTable['id'], payLoadTable['name']);
     end
   elseif(requestType == WarpRequestTypeCode.DELETE_ROOM) then     
     if(RequestListenerTable.onDeleteRoomDone ~= nil) then
      RequestListenerTable.onDeleteRoomDone(resultCode, payLoadTable['id']);
     end   
   elseif(requestType == WarpRequestTypeCode.CHAT) then     
     if(RequestListenerTable.onSendChatDone ~= nil) then
      RequestListenerTable.onSendChatDone(resultCode);
     end  
   elseif(requestType == WarpRequestTypeCode.PRIVATE_CHAT) then     
     if(RequestListenerTable.onSendPrivateChatDone ~= nil) then
      RequestListenerTable.onSendPrivateChatDone(resultCode);
     end       
   elseif(requestType == WarpRequestTypeCode.UPDATE_PEERS) then     
     if(RequestListenerTable.onSendUpdatePeersDone ~= nil) then
      RequestListenerTable.onSendUpdatePeersDone(resultCode);
     end      
   elseif(requestType == WarpRequestTypeCode.GET_ROOMS) then     
     if(RequestListenerTable.onGetAllRoomsDone ~= nil) then
      local roomsString = payLoadTable['ids']
      local roomsTable = splitString(roomsString, ';')
      RequestListenerTable.onGetAllRoomsDone(resultCode, roomsTable)
     end   
   elseif(requestType == WarpRequestTypeCode.GET_USERS) then     
     if(RequestListenerTable.onGetOnlineUsersDone ~= nil) then
      local usersString = payLoadTable['names']
      local usersTable = splitString(usersString, ';')       
      RequestListenerTable.onGetOnlineUsersDone(resultCode, usersTable)
     end
   elseif(requestType == WarpRequestTypeCode.GET_USER_INFO) then     
     if(RequestListenerTable.onGetLiveUserInfoDone ~= nil) then    
      RequestListenerTable.onGetLiveUserInfoDone(resultCode, payLoadTable['name'], payLoadTable['custom'], payLoadTable['locationId'], payLoadTable['isLobby'] ~= nil)
     end  
   elseif(requestType == WarpRequestTypeCode.GET_ROOM_INFO) then     
     if(RequestListenerTable.onGetLiveRoomInfoDone ~= nil) then
        if(resultCode ~= WarpResponseResultCode.SUCCESS) then
          RequestListenerTable.onGetLiveRoomInfoDone(resultCode, nil)          
        else      
          local roomTable = buildLiveRoomInfoTable(payLoadTable)
          RequestListenerTable.onGetLiveRoomInfoDone(resultCode, roomTable)
        end        
     end
   elseif(requestType == WarpRequestTypeCode.GET_LOBBY_INFO) then     
     if(RequestListenerTable.onGetLiveLobbyInfoDone ~= nil) then
        if(resultCode ~= WarpResponseResultCode.SUCCESS) then
          RequestListenerTable.onGetLiveLobbyInfoDone(resultCode, nil)          
        else      
          local roomTable = buildLiveRoomInfoTable(payLoadTable)
          RequestListenerTable.onGetLiveLobbyInfoDone(resultCode, roomTable)
        end        
     end     
   elseif(requestType == WarpRequestTypeCode.SET_CUSTOM_ROOM_DATA) then  
     if(RequestListenerTable.onSetCustomRoomDataDone ~= nil) then
        if(resultCode ~= WarpResponseResultCode.SUCCESS) then
          RequestListenerTable.onSetCustomRoomDataDone(resultCode, nil)          
        else      
          local roomTable = buildLiveRoomInfoTable(payLoadTable)
          RequestListenerTable.onSetCustomRoomDataDone(resultCode, roomTable)
        end        
     end
   elseif(requestType == WarpRequestTypeCode.SET_CUSTOM_USER_DATA) then
     if(RequestListenerTable.onSetCustomUserDataDone ~= nil) then
        RequestListenerTable.onSetCustomUserDataDone(resultCode, payLoadTable['name'], payLoadTable['custom'], payLoadTable['locationId'], payLoadTable['isLobby'] ~= nil)
     end   
   elseif(requestType == WarpRequestTypeCode.UPDATE_ROOM_PROPERTY) then
     if(RequestListenerTable.onUpdateRoomProperties ~= nil) then
        if(resultCode ~= WarpResponseResultCode.SUCCESS) then
          RequestListenerTable.onUpdateRoomProperties(resultCode, nil)          
        else      
          local roomTable = buildLiveRoomInfoTable(payLoadTable)
          RequestListenerTable.onUpdateRoomProperties(resultCode, roomTable)
        end
     end                 
   elseif((requestType == WarpRequestTypeCode.JOIN_ROOM_WITH_PROPERTIES) or (requestType == WarpRequestTypeCode.JOIN_ROOM_IN_RANGE)) then
     if(RequestListenerTable.onJoinRoomDone ~= nil) then
        RequestListenerTable.onJoinRoomDone(resultCode, payLoadTable['id'])
     end    
   elseif((requestType == WarpRequestTypeCode.GET_ROOM_WITH_PROPERTIES) or (requestType == WarpRequestTypeCode.GET_ROOM_IN_RANGE)) then
     if(RequestListenerTable.onGetMatchedRoomsDone ~= nil) then
        if(resultCode ~= WarpResponseResultCode.SUCCESS) then
          RequestListenerTable.onGetMatchedRoomsDone(resultCode, nil)          
        else      
          local roomsTable = buildMatchedRoomsTable(payLoadTable)
          RequestListenerTable.onGetMatchedRoomsDone(resultCode, roomsTable)
        end
     end
   elseif(requestType == WarpRequestTypeCode.LOCK_PROPERTIES) then     
     if(RequestListenerTable.onLockPropertiesDone ~= nil) then
      RequestListenerTable.onLockPropertiesDone(resultCode);
     end    
   elseif(requestType == WarpRequestTypeCode.UNLOCK_PROPERTIES) then     
     if(RequestListenerTable.onUnlockPropertiesDone ~= nil) then
      RequestListenerTable.onUnlockPropertiesDone(resultCode);
     end    
   elseif((requestType == WarpRequestTypeCode.MOVE) and (RequestListenerTable.onSendMoveDone ~= nil)) then
      RequestListenerTable.onSendMoveDone(resultCode);
   elseif((requestType == WarpRequestTypeCode.START_GAME) and (RequestListenerTable.onStartGameDone ~= nil)) then
      RequestListenerTable.onStartGameDone(resultCode);
   elseif((requestType == WarpRequestTypeCode.STOP_GAME) and (RequestListenerTable.onStopGameDone ~= nil)) then
      RequestListenerTable.onStopGameDone(resultCode);
   elseif((requestType == WarpRequestTypeCode.GET_MOVE_HISTORY) and (RequestListenerTable.onGetMoveHistoryDone ~= nil)) then
      local historyTable = nil
      if(resultCode == WarpResponseResultCode.SUCCESS) then
        historyTable = buildMoveHistoryTable(payLoadTable)
      end
      RequestListenerTable.onGetMoveHistoryDone(resultCode, historyTable); 
   end   
 end 
    
 function WarpClient.initialize(api, secret, host)
   WarpConfig.apiKey = api
   WarpConfig.secretKey = secret
   WarpConfig.WarpClient = WarpClient   
   if(host ~= nil) then
     LookupDone = true
     WarpConfig.warp_host = host
   end
 end
 
 function WarpClient.enableTrace(enable)
   WarpConfig.trace = enable
 end

 function WarpClient.receivedData(data)
   if(string.len(data)>0) then 
     local parsedLen = 0
     local dataLen = string.len(data)
     while(parsedLen < dataLen) do
       local messageType = string.byte(data, parsedLen+1, parsedLen+1)
       if(messageType == WarpMessageTypeCode.RESPONSE) then
         local requestType, resultCode, payLoad, messageLen  = decodeWarpResponseMessage(partial, parsedLen);
         parsedLen = parsedLen + messageLen
         onResponse(requestType, resultCode, payLoad)
       elseif(messageType == WarpMessageTypeCode.UPDATE) then
         local notifyType, payload, messageLen = decodeWarpNotifyMessage(partial, parsedLen)
         parsedLen = parsedLen + messageLen
         onNotify(notifyType, payload)
       else
         assert(false)
       end
     end
   end  
 end
   
 function WarpClient.lookupDone(success)
   if(success) then
     LookupDone = true;
   else
     _connectionState = WarpConnectionState.DISCONNECTED
     fireConnectionEvent(WarpResponseResultCode.CONNECTION_ERROR);
   end
 end
   
 function WarpClient.connectWithUserName(username)
    if (username==nil or isUserNameValid(username) == false) then
        fireConnectionEvent(WarpResponseResultCode.BAD_REQUEST);
        return;
    elseif (_connectionState ~= WarpConnectionState.DISCONNECTED and _connectionState ~= WarpConnectionState.DISCONNECTING) then
        fireConnectionEvent(WarpResponseResultCode.BAD_REQUEST);
        return;
    end
    _username = username
    _connectionState = WarpConnectionState.CONNECTING;
 end
   
   function WarpClient.onConnect(success)
     if(success == true) then
        local warpMessage = RequestBuilder.buildAuthRequest(_username, 0);
        Channel.socket_send(warpMessage);
     elseif(_connectionState == WarpConnectionState.DISCONNECTING) then
       _connectionState = WarpConnectionState.DISCONNECTED; 
       if(RequestListenerTable.onDisconnectDone ~= nil) then
         RequestListenerTable.onDisconnectDone(WarpResponseResultCode.SUCCESS)
       end
     elseif(_connectionState ~= WarpConnectionState.DISCONNECTED) then
       _connectionState = WarpConnectionState.DISCONNECTED; 
       fireConnectionEvent(WarpResponseResultCode.CONNECTION_ERROR)            
     end
   end
     
   function fireConnectionEvent(resultCode)     
     if(RequestListenerTable.onConnectDone ~= nil) then
       RequestListenerTable.onConnectDone(resultCode)
     end 
   end
     
   function WarpClient.Loop()   

     if( not(LookupDone) and not(LookupChannel.isConnected) and (_connectionState == WarpConnectionState.CONNECTING)) then
       LookupChannel.socket_connect()
     end
     if(not(LookupDone) and LookupChannel.isConnected) then
       LookupChannel.socket_recv()
     end     
     if((LookupDone == true) and (Channel.isConnected == false) and (_connectionState == WarpConnectionState.CONNECTING)) then
       Channel.socket_connect()
     end     
     if(Channel.isConnected == true) then
      Channel.socket_recv();
     end
     if((_connectionState == WarpConnectionState.CONNECTED) and ((os.time() - lastSendTime) > 2)) then
       WarpClient.sendKeepAlive()
       lastSendTime = os.time()
     end     
   end
   
   function WarpClient.sendKeepAlive()
     local keepAliveMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.KEEP_ALIVE, 0, WarpContentTypeCode.FLAT_STRING, 0, nil);
     Channel.socket_send(keepAliveMsg);     
   end
   
   function WarpClient.disconnect() 
        if(_connectionState == WarpConnectionState.DISCONNECTED or _connectionState == WarpConnectionState.DISCONNECTING) then
          if(RequestListenerTable.onDisconnectDone ~= nil) then
            RequestListenerTable.onDisconnectDone(WarpResponseResultCode.BAD_REQUEST)            
            return;
          end          
        end
        userName = "";
        sessionId = 0;
        _connectionState = WarpConnectionState.DISCONNECTING;
        
        local signoutMsg = RequestBuilder.buildWarpRequest(WarpRequestTypeCode.SIGNOUT,
            sessionId, 0, WarpMessageTypeCode.REQUEST, 0,
            WarpContentTypeCode.BINARY, 0, nil);
        Channel.socket_send(signoutMsg);
 end
 
  function WarpClient.joinLobby() 
    warplog('WarpClient.joinLobby')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local lobbyMsg = RequestBuilder.buildLobbyRequest(WarpRequestTypeCode.JOIN_LOBBY)
    Channel.socket_send(lobbyMsg);
 end 
 
  function WarpClient.leaveLobby() 
    warplog('WarpClient.leaveLobby')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local lobbyMsg = RequestBuilder.buildLobbyRequest(WarpRequestTypeCode.LEAVE_LOBBY)
    Channel.socket_send(lobbyMsg);
 end 
 
  function WarpClient.subscribeLobby() 
    warplog('WarpClient.subscribeLobby')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local lobbyMsg = RequestBuilder.buildLobbyRequest(WarpRequestTypeCode.SUBSCRIBE_LOBBY)
    Channel.socket_send(lobbyMsg);
 end 
 
  function WarpClient.unsubscribeLobby() 
    warplog('WarpClient.unsubscribeLobby')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local lobbyMsg = RequestBuilder.buildLobbyRequest(WarpRequestTypeCode.UNSUBSCRIBE_LOBBY)
    Channel.socket_send(lobbyMsg);
 end 
 
  function WarpClient.getLiveLobbyInfo() 
    warplog('WarpClient.getLiveLobbyInfo')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then       
        return;
    end    
    local lobbyMsg = RequestBuilder.buildLobbyRequest(WarpRequestTypeCode.GET_LOBBY_INFO)
    Channel.socket_send(lobbyMsg);
  end 
 
  function WarpClient.joinRoom(roomid) 
    warplog('WarpClient.joinRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local joinRoomMsg = RequestBuilder.buildRoomRequest(WarpRequestTypeCode.JOIN_ROOM, roomid)
    Channel.socket_send(joinRoomMsg);
 end 
 
  function WarpClient.deleteRoom(roomid) 
    warplog('WarpClient.deleteRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local delRoomMsg = RequestBuilder.buildRoomRequest(WarpRequestTypeCode.DELETE_ROOM, roomid)
    Channel.socket_send(delRoomMsg);
 end 
 
  function WarpClient.getLiveRoomInfo(roomid) 
    warplog('WarpClient.getLiveRoomInfo')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local delRoomMsg = RequestBuilder.buildRoomRequest(WarpRequestTypeCode.GET_ROOM_INFO, roomid)
    Channel.socket_send(delRoomMsg);
 end 
 
  function WarpClient.unsubscribeRoom(roomid) 
    warplog('WarpClient.unsubscribeRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then     
        
        return;
    end    
    local joinRoomMsg = RequestBuilder.buildRoomRequest(WarpRequestTypeCode.UNSUBSCRIBE_ROOM, roomid)
    Channel.socket_send(joinRoomMsg);
 end 
 
  function WarpClient.leaveRoom(roomid) 
    warplog('WarpClient.leaveRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then     
        
        return;
    end    
    local joinRoomMsg = RequestBuilder.buildRoomRequest(WarpRequestTypeCode.LEAVE_ROOM, roomid)
    Channel.socket_send(joinRoomMsg);
 end 
 
  function WarpClient.subscribeRoom(roomid)
    warplog('WarpClient.subscribeRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local joinRoomMsg = RequestBuilder.buildRoomRequest(WarpRequestTypeCode.SUBSCRIBE_ROOM, roomid)
    Channel.socket_send(joinRoomMsg);
 end 
 
  function WarpClient.sendChat(message)
    warplog('WarpClient.sendChat')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local chatMsg = RequestBuilder.buildChatRequest(message)
    Channel.socket_send(chatMsg);
  end 
 
  function WarpClient.sendUpdatePeers(message)
    warplog('WarpClient.sendUpdatePeers')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local updateMsg = RequestBuilder.buildUpdatePeersRequest(message)
    Channel.socket_send(updateMsg);
  end  
 
  function WarpClient.sendPrivateChat(username, message)
    warplog('WarpClient.sendPrivateChat')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local chatMsg = RequestBuilder.buildPrivateChatRequest(username, message)
    Channel.socket_send(chatMsg);
  end 
 
  function WarpClient.createRoom(name, owner, maxUsers, properties)
    warplog('WarpClient.createRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local roomMsg = RequestBuilder.buildCreateRoomRequest(name, owner, maxUsers, properties, 0)
    Channel.socket_send(roomMsg);    
  end  
  
  function WarpClient.createTurnRoom(name, owner, maxUsers, properties, turnTime)
    warplog('WarpClient.createTurnRoom')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local roomMsg = RequestBuilder.buildCreateRoomRequest(name, owner, maxUsers, properties, turnTime)
    Channel.socket_send(roomMsg);    
  end
  
  function WarpClient.sendMove(moveData)
      warplog('WarpClient.sendMove')
      if(_connectionState ~= WarpConnectionState.CONNECTED) then             
          return;      
      end
      local moveTable = {}
      moveTable.moveData = moveData
      local moveMessage = JSON:encode(moveTable); 
      local warpMessage = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.MOVE, 0, WarpContentTypeCode.JSON, string.len(moveMessage), tostring(moveMessage));  
      Channel.socket_send(warpMessage);
  end
  
  function WarpClient.startGame()
    warplog('WarpClient.startGame')
      if(_connectionState ~= WarpConnectionState.CONNECTED) then             
          return;      
      end    
   local startMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.START_GAME, 0, WarpContentTypeCode.FLAT_STRING, 0, nil);
    Channel.socket_send(startMsg);       
  end
  
  function WarpClient.stopGame()
    warplog('WarpClient.stopGame')
      if(_connectionState ~= WarpConnectionState.CONNECTED) then             
          return;      
      end    
   local stopMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.STOP_GAME, 0, WarpContentTypeCode.FLAT_STRING, 0, nil);
    Channel.socket_send(stopMsg);       
  end
  
  function WarpClient.getMoveHistory()
      warplog('WarpClient.getMoveHistory')
      if(_connectionState ~= WarpConnectionState.CONNECTED) then             
          return;      
      end
      local historyTable = {}
      historyTable.count = 5
      local historyMessage = JSON:encode(historyTable); 
      local warpMessage = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.GET_MOVE_HISTORY, 0, WarpContentTypeCode.JSON, string.len(historyMessage), tostring(historyMessage));  
      Channel.socket_send(warpMessage);
  end
  
  function WarpClient.getAllRooms()
    warplog('WarpClient.getAllRooms')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end        
   local roomsMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.GET_ROOMS, 0, WarpContentTypeCode.FLAT_STRING, 0, nil);
    Channel.socket_send(roomsMsg);    
  end    
    
  function WarpClient.getOnlineUsers()
    warplog('WarpClient.getOnlineUsers')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end        
   local roomsMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.GET_USERS, 0, WarpContentTypeCode.FLAT_STRING, 0, nil);
    Channel.socket_send(roomsMsg);    
  end  
 
  function WarpClient.getLiveUserInfo(username) 
    warplog('WarpClient.getLiveUserInfo')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local warpMsg = RequestBuilder.buildUserInfoRequest(username)
    Channel.socket_send(warpMsg);
  end 
 
  function WarpClient.setCustomUserData(username, data) 
    warplog('WarpClient.setCustomUserData')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local warpMsg = RequestBuilder.buildSetUserDataRequest(username, data)
    Channel.socket_send(warpMsg);
  end 
  
  function WarpClient.setCustomRoomData(roomid, data) 
    warplog('WarpClient.setCustomRoomData')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local warpMsg = RequestBuilder.buildSetRoomDataRequest(roomid, data)
    Channel.socket_send(warpMsg);
  end 
  
  function WarpClient.updateRoomProperties(roomid, newProperties, removeProperties) 
    warplog('WarpClient.updateRoomProperties')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end
    local reqBodyTable = {}
    reqBodyTable.id = roomid
    reqBodyTable.addOrUpdate = newProperties    
    local removeString = table.concat(removeProperties, ';')
    reqBodyTable.remove = removeString
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.UPDATE_ROOM_PROPERTY, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);
  end   
  
  function WarpClient.joinRoomWithProperties(matchProperties) 
    warplog('WarpClient.joinRoomWithProperties')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local reqBodyTable = {}
    reqBodyTable.properties = matchProperties
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.JOIN_ROOM_WITH_PROPERTIES, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);
  end 
  
  function WarpClient.getRoomsWithProperties(matchProperties) 
    warplog('WarpClient.getRoomsWithProperties')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local reqBodyTable = {}
    reqBodyTable.properties = matchProperties
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.GET_ROOM_WITH_PROPERTIES, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);
  end 
  
  function WarpClient.lockProperties(lockPropertiesTable)
    warplog('WarpClient.lockProperties')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end
    local reqBodyTable = {}
    reqBodyTable.lockProperties = lockPropertiesTable
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.LOCK_PROPERTIES, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);
  end     
    
  function WarpClient.unlockProperties(unlockPropertiesArray)
    warplog('WarpClient.unlockProperties')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end
    local reqBodyTable = {}
    local unlockPropString = table.concat(unlockPropertiesArray, ';')
    reqBodyTable.unlockProperties = unlockPropString
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.UNLOCK_PROPERTIES, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);
  end
  
  function WarpClient.joinRoomInRange(minUsers, maxUsers, maxPreferred)
    warplog('WarpClient.joinRoomInRange')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local reqBodyTable = {}
    reqBodyTable.minUsers = minUsers
    reqBodyTable.maxUsers = maxUsers
    reqBodyTable.maxPreferred = maxPreferred
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.JOIN_ROOM_IN_RANGE, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);    
  end
  
  function WarpClient.getRoomsInRange(minUsers, maxUsers)
    warplog('WarpClient.getRoomsInRange')
    if(_connectionState ~= WarpConnectionState.CONNECTED) then             
        return;
    end    
    local reqBodyTable = {}
    reqBodyTable.minUsers = minUsers
    reqBodyTable.maxUsers = maxUsers
    local reqPayload = tostring(JSON:encode(reqBodyTable))
    local lengthPayload = string.len(reqPayload);
    local warpMsg = RequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.GET_ROOM_IN_RANGE, 0, WarpContentTypeCode.JSON, lengthPayload, reqPayload);
    Channel.socket_send(warpMsg);
  end
  
 return WarpClient
 