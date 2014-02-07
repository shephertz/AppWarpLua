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

local isNewRoomCreated = false;

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	display.setDefault( "background", 255, 255, 255 )
  
	statusText = display.newText( "Click to Connect to Start", 0, 0, native.systemFontBold, 24 )
	statusText:setTextColor( 115 )
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
                    if(string.len(ROOM_ID)>0 and connectButton:getLabel() == "Back") then
                      statusText.text = "Disconnecting.."
                      appWarpClient.unsubscribeRoom(ROOM_ID)
                      appWarpClient.leaveRoom(ROOM_ID)
                      appWarpClient.deleteRoom(ROOM_ID)
                      appWarpClient.disconnect()
                    else 
                      statusText.text = "Connecting.."
                      USER_NAME = tostring(os.clock())
                      appWarpClient.connectWithUserName(USER_NAME) -- join with a random name
                    end
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
    appWarpClient.joinRoomInRange (1, 1, false)
  else
    statusText.text = "onConnectDone: Failed"..resultCode;
  end
  
end

function scene.onDisconnectDone(resultCode)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    statusText.text = "Click to Connect to Start"   
    connectButton:setLabel("Connect")
  else
    statusText.text = "onDisconnectDone: Failed"..resultCode;
  end
end

function scene.onJoinRoomDone(resultCode, roomId)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    appWarpClient.subscribeRoom(roomId)
  elseif(resultCode == WarpResponseResultCode.RESOURCE_NOT_FOUND) then
    -- no room found with one user creating new room
    local roomPropertiesTable = {}
    roomPropertiesTable["result"] = ""
    ROOM_ADMIN = USER_NAME
    appWarpClient.createTurnRoom ("TicTacToeRoom", ROOM_ADMIN, 2, roomPropertiesTable, 30)
  else
    statusText.text = "onJoinRoomDone: failed"..resultCode
  end  
end

function scene.onCreateRoomDone(resultCode, roomId, roomName)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    isNewRoomCreated = true;
    appWarpClient.joinRoom(roomId)
  else
    statusText.text = "onCreateRoomDone failed"..resultCode
  end  
end

function scene.onSubscribeRoomDone(resultCode, roomId)
  if(resultCode == WarpResponseResultCode.SUCCESS) then
    ROOM_ID = roomId;
    if(isNewRoomCreated) then
      waitForOtherUser()
    else
      startGame()
    end
  else
    statusText.text = "subscribeRoom failed"
  end  
end

function scene.onUserJoinedRoom(userName, roomId)
  if(roomId == ROOM_ID and userName ~= USER_NAME) then
    connectButton:setLabel("Connect")
    startGame()
  end
end

function startGame ()
  storyboard.gotoScene( "GameScene", "slideLeft", 800)
end

function waitForOtherUser ()
  connectButton:setLabel("Back")
  statusText.text = "Waiting for other user"
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	
	print( "1: enterScene event" )
  statusText.text = "Click to Connect to Start"
  connectButton.isVisible = true

  appWarpClient.addRequestListener("onConnectDone", scene.onConnectDone)  
  appWarpClient.addRequestListener("onDisconnectDone", scene.onDisconnectDone)  
  appWarpClient.addRequestListener("onJoinRoomDone", scene.onJoinRoomDone)  
  appWarpClient.addRequestListener("onCreateRoomDone", scene.onCreateRoomDone)  
  appWarpClient.addRequestListener("onSubscribeRoomDone", scene.onSubscribeRoomDone)  
  appWarpClient.addNotificationListener("onUserJoinedRoom", scene.onUserJoinedRoom)
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