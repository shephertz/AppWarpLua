require "socket"
require "AppWarp.WarpConfig"    
local LookupChannel = {}    
local client_socket = nil

LookupChannel.isConnected = false

function LookupChannel.socket_connect()
  
  if(client_socket == nil) then    
    client_socket = socket.tcp();
    client_socket:settimeout(0)
  end
  if(LookupChannel.isConnected == true) then
    return
  end
  local status, err = client_socket:connect(WarpConfig.lookup_host, WarpConfig.lookup_port)
  if(err == "already connected")  then
    LookupChannel.isConnected = true;
    warplog("lookup connected")   
    LookupChannel.sendRequest();
  else
    --warplog("error is "..tostring(err));
  end
  
end
  
function LookupChannel.sendRequest()
    local reqMsg = getLookupRequest()
    client_socket:send(reqMsg);
    warplog("sent lookup request");
  end
     
function LookupChannel.socket_close()
  client_socket:close();
end

function LookupChannel.socket_recv()
  local buffer;
  local status;
  if(client_socket == nil) then
    return
  end 
   
  buffer, status, partial = client_socket:receive();
  
  if(partial ~= nil) then
    local partialstring = tostring(partial);
    local length = string.len(partialstring);
    if(length > 0) then
      local JSON = require "AppWarp.JSON"
      local table = JSON:decode(partialstring);
      if(table['address'] ~= nil) then
        WarpConfig.warp_host = table['address'];
        warplog("server address is "..WarpConfig.warp_host)
        WarpConfig.WarpClient.lookupDone(true);
      else
        warplog("lookup failed. address not found")
        WarpConfig.WarpClient.lookupDone(false);
      end      
    end
  end  
  if (status == "timeout") then
    --warplog("timeout socket")
  elseif status == "closed" then 
    warplog("closed lookup socket")
    LookupChannel.isConnected = false;    
    client_socket = nil;       
  end
end

return LookupChannel
    
    