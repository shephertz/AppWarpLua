--
-- Abstract: Storyboard Chat Sample using AppWarp
--
--
-- Demonstrates use of the AppWarp API (connect, disconnect, joinRoom, subscribeRoom, chat )
--

display.setStatusBar( display.HiddenStatusBar )

local storyboard = require "storyboard"
local widget = require "widget"

-- load first scene
storyboard.gotoScene( "ConnectScene", "fade", 400 )

-- Replace these with the values from AppHQ dashboard of your AppWarp app
API_KEY = "14a611b4b3075972be364a7270d9b69a5d2b24898ac483e32d4dc72b2df039ef"
SECRET_KEY = "55216a9a165b08d93f9390435c9be4739888d971a17170591979e5837f618059"
ROOM_ID = ""
USER_NAME = ""
REMOTE_USER = ""
ROOM_ADMIN = ""

-- create global warp client and initialize it
appWarpClient = require "AppWarp.WarpClient"
appWarpClient.initialize(API_KEY, SECRET_KEY)

--appWarpClient.enableTrace(true)

-- IMPORTANT! loop WarpClient. This is required for receiving responses and notifications
local function gameLoop(event)
  appWarpClient.Loop()
end

Runtime:addEventListener("enterFrame", gameLoop)