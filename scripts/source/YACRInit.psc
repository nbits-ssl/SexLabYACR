Scriptname YACRInit extends Quest  

Event OnInit()
	if !(SSLYACR.IsRunning())
		SSLYACR.Start()
	endif
	; self.Stop()
	; this is the initializer AND Quest Reload Manager
EndEvent

Function Reboot()
	if (SSLYACR.IsRunning())
		AppUtil.WakeUpAll()
		SSLYACR.Stop()
	endif
	SSLYACR.Start()
EndFunction

Quest Property SSLYACR  Auto  
YACRUtil Property AppUtil Auto
