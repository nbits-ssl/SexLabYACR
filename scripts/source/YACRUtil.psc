Scriptname YACRUtil extends Quest  

Function Log(String msg)
	; bool debugflag = true
	; bool debugflag = false

	if (Config.debugLogFlag)
		debug.trace("[yacr] " + msg)
	endif
EndFunction

Faction Function GetEnemyType(Actor act)
	if (act.GetActorBase().GetSex() == 1) ; female
		return None
	endif
	
	if (act.IsInFaction(BanditFaction))
		return BanditFaction
	elseif (act.IsInFaction(ThalmorFaction))
		return ThalmorFaction
	elseif (act.IsInFaction(PredatorFaction))
		return PredatorFaction
	elseif (act.IsInFaction(VampireFaction))
		return VampireFaction
	elseif (act.IsInFaction(DraugrFaction))
		return DraugrFaction
	elseif (act.IsInFaction(TrollFaction))
		return TrollFaction
	elseif (act.IsInFaction(ChaurusFaction))
		return ChaurusFaction
	elseif (act.IsInFaction(SkeeverFaction))
		return SkeeverFaction
	elseif (act.IsInFaction(FalmerFaction))
		return FalmerFaction
	elseif (act.IsInFaction(GiantFaction))
		return GiantFaction
	elseif (act.IsInFaction(WerewolfFaction))
		return WerewolfFaction
	elseif (act.IsInFaction(DLC2RieklingFaction))
		return DLC2RieklingFaction
	else
		return None
	endif
EndFunction

Actor[] Function GetHelpers(faction fact)
	if (fact == BanditFaction)
		return self._getHelpers(SSLYACRHelperBanditSearcher)
	else
		return None
	endif
EndFunction

Actor[] Function _getHelpers(Quest qst)
	Actor[] helpers
	
	if (!qst.IsRunning())
		qst.Start()
		helpers = (qst as YACRHelperSearch).Gather()
		qst.Stop()
	endif
	
	return helpers
EndFunction

; from crationkit.com, author is Chesko
int Function ArrayCount(Actor[] myArray)
	int i = 0
	int myCount = 0
	while i < myArray.Length
		if myArray[i] != none
			myCount += 1
			i += 1
		else
			i += 1
		endif
	endwhile
	return myCount
EndFunction

YACRConfig Property Config Auto

Faction Property BanditFaction  Auto
Faction Property PredatorFaction  Auto
Faction Property VampireFaction  Auto
Faction Property DraugrFaction  Auto
Faction Property TrollFaction  Auto
Faction Property ChaurusFaction  Auto
Faction Property SkeeverFaction  Auto
Faction Property FalmerFaction  Auto
Faction Property GiantFaction  Auto
Faction Property WerewolfFaction  Auto
Faction Property DLC2RieklingFaction  Auto
Faction Property ThalmorFaction  Auto  

Quest Property SSLYACRHelperBanditSearcher  Auto  
