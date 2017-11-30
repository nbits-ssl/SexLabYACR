Scriptname YACRStopCombatEffect extends activemagiceffect  

Event OnEffectStart(Actor akTarget, Actor akCaster) 
	akTarget.SetAV("Invisibility", 1)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.SetAV("Invisibility", 0)
EndEvent