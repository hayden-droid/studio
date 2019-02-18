-- CodeSync: ModuleScript (2/18/2019 2:03:06 AM)
local selection = game:GetService("Selection")

return function(parentInstance, args, component)
	local mappingsUpdated = Instance.new("BindableEvent")
	
	local folderName = Instance.new("StringValue")
	folderName.Value = "E:\\Workspace\\Public\\Rangular"
	
	local codeSyncMap = args.syncExecutor:getMappings()
	
	args.toolbarButton.mouseButton1Click:connect(function()
		parentInstance.Enabled = not parentInstance.Enabled
	end)
	
	args.syncExecutor.mappingsUpdated:connect(function()
		codeSyncMap = args.syncExecutor:getMappings()
		mappingsUpdated:Fire()
	end)
	
	return setmetatable({
		mappingsUpdated = mappingsUpdated.Event,
		widget = parentInstance,
		selection = selection,
		
		canImport = function(controller)
			local selectionList = selection:Get()
			if (#selectionList ~= 1) then
				return false
			end
			
			return args.syncExecutor:getMapping(selectionList[1]) == nil
		end,
		
		canExport = function(controller)
			return controller:canImport() -- TODO: Improve
		end,
		
		import = function(event)
			local selectedInstance = selection:Get()[1]
			if (not selectedInstance) then
				warn("No instance to import into.")
				return
			end
			
			local importLocation = args.syncService:selectFolderPath()
			args.syncExecutor:import(selectedInstance, importLocation)
			-- TODO: ???
		end,
		
		export = function(event)
			local selectedInstance = selection:Get()[1]
			if (not selectedInstance) then
				warn("No instance to export.")
				return
			end
			
			local exportLocation = args.syncService:selectFolderPath()
			if (not exportLocation) then
				warn("No location selected to export to.")
				return
			end
			
			args.syncExecutor:export(selectedInstance, exportLocation)
			-- TODO: ???
		end
	}, {
		__index = function(t, ind)
			if (ind == "codeSyncMap") then
				return codeSyncMap
			end
			
			return rawget(t, ind)
		end
	})
end

-- WebGL3D