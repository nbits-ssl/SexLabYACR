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
	
	int x = AvailableEnemyFactions.Length
	while x
		x -= 1
		AvailableEnemyFactions[x]
		if (act.IsInFaction(AvailableEnemyFactions[x]))
			return AvailableEnemyFactions[x]
		endif
	endwhile
	
	return None
EndFunction

; bandit, thalmor, vampire, draugr, falmer, wolf(only one helper), skeever
Actor[] Function GetHelpers(faction fact)
	int x = MultiplayEnemyFactions.Find(fact)
	if (x)
		return self._getHelpers(MultiplayEnemySearcher[x])
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

Faction[] Property AvailableEnemyFactions  Auto  
Faction[] Property MultiplayEnemyFactions  Auto  
Quest[] Property MultiplayEnemySearcher  Auto  
