local Maid = {}
Maid.__index = Maid

-- Create a new instance of the maid.
function Maid.new()
	return setmetatable({
		Objects = {}
	}, Maid)
end

local SupportedTypes = {"Instance", "RBXScriptConnection"}

-- Hand over connection(s)/instance(s) for the maid to track.
function Maid:Add(...)
	if self.Objects == nil then
		warn("Maid: You need to call Maid.new().")
		return
	end

	for _, Object in ipairs(table.pack(...)) do
		if not table.find(SupportedTypes, typeof(Object)) then
			warn(("Maid: Object of type %s is not supported by maid."):format(typeof(Object)))
		end

		table.insert(self.Objects, Object)
	end
end

-- Clean all connections/instances handed to maid.
function Maid:Clean()
	for _, Object in ipairs(self.Objects) do
		if typeof(Object) == "Instance" then
			Object.Parent = nil
			Object:Destroy()
		elseif typeof(Object) == "RBXScriptConnection" then
			Object:Disconnect()
		end
	end
end

-- Call Clean() once the given connection is fired
function Maid:LinkConnection(Connection)--kinda goofy aint gonna lie
	local c;
	c=Connection:Connect(function()
		self:Clean()
		c:Disconnect()
	end)
end

return Maid
