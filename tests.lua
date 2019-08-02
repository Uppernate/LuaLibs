local chronos = require'chronos'
local vector2 = require'./Vector.lua'

function measure(name, f)
	local total = 0
	for i = 1, 2000 do
		total = total + f()
	end
	total = total / 2000
	print(string.format('%s: %fms', name, total))
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
	local v = vector2(0, 0)
	local a, m = v.angle, v.magnitude
	local t = chronos.nanotime()
	for i = 1, 1000000 do
		v.__x = false
		var = v.x
	end
	return (chronos.nanotime() - t) * 1000
end

measure('vector2(), no parameters', noParams)
measure('vector2(), number parameters', numParams)
measure('vector2(), named table parameter', namedParam)
measure('vector2(), array table parameter', arrayParam)
measure('vector2(), vector parameter', vectorParam)
measure('vector2(), calling vector itself', vectorCall)
measure('vector2(), getting, generating x', getGenX)