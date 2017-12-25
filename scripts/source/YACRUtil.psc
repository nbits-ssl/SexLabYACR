Scriptname YACRUtil extends Quest  

Function Log(String msg)
	; bool debugflag = true
	; bool debugflag = false

	if (Config.debugLogFlag)
		debug.trace("[yacr] " + msg)
	endif
EndFunction

Function Notif(String msg)
	; bool debugflag = true
	; bool debugflag = false

	if (Config.debugNotifFlag)
		debug.notification("[yacr] " + msg)
	endif
EndFunction

bool Function CheckSex(Actor act, int gender = -1)
	if (gender == -1)
		return true
	endif
	
	int agender = SexLab.GetGender(act)
	if (agender == gender || agender == gender + 2)
		return true
	else
		return false
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

Actor Function GetPlayerAggressor()
	Actor act
	if (PlayerAggressor)
		act = PlayerAggressor.GetActorRef()
	endif
	return act
EndFunction

Function BanishAllDaedra()
	if (SSLYACRDaedraBreaker.IsRunning())
		SSLYACRDaedraBreaker.Stop()
	endif
	SSLYACRDaedraBreaker.Start()
	SSLYACRDaedraBreaker.Stop()
EndFunction

Function KnockDownAll()
	self.Log("KnockDownAll()")
	Actor PlayerActor = Game.GetPlayer()
	Actor act
	ReferenceAlias ref
	float health
	int len = Teammates.Length
	
	while len
		len -= 1
		ref = Teammates[len]
		act = ref.GetActorRef()
		if (act && !act.HasKeyWordString("SexLabActive") && \
			PlayerActor.GetParentCell() == act.GetParentCell())
			
			act.SetGhost()
			act.StopCombat()
			act.StopCombatAlarm()
			if (act.HasKeyWord(ActorTypeNPC))
				act.SetNoBleedoutRecovery(true)
				health = act.GetAV("health")
				act.DamageAV("health", health + 30.0)
				; debug.SendAnimationEvent(act as ObjectReference, "BleedOutStart")
				act.SetGhost(false)
			else
				act.SetGhost(false)
				act.AddSpell(SSLYACRParalyseMagic)
				(PlayerActor as ObjectReference).PushActorAway(act, 2.0)
			endif
		endif
	endWhile
EndFunction

Function WakeUpAll()
	self.Log("WakeUpAll()")
	Actor act
	ReferenceAlias ref
	float health
	int len = Teammates.Length
	
	while len
		len -= 1
		ref = Teammates[len]
		act = ref.GetActorRef()
		if (act)
			if (act.HasKeyWord(ActorTypeNPC))
				act.SetNoBleedoutRecovery(false)
			else
				act.RemoveSpell(SSLYACRParalyseMagic)
			endif
		endif
	endWhile
EndFunction

Function PurgePlayerFromTeam()
	self.Log("Purge")
	Actor act
	ReferenceAlias ref
	int len = Teammates.Length
	
	while len
		len -= 1
		ref = Teammates[len]
		act = ref.GetActorRef()
		self.Log(act)
		if (act)
			act.SetPlayerTeammate(false)
		endif
	endWhile
EndFunction

Function RecoverPlayerToTeam()
	self.Log("Recover")
	Actor act
	ReferenceAlias ref
	int len = Teammates.Length

	while len
		len -= 1
		ref = Teammates[len]
		act = ref.GetActorRef()
		self.Log(act)
		if (act)
			if !(act.HasKeyWordString("SexLabActive"))
				act.SetPlayerTeammate(true)
			endif
		endif
	endWhile
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

Actor[] Function GetHelpers(Actor aggr, Faction fact)
	Actor[] helpers
	
	if (aggr.HasKeyWord(ActorTypeNPC))
		if !(SSLYACRHelperHumanMain.IsRunning())
			SSLYACRHelperHumanMainAggr.ForceRefTo(aggr)
			helpers = self._getHelpers(SSLYACRHelperHumanSearcher, MultiplayEnemyFactionsConfig[0])
			SSLYACRHelperHumanMain.Stop()
		endif
	else ; Creature
		int x = MultiplayEnemyFactions.Find(fact)
		
		if (x > -1)
			helpers = self._getHelpers(MultiplayEnemySearcher[x], MultiplayEnemyFactionsConfig[x])
		endif
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
		if (tmpArray.Length > 2)
			helpers = new Actor[2]
			helpers[0] = tmpArray[0]
			helpers[1] = tmpArray[1]
		else
			return tmpArray
		endif
	elseif (max == 1)
		if (tmpArray.Length > 1)
			helpers = new Actor[1]
			helpers[0] = tmpArray[0]
		else
			return tmpArray
		endif
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
SexLabFramework Property SexLab  Auto

Faction[] Property AvailableEnemyFactions  Auto  
Faction[] Property MultiplayEnemyFactions  Auto  
Quest[] Property MultiplayEnemySearcher  Auto  

Bool[] Property AvailableEnemyFactionsConfig  Auto  
Int[] Property MultiplayEnemyFactionsConfig  Auto  

ReferenceAlias[] Property Teammates  Auto  
ReferenceAlias Property PlayerAggressor  Auto  

SPELL Property SSLYACRParalyseMagic  Auto  

Keyword Property ActorTypeNPC  Auto  

Quest Property SSLYACRHelperHumanSearcher  Auto  

Quest Property SSLYACRHelperHumanMain  Auto  

ReferenceAlias Property SSLYACRHelperHumanMainAggr  Auto  

Quest Property SSLYACRDaedraBreaker  Auto  
