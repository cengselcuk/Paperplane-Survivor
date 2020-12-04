local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()

local levelsettings = "Easy"
local planecolor = "red"

local json = require("json")

local filePathForHardness = system.pathForFile( "hardnessholder.json", system.DocumentsDirectory )
local hardnessTable = {}
local stringHardness = {}

local filePathForColor = system.pathForFile( "colorholder.json", system.DocumentsDirectory )
local colorTable = {}
local stringColor = {}

local filePathForAudio = system.pathForFile("audioholder.json", system.DocumentsDirectory)
local mutePic
local audioPic

local filePathForAudio = system.pathForFile("audioholder.json", system.DocumentsDirectory)
local soundOnOff = {}
soundOnOff[1] = "on"





local function loadHardness()
    local file = io.open( filePathForHardness, "r" )

    if file then
      local contentsH = file:read("*a")
      io.close( file )
      hardnessTable = json.decode(contentsH)
    end

    return hardnessTable[1]

end




local function saveHardness(stringHardness)
    local file = io.open(filePathForHardness,"w")

    if file then
      file:write(json.encode(stringHardness))
      io.close( file )
    end
    
end    




local function loadColor()
    local file = io.open(filePathForColor, "r")

    if file then
      local contentsC = file:read("*a")
      io.close( file )
      colorTable = json.decode(contentsC)
    end
    
    return colorTable[1]

end




local function saveColor(stringColor)
    local file = io.open( filePathForColor,"w" )

    if file then
      file:write(json.encode(stringColor))
      io.close( file )
    end
    
end           




local function onSwitchPress( event )
    local switch = event.target
    --print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    
    
    if (switch.id == "Easy") then
      levelsettings = "Easy"
      composer.setVariable("level", levelsettings)

      stringHardness[1] = nil
      stringHardness[1] = "Easy"
      saveHardness(stringHardness)
      
    elseif (switch.id == "Medium") then
      levelsettings = "Medium"
      composer.setVariable("level", levelsettings)

      stringHardness[1] = nil
      stringHardness[1] = "Medium"
      saveHardness(stringHardness)
      
    elseif (switch.id == "Hard") then
      levelsettings = "Hard"
      composer.setVariable("level", levelsettings)

      stringHardness[1] = nil
      stringHardness[1] = "Hard"
      saveHardness(stringHardness)

    elseif (switch.id == "Impossible") then
      levelsettings = "Impossible"
      composer.setVariable("level",levelsettings)  

      stringHardness[1] = nil
      stringHardness[1] = "Impossible"
      saveHardness(stringHardness)
      
    end  
    
end



local function onSwitchPress2 (event)
      local switch = event.target
      
      if(switch.id == "Blue") then
        planecolor = "blue"
        composer.setVariable("color",planecolor)

        stringColor[1] = nil
        stringColor[1] = "blue"
        saveColor(stringColor)
        
      elseif (switch.id == "Black") then
        planecolor = "black"
        composer.setVariable("color",planecolor)

        stringColor[1] = nil
        stringColor[1] = "black"
        saveColor(stringColor)
        
      elseif (switch.id == "Cool") then
        planecolor = "cool"
        composer.setVariable("color",planecolor)

        stringColor[1] = nil
        stringColor[1] = "cool"
        saveColor(stringColor)

      elseif (switch.id == "White") then
        planecolor = "white"
        composer.setVariable( "color",planecolor )

        stringColor[1] = nil
        stringColor[1] = "white"
        saveColor(stringColor)  
        
      end  

end



local function gotoMenu()
  composer.gotoScene("menu")
  
end



local function audioOn()

  mutePic.isVisible = false
  audioPic.isVisible = true

  local file = io.open(filePathForAudio, "w")

  if file then
    file:write(json.encode("on"))
    io.close(file)

  end  




end



local function audioOff()

  mutePic.isVisible = true
  audioPic.isVisible = false

  local file = io.open(filePathForAudio, "w")

  if file then
    file:write(json.encode("off"))
    io.close(file)

  end  



end




function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

  local hardnessBridge = loadHardness()

  local isEasy = false
  local isMedium = false
  local isHard = false
  local isImpossible = false

  if (hardnessBridge == "Easy") then
    isEasy = true
  elseif (hardnessBridge == "Medium") then
    isMedium = true
  elseif (hardnessBridge == "Hard") then
    isHard = true
  elseif (hardnessBridge == "Impossible") then
    isImpossible = true
  elseif (hardnessBridge == nil) then
    isEasy = true  
  end  

  
  local radioGroup = display.newGroup()
  
  local radioButton1 = widget.newSwitch(
    {
        left = 580,
        top = 210,
        style = "radio",
        id = "Easy",
        initialSwitchState = isEasy,
        onPress = onSwitchPress
    }
)
radioGroup:insert( radioButton1 )
 
local radioButton2 = widget.newSwitch(
    {
        left = 580,
        top = 310,
        style = "radio",
        id = "Medium",
        initialSwitchState = isMedium,
        onPress = onSwitchPress
    }
)
radioGroup:insert( radioButton2 )

local radioButton3 = widget.newSwitch(
    {
        left = 580,
        top = 410,
        style = "radio",
        id = "Hard",
        initialSwitchState = isHard,
        onPress = onSwitchPress
    }
)
radioGroup:insert( radioButton3 )

local radioButton4 = widget.newSwitch(
    {
        left = 580,
        top = 510,
        style = "radio",
        id = "Impossible",
        initialSwitchState = isImpossible,
        onPress = onSwitchPress
    }
)
radioGroup:insert( radioButton4 )

  local back = display.newImageRect(sceneGroup, "images/backgrounds/b1.png", 1280, 720)
  back.x = display.contentCenterX
  back.y = display.contentCenterY

  local leveltext = display.newText(sceneGroup, "Level", 640, 120 , "font1.ttf", 48)
  leveltext:setFillColor(0.2,0.76,0.67)
  
  local easytext = display.newText(sceneGroup, "Easy", 700, 223, "font4.ttf", 32)
  local mediumtext = display.newText(sceneGroup, "Medium", 720, 323, "font4.ttf", 32)
  local hardtext = display.newText(sceneGroup, "Hard", 702, 423, "font4.ttf", 32)
  local impossibletext = display.newText(sceneGroup,"Impossible", 758, 523, "font4.ttf", 32)
  
  
  local planetext = display.newText(sceneGroup, "Paperplane", 240, 120, "font1.ttf", 48)
  planetext:setFillColor(0.2,0.76,0.67)
  
  local defaultplane = display.newImageRect(sceneGroup, "images/paperplaneblue.png", 300,300)
  defaultplane.x = 280; defaultplane.y = 220
  defaultplane:scale(0.21,0.21)
  
  local redplane = display.newImageRect(sceneGroup, "images/paperplaneblack.png", 300,300)
  redplane.x = 280; redplane.y = 320
  redplane:scale(0.21,0.21)
  
  local greenplane = display.newImageRect(sceneGroup, "images/paperplanecool.png", 300,300)
  greenplane.x = 280; greenplane.y = 420
  greenplane:scale(0.23,0.23)

  local pinkplane = display.newImageRect(sceneGroup, "images/paperplanewhite.png", 300,300)
  pinkplane.x = 280; pinkplane.y = 520
  pinkplane:scale( 0.3, 0.3 )
  


  local colorBridge = loadColor()

  local isBlue = false
  local isBlack = false
  local isCool = false
  local isWhite = false

  if (colorBridge == "blue") then
    isBlue = true
  elseif (colorBridge == "black") then
    isBlack = true
  elseif (colorBridge == "cool") then
    isCool = true
  elseif (colorBridge == "white") then
    isWhite = true  
  elseif (colorBridge == nil) then
    isBlue = true
  end    
  
  
  
  local radioGroup2 = display.newGroup()
  
  local radioButtonblue = widget.newSwitch(
    {
        left = 150,
        top = 210,
        style = "radio",
        id = "Blue",
        initialSwitchState = isBlue,
        onPress = onSwitchPress2
    }
)
radioGroup2:insert( radioButtonblue )
 
local radioButtonblack = widget.newSwitch(
    {
        left = 150,
        top = 310,
        style = "radio",
        id = "Black",
        initialSwitchState = isBlack,
        onPress = onSwitchPress2
    }
)
radioGroup2:insert( radioButtonblack )

local radioButtoncool = widget.newSwitch(
    {
        left = 150,
        top = 410,
        style = "radio",
        id = "Cool",
        initialSwitchState = isCool,
        onPress = onSwitchPress2
    }
)
radioGroup2:insert( radioButtoncool )

local radioButtonwhite = widget.newSwitch(
    { 
        left = 150,
        top = 510,
        style = "radio",
        id = "White",
        initialSwitchState = isWhite,
        onPress = onSwitchPress2
    }
)
radioGroup2:insert( radioButtonwhite )

  
  local fileAudio = io.open(filePathForAudio, "r")

    if fileAudio then
      local contentsA = fileAudio:read("*a")
      io.close( fileAudio )
      soundOnOff = json.decode(contentsA)

    end


  local soundText = display.newText(sceneGroup, " Sound: ", 860, 45, "font1.ttf", 42)
  soundText:setFillColor( 0.2,0.76,0.67 )

  audioPic = display.newImageRect(sceneGroup,"images/audio.png", 80, 80)
  audioPic.x = 980
  audioPic.y = 45



  mutePic = display.newImageRect(sceneGroup,"images/mute.png", 80, 80)
  mutePic.x = 980
  mutePic.y = 45


  
  if soundOnOff[1] == "on" or soundOnOff == "on" then
    audioPic.isVisible = true
    mutePic.isVisible = false

  elseif soundOnOff[1] == "off" or soundOnOff == "off" then
    audioPic.isVisible = false
    mutePic.isVisible = true

  end   

  
  audioPic:addEventListener( "tap", audioOff )
  mutePic:addEventListener( "tap", audioOn )


  local credits = display.newText(sceneGroup, "By Mazellan Gaming", 100, 100, "font4.ttf", 28)
  credits.x = 880
  credits.y = 620
  credits:setFillColor( 1,0,0, 0.7)
  
  
  local gotoMenubtn = display.newImageRect("images/goback.png", 100, 100)
  gotoMenubtn.x = 5
  gotoMenubtn.y = 50

  gotoMenubtn:addEventListener( "tap", gotoMenu )
  
  sceneGroup:insert(gotoMenubtn)
  sceneGroup:insert(radioGroup)
  sceneGroup:insert(radioGroup2)

end



function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

	end
end



function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen

	end
end



function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

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
