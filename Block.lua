Block = {}

function Block:new(x, y, height, width, color, isSolid)
	local object = {
		x = x,
		y = y,
		width = width,
		height = height,
		color = color,
		solid = isSolid,
	}

	setmetatable(object, {__index = Block});

	object.b = love.physics.newBody(world, x, y, "dynamic")
	object.b:setMass(10)
	object.s = love.physics.newRectangleShape(width,height)
	object.f = love.physics.newFixture(object.b, object.s)
	object.f:setRestitution(0.4)
	object.f:setUserData("Block")

	return object;
end

