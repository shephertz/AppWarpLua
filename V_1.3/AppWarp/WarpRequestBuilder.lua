
local JSON = require "AppWarp.JSON"

local WarpRequestBuilder = {}

  function WarpRequestBuilder.buildWarpRequest(calltype, sessionId, requestid, requestType, reserved, payloadType, payLoadSize, payLoad)
    local requestString ;
    requestString = string.char(calltype)
    requestString = requestString .. string.char(requestType)
    requestString = requestString .. appendIntegerInRquestString(sessionId);
    requestString = requestString .. appendIntegerInRquestString(requestid);
    requestString = requestString .. string.char(reserved)
    requestString = requestString .. string.char(payloadType)
    requestString = requestString .. appendIntegerInRquestString(payLoadSize);
    if(payLoad ~= nil) then    
      requestString = requestString .. payLoad
    end  
    return requestString  
 end
 
  function WarpRequestBuilder.buildAuthRequest(user, sid)
   local timeStamp = os.time()*1000;
   authTable ={}
   authTable["version"] =  "Lua_1.0";
   authTable["timeStamp"] =  timeStamp;
   authTable["user"] =  user;
   authTable["apiKey"] =  WarpConfig.apiKey;
   authTable["signature"] =  calculateSignature(WarpConfig.apiKey, "Lua_1.0", user, timeStamp, WarpConfig.secretKey);
   authTable["keepalive"] =  WarpConfig.keepAliveInterval;
   authTable["recoverytime"] =  RecoveryTime;
   local authMessage = JSON:encode(authTable);  
   local lengthPayload = string.len(tostring(authMessage));
   local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, sid, 0, WarpRequestTypeCode.AUTH, 0, WarpContentTypeCode.JSON, lengthPayload, tostring(authMessage));
   return warpMessage
 end
 
  function WarpRequestBuilder.buildRoomRequest(code, roomid)
   local roomTable ={}
   roomTable["id"] =  roomid;  
   local roomMessage = JSON:encode(roomTable);  
   local lengthPayload = string.len(tostring(roomMessage));
   local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, code, 0, WarpContentTypeCode.JSON, lengthPayload, tostring(roomMessage));
   return warpMessage
 end 
 
  function WarpRequestBuilder.buildUserInfoRequest(username)
   local userTable ={}
   userTable["name"] =  username;  
   local userMessage = JSON:encode(userTable);  
   local lengthPayload = string.len(tostring(userMessage));
   local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.GET_USER_INFO, 0, WarpContentTypeCode.JSON, lengthPayload, tostring(userMessage));
   return warpMessage
 end
 
  function WarpRequestBuilder.buildSetUserDataRequest(username, data)
   local userTable ={}
   userTable["name"] =  username;  
   userTable["data"] = data;
   local userMessage = JSON:encode(userTable);  
   local lengthPayload = string.len(tostring(userMessage));
   local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.SET_CUSTOM_USER_DATA, 0, WarpContentTypeCode.JSON, lengthPayload, tostring(userMessage));
   return warpMessage
 end 
 
  function WarpRequestBuilder.buildSetRoomDataRequest(roomid, data)
   local roomTable ={}
   roomTable["id"] =  roomid;  
   roomTable["data"] = data;
   local roomMessage = JSON:encode(roomTable);  
   local lengthPayload = string.len(tostring(roomMessage));
   local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.SET_CUSTOM_ROOM_DATA, 0, WarpContentTypeCode.JSON, lengthPayload, tostring(roomMessage));
   return warpMessage
  end  
 
  function WarpRequestBuilder.buildLobbyRequest(code)
   local lobbyTable ={}
   lobbyTable["isPrimary"] =  true;  
   local lobbyMessage = JSON:encode(lobbyTable);  
   local lengthPayload = string.len(tostring(lobbyMessage));
   local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, code, 0, WarpContentTypeCode.JSON,
     lengthPayload, tostring(lobbyMessage));
   return warpMessage
 end
 
  function WarpRequestBuilder.buildPrivateChatRequest(username, message)
    local chatTable = {}
    chatTable["chat"] = message
    chatTable["to"] = username
    local chatMessage = JSON:encode(chatTable)
    local lengthPayload = string.len(tostring(chatMessage));
    local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.PRIVATE_CHAT, 0, WarpContentTypeCode.JSON,
     lengthPayload, tostring(chatMessage));
   return warpMessage    
 end
 
  function WarpRequestBuilder.buildChatRequest(message)
    local chatTable = {}
    chatTable["chat"] = message
    local chatMessage = JSON:encode(chatTable)
    local lengthPayload = string.len(tostring(chatMessage));
    local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.CHAT, 0, WarpContentTypeCode.JSON,
     lengthPayload, tostring(chatMessage));
   return warpMessage    
 end 
 
  function WarpRequestBuilder.buildUpdatePeersRequest(update)
    local lengthPayload = string.len(update);
    local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.UPDATE_PEERS, 0, WarpContentTypeCode.BINARY,
     lengthPayload, tostring(update));
   return warpMessage
  end 
 
  function WarpRequestBuilder.buildCreateRoomRequest(name, owner, maxUsers, properties, turnTime)
    local roomCreateTable = {}
    roomCreateTable["name"] = name
    roomCreateTable["owner"] = owner
    roomCreateTable["maxUsers"] = maxUsers
    roomCreateTable["properties"] = properties       
    if(turnTime > 0) then      
      roomCreateTable["turnTime"] = turnTime
      roomCreateTable["inox"] = true
    end
    
    local roomCreateMessage = JSON:encode(roomCreateTable)
    local lengthPayload = string.len(tostring(roomCreateMessage));
    local warpMessage = WarpRequestBuilder.buildWarpRequest(WarpMessageTypeCode.REQUEST, WarpConfig.session_id, 0, WarpRequestTypeCode.CREATE_ROOM, 0, WarpContentTypeCode.JSON,
     lengthPayload, tostring(roomCreateMessage));
   return warpMessage    
 end
 
 return WarpRequestBuilder;