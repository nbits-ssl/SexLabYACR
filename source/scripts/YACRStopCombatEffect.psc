Scriptname YACRStopCombatEffect extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster) 
	self._readySexAggr(akCaster)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	self._endSexAggr(akCaster)
EndEvent


Function _readySexAggr(Actor act)
	act.SetGhost(true)
	act.StopCombat()
	; act.StopCombatAlarm()
EndFunction

Function _endSexAggr(Actor act)
	act.SetGhost(false)
EndFunction