local chronos = require'chronos'
local vector2 = require'./VectorArray.lua'

function measure(name, f)
	local total = 0
	for i = 1, 500 do
		total = total + f()
	end
	total = total / 500
	print(string.format('%s: %fms', name, total))
end

function new()
	local var
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2.new()
	end
	return (chronos.nanotime() - t) * 1000
end

function newlocal()
	local var
	local v = vector2
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = v.new()
	end
	return (chronos.nanotime() - t) * 1000
end

function noParams()
	local var
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2()
	end
	return (chronos.nanotime() - t) * 1000
end

function numParams()
	local var
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2(0, 0)
	end
	return (chronos.nanotime() - t) * 1000
end

function namedParam()
	local var
	local v = {x = 0, y = 0}
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2(v)
	end
	return (chronos.nanotime() - t) * 1000
end

function arrayParam()
	local var
	local v = {0, 0}
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2(v)
	end
	return (chronos.nanotime() - t) * 1000
end

function vectorParam()
	local var
	local v = vector2(0, 0)
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2(v)
	end
	return (chronos.nanotime() - t) * 1000
end

function vectorCall()
	local var
	local v = vector2(0, 0)
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = v()
	end
	return (chronos.nanotime() - t) * 1000
end

function getNoGen()
	local var
	local v = vector2(0, 0)
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = v.x
	end
	return (chronos.nanotime() - t) * 1000
end

function getGenX()
	local var
	local v = vector2(1, 1)
	local a, m = v.angle, v.magnitude
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		v.__x = false
		var = v.x
	end
	return (chronos.nanotime() - t) * 1000
end

function getGenY()
	local var
	local v = vector2(1, 1)
	local a, m = v.angle, v.magnitude
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		v.__y = false
		var = v.y
	end
	return (chronos.nanotime() - t) * 1000
end

function getGenAngle()
	local var
	local v = vector2(1, 1)
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		v.__angle = false
		var = v.angle
	end
	return (chronos.nanotime() - t) * 1000
end

function getGenMagnitude()
	local var
	local v = vector2(1, 1)
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		v.__magnitude = false
		var = v.magnitude
	end
	return (chronos.nanotime() - t) * 1000
end

function justATable()
	local var
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = {x = 0, y = 0}
	end
	return (chronos.nanotime() - t) * 1000
end

function vectorWithTable()
	local var
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		var = vector2{x = 1, y = 1}
	end
	return (chronos.nanotime() - t) * 1000
end

function empty()
	local var
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		
	end
	return (chronos.nanotime() - t) * 1000
end

measure('nothing, just a loop', empty)
measure('vector2.new(), no params', newlocal)
measure('vector2.new(), no params, local var', new)
measure('vector2(), no parameters', noParams)
measure('vector2(), number parameters', numParams)
measure('vector2(), named table parameter', namedParam)
measure('vector2(), array table parameter', arrayParam)
measure('vector2(), vector parameter', vectorParam)
measure('vector2(), calling vector itself', vectorCall)
measure('vector2(), getting, no gen', getNoGen)
measure('vector2(), getting, generating x', getGenX)
measure('vector2(), getting, generating y', getGenY)
measure('vector2(), getting, generating angle', getGenAngle)
measure('just vector table creation', justATable)
measure('vector2(), with table constructor as parameter', vectorWithTable)