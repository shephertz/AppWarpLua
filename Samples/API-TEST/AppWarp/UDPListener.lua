require "socket"
local UDPListener = {}    
local udp_socket = nil
local ip = nil

UDPListener.isUDPEnabled = false

local waitingForAck = false;
local initTime = 0;
local UDP_WAIT_TIME = 3;

function UDPListener.socket_connect()
  if(udp_socket == nil) then
    udp_socket = socket.udp()
    udp_socket:settimeout(0)
    udp_socket:setpeername(WarpConfig.warp_host, WarpConfig.warp_port) 
  end
end

function UDPListener.socket_close()
  if(udp_socket~=nil) then
    udp_socket:setpeername('*')
    udp_socket:close()
  end
end

function UDPListener.socket_send(requestType, msg)
  if(requestType == WarpRequestTypeCode.ASSOC_PORT) then
    waitingForAck = true;
    initTime = os.time();
  end
  udp_socket:send(msg)
  udpLastSendTime = os.time()
end
  
function UDPListener.socket_recv()
  
  if(udp_socket == nil) then
    return
  end 
  
  if(waitingForAck) then
    if( os.time()-initTime >= UDP_WAIT_TIME) then
      waitingForAck = false;
      waitCounter = 0;
      WarpConfig.WarpClient.fireUDPEvent(WarpResponseResultCode.BAD_REQUEST)
      UDPListener.socket_close()
      UDPListener.isUDPEnabled = false
      return
    end
  end
   
  data, status = udp_socket:receive();
  if(status=="timeout") then
    --warplog("timeout socket")
  elseif(status=="closed")then
    UDPListener.socket_close()  
	UDPListener.isUDPEnabled = false
  end
 if(data ~= nil) then
    warplog("udp read some partial bytes "..tostring(length))
    WarpConfig.WarpClient.receivedUDPData(data)   
    waitingForAck = false;
  end  
end

return UDPListener