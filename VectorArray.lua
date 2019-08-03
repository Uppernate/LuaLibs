local vector2 = {}
local meta = {}
vector2.__type = 'vector2'
setmetatable(vector2, meta)

local cos = math.cos
local sin = math.sin
local atan2 = math.atan2
local sqrt = math.sqrt
local PI = math.pi
local FULLPI = PI * 2
local min = math.min
local max = math.max
local format = string.format

-- Constructor

function vector2.new(a, b)
	if type(a) == 'number' then
		return setmetatable({a, b or a, 0, 0, 0, true, true, false, false, false}, vector2)
	elseif type(a) == 'table' then
		if a.__type == vector2.__type then
			return setmetatable({a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10]}, vector2)
		else
			return setmetatable({a.x or a[1] or 0, a.y or a[2] or 0, 0, 0, 0, true, true, false, false, false}, vector2)
		end
	else
		return setmetatable({0, 0, 0, 0, 0, true, true, false, false, false}, vector2)
	end
end

vector2.__call = vector2.new

function meta:__call(...) 
	return vector2.new(...)
end

-- Getters

vector2.__getters = {}

function vector2.__getters:x()
	if self[6] then 
		return self[1] 
	elseif self[8] and (self[9] or self[10]) then 
		self[1] = cos(self[3]) * (self[9] and self[4] or self[10] and sqrt(self[5])) 
		self[6] = true
		return self[1]
	else 
		error("cannot generate vector2.x") 
	end
end

function vector2.__getters:y()
	if self[7] then 
		return self[2]
	elseif self[8] and (self[9] or self[10]) then 
		self[2] = sin(self[3]) * (self[9] and self[4] or self[10] and sqrt(self[5])) 
		self[7] = true
		return self[2]
	else 
		error("cannot generate vector2.y") 
	end
end

function vector2.__getters:angle()
	if self[8] then 
		return self[3]
	elseif self[6] and self[7] then 
		self[3] = atan2(self[2], self[1])
		self[8] = true
		return self[3]
	else 
		error("cannot generate vector2.angle") 
	end
end

function vector2.__getters:magnitude()
	if self[9] then 
		return self[4]
	elseif self[10] then
		self[4] = sqrt(self[5])
		self[9] = true
	elseif self[6] and self[7] then 
		self[5] = self[1] * self[1] + self[2] * self[2]
		self[10] = true
		self[4] = sqrt(self[5])
		self[9] = true
		return self[4]
	else 
		error("cannot generate vector2.magnitude") 
	end
end

function vector2.__getters:magnitudeSqr()
	if self[10] then 
		return self[5]
	elseif self[6] and self[7] then 
		self[5] = self[1] * self[1] + self[2] * self[2]
		self[10] = true
		return self[10]
	else 
		error("cannot generate vector2.magnitudeSqr") 
	end
end

-- Get Index

function vector2:__index(k)
	if vector2.__getters[k] then
		return vector2.__getters[k](self)
	end
	return vector2[k]
end

-- Setters

vector2.__setters = {}

function vector2.__setters:x(value)
	self[1] = value
	self[6] = true
	if not self[7] then vector2.__getters.y(self) end
	self[8] = false
	self[9] = false
	self[10] = false
	return self[1]
end

function vector2.__setters:y(value)
	self[2] = value
	self[7] = true
	if not self[6] then vector2.__getters.x(self) end
	self[8] = false
	self[9] = false
	self[10] = false
	return self[2]
end

function vector2.__setters:angle(value)
	self[3] = (value + PI) % FULLPI - PI
	self[8] = true
	if not self[9] then vector2.__getters.magnitude(self) end
	self[6] = false
	self[7] = false
	return self[3]
end

function vector2.__setters:magnitude(value)
	if self[6] and self[7] then
		if not self[9] then vector2.__getters.magnitude(self) end
		self[1] = self[1] / self[4] * value
		self[2] = self[2] / self[4] * value
		self[4] = value
		self[5] = value * value
		self[10] = true
		if not self[8] then vector2.__getters.angle(self) end
	else
		self[4] = value
		self[9] = true
		self[5] = value * value
		self[10] = true
		if not self[8] then vector2.__getters.angle(self) end
		self[6] = false
		self[7] = false
	end
	return self[4]
end

function vector2.__setters:magnitudeSqr(value)
	self[5] = value
	self[10] = true
	self[6] = false
	self[7] = false
	self[9] = false
	return self[5]
end

-- Set Index

function vector2:__newindex(k, v)
	if vector2.__setters[k] then
		return vector2.__setters[k](self, v)
	elseif vector2.__getters[k] then
		error(format('cannot set property %q of %q', k, self.__type))
	end
	return v
end

-- Vector functions

function vector2:set(a, b)
	local t = type(a)
	if a and t == 'number' and b then
		self.x = a
		self.y = b
	elseif a and t == 'number' then
		self.x = a 
		self.y = a 
	elseif t == 'table' and a.__type and a.__type == vector2.__type then
		self[1] = a[1]
		self[2] = a[2]
		self[3] = a[3]
		self[4] = a[4]
		self[5] = a[5]
		self[6] = a[6]
		self[7] = a[7]
		self[8] = a[8]
		self[9] = a[9]
		self[10] = a[10]
	elseif t == 'table' then
		self.x = a.x or a[1] or 0
		self.y = a.y or a[2] or 0
	end
end

function vector2:normalise()
	if self.magnitude > 0 then
		self.magnitude = 1
	end
	return self
end

function vector2:copy(a)
	if a then
		self:set(a)
	else
		return self()
	end
end

function vector2:dot(v)
	return self.x * v.x + self.y * v.y
end

function vector2:cross(v)
	return self.x * v.y - self.y * v.x
end

function vector2:unit()
	return self():normalise()
end

function vector2:lerp(v, alpha)
	return self:set(self.x * (1 - alpha) + v.x * alpha, self.y * (1 - alpha) + v.y * alpha)
end

function vector2:angleLerp(v, alpha)
	if v.__type and v.__type == vector2.__type then
		this.angle = this.angle + (((( v.angle - self.angle % FULLPI ) + PI * 3) % FULLPI) - PI) * alpha
		return self
	else
		this.angle = this.angle + (((( v - self.angle % FULLPI ) + PI * 3) % FULLPI) - PI) * alpha
		return self
	end
end

function vector2:shortestAngleTo(v)
	if v.__type and v.__type == vector2.__type then
		return ((( v.angle - self.angle % FULLPI ) + PI * 3) % FULLPI ) - PI
	else
		return ((( v - self.angle % FULLPI ) + PI * 3) % FULLPI ) - PI
	end
end

function vector2:range(tl, br)
	left, top = min(tl.x, br.x), min(tl.y, br.y)
	right, bottom = max(tl.x, br.x), max(tl.y, br.y)
	return self:set( min( max( self.x, left ), right ), min( max( self.y, top ), bottom ) )
end

function vector2:min(...)
	local args = {...}
	local left, top = self.x, self.y
	for i, v in pairs(args) do
		left = min(left, v.x)
		top = min(top, v.y)
	end
	return self:set(left, top)
end

function vector2:max(...)
	local args = {...}
	local right, bottom = self.x, self.y
	for i, v in pairs(args) do
		right = max(left, v.x)
		bottom = max(top, v.y)
	end
	return self:set(right, bottom)
end

function vector2:localise(origin, direction)
	self = self - origin
	self.angle = self.angle - direction.angle
	return self
end

function vector2:unlocalise(origin, direction)
	self.angle = self.angle + direction.angle
	self:add(origin)
	return self
end

function vector2:transform(v)
	self.angle = self.angle + v.angle
	self:mul(v.magnitude)
	return self
end

function vector2:inverseTransform(v)
	self.angle = self.angle - v.angle
	self:div(v.magnitude)
	return self
end

function vector2:perpendicular()
	return vector2(-self.y, self.x)
end

function vector2:unpack()
	return self.x, self.y
end

function vector2:modMagnitude(v)
	self.magnitude = self.magnitude % v
	return self
end

-- Math

function vector2:__unm()
	return vector2(-self.x, -self.y)
end

function vector2:__add(v)
	local t = type(v)
	if t == 'table' then
		return vector2( self.x + (v.x or v[1]), self.y + (v.y or v[2]) )
	elseif t == 'number' then
		return vector2( self.x + v, self.y + v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
end

function vector2:__sub(v)
	local t = type(v)
	if t == 'table' then
		return vector2( self.x - (v.x or v[1]), self.y - (v.y or v[2]) )
	elseif t == 'number' then
		return vector2( self.x - v, self.y - v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
end

function vector2:__mul(v)
	local t = type(v)
	if t == 'table' then
		return vector2( self.x * (v.x or v[1]), self.y * (v.y or v[2]) )
	elseif t == 'number' then
		return vector2( self.x * v, self.y * v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
end

function vector2:__div(v)
	local t = type(v)
	if t == 'table' then
		return vector2( self.x / (v.x or v[1]), self.y / (v.y or v[2]) )
	elseif t == 'number' then
		return vector2( self.x / v, self.y / v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
end

function vector2:__mod(v)
	local t = type(v)
	if t == 'table' then
		return vector2( self.x % (v.x or v[1]), self.y % (v.y or v[2]) )
	elseif t == 'number' then
		return vector2( self.x % v, self.y % v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
end

function vector2:__pow(v)
	local t = type(v)
	if t == 'table' then
		return vector2( self.x ^ (v.x or v[1]), self.y ^ (v.y or v[2]) )
	elseif t == 'number' then
		return vector2( self.x ^ v, self.y ^ v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
end

function vector2:__eq(v)
	return self.x == v.x and self.y == v.y
end

function vector2:__lt(v)
	return self.magnitude < v.magnitude
end

function vector2:__le(v)
	return self.magnitude <= v.magnitude
end

function vector2:__len(v)
	return self.magnitude
end

-- Math but as functions that do not create additional vectors

function vector2:negate()
	return self:set(-self.x, -self.y)
end

function vector2:add(v)
	local t = type(v)
	if t == 'table' then
		return self:set( self.x + (v.x or v[1]), self.y + (v.y or v[2]) )
	elseif t == 'number' then
		return self:set( self.x + v, self.y + v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
	return self
end

function vector2:sub(v)
	local t = type(v)
	if t == 'table' then
		return self:set( self.x - (v.x or v[1]), self.y - (v.y or v[2]) )
	elseif t == 'number' then
		return self:set( self.x - v, self.y - v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
	return self
end

function vector2:mul(v)
	local t = type(v)
	if t == 'table' then
		return self:set( self.x * (v.x or v[1]), self.y * (v.y or v[2]) )
	elseif t == 'number' then
		return self:set( self.x * v, self.y * v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
	return self
end

function vector2:div(v)
	local t = type(v)
	if t == 'table' then
		return self:set( self.x / (v.x or v[1]), self.y / (v.y or v[2]) )
	elseif t == 'number' then
		return self:set( self.x / v, self.y / v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
	return self
end

function vector2:mod(v)
	local t = type(v)
	if t == 'table' then
		return self:set( self.x % (v.x or v[1]), self.y % (v.y or v[2]) )
	elseif t == 'number' then
		return self:set( self.x % v, self.y % v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
	return self
end

function vector2:pow(v)
	local t = type(v)
	if t == 'table' then
		return self:set( self.x ^ (v.x or v[1]), self.y ^ (v.y or v[2]) )
	elseif t == 'number' then
		return self:set( self.x ^ v, self.y ^ v)
	else
		error(format('attempt to perform arithmetic on a vector2 and %s', t))
	end
	return self
end

-- Misc

function vector2:__tostring()
	return format('%s[%f, %f]', self.__type, self.x, self.y)
end

return vector2