local chronos = require'chronos'
local vector2 = require'./Vector.lua'

function measure(name, f)
	local total = 0
	for i = 1, 1000 do
		total = total + f()
	end
	total = total / 1000
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

measure('vector2(), no parameters', noParams)
measure('vector2(), number parameters', numParams)
measure('vector2(), named table parameter', namedParam)
measure('vector2(), array table parameter', arrayParam)
measure('vector2(), vector parameter', vectorParam)