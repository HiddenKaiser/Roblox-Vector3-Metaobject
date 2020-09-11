--[[
Documentation:
https://developer.roblox.com/en-us/api-reference/datatype/Vector3

Extra Info:
Cannot use any other constructor functions other than Vector3.new() because of enums.
This version can also add and subtract numbers to vectors

Made by HiddenKaiser on 9/11/20 at 2:30 pm
--]]

local Vector3 = {__type = "Vector3"}
local mt = {__index = Vector3}

-- Math operations

function Vector3.new(x, y, z, dont_unit) -- Constructs a new Vector3 using the given x, y, and z components.
    local self = {x = x or 0, y = y or 0, z = z or 0}
    setmetatable(self, mt)
    self.Magnitude = self:GetMagnitude()
    if not dont_unit then  self.Unit = Vector3.new(self.x / self.Magnitude, self.y / self.Magnitude, self.z / self.Magnitude, true)  end
    self:SetupAliases()
	return self
end

function mt.__mul(a, b) -- When the vector gets multiplied
	if (type(a) == "number") then
		-- a is a scalar, b is a vector
		local scalar, vector = a, b
		return Vector3.new(scalar * vector.x, scalar * vector.y, scalar * vector.z)
	elseif (type(b) == "number") then
		-- a is a vector, b is a scalar
		local vector, scalar = a, b
		return Vector3.new(vector.x * scalar, vector.y * scalar, vector.z * scalar)
	elseif (a.__type and a.__type == "Vector3" and b.__type and b.__type == "Vector3") then
		-- both a and b are vectors
		return Vector3.new(a.x * b.x, a.y * b.y, a.z * b.z)
	end
end
 
function mt.__div(a, b) -- When the vector gets divided
	if (type(a) == "number") then
		-- a is a scalar, b is a vector
		local scalar, vector = a, b
		return Vector3.new(scalar / vector.x, scalar / vector.y, scalar / vector.z)
	elseif (type(b) == "number") then
		-- a is a vector, b is a scalar
		local vector, scalar = a, b
		return Vector3.new(vector.x / scalar, vector.y / scalar, vector.z / scalar)
	elseif (a.__type and a.__type == "Vector3" and b.__type and b.__type == "Vector3") then
		-- both a and b are vectors
		return Vector3.new(a.x / b.x, a.y / b.y, a.z / b.z)
	end
end

function mt.__add(a, b) -- When the vector gets added
	if (type(a) == "number") then
		-- a is a scalar, b is a vector
		local scalar, vector = a, b
		return Vector3.new(scalar + vector.x, scalar + vector.y, scalar + vector.z)
	elseif (type(b) == "number") then
		-- a is a vector, b is a scalar
		local vector, scalar = a, b
		return Vector3.new(vector.x + scalar, vector.y + scalar, vector.z + scalar)
	elseif (a.__type and a.__type == "Vector3" and b.__type and b.__type == "Vector3") then
		-- both a and b are vectors
		return Vector3.new(a.x + b.x, a.y + b.y, a.z + b.z)
	end
end

function mt.__sub(a, b) -- When the vector gets subtracted
	if (type(a) == "number") then
		-- a is a scalar, b is a vector
		local scalar, vector = a, b
		return Vector3.new(scalar - vector.x, scalar - vector.y, scalar - vector.z)
	elseif (type(b) == "number") then
		-- a is a vector, b is a scalar
		local vector, scalar = a, b
		return Vector3.new(vector.x - scalar, vector.y - scalar, vector.z - scalar)
	elseif (a.__type and a.__type == "Vector3" and b.__type and b.__type == "Vector3") then
		-- both a and b are vectors
		return Vector3.new(a.x - b.x, a.y - b.y, a.z - b.z)
	end
end

-- Math operations End

-- Misc functions

function mt.__tostring(t) -- when tostring is called on the vector
	return ("(".. t.x .. ", " .. t.y .. ", " ..t.z ..")");
end;

function Vector3:floor() -- math.floor the vector
	local x,y,z = self.x,self.y,self.z
	return Vector3.new(math.floor(x), math.floor(y), math.floor(z))
end

function Vector3:GetMagnitude() -- Get magnitude, (can also just use Vector.Magnitude)
    return self.Magnitude or math.abs( math.sqrt( (self.x)^2 + (self.y)^2 + (self.z)^2 ) )
end

function Vector3:Lerp(b,percent) -- Lerp two vectors
    if b and percent then
        local result = self + ((b - self) * percent)
        return result
    end
end

function Vector3:Dot(b) -- Get dot product of vector b
	local a = self
	local dot = ( (a.x*b.x) + (a.y*b.y) + (a.z*b.z) )
	return dot
end

function Vector3:Cross(b) -- Get cross product of vector b
    local a = self
    return Vector3.new(
        (a.y*b.z) - (a.z*b.y),
        (a.z*b.x) - (a.x*b.z),
        (a.x*b.y) - (a.y*b.x)
    )
end

function Vector3:FuzzyEq(v1, epsilon) -- Returns true if the given Vector3 falls within the epsilon radius of this Vector3.
	local v2 = self
	local function fuzzyEq(a, b, epsilon)  return a == b or math.abs(a - b) <= (math.abs(a) + 1) * epsilon  end
    
	if not fuzzyEq(v1.x, v2.x, epsilon) then  return false  end
	if not fuzzyEq(v1.y, v2.y, epsilon) then  return false  end
	if not fuzzyEq(v1.z, v2.z, epsilon) then  return false  end
	return true
end

function Vector3:SetupAliases() -- Sets up aliases for functions and properties
    self.magnitude = self.Magnitude
    self.unit = self.Unit
    self.X = self.x;  self.Y = self.y;  self.Z = self.z; -- xyz to XYZ
    
    function Vector3:IsClose(...)  return self:FuzzyEq(...)  end -- alias of FuzzyEq
    function Vector3:lerp(...)  return self:Lerp(...)  end -- alias of Lerp
    function Vector3:dot(...)  return self:Dot(...)  end -- alias of 
    function Vector3:cross(...)  return self:Cross(...)  end -- alias of 
end