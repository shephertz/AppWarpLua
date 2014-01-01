require "socket"
    
local WarpChannel = {}    
local client_socket = nil

WarpChannel.isConnected = false

function WarpChannel.socket_connect()
  
  if(client_socket == nil) then    
    client_socket = socket.tcp();
    client_socket:settimeout(0)
  end
  if(WarpChannel.isConnected == true) then
    return
  end
  local status, err = client_socket:connect(WarpConfig.warp_host, WarpConfig.warp_port)
  if(err == "already connected")  then
    warplog("channel connected")
    WarpChannel.isConnected = true;
    WarpConfig.WarpClient.onConnect(true);    
  else
    --warplog("error is "..tostring(err));
  end
  
end
      
function WarpChannel.socket_close()
  client_socket:close();
end

function WarpChannel.socket_send(buffer)
  client_socket:send(buffer)
end
  
function WarpChannel.socket_recv()
  local buffer;
  local status;
  if(client_socket == nil) then
    return
  end 
   
  buffer, status, partial = client_socket:receive('*a');
 
  if(partial ~= nil) then
    local partialstring = tostring(partial);
    local length = string.len(partialstring);
    if(length > 0) then
      warplog("read some partial bytes "..tostring(length))
      WarpConfig.WarpClient.receivedData(partial)    
    end
  end  
  if (status == "timeout") then
    --warplog("timeout socket")
  elseif status == "closed" then 
    warplog("closed socket")
    WarpChannel.isConnected = false;    
    client_socket = nil;   
    WarpConfig.WarpClient.onConnect(false);
  end
end

return WarpChannel    
    
    