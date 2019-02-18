-- CodeSync: ModuleScript (2/18/2019 2:03:06 AM)
local rangular = require(script.Parent.Parent.Modules.Rangular)
local syncService = require(script.SyncService)
local serializeService = require(script.SerializeService)

local codeSyncComponent = script.Parent.Parent.Components.CodeSync

rangular:registerComponent(codeSyncComponent)

return function(virtualPlugin, settings)
	local mappingStorage = virtualPlugin.storage:create("CodeSync")
	local syncExecutor = require(script.SyncExecutor)(mappingStorage)
	local syncButton = virtualPlugin.toolbar:addButton("Code Sync", "Sync scripts back and forth from file system.", "rbxassetid://2862148797")
	
	local widgetInfo = DockWidgetPluginGuiInfo.new(Enum.InitialDockState.Left, false, false, 256, 256)
	local widget = virtualPlugin.instance:CreateDockWidgetPluginGui("RobloxStudioPlus_CodeSync", widgetInfo)
	widget.Title = "Code Sync"
	
	game.StarterGui.CodeSync:ClearAllChildren()
	local debugMode = false
	local parent = debugMode and game.StarterGui.CodeSync or widget
	
	local codeSync = rangular:bootstrap(parent, codeSyncComponent.Name, {
		toolbarButton = syncButton,
		syncService = syncService,
		serializeService = serializeService,
		syncExecutor = syncExecutor
	}, rangular.instance.StyleService.Themes.Studio)
	
	codeSync.component:compile()
	
	return {}
end

-- WebGL3D
