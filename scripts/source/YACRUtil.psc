Scriptname YACRUtil extends Quest  

Function Log(String msg)
	; bool debugflag = true
	; bool debugflag = false

	if (Config.debugLogFlag)
		debug.trace("[yacr] " + msg)
	endif
EndFunction

YACRConfig Property Config Auto