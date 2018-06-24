Scriptname YACRReload extends ReferenceAlias  

Event OnCellLoad()
	if (Config.modEnabled)
		AppUtil.Log("OnCellLoad Quest will reload")
		RegisterForSingleUpdate(5)
	else
		AppUtil.Log("OnCellLoad Quest will not reload, mod disabled")
	endif
EndEvent

Event OnUpdate()
	self._reload()
	AppUtil.Log("Reload quest done")
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
YACRConfig Property Config Auto
