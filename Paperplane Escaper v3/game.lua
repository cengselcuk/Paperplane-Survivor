local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()


local json = require( "json" )
local scoresTable = {}
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )

local filePathForAudio = system.pathForFile("audioholder.json", system.DocumentsDirectory)
local soundOnOff = {}
soundOnOff[1] = "on"


io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
math.randomseed(os.time())
-- =====================================================
require "ssk2.loadSSK"
_G.ssk.init( { measure = false } )
-- =====================================================
--ssk.meters.create_fps(true)
--ssk.meters.create_mem(true)
--ssk.misc.enableScreenshotHelper("s") 
--ssk.easyIFC.generateButtonPresets( nil, true )
-- =====================================================
--if( ssk.misc.countLocals ) then ssk.misc.countLocals(1) end
-- =====================================================

local physics = require "physics"
physics.start()
physics.setGravity( 0, 0 )
--physics.setDrawMode("hybrid")


local mRand = math.random

local flyTable = {}
local gameLoopTimer
local died = false

local heart
local heartArray = {}

local layers
local player
local back
local wrapProxy
local pauseBtn
local playBtn

local lives = 3
local timeCount = 0
local timeLable
local livesLable

local flyMusic
local ouchSound
local pickupSound
local gameOverSound

local resumeX = 0
local resumeY = 0
local resumeRotation = 0

local isPaused = false

local filePathForHardness = system.pathForFile("hardnessholder.json", system.DocumentsDirectory)
local filePathForColor = system.pathForFile("colorholder.json", system.DocumentsDirectory)

local tempHardness = {}
local tempColor = {}


local function loadHardness()
  local file = io.open(filePathForHardness, "r")

  if file then
    local contentsH = file:read("*a")
    io.close( file )
    tempHardness = json.decode(contentsH)
  end
  
  return tempHardness[1]

end    



local function loadColor()
  local file = io.open(filePathForColor, "r")

  if file then
    local contentsC = file:read("*a")
    io.close( file )
    tempColor = json.decode(contentsC)
  end
  
  return tempColor[1]

end    






--local hardness = "Easy"
local hardness = loadHardness()

local howManySeconds = 900

local planecolor = loadColor()

if (planecolor == nil) then
  planecolor = "blue"
end  




local function createFlies()
  
  local sceneGroup = scene.view
  local newFly = display.newImageRect(sceneGroup,"images/fly100px.png", 525, 475)
  newFly:scale(0.15,0.15)
  table.insert(flyTable, newFly)

  local randomForBigOne = math.random(100)

  if randomForBigOne == 20 or randomForBigOne == 21 or randomForBigOne == 22 or randomForBigOne == 23 then
    physics.addBody(newFly, "dynamic", {radius=55, bounce=2})
    newFly.myName = "fly"
    newFly:scale( 1.7, 1.7 )

  elseif randomForBigOne == 30 then
    physics.addBody(newFly, "dynamic", {radius=70, bounce=3})
    newFly.myName = "fly"
    newFly:scale( 2.4 , 2.4 )  
  
  else   
    physics.addBody(newFly, "dynamic", {radius=30, bounce=1})
    newFly.myName = "fly"

  end  


  local whereFrom = math.random(4)


  local x1,y1,x2,y2,x3,y3,x4,y4
  local tempTan1, tempTan2, tempTan3, tempTan4
  
  if whereFrom == 1 then -- up
    
    newFly.x = math.random(display.contentWidth)
    newFly.y = -60
    x1 = math.random( -40, 40 )
    if x1 == 0 then
      x1 = 1
    end  
    y1 = math.random( 40, 120 )
    tempTan1 = (y1/x1)
    if tempTan1 > 0 then
      newFly.rotation = 90 + (math.atan( tempTan1 )*57)
    else
      newFly.rotation = 270 + (math.atan( tempTan1 )*57)
    end  
    newFly:setLinearVelocity(x1, y1)
    
  elseif whereFrom == 2 then -- left
    
    newFly.x = -60
    newFly.y = math.random(display.contentHeight)
    x2 = math.random( 40, 120 )
    y2 = math.random( -60, 60 )
    tempTan2 = (y2/x2)
    newFly.rotation = 90 + (math.atan( tempTan2 )*57)
    newFly:setLinearVelocity(x2, y2)
    
  elseif whereFrom == 3 then -- right
    
    newFly.x = display.contentWidth + 60
    newFly.y = math.random(display.contentHeight)
    x3 = math.random( -120, -40 )
    y3 = math.random( -60, 60 )
    tempTan3 = (y3/x3)
    newFly.rotation = 270 + (math.atan( tempTan3 )*57)
    newFly:setLinearVelocity(x3,y3)
    
  elseif whereFrom == 4 then -- down
    
    newFly.x = math.random(display.contentWidth)
    newFly.y = display.contentHeight + 60
    x4 = math.random( -40, 40 )
    if x4 == 0 then
      x4 = 1
    end  
    y4 = math.random( -120, -40 )
    tempTan4 = (y4/x4)
    if tempTan4 > 0 then
      newFly.rotation = 270 + (math.atan( tempTan4 )*57)
    else
      newFly.rotation = 90 + (math.atan( tempTan4 )*57)
    end  
    newFly:setLinearVelocity(x4, y4)

    
  end
  
  --newFly:applyTorque(-6,6)

end


local function timeCounter()
  timeCount = timeCount + 1
  timeLable.text = timeCount
  
  
end



--Selcuk Mazellan



local function gameLoop()

  if (timeCount > 2) then
  
  createFlies()

  for i = #flyTable, 1, -1 do
    
    local thisFly = flyTable[i]
    
    if ( thisFly.x < -100 or
      thisFly.x > display.contentWidth + 100 or
      thisFly.y < -100 or
      thisFly.y > display.contentHeight + 100 )
    then
      display.remove(thisFly)
      table.remove(flyTable, i)
    end
    
  end  

end

end




local function restorePlane()
  
  player.isBodyActive = false
  player.x = display.contentCenterX
  player.y = display.contentCenterY
  
  transition.to(player, {alpha = 1, time = 3000,
      onComplete = function()
        player.isBodyActive = true
        died = false
      end
      })
      
end  




local function spawnHealth()
  
  local sceneGroup = scene.view
  
  if (#heartArray == 0) then
    heart = display.newImageRect(sceneGroup,"images/heart.png", 256, 256)
    heart.x = math.random(display.contentWidth)
    heart.y = math.random(display.contentHeight)
    heart:scale(0.4,0.4)
    physics.addBody(heart, "static", {radius = 37, bounce = 0, isSensor = true})
    heart.myName = "heart"
    
    table.insert(heartArray, heart)
    
    transition.to(heart, {alpha = 0.2, time = 3600,
        onComplete = function()
          display.remove(heart)
          table.remove(heartArray, 1)
          end })
          
  end
  

end




local function gotoMenu()
  
  composer.gotoScene("menu")
  
  
end



local function bodyActiveFalse()
	player.isBodyActive = false
end	




local function onCollision(event)
  
  local sceneGroup = scene.view
  local phase = event.phase
  
  if phase == "began" then
    
    local obj1 = event.object1
    local obj2 = event.object2

    local animationX
    local animationY
    
    if ( ( obj1.myName == "fly" and obj2.myName == "paperplane" or
           obj1.myName == "paperplane" and obj2.myName == "fly" ) )
    then

    

    if obj1.myName == "fly" then
      animationX = obj1.x
      animationY = obj1.y

      display.remove(obj1)

      for i = #flyTable, 1, -1 do
                if ( flyTable[i] == obj1 or flyTable[i] == obj2 ) then
                    table.remove( flyTable, i )
                    break
                end
      end

    elseif obj2.myName == "fly" then
      animationX = obj2.x
      animationY = obj2.y

      display.remove(obj2)

      for i = #flyTable, 1, -1 do
                if ( flyTable[i] == obj1 or flyTable[i] == obj2 ) then
                    table.remove( flyTable, i )
                    break
                end
      end

    end    


    local explosiondata = {width=120, height=120, numFrames = 25, SheetContentWidth = 3000, SheetContentHeight = 120}

    local explosionsheet = graphics.newImageSheet("images/explosion.png", explosiondata)

    local animationdata = {name="pat", start = 1, count = 25, time=500, loopCount = 1}

    local animation = display.newSprite(explosionsheet, animationdata)

    animation.x = animationX
    animation.y = animationY

    animation:setSequence( "pat" )
    animation:play()




      local fileAudio = io.open(filePathForAudio, "r")

      if fileAudio then
        local contentsA = fileAudio:read("*a")
        io.close( fileAudio )
        soundOnOff = json.decode(contentsA)

      end


      if soundOnOff[1] == "on" or soundOnOff == "on" then

        audio.play( ouchSound )

      end
      
      if died == false then
        
        died = true
        
        lives = lives - 1
        livesLable.text = "Lives: "..lives
        
        if lives == 0 then
          display.remove(player)
          Runtime:removeEventListener("enterFrame", player);
          back:removeEventListener("touch")
          timer.cancel(timeGoGo)


          local gameOverOverlay = display.newImageRect(sceneGroup,"images/backgrounds/gameover.png", 608, 342)
          gameOverOverlay.x = display.contentCenterX
          gameOverOverlay.y = display.contentCenterY
          gameOverOverlay:toFront()
          
          
          local diedText = display.newText(sceneGroup,"Game Over !", display.contentCenterX, display.contentCenterY - 120, "Roboto-Light.ttf", 44)
          diedText:setFillColor(0.2,0.76,0.67)
          diedText:toFront()
          
          local gameOverTime = display.newText(sceneGroup,"Your time: "..timeCount.." s", display.contentCenterX, display.contentCenterY - 50
            ,"Roboto-Light.ttf", 44)
          gameOverTime:setFillColor(0.2,0.76,0.67)
          gameOverTime:toFront()
          
          display.remove(pauseBtn)

          timer.pause(gameLoopTimer)
          timer.pause(spawnHealthTimer)

          audio.setVolume( 0.1, {channel = 1} )

          if soundOnOff[1] == "on" or soundOnOff == "on" then
            audio.play(gameOverSound)

          end  


          local file = io.open( filePath, "r" )

          if file then
            local contents = file:read( "*a" )
            io.close( file )
            scoresTable = json.decode( contents )
          end
          
          if (scoresTable == nil or #scoresTable == 0) then
            scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
          end  


          if timeCount > scoresTable[1] then
            local newRecord = display.newText(sceneGroup, "NEW RECORD!!!", display.contentCenterX, display.contentCenterY+10,"Roboto-Light.ttf", 50)
            newRecord:setFillColor( 1,0,0 )

            local newRecordStar1 = display.newImageRect(sceneGroup, "images/star.png", 40, 40)
            local newRecordStar2 = display.newImageRect(sceneGroup, "images/star.png", 40, 40)

            newRecordStar1.x = display.contentCenterX - 220
            newRecordStar1.y = display.contentCenterY + 10

            newRecordStar2.x = display.contentCenterX + 220
            newRecordStar2.y = display.contentCenterY + 10

             transition.blink( newRecord, {time=2000} )
             transition.blink( newRecordStar1, {time=2000} )
             transition.blink( newRecordStar2, {time=2000} )

            
          end 




          table.insert( scoresTable, timeCount )

          local function compare( a, b )
            return a > b
          end
           
          table.sort( scoresTable, compare )


          for i = #scoresTable, 11, -1 do
             table.remove( scoresTable, i )
          end

          local file = io.open( filePath, "w" )

          if file then
            file:write( json.encode( scoresTable ) )
            io.close( file )
          end  



          
          local gotoMenuBtn = widget.newButton(
          {
            label = "Go to Menu",
            onPress = gotoMenu,
            emboss = true,
            -- Properties for a rounded rectangle button
            shape = "roundedRect",
            font = "Roboto-Light.ttf",
            width = 240,
            height = 50,
            cornerRadius = 2,
            labelColor = { default = {1,0,0}, over = {1,0,0,0.8} },
            fontSize = 24,
            fillColor = { default={0,0,1,0.5}, over={1,0,0,0.6} },
            strokeColor = { default={0.2,0.76,0.67,5}, over={0.3,0.4,0.5,0.6} },
            strokeWidth = 3
          }
        )
            gotoMenuBtn:scale(1.5,1.5)
            gotoMenuBtn.x = 480
            gotoMenuBtn.y = display.contentCenterY + 100
            
            sceneGroup:insert(gotoMenuBtn)
          
          
        else
          player.alpha = 0
          timer.performWithDelay(10, bodyActiveFalse, 1)
          restorePlaneTimer = timer.performWithDelay(1000, restorePlane)
        end
      end
      
      
    elseif ( ( obj1.myName == "heart" and obj2.myName == "paperplane" or
           obj1.myName == "paperplane" and obj2.myName == "heart" ) )
    then


    local fileAudioHeart = io.open(filePathForAudio, "r")

      if fileAudioHeart then
        local contentsHeart = fileAudioHeart:read("*a")
        io.close( fileAudioHeart )
        soundOnOff = json.decode(contentsHeart)

      end

      


      if soundOnOff[1] == "on" or soundOnOff == "on" then

        audio.play( pickupSound )

      end


      local copyHeart = display.newImageRect("images/heart.png",256,256)
      copyHeart:scale(0.4,0.4)
      copyHeart.x = heart.x
      copyHeart.y = heart.y

      transition.to( copyHeart, {time = 1500, x=100, y=50, alpha = 0.2, onComplete = function() display.remove(copyHeart) end} )

      
      lives = lives + 1
      livesLable.text = "Lives: "..lives
      


      display.remove(heart)
      
      for i=#heartArray, 1, -1 do
        
        table.remove(heartArray, i)
        
      end  
    
    end

  end


end



local function resumeGame(event)
  if event.phase == "ended" then
    transition.resume()
    physics.start()
    
    timer.resume(timeGoGo)
    timer.resume(gameLoopTimer)
    timer.resume(spawnHealthTimer)

    audio.resume( 1 )

    -- player.x = resumeX
    -- player.y = resumeY
    -- player.rotation = resumeRotation
    
    -- Runtime:addEventListener("enterFrame",player)
    -- back:addEventListener("touch")
    -- Runtime:addEventListener("collision",onCollision)

    --This is a hack to force SSK to ignore delta time calculations 
    --if the game has been paused
    ssk.actions.move.forward( player, { ignoreDeltaTime = true } )
    
    playBtn.isVisible = false
    pauseBtn.isVisible = true

    isPaused = false
    return true
  end
  
end  



local function pauseGame(event)
  if event.phase == "ended" then
    transition.pause()
    physics.pause()
    
    timer.pause(timeGoGo)
    timer.pause(gameLoopTimer)
    timer.pause(spawnHealthTimer)

    audio.pause( 1 )
    
    -- resumeX = player.x
    -- resumeY = player.y
    -- resumeRotation = player.rotation
    
    -- ignore("enterFrame", player)
    -- back:removeEventListener("touch")
    -- ignore("collision", onCollision)
    
    pauseBtn.isVisible = false
    playBtn.isVisible = true
    

    isPaused = true

    
    return true
  end
  
end  










function scene:create( event )
  --composer.recycleOnSceneChange = true
	local sceneGroup = self.view
	
  physics.pause()
  
  layers = ssk.display.quickLayers( group,  "underlay",  "world",  "gems", "content", "interfaces" )
  wrapProxy = ssk.display.newImageRect( layers.content, centerX, centerY, "images/fillT.png", { w = fullw + 80, h = fullh + 80 } )
  
  sceneGroup:insert(layers)
  
  back = display.newImageRect(sceneGroup, "images/backgrounds/b1.png", 1280, 720)
  back.x = display.contentCenterX
  back.y = display.contentCenterY
  

  if composer.getVariable("color") ~= nil then
    planecolor = composer.getVariable("color")
  end

  local physics_body = {}
  physics_body["plane"] = {

    {

      
                    
                    pe_fixture_id = "plane", density = 1.5, friction = 0, bounce = 4, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -11, 26  ,  4, -33  ,  9, 26  ,  1, 38  }
                    }
                     ,
                    {
                    pe_fixture_id = "plane", density = 1.5, friction = 0, bounce = 4, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   9, 26  ,  4, -33  ,  32, 23  ,  31, 29  }
                    }
                     ,
                    {
                    pe_fixture_id = "plane", density = 1.5, friction = 0, bounce = 4, 
                    filter = { categoryBits = 1, maskBits = 65535, groupIndex = 0 },
                    shape = {   -28, 28  ,  -32, 25  ,  -1, -33  ,  4, -33  ,  -11, 26  }
                    }
    




  }


  player = ssk.display.newImageRect( layers.player, centerX, centerY, "images/paperplane"..planecolor..".png", {bounce = 6})
  player.faceAngle = 0
  physics.addBody(player, "dynamic", unpack( physics_body["plane"] ))
  player.myName = "paperplane"


  if planecolor == "white" then
    player:scale( 3.6, 3.6 )

  elseif planecolor == "black" then
    player:scale( 3, 3 )

  elseif planecolor == "cool" then
    player:scale( 3.2, 3.2 )  

  elseif planecolor == "blue" then
    player:scale( 3.1, 3.1 )  

  end  
  
  
  --changed to touch event
  pauseBtn = display.newImageRect(sceneGroup,"images/pause.png", 500, 500)
  pauseBtn.x = 1000
  pauseBtn.y = 40
  pauseBtn:scale(0.13,0.13)
  pauseBtn:addEventListener("touch", pauseGame)


  --changed to touch event
  playBtn = display.newImageRect(sceneGroup,"images/play.png", 500, 500)
  playBtn.x = 1000
  playBtn.y = 40
  playBtn:scale(0.13,0.13)
  playBtn.isVisible = false
  playBtn:addEventListener("touch", resumeGame)
  
  
  timeLable = display.newText(sceneGroup,"0", right - 150, top + 50, "Roboto-Light.ttf", 40)
  livesLable = display.newText(sceneGroup,"Lives: "..lives, left + 150, top + 50, "Roboto-Light.ttf", 32)
  
  
  --hardness = composer.getVariable("level")
  
  if hardness == "Easy" then
    howManySeconds = 900
    
  elseif hardness == "Medium" then
    howManySeconds = 650
    
  elseif hardness == "Hard" then
    howManySeconds = 400

  elseif hardness == "Impossible" then
    howManySeconds = 200
    
  end  
  
  --testing
  --howManySeconds = 50000

  ouchSound = audio.loadSound("audios/ouch.mp3")
  pickupSound = audio.loadSound("audios/pickupmp.mp3")
  gameOverSound = audio.loadSound("audios/gameover.mp3")
  flyMusic = audio.loadStream("audios/flymusic.mp3")



  function player.enterFrame( self )
    if isPaused then return false end  

  	ssk.actions.face( self, { angle = self.faceAngle, rate = 750 } )
    ssk.actions.move.forward( self, { rate = 400 } )
    ssk.actions.scene.rectWrap( self, wrapProxy )

    return true
  end; 


  function back.touch( self, event )
    if isPaused then return false end  
    if event.phase == "moved" or event.phase == "ended" then

    	local vec = ssk.math2d.diff( player, event )
    	player.faceAngle = ssk.math2d.vector2Angle( vec )
    end  
  	return false
  end;
  


  Runtime:addEventListener( 'enterFrame', player )
  back:addEventListener( 'touch' )

end
 

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase
  
  

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
    

	elseif ( phase == "did" ) then
		
    physics.start()
    
    Runtime:addEventListener( "collision", onCollision )
    gameLoopTimer = timer.performWithDelay(howManySeconds,gameLoop,0)
    
    
    timeGoGo = timer.performWithDelay(1000,timeCounter,0)
    
    spawnHealthTimer = timer.performWithDelay(math.random(25000,35000), spawnHealth, 0)

    local fileAudio = io.open(filePathForAudio, "r")

    if fileAudio then
      local contentsA = fileAudio:read("*a")
      io.close( fileAudio )
      soundOnOff = json.decode(contentsA)

    end


    if soundOnOff[1] == "on" or soundOnOff == "on" then

      audio.play( flyMusic, { channel=1, loops=-1 } )

    end


 	end
end


-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
    
    

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
    
    Runtime:removeEventListener( "collision", onCollision )
    physics.pause()
    
    timer.cancel(gameLoopTimer)
    timer.cancel(timeGoGo)
    timer.cancel(restorePlaneTimer)
    timer.cancel(spawnHealthTimer)
    
    audio.stop( 1 )

    composer.removeScene( "game" )

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

  audio.dispose( flyMusic )
  audio.dispose( ouchSound )
  audio.dispose( pickupSound )
  audio.dispose( gameOverSound )

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
