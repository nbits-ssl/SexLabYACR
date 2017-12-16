Scriptname YACRReload extends ReferenceAlias  

Event OnCellLoad()
	AppUtil.Log("OnCellLoad reload")
	RegisterForSingleUpdate(5)
EndEvent

;Event OnLocationChange(Location akOldLoc, Location akNewLoc)
;	debug.trace("[yacr] OnLocationChange reload")
;	RegisterForSingleUpdate(5)
;EndEvent

Event OnUpdate()
	AppUtil.Log("Reload quest")
	self._reload()
EndEvent

Function _reload()
	if (SSLYACR.IsRunning())
		AppUtil.WakeUpAll()
		SSLYACR.Stop()
	endif
	SSLYACR.Start()
EndFunction

Quest Property SSLYACR  Auto  
YACRUtil Property AppUtil Auto