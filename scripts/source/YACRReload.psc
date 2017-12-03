Scriptname YACRReload extends ReferenceAlias  

Quest Property SSLYACR  Auto  

Event OnCellLoad()
	debug.trace("[yacr] OnCellLoad reload")
	RegisterForSingleUpdate(5)
EndEvent

;Event OnLocationChange(Location akOldLoc, Location akNewLoc)
;	debug.trace("[yacr] OnLocationChange reload")
;	RegisterForSingleUpdate(5)
;EndEvent

Event OnUpdate()
	debug.trace("[yacr] Reload quest")
	self._reload()
EndEvent

Function _reload()
	if (SSLYACR.IsRunning())
		SSLYACR.Stop()
	endif
	SSLYACR.Start()
EndFunction