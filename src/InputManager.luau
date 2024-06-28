--!strict

-- Manages binded inputs. Updates the binded actions when the properties are updated.

export type ContextCallback = (string, Enum.UserInputState, InputObject) -> ()
export type PackedKeys = { Enum.KeyCode | Enum.UserInputType }

export type BindData = {
	contextId: string,
	callback: ContextCallback,
	hasMobile: boolean,
	packedKeys: { Enum.KeyCode | Enum.UserInputType },
	unbind: (self: BindData) -> (),
	bind: (self: BindData) -> (),
}

local contextActionService = game:GetService("ContextActionService")

local inputRegistry = {}

local bindDataKeyToType = {
	["callback"] = "function",
	["hasMobile"] = "boolean",
	["packedKeys"] = "table",
}

local function assertBindKeyToValue(key: string, value: any)
	local keyToExpectedType: string? = bindDataKeyToType[key]
	local passedKeyType: string = typeof(value)
	assert(typeof(keyToExpectedType) == "string", `[InputRegistry]: Attempt to set non existent key {key}`)
	assert(
		passedKeyType == keyToExpectedType,
		`[InputRegistry]: Attempt to set {key} to invalid type {passedKeyType}, expected {keyToExpectedType}`
	)
	return true
end

local function quickBind(contextId: string, callback: ContextCallback, hasMobile: boolean, packedKeys: PackedKeys)
	contextActionService:BindAction(contextId, callback, hasMobile, unpack(packedKeys))
end

-- Packs data into a BindData structure, including binding and unbinding functions.
-- @param contextId string Identifier for the binding context.
-- @param callback ContextCallback Function to call when the input is triggered.
-- @param hasMobile boolean Indicates if the binding should apply to mobile devices.
-- @param packedKeys PackedKeys Keys or input types that trigger the action.
-- @returns BindData A structure containing the packed binding data.
local function packBindData(
	contextId: string,
	callback: ContextCallback,
	hasMobile: boolean,
	packedKeys: PackedKeys
): BindData
	local packedBindedData = {
		contextId = contextId,
		callback = callback,
		hasMobile = hasMobile,
		packedKeys = packedKeys,
	}

	function packedBindedData.unbind()
		contextActionService:UnbindAction(contextId)
	end

	function packedBindedData.bind(self: BindData)
		contextActionService:BindAction(self.contextId, self.callback, self.hasMobile, table.unpack(self.packedKeys))
	end

	return packedBindedData
end

-- Main function to bind an action and handle property changes.
-- @param contextId string Identifier for the binding context.
-- @param ... Parameters forwarded to quickBind and packBindData (callback, hasMobile, packedKeys).
-- @returns BindData A structure representing the bound action data.
function inputRegistry:bindAction(contextId: string, ...)
	quickBind(contextId, ...)
	local bindData = packBindData(contextId, ...)

	local function onPropertyChanged(_, key: string, value)
		assertBindKeyToValue(key, value)
		bindData[key] = value
		bindData:unbind()
		bindData:bind()
	end

	return setmetatable({} :: BindData, {
		__index = bindData,
		__newindex = onPropertyChanged,
	})
end

return inputRegistry
