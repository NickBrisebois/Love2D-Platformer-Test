
require "player/Player"
require "Block"
require "camera"

function love.load()
	g = love.graphics

	-- Window height/width
	width = g.getWidth()
	height = g.getHeight()

	map={
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}, 
	   { 0, 1, 0, 0, 2, 2, 2, 0, 3, 0, 3, 0, 1, 1, 1, 0, 0, 0, 0, 0},
	   { 0, 1, 0, 0, 2, 0, 2, 0, 3, 0, 3, 0, 1, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 1, 1, 0, 2, 2, 2, 0, 0, 3, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0},
	   { 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 2, 2, 2, 0, 3, 3, 3, 0, 1, 1, 1, 0, 2, 0, 0, 0, 0, 0, 0},
	   { 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0},
	   { 0, 2, 0, 0, 0, 3, 0, 3, 0, 1, 0, 1, 0, 2, 0, 0, 0, 0, 0, 0},
	   { 0, 2, 2, 2, 0, 3, 3, 3, 0, 1, 1, 1, 0, 2, 2, 2, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	   { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
	}

	block_list = {}

	-- Player's color
	playerColor = {255,0,128}
	g.setBackgroundColor(85, 85, 85)

	-- Restrict camera
	camera:setBounds(0, 0, width, math.floor(height / 8))
	world = love.physics.newWorld(0, 200, true)

	-- Player settings
	p = Player:new()
	p.x = 300
	p.y = 300
	p.width = 25
	p.height = 40
	p.jumpSpeed = -800
	p.runSpeed = 500

	create_world(map)

	gravity = 1000
	yFloor = 500 -- Temporary floor (Remove later)
	delay = 120
end


function love.draw()
	camera:set()
	local x = math.floor(p.x)
	local y = math.floor(p.y)

	for i=1, table.getn(block_list) do
		g.setColor(block_list[i].color)
		g.rectangle("fill", block_list[i].x, block_list[i].y, block_list[i].width, block_list[i].height)
	end

	-- Draw the player
	g.setColor(playerColor)
	g.rectangle("fill", x, y, p.width, p.height)

	-- Temporary floor
	g.setColor({255,0,30})
	g.rectangle("fill", 0, 500, 1000, 20)

	g.setColor(new_block.color)
	g.rectangle("fill", new_block.x, new_block.y, new_block.width, new_block.height)

	--debug info (x/y coords + player state)
	g.setColor(255, 255, 255)
	camera:unset()
	g.print("Player coords: ("..x..","..y..")", 5, 5)
	g.print("Current state: "..p.state, 5, 20)
	g.print("Collision Detected: "..string.format("%s\n", tostring(p.collided)), 5, 40)
end


function love.update(dt)

	world:update(dt)

	-- Check if you're pressing left/right then go in the direction you chose
	if love.keyboard.isDown("right") then
		p:moveRight()
	end
	if love.keyboard.isDown("left") then
		p:moveLeft()
	end

	-- Jumping. if you're not already jumping, and you pressed the button, then jump
	if not(playerState == "jump") and love.keyboard.isDown(" ") then
		hasJumped = true
		p:jump()
	end

	-- Add velocity to player's x and y positions
	p:update(dt, gravity)

	-- Shitty collision for the floor
	p.x = math.clamp(p.x, 0, 400 * 2 - p.width)
	if p.y < 0 then p.y = 0 end
	if p.y > yFloor - p.height then
		p:hitFloor(yFloor)
	end

	camera:setPosition(math.floor(p.x - width /2), math.floor(p.y - height / 2))
end


function love.keyreleased(key)
	-- Quit the game
	if key == "escape" then
		love.event.push("quit")
	end
    if (key == "right") or (key == "left") then
        p:stop()
    end
    if (key == " ") then
    	hasJumped = false
    end
end

function math.clamp(x, min, max) 
	return x < min and min or (x > max and max or x)
end

function check_collision(one, two)

end

function create_world(map)
	for y=1, table.getn(map) do
		for x=1, table.getn(map[y]) do
			if(map[y][x] ~= 0) then
				new_block = Block:new(
					x*(map[y][x]*10),      -- X value
					y*(map[y][x]*10),      -- Y value
					(map[y][x]*10),   	   -- Block height
					(map[y][x]*10),        -- Block width
					{255,0,map[y][x]*100}, -- Block colour
					true)                  -- Is block solid (ie. Enable or disable collision detection)
				block_list[#block_list+1] = new_block
			end
		end
	end
end