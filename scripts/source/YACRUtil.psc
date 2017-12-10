Scriptname YACRUtil extends Quest  

Function Log(String msg)
	; bool debugflag = true
	; bool debugflag = false

	if (Config.debugLogFlag)
		debug.trace("[yacr] " + msg)
	endif
EndFunction

Function CleanFlyingDeadBody(Actor act)
	if (act.IsDead())
		ObjectReference wobj = act as ObjectReference
		wobj.SetPosition(wobj.GetPositionX(), wobj.GetPositionY() + 10.0, wobj.GetPositionZ())
		debug.sendAnimationEvent(wobj, "ragdoll")
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
			if (AvailableEnemyFactionsConfig[x])
				return AvailableEnemyFactions[x]
			else
				return None
			endif
		endif
	endwhile
	
	return None
EndFunction

bool Function ValidateMultiplaySupport(Faction fact)
	int x = MultiplayEnemyFactions.Find(fact)
	
	if (x > -1)
		int y = MultiplayEnemyFactionsConfig[x]
		if (y == 0)
			return false
		else
			return true
		endif
	else
		return false
	endif
	
	return false
EndFunction

; bandit, thalmor, vampire, draugr, falmer, wolf(only one helper), skeever
Actor[] Function GetHelpers(Faction fact)
	Actor[] helpers
	int x = MultiplayEnemyFactions.Find(fact)
	
	if (x > -1)
		helpers = self._getHelpers(MultiplayEnemySearcher[x], MultiplayEnemyFactionsConfig[x])
	endif
	
	return helpers
EndFunction

Actor[] Function _getHelpers(Quest qst, int max)
	Actor[] tmpArray
	Actor[] helpers

	if (max == 0) ; not reach
		return helpers
	endif
	
	if (!qst.IsRunning())
		qst.Start()
		tmpArray = (qst as YACRHelperSearch).Gather()
		qst.Stop()
	endif
	ArraySort(tmpArray)
	
	if (max == 3)
		return tmpArray
	elseif (max == 2)
		helpers = new Actor[2]
		helpers[0] = tmpArray[0]
		helpers[1] = tmpArray[1]
	elseif (max == 1)
		helpers = new Actor[1]
		helpers[0] = tmpArray[0]
	endif
	
	return helpers
EndFunction

; from crationkit.com, author is Chesko || Form[] => Actor[]
bool function ArraySort(Actor[] myArray, int i = 0)
	bool bFirstNoneFound = false
	int iFirstNonePos = i
	while i < myArray.Length
		if myArray[i] == none
			if bFirstNoneFound == false
				bFirstNoneFound = true
				iFirstNonePos = i
				i += 1
			else
				i += 1
			endif
		else
			if bFirstNoneFound == true
			;check to see if it's a couple of blank entries in a row
				if !(myArray[i] == none)
					;notification("Moving element " + i + " to index " + iFirstNonePos)
					myArray[iFirstNonePos] = myArray[i]
					myArray[i] = none
					;Call this function recursively until it returns
					ArraySort(myArray, iFirstNonePos + 1)
					return true
				else
					i += 1
				endif
			else
				i += 1
			endif
		endif
	endWhile
	return false
endFunction

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

Faction[] Property AvailableEnemyFactions  Auto  
Faction[] Property MultiplayEnemyFactions  Auto  
Quest[] Property MultiplayEnemySearcher  Auto  

Bool[] Property AvailableEnemyFactionsConfig  Auto  
Int[] Property MultiplayEnemyFactionsConfig  Auto  
