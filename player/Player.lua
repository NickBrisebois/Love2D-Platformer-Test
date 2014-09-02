Player = {}

-- Constructor
function Player:new()
	local object = {
		x = 0,
		y = 0,
		width = 0,
		height = 0,
		state = "",
		canJump = false,
		collided = false
	}
	setmetatable(object, { __index = Player })

	object.b = love.physics.newBody(world, x, y, "dynamic")
	object.b:setMass(10)
	object.s = love.physics.newRectangleShape(width,height)
	object.f = love.physics.newFixture(object.b, object.s)
	object.f:setRestitution(0.4)
	object.f:setUserData("Block")

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

function Player:update(dt, gravity)
	
	-- TODO: REDO THIS FUNCTION

end