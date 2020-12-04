local composer = require( "composer" )
local scene = composer.newScene()
local json = require( "json" )
 
local filePath = system.pathForFile( "scores.json", system.DocumentsDirectory )
local scoresTable = {}


local function loadScores()
	local file = io.open( filePath, "r" )

	if file then
		local contents = file:read("*a")
		io.close( file )
		scoresTable = json.decode( contents )
	end
	
	if (scoresTable == nil or #scoresTable == 0) then
		scoresTable = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 }
	end

end			



local function saveScores()
 
    for i = #scoresTable, 11, -1 do
        table.remove( scoresTable, i )
    end
 
    local file = io.open( filePath, "w" )
 
    if file then
        file:write( json.encode( scoresTable ) )
        io.close( file )
    end
end





local function gotoMenu()
    composer.gotoScene( "menu" )
end


function scene:create( event )

	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

	loadScores()

	local function compare( a, b )
        return a > b
    end

    table.sort( scoresTable, compare )

    saveScores()
    

  	local back = display.newImageRect(sceneGroup, "images/backgrounds/b1.png", 1280, 720)
  	back.x = display.contentCenterX
  	back.y = display.contentCenterY

    local star1 = display.newImageRect(sceneGroup, "images/star.png", 40, 40)
    local star2 = display.newImageRect(sceneGroup, "images/star.png", 40, 40)

    star1.x = 340
    star1.y = 50

    star2.x = 620
    star2.y = 50

    local highScoresHeader = display.newText( sceneGroup, "High Scores", display.contentCenterX, 50, "font1", 44 )
    highScoresHeader:setFillColor(0.2,0.76,0.67)

    for i = 1, 10 do
        if ( scoresTable[i] ) then
            local yPos = 50 + ( i * 56 )
 
            local rankNum = display.newText( sceneGroup, i .. ")", display.contentCenterX-50, yPos, "font4.ttf", 36 )
            rankNum:setFillColor( 0.8 )
            rankNum.anchorX = 1
 
            local thisScore = display.newText( sceneGroup, scoresTable[i].." s", display.contentCenterX-30, yPos, "font4.ttf", 36 )
            thisScore.anchorX = 0
        end
    end


    local gotoMenubtn = display.newImageRect(sceneGroup,"images/goback.png", 100, 100)
  	gotoMenubtn.x = 5
  	gotoMenubtn.y = 50

  	gotoMenubtn:addEventListener( "tap", gotoMenu )
  

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

		composer.removeScene( "highscores" )
    

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
