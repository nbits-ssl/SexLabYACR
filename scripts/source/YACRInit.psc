Scriptname YACRInit extends Quest  

Quest Property SSLYACR  Auto  

Event OnInit()
	if !(SSLYACR.IsRunning())
		SSLYACR.Start()
	endif
	; self.Stop()
	; this is the initializer AND Quest Reload Manager
EndEvent

Function Reboot()
	if (SSLYACR.IsRunning())
		SSLYACR.Stop()
	endif
	SSLYACR.Start()
EndFunction