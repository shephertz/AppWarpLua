 WarpConnectionState = {
    ["CONNECTED"] = 0;
    ["CONNECTING"] = 1;
    ["DISCONNECTED"] = 2;
    ["DISCONNECTING"] = 3;
    ["RECOVERING"] = 4;
  }
 
 WarpContentTypeCode = {
    ["FLAT_STRING"] = 0,
    ["BINARY"] = 1,
    ["JSON"] = 2
  }
  
  WarpMessageTypeCode = {
    ["REQUEST"] = 0,
    ["RESPONSE"] = 1,
    ["UPDATE"] = 2
  }
  
  WarpNotifyTypeCode = {
     ["ROOM_CREATED"] = 1,
     ["ROOM_DELETED"] = 2,
     ["USER_JOINED_LOBBY"] = 3,
     ["USER_LEFT_LOBBY"] = 4,
     ["USER_JOINED_ROOM"] = 5,
     ["USER_LEFT_ROOM"] = 6,
     ["USER_ONLINE"] = 7,
     ["USER_OFFLINE"] = 8,
     ["CHAT"] = 9,
     ["UPDATE_PEERS"] = 10,  
     ["ROOM_PROPERTY_CHANGE"] = 11,  
     ["PRIVATE_CHAT"] = 12, 
     ["MOVE_COMPLETED"] = 13,
     ["USER_PAUSED"] = 14,
     ["USER_RESUMED"] = 15,
     ["GAME_STARTED"] = 16,
     ["GAME_STOPPED"] = 17
  }
  
  WarpRequestTypeCode = {
    
     ["AUTH"] = 1,

     ["JOIN_LOBBY"] = 2,

     ["SUBSCRIBE_LOBBY"] = 3,
    
     ["UNSUBSCRIBE_LOBBY"] = 4,
    
     ["LEAVE_LOBBY"] = 5,
    
     ["CREATE_ROOM"] = 6,
    
     ["JOIN_ROOM"] = 7,
    
     ["SUBSCRIBE_ROOM"] = 8,
    
     ["UNSUBSCRIBE_ROOM"] = 9,
    
     ["LEAVE_ROOM"] = 10,
    
     ["DELETE_ROOM"] = 11,
    
     ["CHAT"] = 12,
    
     ["UPDATE_PEERS"] = 13,
    
     ["SIGNOUT"] = 14,

     ["CREATE_ZONE"] = 15,
    
     ["DELETE_ZONE"] = 16,    
    
     ["GET_ROOMS"] = 17,
    
     ["GET_USERS"] = 18,
    
     ["GET_USER_INFO"] = 19,
    
     ["GET_ROOM_INFO"] = 20,

     ["SET_CUSTOM_ROOM_DATA"] = 21,
    
     ["SET_CUSTOM_USER_DATA"] = 22,    
    
     ["GET_LOBBY_INFO"] = 23,
    
     ["JOIN_ROOM_N_USER"] = 24,
    
     ["UPDATE_ROOM_PROPERTY"] = 25,
    
     ["JOIN_ROOM_WITH_PROPERTIES"] = 27,
    
     ["GET_ROOM_WITH_N_USER"] = 28,
    
     ["GET_ROOM_WITH_PROPERTIES"] = 29,
    
     ["PRIVATE_CHAT"] = 30,
    
     ["MOVE"] = 31,
    
     ["LOCK_PROPERTIES"] = 35,
    
     ["UNLOCK_PROPERTIES"] = 36,
    
     ["JOIN_ROOM_IN_RANGE"] = 37,
    
     ["GET_ROOM_IN_RANGE"] = 38,
    
     ["KEEP_ALIVE"] = 63,
    
     ["ASSOC_PORT"] = 64,
     
     ["ACK_ASSOC_PORT"] = 65,
     
     ["START_GAME"] = 66,
     
     ["STOP_GAME"] = 67,
     
     ["GET_MOVE_HISTORY"] = 68
  }
  
  WarpResponseResultCode = {    
     ["SUCCESS"] = 0,    
     ["AUTH_ERROR"] = 1,    
     ["RESOURCE_NOT_FOUND"] = 2,    
     ["RESOURCE_MOVED"] = 3,     
     ["BAD_REQUEST"] = 4,
     ["CONNECTION_ERROR"] = 5,
     ["UNKNOWN_ERROR"] = 6,
     ["RESULT_SIZE_ERROR"] = 7,
     ["SUCCESS_RECOVERED"] = 8,
     ["CONNECTION_ERROR_RECOVERABLE"] = 9
  }