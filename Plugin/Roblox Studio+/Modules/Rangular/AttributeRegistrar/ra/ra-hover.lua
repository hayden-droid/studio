-- CodeSync: ModuleScript (2/18/2019 2:03:06 AM)
local attributeTypes = require(script.Parent.Parent.AttributeTypes)
local attributeValueParser = require(script.Parent.Parent.AttributeValueParser)

return {
	["type"] = attributeTypes.instance,
	
	trigger = function(attribute, instance, activeComponent, value, instanceComponent)
		assert(instance:IsA("GuiObject") or instance:IsA("ClickDetector"), "Expected ra-hover to be used with GuiObject or ClickDetector (got " .. instance.ClassName .. ")")
		
		value = attributeValueParser:parseAttributeValue(activeComponent.controller, value)
		assert(typeof(value) == "function", "Expected ra-hover value to be function (got " .. typeof(value) .. ")")
			
		local function mouseEnter(...)
			value({
				controller = instanceComponent.controller,
				instance = instance
			}, ...)
		end
		
		if (instance:IsA("GuiObject")) then
			instance.MouseEnter:connect(mouseEnter)
		elseif (instance:IsA("ClickDetector")) then
			instance.MouseHoverEnter:connect(mouseEnter)
		end
		
		return {}
	end
}

-- WebGL3D
