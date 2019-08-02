local chronos = require'chronos'
local vector2 = require'./Vector.lua'

local var
local t = chronos.nanotime()
for i = 1, 1000000 do
	var = vector2()
end
t = chronos.nanotime() - t * 1000

print(string.format('vector2(), no parameters, %f', t))

local var
t = chronos.nanotime()
for i = 1, 1000000 do
	var = vector2(0, 0)
end
t = chronos.nanotime() - t * 1000

print(string.format('vector2(), number parameters, %f', t))

local var
local v = {0, 0}
t = chronos.nanotime()
for i = 1, 1000000 do
	var = vector2(v)
end
t = chronos.nanotime() - t * 1000

print(string.format('vector2(), array table parameter, %f', t))