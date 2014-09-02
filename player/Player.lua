Player = {}

-- Constructor
function Player:new(x, y, width, height, color)
	local object = {
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		state = "",
		color = color,
		canJump = false,
		collided = false
	}

	object.b = love.physics.newBody(world, x, y, "dynamic")
	object.b:setMass(10)
	object.s = love.physics.newRectangleShape(width,height)
	object.f = love.physics.newFixture(object.b, object.s)
	object.f:setRestitution(0.4)
	object.f:setUserData("Block")

	setmetatable(object, { __index = Player })

	return object
end

function Player:jump()
	if self.canJump then
		self.b:applyForce(0, -5000)
		self.canJump = false
	end
end

function Player:moveRight()
	self.b:applyForce(1000, 0)
	self.state = "moveRight"
end

function Player:moveLeft()
	self.b:applyForce(-1000,0)
	self.state = "moveLeft"
end

function Player:stop()
	-- TODO: STOP THE DAMN PLAYER
end

function Player:hitFloor(maxY)
	self.canJump = true
end

function Player:update(dt)

end

function Player:draw()
	love.graphics.setColor(self.color)
	love.graphics.polygon("line", self.b:getWorldPoints(self.s:getPoints()))
end