Scriptname YACRInit extends Quest  

Quest Property SSLYACR  Auto  

Event OnInit()
	if !(SSLYACR.IsRunning())
		SSLYACR.Start()
	endif
	self.Stop()
EndEvent