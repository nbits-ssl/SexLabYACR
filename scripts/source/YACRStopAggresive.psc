Scriptname YACRStopAggresive extends activemagiceffect  

float NativeAggrValue

Event OnEffectStart(Actor akTarget, Actor akCaster)
	NativeAggrValue = akTarget.GetAV("Aggression")
	akTarget.SetAV("Aggression", 1.0)
	akTarget.StopCombat()
	akTarget.StopCombatAlarm()
	akTarget.EnableAI(false)
	akTarget.EnableAI()
	; debug.trace("[yacr] StopAggression!! " + NativeAggrValue)
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	akTarget.SetAV("Aggression", NativeAggrValue)
EndEvent


; ################### unused effect & script