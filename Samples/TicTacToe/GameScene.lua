---------------------------------------------------------------------------------
--
-- GameScene.lua
--
---------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local GRID_WIDTH = 256
local OBJECT_WIDTH = 64
local GAP = 256/3
local START_X = display.contentWidth/2-GRID_WIDTH/2
local START_Y = display.contentHeight/2-GRID_WIDTH/2
local TYPE = "0"

local ARRAY = {}
for i=0,2 do
  ARRAY[i] = {}
  for j=0,2 do
    ARRAY[i][j] = "-"
  end
end

local IMAGE_ARRAY = {}
for i=0,2 do
  IMAGE_ARRAY[i] = {}
end

local isUserTurn = false
local isGameRunning = false
local isGameOver = false
---------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
---------------------------------------------------------------------------------

local imagebg, imageGameBorad, statusText, detailText

local onTouch = function (event)
  if event.phase == "began" then 
      if(isGameOver) then
        storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )
      end
      if(isGameRunning == false and ROOM_ADMIN == USER_NAME ) then
        appWarpClient.startGame()
        return;
      end
      if (isUserTurn) then
        getIndex(event.x, event.y);
        isUserTurn = false
      else
        statusText.text = "Not your turn"
      end
    return true
  end
end

function getIndex(touchX, touchY)
  if(touchX>START_X and touchX<START_X+GRID_WIDTH and touchY>START_Y and touchY<START_Y+GRID_WIDTH) then
    for i=0,2 do
      for j=0,2 do 
        if ( touchX>(START_X+(j*GAP)) and touchX<(START_X+(j*GAP)+GAP) 
            and touchY>(START_Y+(i*GAP)) and touchY<(START_Y+(i*GAP)+GAP) ) then
            if(ARRAY[i][j] == "-" and TYPE=="0") then
              ARRAY[i][j] = "0"
            elseif(ARRAY[i][j] == "-" and TYPE=="X") then
              ARRAY[i][j] = "X"  
            end
            updateUI(i, j, TYPE);
            if(isGameWon()) then
              appWarpClient.sendMove(i .. "/" .. j .. "#" .. "WIN")
              handleFinishGame("WIN", "GAME_WIN")
            elseif(checkForDraw()) then
              appWarpClient.sendMove(i .. "/" .. j .. "#" .. "DRAW")
              handleFinishGame("DRAW", "MATCH_DRAW")
            else
              appWarpClient.sendMove(i .. "/" .. j .. "#" .. "")
              statusText.text = "Move Sent"
            end
        end
      end
    end
  end
end
-- check for game win row, column and diagonal
function isGameWon()
  if(ARRAY[0][0]~="-" and ARRAY[0][0] == ARRAY[0][1] and ARRAY[0][0] == ARRAY[0][2]) then
    return true;
  elseif(ARRAY[1][0]~="-" and ARRAY[1][0] == ARRAY[1][1] and ARRAY[1][0] == ARRAY[1][2]) then 
    return true;
  elseif(ARRAY[2][0]~="-" and ARRAY[2][0] == ARRAY[2][1] and ARRAY[2][0] == ARRAY[2][2]) then
    return true;
  elseif(ARRAY[0][0]~="-" and ARRAY[0][0] == ARRAY[1][0] and ARRAY[0][0] == ARRAY[2][0]) then
    return true;
  elseif(ARRAY[0][1]~="-" and ARRAY[0][1] == ARRAY[1][1] and ARRAY[0][1] == ARRAY[2][1]) then
    return true;
  elseif(ARRAY[0][2]~="-" and ARRAY[0][2] == ARRAY[1][2] and ARRAY[0][2] == ARRAY[2][2]) then  
    return true;
  elseif(ARRAY[0][0]~="-" and ARRAY[0][0] == ARRAY[1][1] and ARRAY[0][0] == ARRAY[2][2]) then  
    return true;
  elseif(ARRAY[0][2]~="-" and ARRAY[0][2] == ARRAY[1][1] and ARRAY[0][2] == ARRAY[2][0]) then  
    return true;
  end
  return false;
end

-- check for empty space in ARRAY
function checkForDraw()
  for i=0,2 do
    for j=0,2 do
      if(ARRAY[i][j]=="-") then
        return false;
      end
    end
  end
  return true;
end

function updateUI(i, j, t) 
  local group = display.newGroup();
  ARRAY[i][j] = t
  GAP = 256/3
  DRAW_X = START_X + (j*GAP) + GAP/2 - OBJECT_WIDTH/2
  DRAW_Y = START_Y + (i*GAP) + GAP/2 - OBJECT_WIDTH/2
    if( t == "0" ) then
      object = display.newImage( "button_AI.png", DRAW_X, DRAW_Y )
      IMAGE_ARRAY[i][j] = object
    elseif ( t == "X" ) then
      object = display.newImage( "button_exit.png", DRAW_X, DRAW_Y )
      IMAGE_ARRAY[i][j] = object
    end
end

function handleFinishGame(result, detail) 
  if(isGameRunning == false) then
    return
  end
  if (result == "WIN") then
    statusText.text = "Congrats! Game Won"
  elseif(result == "LOOSE") then
    statusText.text = "Oops! Game Loose"
  elseif(result == "DRAW") then  
    statusText.text = "Match Draw"
  end
  if (detail == "OPPONENT_LEFT") then
    detailText.text = "OPPONENT_LEFT";
  elseif (detail == "TIME_OVER") then
    detailText.text = "TIME_OVER";
  elseif (detail == "GAME_DRAW") then  
    detailText.text = "GAME_DRAW";
  elseif (detail == "GAME_WIN") then 
    detailText.text = "GAME_COMPLETED";
  elseif (detail == "GAME_LOOSE") then   
    detailText.text = "GAME_COMPLETED";
  end
  isGameRunning = false
  isGameOver = true
  appWarpClient.stopGame()
  appWarpClient.unsubscribeRoom(ROOM_ID);
  appWarpClient.leaveRoom(ROOM_ID);
  appWarpClient.deleteRoom(ROOM_ID);
  ROOM_ID = ""
  appWarpClient.disconnect()
end

Runtime:addEventListener("touch", onTouch);

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local screenGroup = self.view
	
	display.setDefault( "background", 255, 255, 255 )
  
  imageGameBorad = display.newImage( "grid.png", START_X, START_Y )
	screenGroup:insert( imageGameBorad )
  
	statusText = display.newText( "Welcome", 0, 0, native.systemFontBold, 24 )
  detailText = display.newText( "", 0, 0, native.systemFontBold, 24 )
  
  statusText:setTextColor( 155 )
	statusText:setReferencePoint( display.CenterReferencePoint )
	statusText.x, statusText.y = display.contentWidth * 0.5, 20
	screenGroup:insert( statusText )
  
  detailText:setTextColor( 155 )
	detailText:setReferencePoint( display.CenterReferencePoint )
	detailText.x, detailText.y = display.contentWidth * 0.5, 50
	screenGroup:insert( detailText )
	
  disconnectButton =  require("widget").newButton
        {
            left = (display.contentWidth-200)/2,
            top = display.contentHeight - 50,
            label = "Disconnect",
            width = 200, height = 40,
            cornerRadius = 4,
            onEvent = function(event) 
                if "ended" == event.phase then
                    statusText.text = "disconnecting.."
                    appWarpClient.unsubscribeRoom(ROOM_ID);
                    appWarpClient.leaveRoom(ROOM_ID);
                    appWarpClient.disconnect()
                    storyboard.gotoScene( "ConnectScene", "slideLeft", 800 )		
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

  disconnectButton.isVisible = true
  if(ROOM_ADMIN == USER_NAME) then
    statusText.text = "Tap to start"
    TYPE = "X"
  else
    statusText.text = "Wait to start"
  end
  detailText.text = ""
  appWarpClient.addRequestListener("onConnectDone", scene.onConnectDone)        
  appWarpClient.addRequestListener("onDisconnectDone", scene.onDisconnectDone)
  appWarpClient.addNotificationListener("onUserLeftRoom", scene.onUserLeftRoom)
  appWarpClient.addNotificationListener("onGameStarted", scene.onGameStarted)
  appWarpClient.addNotificationListener("onGameStopped", scene.onGameStopped)
  appWarpClient.addNotificationListener("onMoveCompleted", scene.onMoveCompleted)
end

function scene.onConnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    statusText.text = "Connection Error.."
    storyboard.gotoScene( "ConnectScene", "slideLeft", 800  )
  end  
end

function scene.onGameStarted(sender, roomId, nextTurn)
  isGameRunning = true
  if(nextTurn == USER_NAME) then
    isUserTurn = true
    statusText.text = "Your Turn"
  else
    isUserTurn = false
    statusText.text = "Opponent Turn"
  end
end

function scene.onMoveCompleted(sender, roomId, nextTurn, moveData)
  if(isGameRunning) then
    if(nextTurn == USER_NAME) then
      statusText.text = "Your Turn"
      isUserTurn = true
    else 
      statusText.text = "Opponent Turn"
      isUserTurn = false
    end
  end
   
  if(sender ~= USER_NAME) then
    if(string.len(moveData)>0) then
      i = string.sub(moveData, 0, string.find(moveData, "/")-1)
      j = string.sub(moveData, string.find(moveData, "/")+1, string.find(moveData, "#")-1)
      data = string.sub(moveData, string.find(moveData, "#")+1, string.len(moveData))
      if(TYPE == "X") then
        updateUI(tonumber(i), tonumber(j), "0");
      elseif (TYPE == "0") then
        updateUI(tonumber(i), tonumber(j), "X");
      end
      if(string.len(data)>0) then
        if(data=="WIN") then
          handleFinishGame("LOOSE", "GAME_LOOSE")
        elseif(data=="DRAW") then
          handleFinishGame("DRAW", "")
        end
      end
    else 
      handleFinishGame("WIN", "TIME_OVER")
    end
  else
    if(string.len(moveData)==0) then
      handleFinishGame("LOOSE", "TIME_OVER")
    end
  end
end

function scene.onGameStopped(sender, roomId)
  isGameRunning = false
end

function scene.onUserLeftRoom(userName, roomId)
  if (isGameRunning and userName ~= USER_NAME) then
    handleFinishGame("WIN", "OPPONENT_LEFT")
  end
end

function scene.onDisconnectDone(resultCode)
  if(resultCode ~= WarpResponseResultCode.SUCCESS) then
    
  else
    
  end  
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	
	print( "2: exitScene event" )
  disconnectButton.isVisible = false
  isUserTurn = false
  isGameRunning = false
  isGameOver = false
  for i=0,2 do
  ARRAY[i] = {}
    for j=0,2 do
      display.remove(IMAGE_ARRAY[i][j])
      IMAGE_ARRAY[i][j] = nil
    end
  end
  for i=0,2 do
  ARRAY[i] = {}
    for j=0,2 do
      ARRAY[i][j] = "-"
    end
  end
end


-- Called prior to the removal of scene's "view" (display group)
function scene:destroyScene( event )
	print( "((destroying scene 2's view))" )
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