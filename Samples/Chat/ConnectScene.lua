---------------------------------------------------------------------------------
--
-- ConnectScene.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image, statusText, connectButton

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	image = display.newImage( "bg.jpg" )
	screenGroup:insert( image )
  
	statusText = display.newText( "Click to Connect to Start", 0, 0, native.systemFontBold, 24 )
	statusText:setTextColor( 255 )
	statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 50
	screenGroup:insert( statusText )	   
  
  connectButton =  require("widget").newButton
        {
            left = (display.contentWidth-200)/2,
            top = display.contentHeight - 70,
            label = "Connect",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = "Connecting.."
                    appWarpClient.connectWithUserName(tostring(os.clock())) -- join with a random name
                end
            end
        }
        
	print( "\n1: createScene event")
end

----------------------------------------------------------------------
-- Common Scene Handline
----------------------------------------------------------------------

function scene.onConnectDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    statusText.text = "Joining room.."    
    appWarpClient.joinRoom(STATIC_ROOM_ID)
  else
    statusText.text = "Connect failed.."
  end
  
end

function scene.onJoinRoomDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    appWarpClient.subscribeRoom(STATIC_ROOM_ID)
  else
    statusText.text = "joinRoomDone failed"
  end  
end

function scene.onSubscribeRoomDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    storyboard.gotoScene( "ChatScene", "slideLeft", 800)
  else
    statusText.text = "subscribeRoom failed"
  end  
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	print( "1: enterScene event" )
  statusText.text = "Click to Connect to Start"
  connectButton.isVisible = true

  appWarpClient.addRequestListener("onConnectDone", scene.onConnectDone)  
  appWarpClient.addRequestListener("onJoinRoomDone", scene.onJoinRoomDone)  
  appWarpClient.addRequestListener("onSubscribeRoomDone", scene.onSubscribeRoomDone)  
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "1: exitScene event" )

  connectButton.isVisible = false
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
	print( "((destroying scene 1's view))" )
  display.remove(connectButton)
end

---------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

---------------------------------------------------------------------------------

return scene