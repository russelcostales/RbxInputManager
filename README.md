# Input Registry for Roblox Context Actions

This Lua module manages binded inputs using Roblox's ContextActionService. It allows you to bind actions to specific contexts, such as keyboard keys or other input types, and provides mechanisms for updating these bindings dynamically.

## Features

- **Dynamic Binding:** Bind and unbind actions based on specified contexts.
- **Property Management:** Update binded actions by modifying properties like callback function, mobile device compatibility, and input keys.
- **Type Safety:** Ensures type safety for property updates to prevent runtime errors.

## Usage

### Prerequisites

- This module is designed for use within Roblox games that utilize Lua scripting.
  
### Setup
**Integration:**
   - Copy the provided Lua script into a ModuleScript within Roblox Studio.
   - Ensure the script is accessible to your game's scripts.

**Initialization:**
   - Require the module in your script:
     ```lua
     local inputRegistry = require(path.to.InputRegistry)
     ```

### Binding Actions

To bind an action:

```lua
local contextId = "MyActionContext"
local callback = function(actionName, inputState, inputObject)
    -- Handle input action here
end
local hasMobile = true -- Set to true if the action should apply to mobile devices
local packedKeys = {Enum.KeyCode.Space, Enum.KeyCode.ButtonA} -- Example keys

local bindData = inputRegistry:bindAction(contextId, callback, hasMobile, packedKeys)
```

### Updating Bindings

You can update the binding dynamically by modifying properties of `bindData`:

```lua
bindData.callback = newCallbackFunction
bindData.hasMobile = false
bindData.packedKeys = {Enum.KeyCode.E, Enum.UserInputType.Touch}
```

### Unbinding Actions

To unbind an action:

```lua
bindData:unbind()
```

### Handling Property Changes

The module ensures type safety when modifying properties of `bindData`. If you need to update a property dynamically:

```lua
bindData.callback = newCallbackFunction
```

### Error Handling

The module includes basic error handling to prevent invalid property assignments. Ensure properties are updated with correct types to avoid runtime errors.

## Notes

- **ContextActionService:** Utilizes Roblox's built-in service for managing contextual actions.
- **Mobile Compatibility:** Supports defining whether actions apply to mobile devices.
- **Dynamic Updates:** Easily update actions without manually managing each binding.

For detailed API reference, consult the inline comments within the Lua script.
