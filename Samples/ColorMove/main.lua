-- 
-- Abstract: Move Vectors in realtime. Lets users drag update vector positions 
-- and updates the new positions on all clients.
-- 

-- create global warp client and initialize it
appWarpClient = require "AppWarp.WarpClient"

-- Replace these with the values from AppHQ dashboard of your AppWarp app
API_KEY = "YourAPIKey"
SECRET_KEY = "YourSecretKey"
STATIC_ROOM_ID = "RoomId"

appWarpClient.initialize(API_KEY, SECRET_KEY)

-- uncomment if you want to enable trace printing of appwarp
--appWarpClient.enableTrace(true)

-- IMPORTANT! loop WarpClient. This is required for receiving responses and notifications
local function gameLoop(event)
  appWarpClient.Loop()
end

Runtime:addEventListener("enterFrame", gameLoop)

-- do the appwarp client related handling in a separate file
require "warplisteners"

statusText = display.newText( "Connecting..", 10, display.contentHeight, native.systemFontBold, 24 )
statusText.width = 128

-- start connecting with a random name
appWarpClient.connectWithUserName(tostring(os.clock()))

local arguments =
{
	{ x=50, y=10, w=100, h=100, r=10, red=255, green=0, blue=128, id = 1 },
	{ x=10, y=50, w=100, h=100, r=10, red=0, green=128, blue=255, id = 2 },
	{ x=90, y=90, w=100, h=100, r=10, red=255, green=255, blue=0, id = 3 }
}

myButtons = {}

local function onTouch( event )
	local t = event.target
	local phase = event.phase
	if "began" == phase then
		-- Make target the top-most object
		local parent = t.parent
		parent:insert( t )
		display.getCurrentStage():setFocus( t )
		t.isFocus = true
		-- Store initial position
		t.x0 = event.x - t.x
		t.y0 = event.y - t.y
	elseif t.isFocus then
		if "moved" == phase then
			-- Make object move (we subtract t.x0,t.y0 so that moves are
			-- relative to initial grab point, rather than object "snapping").
			t.x = event.x - t.x0
			t.y = event.y - t.y0
		elseif "ended" == phase or "cancelled" == phase then
			display.getCurrentStage():setFocus( nil )
			t.isFocus = false
      print("moved button id ".. tostring(t.id))
      -- send the update to others in the game room. space delimit the values and parse accordingly
      -- in onUpdatePeersReceived notification
      appWarpClient.sendUpdatePeers(tostring(t.id) .. " " .. tostring(t.x).." ".. tostring(t.y))
		end
	end
	return true
end

-- Iterate through arguments array and create rounded rects (vector objects) for each item
for _,item in ipairs( arguments ) do
	local button = display.newRoundedRect( item.x, item.y, item.w, item.h, item.r )
	button:setFillColor( item.red, item.green, item.blue )
	button.strokeWidth = 6
	button:setStrokeColor( 200,200,200,255 )
	-- Make the button instance respond to touch events
	button:addEventListener( "touch", onTouch )
  
  -- assign ids to buttons and insert in table
  button.id = tostring(item.id)
  myButtons[button.id] = button  
end