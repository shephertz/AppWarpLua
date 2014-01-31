
local JSON = require "AppWarp.JSON"

warplog = function(message)
  if(WarpConfig.trace == false) then
    return
  end
  
  message = tostring(message);
  print(os.clock().." : "..message);
end
 
 function isUserNameValid(input)
   local length = string.len(input);
   if(length <= 25) then
     return true;
   else 
     return false;
   end   
 end
 
 function buildLiveRoomInfoTable(payLoadTable)
     
    local LiveRoomInfo = {} 
    usersString = payLoadTable['usernames']
    LiveRoomInfo.joinedUsersTable = splitString(usersString, ';')
    LiveRoomInfo.id = payLoadTable['id']
    LiveRoomInfo.name = payLoadTable['name']
    LiveRoomInfo.maxUsers = payLoadTable['maxUsers']
    LiveRoomInfo.owner = payLoadTable['owner']
    LiveRoomInfo.customData = payLoadTable['data']
    LiveRoomInfo.propertyTable = JSON:decode(payLoadTable['properties']) 
    LiveRoomInfo.lockTable = JSON:decode(payLoadTable['lockProperties'])
    
    return LiveRoomInfo
 end
 
 function buildMatchedRoomsTable(payLoadTable)
     
    local MatchingRooms = {} 
    local n = 0
    for k,v in pairs(payLoadTable) do
      n = n+1      
      MatchingRooms[n]=v
	  MatchingRooms[n].id = k
    end        
    return MatchingRooms
 end 
 
  function buildMoveHistoryTable(payLoadTable)
    
    local historyArray = payLoadTable['history']
    local historyTable = {} 
    local n = 0
    for k,v in pairs(historyArray) do
      n = n+1
      historyTable[n]=v
    end
    return historyTable
 end 
 
 function decodeWarpResponseMessage(message, offset)

   local length = string.len(message) - offset;
   
   warplog("decodeWarpResponseMessage buffer length: " .. length)
       
   local messageType = string.byte(message, offset+1, offset+1);
   local requestType = string.byte(message, offset+2, offset+2);
   local resultCode = string.byte(message, offset+3, offset+3);
   local reserved = string.byte(message, offset+4, offset+4);
   local payloadType = string.byte(message, offset+5, offset+5);
   
   local a = tonumber(string.byte(message, offset+6, offset+6));
   local b = tonumber(string.byte(message, offset+7, offset+7));
   local c = tonumber(string.byte(message, offset+8, offset+8));
   local d = tonumber(string.byte(message, offset+9, offset+9));
   
   local payLoadSize = (a*16777216) + (b*65536) + (c*256) + d;
   
   local payloadSize = tonumber(payLoadSize);
   
   warplog("messageType " .. messageType);
   warplog("requestType " .. requestType);
   warplog("resultCode " .. resultCode);
   warplog("reserved " .. reserved);
   warplog("payloadType " .. payloadType);
   warplog("payloadSize " .. payloadSize);
   
   local payLoad = string.sub(message, offset+10, offset+10+payloadSize-1);
   
   warplog("payLoad " .. payLoad);
   
   return requestType, resultCode, payLoad, payloadSize+9
   
  end 
  
 function decodeWarpNotifyMessage(message, offset)

   local length = string.len(message) - offset;
   
   warplog("decodeWarpNotifyMessage buffer length: " .. length)
       
   local messageType = string.byte(message, offset+1, offset+1);
   local notifyType = string.byte(message, offset+2, offset+2);
   local reserved = string.byte(message, offset+3, offset+3);
   local payloadType = string.byte(message, offset+4, offset+4);
   
   local a = tonumber(string.byte(message, offset+5, offset+5));
   local b = tonumber(string.byte(message, offset+6, offset+6));
   local c = tonumber(string.byte(message, offset+7, offset+7));
   local d = tonumber(string.byte(message, offset+8, offset+8));
   
   local payLoadSize = (a*16777216) + (b*65536) + (c*256) + d;
   
   local payloadSize = tonumber(payLoadSize);
   
   warplog("messageType " .. messageType);
   warplog("notifyType " .. notifyType);
   warplog("reserved " .. reserved);
   warplog("payloadType " .. payloadType);
   warplog("payloadSize " .. payloadSize);
   
   local payLoad = string.sub(message, offset+9, offset+9+payloadSize-1);
   
   warplog("payLoad " .. payLoad);
   
   return notifyType, payLoad, 8+payloadSize
   
  end   
  
 function getLookupRequest() 
    local message = "GET /lookup?api=".. tostring(WarpConfig.apiKey).." HTTP/1.0\r\n\ Accept:text/html\r\n Connection:keep-alive\r\n\r\n";  
    return message
  end
  
 function appendIntegerInRquestString(number)
   local tempString = "";
   if number < 256 then
        tempString = tempString .. string.char(0);
        tempString = tempString .. string.char(0);
        tempString = tempString .. string.char(0);
        tempString = tempString .. string.char(number);
     elseif number >= 256 and number < 65536 then
        local q = math.floor(number/256);
        local rem = number % 256;
        tempString = tempString .. string.char(0);
        tempString = tempString .. string.char(0);
        tempString = tempString .. string.char(math.floor(q));
        tempString = tempString .. string.char(rem);
     elseif number >= 65536 and number < 16777216 then
        tempString = tempString .. string.char(0);
        local q = math.floor(number/65536);
        local rem = number % 65536;
        tempString = tempString .. string.char(q);
        local q1 = math.floor(rem/256);
        local rem1 = rem % 256;
        tempString = tempString .. string.char(q1);
        tempString = tempString .. string.char(rem1);
     else
       local q = math.floor(number/16777216);
       local rem = number%16777216;
       tempString = tempString .. string.char(q);
       local q1 = math.floor(rem/65536);
       local rem1 = rem%65536;
       tempString = tempString .. string.char(q1);
       local q2 = math.floor(rem1/256);
       local rem2 = rem1%256;
       tempString = tempString .. string.char(q2);
       tempString = tempString .. string.char(rem2);       
     end
     return tempString;
   end
   
  local function url_encode(str)
    if (str) then
      str = string.gsub (str, "\n", "\r\n")
      str = string.gsub (str, "([^%w %-%_%.%~])",
          function (c) return string.format ("%%%02X", string.byte(c)) end)
      str = string.gsub (str, " ", "+")
    end
    return str	
  end
  
  local function fromhex(str)
    return (str:gsub('..', function (cc)
        return string.char(tonumber(cc, 16))
    end))
  end
  
  local function sign(secretKey, params)
     require "AppWarp.sha1"
     local hexString = hmac_sha1(secretKey, params);
     local mime = require("mime")
     local base64String = mime.b64(fromhex(hexString))
     return base64String
   end
   
 function calculateSignature(apiKey, version, user, timeStamp, secretKey)
     local paramString = "apiKey" .. apiKey .. "timeStamp" .. timeStamp .. "user" .. user .. "version" .. version;
     local hmac = sign(secretKey, paramString);
     return url_encode(hmac);
  end
  
  
function splitString(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end  