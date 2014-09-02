Block = {}

function Block:new(x, y, height, width, color, isSolid, isStatic)
	local object = {
		x = x,
		y = y,
		width = width,
		height = height,
		color = color,
		solid = isSolid,
		static = isStatic
	}

	setmetatable(object, {__index = Block});

	if(isStatic) then
		object.b = love.physics.newBody(world, x, y, "static")
	else
		object.b = love.physics.newBody(world, x, y, "dynamic")
		object.b:setMass(10)
	end
	object.s = love.physics.newRectangleShape(width,height)
	object.f = love.physics.newFixture(object.b, object.s)
	object.f:setRestitution(0.4)
	object.f:setUserData("Block")

	return object;
end

function Block:draw() 
	love.graphics.setColor(self.color)
	love.graphics.polygon("line", self.b:getWorldPoints(self.s:getPoints()))
end