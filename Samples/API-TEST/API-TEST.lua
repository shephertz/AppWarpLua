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

local image,scrollView, statusText, getOnlineUserButton,getLiveUserInfoButton,Username,textField,getLiveRoomInfoButton,getLiveUserInfoButton
local roomIdInfo,getLiveLobbyInfoButton,createRoomButton,joinRoomButton,joinRoomIdInfo,subRoomButton,unsubRoomButton,leaveRoomButton,deleteRoomButton
local next,createTurnButton,onlineStatusButton,joinAndSubButton,LeaveAndUnsubButton,usersCountButton,roomsCountButton

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
            left = ((display.contentWidth-200)/2)+100,
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

  getOnlineUserButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+70,
            top = 160,

            label = "Get Online User",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getOnlineUsers()
                end
            end
        }
 



getLiveUserInfoButton =  require("widget").newButton
        {
            
  left = ((display.contentWidth-200)/2)+80,
            top = 120,
            label = "Get Live User Info",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getLiveUserInfo(textField.text)
                end
            end
        }

createRoomButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+60,
            top = 200,
            label = "Create Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    local key= "india"
                    local val =  "up"
                    local t = {}
                    t[key] = val
                    appWarpClient.createRoom('name', 'owner', 5, t)
                end
            end
        }
createTurnButton =  require("widget").newButton
        {
            left = -25,
            top = 200,
            label = "Create Turn Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.createTurnRoom('name', 'owner', 5, "",100)
                end
            end
        }

onlineStatusButton =  require("widget").newButton
        {
            left = -45,
            top = 230,
            label = "Online Status",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getUserStatus(textField.text)
                end
            end
        }

usersCountButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+60,
            top = 230,
            label = "Users Count",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getOnlineUsersCount()
                end
            end
        }
roomsCountButton =  require("widget").newButton
        {
            left = -45,
            top = 260,
            label = "Rooms Count",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getAllRoomsCount()
                end
            end
        }

getLiveLobbyInfoButton =  require("widget").newButton
        {
          left = -20,
            top = 160,
            label = "Get Live Lobby Info",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getLiveLobbyInfo()
                end
            end
        }
    
 


getLiveRoomInfoButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+80,
            top = 300,
            label = "Get Live Room Info",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getLiveRoomInfo(roomIdInfo.text)
                end
            end
        }
    



joinRoomButton =  require("widget").newButton
        {
            left = -50,
            top = 330,
            label = "Join Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.joinRoom(roomIdInfo.text)
                end
            end
        }
subRoomButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+65,
            top = 330,
            label = "Subcribe Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.subscribeRoom(roomIdInfo.text)
                end
            end
        }

unsubRoomButton =  require("widget").newButton
        {
            left = -20,
            top = 360,
            label = "Unsubcribe Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.unsubscribeRoom(roomIdInfo.text)
                end
            end
        }

leaveRoomButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+60,
            top = 360,
            label = "Leave Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.leaveRoom(roomIdInfo.text)
                end
            end
        }

deleteRoomButton =  require("widget").newButton
        {
            left = -40,
            top = 390,
            label = "Delete Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.deleteRoom(roomIdInfo.text)
                end
            end
        }

joinAndSubButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+80,
            top = 390,
            label = "Join And Subscribe",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.joinAndSubscribeRoom(roomIdInfo.text)
                end
            end
        }

LeaveAndUnsubButton =  require("widget").newButton
        {
            left = -4,
            top = 420,
            label = "Leave and Unsubcribe",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                      appWarpClient.leaveAndUnsubscribeRoom(roomIdInfo.text)
                end
            end
        }
 next =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+120,
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
                    storyboard.gotoScene( "API-TEST-NEXT", "slideLeft", 800)
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
  textField = native.newTextField( ((display.contentWidth-200)/2)-60, 120, 150, 40 )  --  create the textfield once it has moved on stage
  textField.text = storyboard.description  -- get the stored value
  textField.placeholder = "Username"
  native.setKeyboardFocus( textField )
  textField.font = native.newFont( "Helvetica-Light", 18 )
  textField:addEventListener( "userInput", inputListener ) 



  roomIdInfo = native.newTextField( ((display.contentWidth-200)/2)-60, 300, 150, 40 )  --  create the roomId feild once it has moved on stage
  roomIdInfo.text = storyboard.description  -- get the stored value
  roomIdInfo.placeholder = "Room ID"
  native.setKeyboardFocus( roomIdInfo )
  roomIdInfo.font = native.newFont( "Helvetica-Light", 18 )
  roomIdInfo:addEventListener( "userInput", inputListener ) 




  disconnectButton.isVisible = true
  getOnlineUserButton.isVisible = true
  getLiveUserInfoButton.isVisible = true
  textField.isVisible = true
  roomIdInfo.isVisible = true
  getLiveUserInfoButton.isVisible = true
  getLiveRoomInfoButton.isVisible = true
  getLiveLobbyInfoButton.isVisible = true
  createRoomButton.isVisible = true
  joinRoomButton.isVisible = true
  subRoomButton.isVisible = true
  unsubRoomButton.isVisible = true
  leaveRoomButton.isVisible = true
  deleteRoomButton.isVisible = true
  createTurnButton.isVisible = true
  onlineStatusButton.isVisible = true
  joinAndSubButton.isVisible = true
  LeaveAndUnsubButton.isVisible = true
  next.isVisible = true
  usersCountButton.isVisible = true
  roomsCountButton.isVisible = true

  statusText.text = "Connected..."
  appWarpClient.addRequestListener("onConnectDone", scene.onConnectDone)        
  appWarpClient.addRequestListener("onDisconnectDone", scene.onDisconnectDone)
  appWarpClient.addRequestListener("onGetOnlineUsersDone", scene.onGetOnlineUsersDone)
  appWarpClient.addRequestListener("onGetLiveUserInfoDone", scene.onGetLiveUserInfoDone)
  appWarpClient.addRequestListener("onGetLiveRoomInfoDone", scene.onGetLiveRoomInfoDone)
  appWarpClient.addRequestListener("onGetLiveLobbyInfoDone", scene.onGetLiveLobbyInfoDone)
  appWarpClient.addRequestListener("onCreateRoomDone", scene.onCreateRoomDone)
  appWarpClient.addRequestListener("onJoinRoomDone", scene.onJoinRoomDone)
  appWarpClient.addRequestListener("onSubscribeRoomDone", scene.onSubscribeRoomDone)
  appWarpClient.addRequestListener("onUnsubscribeRoomDone", scene.onUnsubscribeRoomDone)
  appWarpClient.addRequestListener("onLeaveRoomDone", scene.onLeaveRoomDone)
  appWarpClient.addRequestListener("onDeleteRoomDone", scene.onDeleteRoomDone)
  appWarpClient.addRequestListener("onUserStatusDone", scene.onUserStatusDone)
  appWarpClient.addRequestListener("onGetOnlineUsersCountDone", scene.onGetOnlineUsersCountDone)
  appWarpClient.addRequestListener("onGetAllRoomsCountDone", scene.onGetAllRoomsCountDone)
  appWarpClient.addRequestListener("onJoinAndSubscribeRoomDone", scene.onJoinAndSubscribeRoomDone)
  appWarpClient.addRequestListener("onLeaveAndUnsubscribeRoomDone", scene.onLeaveAndUnsubscribeRoomDone)


  appWarpClient.addNotificationListener("onUpdatePeersReceived", scene.onUpdatePeersReceived)
  appWarpClient.addNotificationListener("onRoomCreated", scene.onRoomCreated)
  appWarpClient.addNotificationListener("onRoomDeleted", scene.onRoomDeleted)
  appWarpClient.addNotificationListener("onUserJoinedRoom", scene.onUserJoinedRoom)
  appWarpClient.addNotificationListener("onUserLeftRoom", scene.onUserLeftRoom)
  appWarpClient.addNotificationListener("onUserLeftLobby", scene.onUserLeftLobby)
  appWarpClient.addNotificationListener("onUserJoinedLobby", scene.onUserJoinedLobby)
  appWarpClient.addNotificationListener("onChatReceived", scene.onChatReceived)


end

function scene.onConnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "Connect failed.."
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )
  end  
end



function scene.onGetOnlineUsersDone(resultCode,usersTable)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text = "resultCode :"..resultCode
    else  
    statusText.text = "resultCode:"..resultCode    
    print(usersTable)
    for i = 1, #usersTable do
        print ("  ",usersTable[i])
    end
  end  
end

function scene.onGetLiveUserInfoDone(resultCode, name,custom,locationId,isLobby)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text = "resultCode :"..resultCode
    else  
    statusText.text = "resultCode:"..resultCode   
    print('name',name)
    print('custom',custom)
    print('locationId',locationId)
    print('isLobby',isLobby)
  end  
end

function scene.onGetLiveRoomInfoDone(resultCode,room1)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text = "resultCode :"..resultCode
    else  
    statusText.text = "resultCode:"..resultCode 
    print('ID  ',room1['id'])
    print('Name  ',room1['name'])
    print('Max users  ',room1['maxUsers'])
    print('Owner  ',room1['owner'])
    print('Data  ',room1['data'])
    print('Owner  ',room1['owner'])
    print('Properties  ',room1['properties'])
print('lockProperties  ',room1['lockProperties'])



    for i = 1, #room1 do
        print ("  id  ",room1[i])
    end  


  end  
end

function scene.onGetLiveLobbyInfoDone(resultCode,room2)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text = "resultCode  :"..resultCode 
    else  
    statusText.text = "resultCode  :"..resultCode  
 print("onGetLiveLobbyInfoDone",tostring(room2))
      for i = 1, #room2 do
        print ("    ",room2[i])
    end 
  end  
end

function scene.onCreateRoomDone(resultCode,id,roomname)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text = "resultCode  :"..resultCode  
    else  
    statusText.text = "resultCode  :"..resultCode  
    print ("onCreateRoomDone:"..resultCode ) 
    print ( "ID:"..id   ) 
    print ( "RoomName :"..roomname ) 

  end  
end

function scene.onJoinRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode 
    print ( "ID:"..id   )    
  end  
end


function scene.onSubscribeRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "ID:"..id)  
  end  
end

function scene.onUnsubscribeRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "ID:"..id)  
  end  
end

function scene.onLeaveRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode 
    print ( "ID:"..id)   
  end  
end

function scene.onDeleteRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode   
    print ( "ID:"..id)   
  end  
end

function scene.onChatReceived(sender, message)
  statusText.text = "new message: "..message
end

function scene.onDisconnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text =  "resultCode  :"..resultCode  
  else
    statusText.text = "Disconnected"
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )		
  end  
end

function scene.onUpdatePeersReceived(payload)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print("onUpdatePeersReceived  :")
    print('payload  ',payload)	
  end  
end

function scene.onRoomCreated(id,name,maxUsers)
  
    print("onRoomCreated  :")
    print('Id  ',id)	
    print('Name  ',name)	
    print('Max user  ',maxUsers)
   
end

function scene.onRoomDeleted(id,name)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print("onRoomDeleted  :")
    print('Id  ',id)	
    print('Name  ',name)	
  end  
end

function scene.onUserJoinedRoom(user,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print("onUserJoinedRoom  :")
    print('Id  ',id)	
    print('User  ',user)	
  end  
end


function scene.onUserLeftRoom(user,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print("onUserLeftRoom  :")
    print('Id  ',id)	
    print('User  ',user)	
  end  
end

function scene.onUserLeftLobby(user)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print("onUserLeftLobby  :")
    print('User  ',user)	
  end  
end


function scene.onUserJoinedLobby(user)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
  else
    print("onUserJoinedLobby  :")
    print('User  ',user)	
  end  
end


function scene.onUserStatusDone(resultCode,status,username)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "status:",status)  
    print ( "username:",username)  
  end  
end

function scene.onGetOnlineUsersCountDone(resultCode,count)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "count:",count)  
  end  
end

function scene.onGetAllRoomsCountDone(resultCode,count)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "count:",count)  
  end  
end

function scene.onJoinAndSubscribeRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "ID:"..id)  
  end  
end

function scene.onLeaveAndUnsubscribeRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
        statusText.text =  "resultCode  :"..resultCode  
    else  
    statusText.text =  "resultCode  :"..resultCode  
    print ( "ID:"..id)  
  end  
end



-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "2: exitScene event" )

  disconnectButton.isVisible = false
  getOnlineUserButton.isVisible = false
  getLiveUserInfoButton.isVisible = false
  textField.isVisible = false
  roomIdInfo.isVisible = false
  getLiveUserInfoButton.isVisible = false
  getLiveRoomInfoButton.isVisible = false
  getLiveLobbyInfoButton.isVisible = false
  createRoomButton.isVisible = false
  joinRoomButton.isVisible = false
  subRoomButton.isVisible = false
  next.isVisible = false
  unsubRoomButton.isVisible = false
  leaveRoomButton.isVisible = false
  deleteRoomButton.isVisible = false
  createTurnButton.isVisible = false
  onlineStatusButton.isVisible = false
  joinAndSubButton.isVisible = false
  LeaveAndUnsubButton.isVisible = false
  usersCountButton.isVisible = false
  roomsCountButton.isVisible = false
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
  print( "((destroying scene 2's view))" )
	  
  display.remove(disconnectButton)
  display.remove(getOnlineUserButton)
  display.remove(getLiveUserInfoButton)
  display.remove(textField)
  display.remove(roomIdInfo)
  display.remove(getLiveRoomInfoButton)
  display.remove(getLiveLobbyInfoButton)
  display.remove(createRoomButton)
  display.remove(joinRoomButton)
  display.remove(subRoomButton)
  display.remove(unsubRoomButton)
  display.remove(leaveRoomButton)
  display.remove(deleteRoomButton)
  display.remove(createTurnButton)
  display.remove(onlineStatusButton)
  display.remove(joinAndSubButton)
  display.remove(LeaveAndUnsubButton)
  display.remove(usersCountButton)
  display.remove(roomsCountButton)

  display.remove(next)

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