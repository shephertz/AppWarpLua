---------------------------------------------------------------------------------
--
-- ChatScene.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image, statusText, helloButton, byeButton, greetButton

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	image = display.newImage( "bg.jpg" )
	screenGroup:insert( image )

	statusText = display.newText( "Start Chatting", 0, 0, native.systemFontBold, 24 )
	statusText:setTextColor( 255 )
	statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 50
	screenGroup:insert( statusText )
	
  helloButton =  require("widget").newButton
        {
            left = (display.contentWidth-200)/2,
            top = display.contentHeight - 70,
            label = "Say Hello",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.sendChat("Hello")
                end
            end
        } 	
        
  byeButton =  require("widget").newButton
        {
            left = (display.contentWidth-200)/2,
            top = display.contentHeight - 140,
            label = "Say Bye",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.sendChat("Bye")
                end
            end
        } 	
        
  greetButton =  require("widget").newButton
        {
            left = (display.contentWidth-200)/2,
            top = display.contentHeight - 210,
            label = "Greet",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.sendChat("How are you?")
                end
            end
        } 	        
        
  disconnectButton =  require("widget").newButton
        {
            left = (display.contentWidth-200)/2,
            top = display.contentHeight - 280,
            label = "Disconnect",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = "disconnecting.."
                    appWarpClient.disconnect()
                end
            end
        }   
        
	print( "\n2: createScene event")
end

----------------------------------------------------------------------
-- Common Scene Handline
----------------------------------------------------------------------

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	print( "2: enterScene event" )
  helloButton.isVisible = true
  byeButton.isVisible = true
  greetButton.isVisible = true
  disconnectButton.isVisible = true
  statusText.text = "Start Chatting"
  appWarpClient.addRequestListener("onConnectDone", scene.onConnectDone)        
  appWarpClient.addRequestListener("onDisconnectDone", scene.onDisconnectDone)
  appWarpClient.addNotificationListener("onChatReceived", scene.onChatReceived)
end

function scene.onConnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "Connect failed.."
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )
  end  
end

function scene.onChatReceived(sender, message)
  statusText.text = "new message: "..message
end

function scene.onDisconnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "Disconnect failed.."
  else
    statusText.text = "Disconnected"
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )		
  end  
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "2: exitScene event" )
	
  helloButton.isVisible = false
  byeButton.isVisible = false
  greetButton.isVisible = false
  disconnectButton.isVisible = false
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	
	print( "((destroying scene 2's view))" )
  display.remove(helloButton)
  display.remove(byeButton)
  display.remove(greetButton)	  
  display.remove(disconnectButton)
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