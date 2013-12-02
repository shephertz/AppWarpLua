 
local local_server = "localhost"
local control_server = "appwarp.control.shephertz.com"
local prod_server = "54.248.235.107"

WarpConfig = {
  ["apiKey"] = "";
  ["secretKey"] = "";
  ["warp_host"] = prod_server;
  ["warp_port"] = 12346;
  ["lookup_host"] = "control.appwarp.shephertz.com";
  ["lookup_port"] = 80;
  ["WarpClient"] = nil;
  ["session_id"] = nil;
  ["keepAliveInterval"] = 6;
  ["trace"] = false;
}