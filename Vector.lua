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
	if type(a) == 'table' then
		if b then
			return setmetatable({_x = a, _y = b, _angle = 0, _magnitude = 0, _sqr = 0, __x = true, __y = true, __angle = false, __magnitude = false, __sqr = false}, vector2)
		else
			return setmetatable({_x = a, _y = a, _angle = 0, _magnitude = 0, _sqr = 0, __x = true, __y = true, __angle = false, __magnitude = false, __sqr = false}, vector2)
		end
	elseif type(a) == 'number' then
		if a.__type == vector2.__type then
			return setmetatable({_x = a._x, _y = a._y, _angle = a._angle, _magnitude = a._magnitude, _sqr = a._sqr, __x = a.__x, __y = a.__y, __angle = a.__angle, __magnitude = a.__magnitude, __sqr = a.__sqr}, vector2)
		else
			return setmetatable({_x = a.x or a[1] or 0, _y = a.y or a[2] or 0, _angle = 0, _magnitude = 0, _sqr = 0, __x = true, __y = true, __angle = false, __magnitude = false, __sqr = false}, vector2)
		end
	else
		return setmetatable({_x = 0, _y = 0, _angle = 0, _magnitude = 0, _sqr = 0, __x = true, __y = true, __angle = false, __magnitude = false, __sqr = false}, vector2)
	end
end

vector2.__call = vector2.new

function meta:__call(...) 
	return vector2.new(...)
end

-- Getters

vector2.__getters = {}

function vector2.__getters:x()
	if self.__x then 
		return self._x 
	elseif self.__angle and (self.__magnitude or self.__sqr) then 
		self._x = cos(self._angle) * (self.__magnitude and self._magnitude or self.__sqr and sqrt(self._sqr)) 
		self.__x = true
		return self._x
	else 
		error("cannot generate vector2.x") 
	end
end

function vector2.__getters:y()
	if self.__y then 
		return self._y
	elseif self.__angle and (self.__magnitude or self.__sqr) then 
		self._y = sin(self._angle) * (self.__magnitude and self._magnitude or self.__sqr and sqrt(self._sqr)) 
		self.__y = true
		return self._y
	else 
		error("cannot generate vector2.y") 
	end
end

function vector2.__getters:angle()
	if self.__angle then 
		return self._angle
	elseif self.__x and self.__y then 
		self._angle = atan2(self._y, self._x)
		self.__angle = true
		return self._angle
	else 
		error("cannot generate vector2.angle") 
	end
end

function vector2.__getters:magnitude()
	if self.__magnitude then 
		return self._magnitude
	elseif self.__sqr then
		self._magnitude = sqrt(self._sqr)
		self.__magnitude = true
	elseif self.__x and self.__y then 
		self._sqr = self._x * self._x + self._y * self._y
		self.__sqr = true
		self._magnitude = sqrt(self._sqr)
		self.__magnitude = true
		return self._magnitude
	else 
		error("cannot generate vector2.magnitude") 
	end
end

function vector2.__getters:magnitudeSqr()
	if self.__sqr then 
		return self._sqr
	elseif self.__x and self.__y then 
		self._sqr = self._x * self._x + self._y * self._y
		self.__sqr = true
		return self.__sqr
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
	self._x = value
	self.__x = true
	if not self.__y then vector2.__getters.y(self) end
	self.__angle = false
	self.__magnitude = false
	self.__magnitudeSqr = false
	return self._x
end

function vector2.__setters:y(value)
	self._y = value
	self.__y = true
	if not self.__x then vector2.__getters.x(self) end
	self.__angle = false
	self.__magnitude = false
	self.__magnitudeSqr = false
	return self._y
end

function vector2.__setters:angle(value)
	self._angle = (value + PI) % FULLPI - PI
	self.__angle = true
	if not self.__magnitude then vector2.__getters.magnitude(self) end
	self.__x = false
	self.__y = false
	return self._angle
end

function vector2.__setters:magnitude(value)
	if self.__x and self.__y then
		if not self.__magnitude then vector2.__getters.magnitude(self) end
		self._x = self._x / self._magnitude * value
		self._y = self._y / self._magnitude * value
		self._magnitude = value
		self._sqr = value * value
		self.__sqr = true
		if not self.__angle then vector2.__getters.angle(self) end
	else
		self._magnitude = value
		self.__magnitude = true
		self._sqr = value * value
		self.__sqr = true
		if not self.__angle then vector2.__getters.angle(self) end
		self.__x = false
		self.__y = false
	end
	return self._magnitude
end

function vector2.__setters:magnitudeSqr(value)
	self._sqr = value
	self.__sqr = true
	self.__x = false
	self.__y = false
	self.__magnitude = false
	return self._sqr
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
		self._x = a._x
		self._y = a._y
		self._angle = a._angle
		self._magnitude = a._magnitude
		self._sqr = a._sqr
		self.__x = a.__x
		self.__y = a.__y
		self.__angle = a.__angle
		self.__magnitude = a.__magnitude
		self.__sqr = a.__sqr
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