-- 原作者 Lua 5.1+ base64 v3.0 (c) 2009 by Alex Kloss <alexthkloss@web.de>
-- 修改使兼容byte seq table by T.G. <farmer1992@gmail.com> 2010 Oct 24

local base64 = LibStub:NewLibrary("BASE64-1.0", 1)

local b ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

local function enc(data)
	local t = {}

	for _, x in pairs(data) do
		local r,b='',x
		for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
		t[#t+1] = r
	end

	t[#t+1] = '0000'

	local r = {}
	table.concat(t):gsub('%d%d%d?%d?%d?%d?', function(x)
		if (#x < 6) then return nil end
		local c=0
		for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
		r[#r+1] = b:sub(c+1,c+1)
	end)

	r[#r+1] = ({ '', '==', '=' })[#data%3+1]
	return table.concat(r)
end

-- decoding
local function dec(data)
	data = string.gsub(data, '[^'..b..'=]', '')
	local t = {}
	data:gsub('.', function(x)
		if (x == '=') then return '' end
		local r,f='',(b:find(x)-1)
		for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
		return r;
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if (#x ~= 8) then return nil end
		local c=0
		for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
		t[#t+1] = c
	end)
	return t
end

base64.enc = enc
base64.dec = dec
