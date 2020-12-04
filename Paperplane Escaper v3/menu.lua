local composer = require( "composer" )
local widget = require("widget")

local scene = composer.newScene()
local json = require("json")


audio.reserveChannels( 1 )
audio.setVolume( 0.25, { channel=1 } )

local tempColor = {}
local filePathForColor = system.pathForFile("colorholder.json", system.DocumentsDirectory)

local function loadColor()
  local file = io.open(filePathForColor, "r")

  if file then
    local contentsC = file:read("*a")
    io.close( file )
    tempColor = json.decode(contentsC)
  end
  
  return tempColor[1]

end  

local planepic = loadColor()
local planelogo


local function gotoGame()
  composer.gotoScene("game", {effect = "fade", time = 1000})
end


local function gotoHighScores()
  composer.gotoScene("highscores")
end


local function gotoSettings()
  composer.gotoScene("settings")
end


function scene:create( event )

	local sceneGroup = self.view
	
  local background = display.newImageRect(sceneGroup, "images/backgrounds/b1.png", 1280, 720)
  background.x = display.contentCenterX
  background.y = display.contentCenterY
  --background:scale(1.2, 1.2)

  
  
  --local playButton = display.newText( sceneGroup, "Play", display.contentCenterX, 400, "Roboto-Light.ttf", 44 )
  --playButton:setFillColor( 0,0,0 )
  
  local playbtn = widget.newButton(
    {
        label = "      PLAY",
        onPress = gotoGame,
        emboss = true,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 250,
        height = 50,
        cornerRadius = 2,
        labelColor = { default = {1,0,0}, over = {1,0,0,0.8} },
        fontSize = 22,
        fillColor = { default={0,0,1,0.5}, over={1,0,0,0.6} },
        strokeColor = { default={0.2,0.76,0.67,5}, over={0.2,0.76,0.67,5} },
        strokeWidth = 3
    }
)
  playbtn:scale(1.5,1.5)
  playbtn.x = 280
  playbtn.y = 250
  
  sceneGroup:insert(playbtn)

  
 
  --local highScoresButton = display.newText( sceneGroup, "High Scores", display.contentCenterX, 500, "Roboto-Light.ttf", 44 )
  --highScoresButton:setFillColor( 0,0,0 )
  
  local highscorebtn = widget.newButton(
    {
        label = "       HIGH SCORES",
        onPress = gotoHighScores,
        emboss = true,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 250,
        height = 50,
        cornerRadius = 2,
        labelColor = { default = {1,0,0}, over = {1,0,0,0.8} },
        fontSize = 22,
        fillColor = { default={0,0,1,0.5}, over={1,0,0,0.6} },
        strokeColor = { default={0.2,0.76,0.67,5}, over={0.2,0.76,0.67,5} },
        strokeWidth = 3
    }
)
  highscorebtn:scale(1.52,1.52)
  highscorebtn.x = 280
  highscorebtn.y = 370
  
  sceneGroup:insert(highscorebtn)
  
  
  local settingsbtn = widget.newButton(
    {
        label = "       SETTINGS",
        onPress = gotoSettings,
        emboss = true,
        -- Properties for a rounded rectangle button
        shape = "roundedRect",
        width = 250,
        height = 50,
        cornerRadius = 2,
        labelColor = { default = {1,0,0}, over = {1,0,0,0.8} },
        fontSize = 22,
        fillColor = { default={0,0,1,0.5}, over={1,0,0,0.6} },
        strokeColor = { default={0.2,0.76,0.67,5}, over={0.2,0.76,0.67,5} },
        strokeWidth = 3
    }
)
  settingsbtn:scale(1.52,1.52)
  settingsbtn.x = 280
  settingsbtn.y = 490
  
  sceneGroup:insert(settingsbtn)

  local playpic = display.newImageRect(sceneGroup, "images/playmenu.png", 50, 50)
  playpic.x = 140
  playpic.y = 250

  local settingspic = display.newImageRect(sceneGroup, "images/settingsmenu.png", 50, 50)
  settingspic.x = 140
  settingspic.y = 490

  local leaderboardpic = display.newImageRect(sceneGroup, "images/leaderboard.png", 55, 55)
  leaderboardpic.x = 140
  leaderboardpic.y = 360

  if planepic == nil then
    planepic = "blue"
  end  

  planelogo = display.newImageRect(sceneGroup, "images/paperplane"..planepic..".png", 250, 250)
  planelogo.x = 750
  planelogo.y = 360


  local planevsflies = display.newImageRect(sceneGroup, "images/menulabel.png", 650, 250)
  planevsflies.x = 500
  planevsflies.y = 80
  
  
  
  --playButton:addEventListener("tap", gotoGame)
  --highScoresButton:addEventListener("tap", gotoHighScores)

end


-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen

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

    composer.removeScene("menu")

	end
end


-- destroy()
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
