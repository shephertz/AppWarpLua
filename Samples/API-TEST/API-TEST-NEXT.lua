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

local image,scrollView, statusText
local propKey,propVal,removeProp,lockPropButton,unlockPropButton,updateRoomPropButton,getRoomPropButton,joinRoomWithPropButton,joinRoomID
local getAllRoom,getRoomInRange,getRoomInRangeWithProp,minUser,maxUser,next,previous
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



 lockPropButton =  require("widget").newButton
        {
            left = -40,
            top = 210,
            label = "lock Properties",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    local key= propKey.text
                    local val =  propVal.text
                    local t = {}
                    t[key] = val
                    appWarpClient.lockProperties(t)
              
                end
            end
        } 

 unlockPropButton =  require("widget").newButton
        {
            left =  ((display.contentWidth-200)/2)+75,
            top = 170,
            label = "unlock Properties",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event)
                local t1 = {removeKey} 
                appWarpClient.unlockProperties(t1)   
            end
        } 

 updateRoomPropButton =  require("widget").newButton
        {
            left =  ((display.contentWidth-200)/2)+60,
            top = 210,
            label = "update Prop",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                     local key= propKey.text
                     local val =  propVal.text
                     local t = {}
                     t[key] = val
                     local t1 = {removeKey} 

                     appWarpClient.updateRoomProperties(joinRoomID.text,t,t1);
                end
            end
        }

 getRoomPropButton =  require("widget").newButton
        {
            left = ((display.contentWidth-200)/2)+85,
            top = 240,
            label = "GetRoomWithProp",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                     local key= propKey.text
                     local val =  propVal.text
                     local t = {}
                     t[key] = val
                    appWarpClient.getRoomsWithProperties(t)
                end
            end
        }
 joinRoomWithPropButton =  require("widget").newButton
        {
            left =  -30,
            top = 240,
            label = "JoinRoomWithProp",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                     local key= propKey.text
                     local val =  propVal.text
                     local t = {}
                     t[key] = val
                    appWarpClient.joinRoomWithProperties(t)
                end
            end
        }

 getAllRoom =  require("widget").newButton
        {
            left =  -50,
            top = 270,
            label = "Get All Room",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    appWarpClient.getAllRooms()
                end
            end
        }

 getRoomInRange =  require("widget").newButton
        {
            left =  -30,
            top = 350,
            label = "GetRoomInRange",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                     appWarpClient.getRoomsInRange(minUser.text,maxUser.text)
                end
            end
        }


getRoomInRangeWithProp =  require("widget").newButton
        {
            left =  0,
            top = 380,
            label = "GetRoomInRangeWithProp",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then     
                     local key= propKey.text
                     local val =  propVal.text
                     local t = {}
                     t[key] = val               
                     appWarpClient.getRoomInRangeWithProperties(minUser.text,maxUser.text,t)
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
                    storyboard.gotoScene( "API-TEST", "slideRight", 800)
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
                    storyboard.gotoScene( "API-TEST-NEXT2", "slideLeft", 800)
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



  propKey = native.newTextField(10, 120, 100, 40 )  --  create the roomId feild once it has moved on stage
  propKey.text = storyboard.description  -- get the stored value
  propKey.placeholder = "Key"
  native.setKeyboardFocus( propKey )
  propKey.font = native.newFont( "Helvetica-Light", 18 )
  propKey:addEventListener( "userInput", inputListener ) 



  propVal = native.newTextField(((display.contentWidth-200)/2)+55, 120, 100, 40 )  --  create the roomId feild once it has moved on stage
  propVal.text = storyboard.description  -- get the stored value
  propVal.placeholder = "Val"
  native.setKeyboardFocus( propVal )
  propVal.font = native.newFont( "Helvetica-Light", 18 )
  propVal:addEventListener( "userInput", inputListener ) 

  removeProp = native.newTextField(((display.contentWidth-200)/2)+160, 120, 100, 40 )  --  create the roomId feild once it has moved on stage
  removeProp.text = storyboard.description  -- get the stored value
  removeProp.placeholder = "Remove"
  native.setKeyboardFocus( removeProp )
  removeProp.font = native.newFont( "Helvetica-Light", 18 )
  removeProp:addEventListener( "userInput", inputListener ) 

  joinRoomID = native.newTextField(10, 170, 100, 40 )  --  create the roomId feild once it has moved on stage
  joinRoomID.text = storyboard.description  -- get the stored value
  joinRoomID.placeholder = "Room ID"
  native.setKeyboardFocus( joinRoomID )
  joinRoomID.font = native.newFont( "Helvetica-Light", 18 )
  joinRoomID:addEventListener( "userInput", inputListener ) 


  minUser = native.newTextField(5, 310, 100, 40 )  --  create the roomId feild once it has moved on stage
  minUser.text = storyboard.description  -- get the stored value
  minUser.placeholder = "Min User"
  native.setKeyboardFocus( minUser )
  minUser.font = native.newFont( "Helvetica-Light", 18 )
  minUser:addEventListener( "userInput", inputListener ) 


  maxUser = native.newTextField(((display.contentWidth-200)/2)+100, 310, 100, 40 )  --  create the roomId feild once it has moved on stage
  maxUser.text = storyboard.description  -- get the stored value
  maxUser.placeholder = "Max User"
  native.setKeyboardFocus( maxUser )
  maxUser.font = native.newFont( "Helvetica-Light", 18 )
  maxUser:addEventListener( "userInput", inputListener ) 

  disconnectButton.isVisible = true
  propKey.isVisible = true
  propVal.isVisible = true
  removeProp.isVisible = true
  previous.isVisible = true
  lockPropButton.isVisible = true
  unlockPropButton.isVisible = true
  updateRoomPropButton.isVisible = true
  getRoomPropButton.isVisible = true
  joinRoomWithPropButton.isVisible = true
  joinRoomID.isVisible = true
  minUser.isVisible = true
  maxUser.isVisible = true
  getAllRoom.isVisible = true
  getRoomInRange.isVisible = true
  getRoomInRangeWithProp.isVisible = true
next.isVisible = true
  statusText.text = "Connected..."
  appWarpClient.addRequestListener("onDisconnectDone", scene.onDisconnectDone)
  appWarpClient.addRequestListener("onLockPropertiesDone", scene.onLockPropertiesDone)
  appWarpClient.addRequestListener("onUnlockPropertiesDone", scene.onUnlockPropertiesDone)
  appWarpClient.addRequestListener("onUpdatePropertyDone", scene.onUpdatePropertyDone)
  appWarpClient.addRequestListener("onUpdateRoomProperties", scene.onUpdateRoomProperties)
  appWarpClient.addRequestListener("onJoinRoomDone", scene.onJoinRoomDone)
  appWarpClient.addRequestListener("onGetAllRoomsDone", scene.onGetAllRoomsDone)
  appWarpClient.addRequestListener("onGetMatchedRoomsDone", scene.onGetMatchedRoomsDone)
  appWarpClient.addNotificationListener("onUserChangedRoomProperty", scene.onUserChangedRoomProperty)


end



function scene.onDisconnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "Disconnect failed.."
  else
    statusText.text = "Disconnected"
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )		
  end  
end


function scene.onLockPropertiesDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  end  
end


function scene.onUnlockPropertiesDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  end  
end


function scene.onUpdatePropertyDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
  end  
end


function scene.onUpdateRoomProperties(resultCode, room1)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
    for i = 1, #room1 do
        print ("    ",room1[i])
    end 
  end  
end


function scene.onJoinRoomDone(resultCode,id)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode  :"..resultCode
    print ("id :    ",id)
  end  
end

function scene.onGetAllRoomsDone(resultCode,roomsTable)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode:"..resultCode
    for i = 1, #roomsTable do
     print ("Room ID ",roomsTable[i])
    end
  end  
end

function scene.onGetMatchedRoomsDone(resultCode,roomsTable1)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode:"..resultCode
    local n =0
    for k,v in pairs(roomsTable1) do
      n = n+1      
      print ('Id ',roomsTable1[k].id)
      print("Name :",v.name)
      print("Max Users :",v.maxUsers)
      print("Owner :",v.owner)
      print("Admin : ",v.isAdmin)
    end 

   
  end  
end


function scene.onUserChangedRoomProperty(sender,id,properties,lockProperties)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "resultCode  :"..resultCode
  else
    statusText.text = "resultCode:"..resultCode
       print ("Sender ",sender)
       print ("Id ",id)
       print ("properties ",properties)
       print ("lockProperties ",lockProperties)
   
  end  
end



-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "2: exitScene event" )

  disconnectButton.isVisible = false
  propKey.isVisible = false
  propVal.isVisible = false
  removeProp.isVisible = false
  previous.isVisible = false
  lockPropButton.isVisible = false
  unlockPropButton.isVisible = false
  updateRoomPropButton.isVisible = false
  getRoomPropButton.isVisible = false
  joinRoomWithPropButton.isVisible = false
  joinRoomID.isVisible = false
  minUser.isVisible = false
  maxUser.isVisible = false
  getAllRoom.isVisible = false
  getRoomInRange.isVisible = false
  getRoomInRangeWithProp.isVisible = false
next.isVisible = false
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
  print( "((destroying scene 2's view))" )
	  
  display.remove(disconnectButton)
  display.remove(propKey)
  display.remove(propVal)
  display.remove(removeProp)
  display.remove(previous)
  display.remove(lockPropButton)
  display.remove(unlockPropButton)
  display.remove(updateRoomPropButton)
  display.remove(getRoomPropButton)
  display.remove(joinRoomWithPropButton)
  display.remove(joinRoomID)
  display.remove(minUser)
  display.remove(maxUser)
  display.remove(getAllRoom)
  display.remove(getRoomInRange)
  display.remove(getRoomInRangeWithProp)
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