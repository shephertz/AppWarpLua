---------------------------------------------------------------------------------
--
-- ChatScene.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()
local json = require( "json" )  -- Include the Corona JSON library
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local image,scrollView, statusText,roomIdInfo,roomData,userData,setCustomRoomDataButton,setCustomUserDataButton,userInfo,unsubLobby,joinLobby
local subLobby,leaveLobby,sendChat,sendPrivateChat,sendUpdatePeer,gameStart,sendMove,getMoveHistory,stopGame,previous,next
local sendUDPUpdatePeers,sendUDPPrivateUpdateButton

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	image = display.newImage( "bg.jpg" )
	screenGroup:insert( image )

	statusText = display.newText( "Connected", 0, 0, native.systemFontBold, 24 )
	statusText:setTextColor( 255 )
	statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 50
	screenGroup:insert( statusText )

     
  disconnectButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+120,
            top = 80,
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


  setCustomRoomDataButton =  require("widget").newButton
        {
            left =-20,
            top = 160,
            label = "SetCustomRoom",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.setCustomRoomData(roomIdInfo.text,roomData.text)
                end
            end
        } 
   setCustomUserDataButton =  require("widget").newButton
        {
            left = -30,
            top = 240,
            label = "SetCustomUser",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.setCustomUserData(userInfo.text,userData.text)
                end
            end
        } 
 sendChat =  require("widget").newButton
        {
            left = 120,
            top = 240,
            label = "Send Chat",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.sendChat(userData.text)
                end
            end
        }
 sendPrivateChat =  require("widget").newButton
        {
            left = -20,
            top = 270,
            label = "Send Private Chat",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.sendPrivateChat(userInfo.text,userData.text)
                end
            end
        }
 sendUpdatePeer =  require("widget").newButton
        {
            left = 140,
            top = 270,
            label = "SendUpdatePeer",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.sendUpdatePeers(userData.text)
                end
            end
        }
 sendUDPUpdatePeers =  require("widget").newButton
        {
            left = -20,
            top = 300,
            label = "sendUDPUpdatePeers",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    print(userData.text)
                    appWarpClient.sendUDPUpdatePeers(userData.text)
                end
            end
        }
 sendUDPPrivateUpdateButton =  require("widget").newButton
        {
            left = 150,
            top = 300,
            label = "sendUDPPriUpdate",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    print(userInfo.text)
                    print(userData.text)
                    appWarpClient.initUDP()  
                   
                end
            end
        }
 joinLobby =  require("widget").newButton
        {
            left = 120,
            top = 330,
            label = "Join Lobby",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.joinLobby()
                end
            end
        } 
leaveLobby =  require("widget").newButton
        {
            left = -40,
            top = 330,
            label = "Leave Lobby",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.leaveLobby()
                end
            end
        }
 subLobby =  require("widget").newButton
        {
            left =140,
            top = 360,
            label = "Subcribe Lobby",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.subscribeLobby()
                end
            end
        }

unsubLobby =  require("widget").newButton
        {
            left = -20,
            top = 360,
            label = "Unsubcribe Lobby",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.unsubscribeLobby()
                end
            end
        }


gameStart =  require("widget").newButton
        {
            left = 120,
            top = 390,
            label = "Start Game",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.startGame()
                end
            end
        }

sendMove =  require("widget").newButton
        {
            left = 120,
            top = 420,
            label = "Send Move",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.sendMove(userData.text)
                end
            end
        }
getMoveHistory =  require("widget").newButton
        {
            left = -25,
            top = 390,
            label = "GetMoveHistory",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.getMoveHistory()
                end
            end
        }
stopGame =  require("widget").newButton
        {
            left = -42,
            top = 420,
            label = "Stop Game",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = ""
                    appWarpClient.stopGame()
                end
            end
        }

 previous =  require("widget").newButton
        {
            left = 10,
            top = 440,
            label = "Previous",
            width = 200, height = 40,
            emboss = false,
           -- Properties for a rounded rectangle button
            shape = "roundedRect",
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    storyboard.gotoScene( "API-TEST-NEXT", "slideRight", 800)
                end
            end
        } 

 next =  require("widget").newButton
        {
            left = 180,
            top = 440,
            label = "Next",
            width = 200, height = 40,
            emboss = false,
           -- Properties for a rounded rectangle button
            shape = "roundedRect",
            fillColor = { default={1,0,0,1}, over={1,0.1,0.7,0.4} },
            strokeColor = { default={1,0.4,0,1}, over={0.8,0.8,1,1} },
            strokeWidth = 4,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    storyboard.gotoScene( "API-TEST", "slideLeft", 800)
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
  local function inputListener( event )  -- handler for text field
      if event.phase == "began" then
          -- user begins editing textField
          print( event.text )
      elseif event.phase == "ended" then
    storyboard.description = event.text
          -- do something with textField's text
      elseif event.phase == "editing" then
      end
  end
  roomIdInfo = native.newTextField( 10, 120, 150, 40 )  --  create the roomId feild once it has moved on stage
  roomIdInfo.text = storyboard.description  -- get the stored value
  roomIdInfo.placeholder = "Room ID"
  native.setKeyboardFocus( roomIdInfo )
  roomIdInfo.font = native.newFont( "Helvetica-Light", 18 )
  roomIdInfo:addEventListener( "userInput", inputListener ) 

  roomData = native.newTextField(170, 120, 150, 40 )  --  create the roomId feild once it has moved on stage
  roomData.text = storyboard.description  -- get the stored value
  roomData.placeholder = "Room Data"
  native.setKeyboardFocus( roomData )
  roomData.font = native.newFont( "Helvetica-Light", 18 )
  roomData:addEventListener( "userInput", inputListener ) 



  userData = native.newTextField(10, 200, 150, 40 )  --  create the roomId feild once it has moved on stage
  userData.text = storyboard.description  -- get the stored value
  userData.placeholder = "Data"
  native.setKeyboardFocus( userData )
  userData.font = native.newFont( "Helvetica-Light", 18 )
  userData:addEventListener( "userInput", inputListener )
 
  userInfo = native.newTextField(170, 200, 150, 40 )  --  create the roomId feild once it has moved on stage
  userInfo.text = storyboard.description  -- get the stored value
  userInfo.placeholder = "Username"
  native.setKeyboardFocus( userData )
  userData.font = native.newFont( "Helvetica-Light", 18 )
  userData:addEventListener( "userInput", inputListener ) 



  disconnectButton.isVisible = true
  roomIdInfo.isVisible = true
  roomData.isVisible = true
  userData.isVisible = true
  setCustomRoomDataButton.isVisible = true
  setCustomUserDataButton.isVisible = true
  userInfo.isVisible = true
  unsubLobby.isVisible = true
  joinLobby.isVisible = true
  subLobby.isVisible = true
  leaveLobby.isVisible = true
  sendChat.isVisible = true
  sendPrivateChat.isVisible = true
  sendUpdatePeer.isVisible = true
  sendUDPUpdatePeers.isVisible = true
  gameStart.isVisible = true
  sendMove.isVisible = true
  getMoveHistory.isVisible = true
  stopGame.isVisible = true
  previous.isVisible = true
  next.isVisible = true
  sendUDPPrivateUpdateButton.isVisible = true

  statusText.text = "Connected..."
  appWarpClient.addRequestListener("onDisconnectDone", scene.onDisconnectDone)
  appWarpClient.addRequestListener("onSetCustomRoomDataDone", scene.onSetCustomRoomDataDone)
  appWarpClient.addRequestListener("onSetCustomUserDataDone", scene.onSetCustomUserDataDone)
  appWarpClient.addRequestListener("onSendChatDone", scene.onSendChatDone)
  appWarpClient.addRequestListener("onSendPrivateChatDone", scene.onSendPrivateChatDone)
  appWarpClient.addRequestListener("onSendUpdatePeersDone", scene.onSendUpdatePeersDone)
  appWarpClient.addRequestListener("onSendPrivateUpdateDone", scene.onSendPrivateUpdateDone)
  appWarpClient.addRequestListener("onJoinLobbyDone", scene.onJoinLobbyDone)
  appWarpClient.addRequestListener("onLeaveLobbyDone", scene.onLeaveLobbyDone)
  appWarpClient.addRequestListener("onSubscribeLobbyDone", scene.onSubscribeLobbyDone)
  appWarpClient.addRequestListener("onUnsubscribeLobbyDone", scene.onUnsubscribeLobbyDone)
  appWarpClient.addRequestListener("onStartGameDone", scene.onStartGameDone)
  appWarpClient.addRequestListener("onSendMoveDone", scene.onSendMoveDone)
  appWarpClient.addRequestListener("onGetMoveHistoryDone", scene.onGetMoveHistoryDone)
  appWarpClient.addRequestListener("onStopGameDone", scene.onStopGameDone)
  appWarpClient.addNotificationListener("onPrivateUpdateReceived", scene.onPrivateUpdateReceived)
  appWarpClient.addNotificationListener("onUpdatePeersReceived", scene.onUpdatePeersReceived)
  appWarpClient.addRequestListener("onInitUDPDone", scene.onInitUDPDone)
  appWarpClient.addNotificationListener("onChatReceived", scene.onChatReceived)
  appWarpClient.addNotificationListener("onPrivateChatReceived", scene.onPrivateChatReceived)
  appWarpClient.addNotificationListener("onMoveCompleted", scene.onMoveCompleted)
  appWarpClient.addNotificationListener("onGameStarted", scene.onGameStarted)
  appWarpClient.addNotificationListener("onGameStopped", scene.onGameStopped)
  appWarpClient.addNotificationListener("onNextTurnRequest", scene.onNextTurnRequest)


end



function scene.onDisconnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "Disconnect failed.."
  else
    statusText.text = "Disconnected"
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )		
  end  
end


function scene.onSetCustomRoomDataDone(resultCode, roomTable2)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode:"..resultCode
    print(roomTable2)
  end  
end


function scene.onSetCustomUserDataDone(resultCode,name,custom,locationId,isLobby)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
        print ("Name ",name)
        print ("locationId ",locationId)
        print ("isLobby ",isLobby)
        print ("custom ",custom)  
  end  
end



function scene.onSendChatDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
  end  
end

function scene.onSendPrivateChatDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  
  end  
end


function scene.onSendUpdatePeersDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  
  end  
end

function scene.onSendPrivateUpdateDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  
  end  
end

function scene.onJoinLobbyDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  
  end  
end

function scene.onLeaveLobbyDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  
  end  
end

function scene.onSubscribeLobbyDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  end  
end

function scene.onUnsubscribeLobbyDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
  end  
end

function scene.onStartGameDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
  end  
end

function scene.onSendMoveDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
  end  
end

function scene.onGetMoveHistoryDone(resultCode, historyTable)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
    for i = 1, #historyTable do
        print ("  ",historyTable[i])
    end
  end  
end

function scene.onStopGameDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
  end  
end

function scene.onSendUDPUpdatePeersDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
  end  
end

function scene.onPrivateUpdateReceived(userName,pl,reserved)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
    print ('userName : ',userName)
    print ('p1 : ',p1)
    print ('reserved == 2  : ',reserved)
  end  
end

function scene.onUpdatePeersReceived(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
   
  end  
end

function scene.onInitUDPDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode 
   
  end  
end

function scene.onChatReceived(sender,chat,id,isLobby)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print('onChatReceived  : ')
    print('Sender' ,sender)
    print('chat',chat)
    print('Id' ,id)
    print('isLobby',isLobby)
  end  
end

function scene.onPrivateChatReceived(sender,chat)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print('onPrivateChatReceived  : ')
    print('Sender' ,sender)
    print('chat',chat)
  end  
end


function scene.onMoveCompleted(sender,id,nextTurn,moveData)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print('onMoveCompleted : ')
    print('Sender' ,sender)
    print('Id',id)
    print('Next Turn' ,nextTurn)
    print('Move data',moveData)
  end  
end

function scene.onGameStarted(sender,id,nextTurn)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print('onGameStarted : ')
    print('Sender' ,sender)
    print('Id',id)
    print('Next Turn' ,nextTurn)
  end  
end


function scene.onGameStopped(sender,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print('onGameStopped  : ')
    print('Sender' ,sender)
    print('Id',id)
  end  
end

function scene.onNextTurnRequest(lastTurn)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print('onNextTurnRequest : ')
    print('lastTurn' ,lastTurn)
  end  
end


-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "2: exitScene event" )

  disconnectButton.isVisible = false
  roomIdInfo.isVisible = false
  userData.isVisible = false
  roomData.isVisible = false
  setCustomRoomDataButton.isVisible = false
  setCustomUserDataButton.isVisible = false
  userInfo.isVisible = false
  unsubLobby.isVisible = false
  joinLobby.isVisible = false
  subLobby.isVisible = false
  leaveLobby.isVisible = false
  sendChat.isVisible = false
  sendPrivateChat.isVisible = false
  sendUpdatePeer.isVisible = false
  gameStart.isVisible = false
  sendMove.isVisible = false
  getMoveHistory.isVisible = false
  stopGame.isVisible = false
  previous.isVisible = false
  next.isVisible = false
  sendUDPUpdatePeers.isVisible = false
  sendUDPPrivateUpdateButton.isVisible = false

end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
  print( "((destroying scene 2's view))" )
	  
  display.remove(disconnectButton)
  display.remove(roomIdInfo)
  display.remove(userData)
  display.remove(roomData)
  display.remove(setCustomRoomDataButton)
  display.remove(setCustomUserDataButton)
  display.remove(userInfo)
  display.remove(unsubLobby)
  display.remove(joinLobby)
  display.remove(subLobby)
  display.remove(leaveLobby)
  display.remove(sendChat)
  display.remove(sendPrivateChat)
  display.remove(sendUpdatePeer)
  display.remove(gameStart)
  display.remove(sendMove)
  display.remove(getMoveHistory)
  display.remove(stopGame)
  display.remove(sendUDPUpdatePeers)
  display.remove(previous)
  display.remove(next)
  display.remove(sendUDPPrivateUpdateButton)




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