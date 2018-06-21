Scriptname YACRUtil extends Quest  

int Function GetVersion()
	return 20180621
EndFunction

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

int Function GetArousal(Actor act)
	return act.GetFactionRank(sla_Arousal)
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

bool Function ValidateSex(Actor victim, Actor aggr, int cfg)
	; 0 is straight, 1 is both, 2 is homo
	if (cfg == 1)
		return true
	else
		int vsex = victim.GetLeveledActorBase().GetSex()
		int asex = aggr.GetLeveledActorBase().GetSex()
		if (cfg == 0 && vsex != asex)
			return true
		elseif (cfg == 2 && vsex == asex)
			return true
		endif
	endif
	
	return false
EndFunction

Function CleanFlyingDeadBody(Actor act)
	if (act.IsDead())
		ObjectReference wobj = act as ObjectReference
		wobj.SetPosition(wobj.GetPositionX(), wobj.GetPositionY() + 10.0, wobj.GetPositionZ())
		debug.sendAnimationEvent(wobj, "ragdoll")
	endif
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
		if (act && act.IsEnabled() && !act.HasKeyWordString("SexLabActive") && \
			PlayerActor.GetParentCell() == act.GetParentCell())
			
			if (act.HasKeyWord(ActorTypeNPC))
				if (act.GetAV("health") > 0)
					act.SetGhost()
					act.StopCombat()
					act.StopCombatAlarm()
					
					act.SetNoBleedoutRecovery(true)
					health = act.GetAV("health")
					act.DamageAV("health", health + 30.0)
					act.SetGhost(false)
				endif
				if (!act.IsBleedingOut() || act.GetAnimationVariableInt("iState") != 5) ; bleedout
					debug.SendAnimationEvent(act, "BleedOutStart")
				endif
			else
				if (!act.HasSpell(SSLYACRParalyseMagic))
					act.SetGhost()
					act.StopCombat()
					act.StopCombatAlarm()
					
					act.SetGhost(false)
					act.AddSpell(SSLYACRParalyseMagic)
					PlayerActor.PushActorAway(act, 2.0)
				endif
			endif
		endif
	endwhile
EndFunction

Function WakeUpAll()
	self.Log("WakeUpAll()")
	Actor act
	ReferenceAlias ref
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
	endwhile
EndFunction

Actor Function CallHelp(Actor aggr)
	self.Log("CallHelp()")
	Actor act
	Actor PlayerActor = Game.GetPlayer()
	ReferenceAlias ref
	int len = Teammates.Length
	int chance = len
	int idx = 0
	bool loop = true
	
	while (chance && loop)
		chance -= 1
		idx = Utility.RandomInt(0, len - 1)
		ref = Teammates[idx]
		act = ref.GetActorRef()
		
		if (act && act.IsEnabled() && !act.HasKeyWordString("SexLabActive") && \
			PlayerActor.GetParentCell() == act.GetParentCell() && act.GetActorBase().GetSex() == 0)
			
			if (act.HasKeyWord(ActorTypeNPC))
				act.SetNoBleedoutRecovery(false)
			else
				act.RemoveSpell(SSLYACRParalyseMagic)
			endif
			
			act.ForceAV("health", 50.0)
			Utility.Wait(1.5)
			act.DoCombatSpellApply(PlayerHelperAngrySpell, aggr)
			act.RemoveSpell(PlayerHelperAngrySpell)
			act.EnableAI(false)
			act.EnableAI()
			loop = false
		endif
	endwhile
	
	if (loop)
		return None
	else
		return act
	endif
EndFunction

Faction Function purgeFollower(Actor act)
	Faction fact
	if (act.IsInFaction(CurrentFollowerFaction))
		act.RemoveFromFaction(CurrentFollowerFaction)
		fact = CurrentFollowerFaction
	elseif (act.IsInFaction(CurrentHireling))
		act.RemoveFromFaction(CurrentHireling)
		fact = CurrentHireling
	endif
	
	act.SetPlayerTeammate(false)
	
	return fact
EndFunction

Function rejoinFollower(Actor act, Faction fact)
	act.SetPlayerTeammate(true)
	act.AddToFaction(fact)
EndFunction

Actor[] Function GetHelpersCombined(Actor victim, Actor aggr)
	Actor[] actors
	Quest searcherQuest
	ReferenceAlias mainAggr
	
	if (aggr.HasKeyWord(ActorTypeNPC))
		searcherQuest = SSLYACRHelperHumanSearcher
		mainAggr = SSLYACRHelperHumanMainAggr
	else
		searcherQuest = SSLYACRHelperCreatureSearcher
		mainAggr = SSLYACRHelperCreatureMainAggr
	endif
	
	mainAggr.ForceRefTo(aggr)
	actors = self._getHelpersCombined(victim, aggr, searcherQuest)
	
	return actors
EndFunction

Actor[] Function _getHelpersCombined(Actor victim, Actor aggr, Quest qst)
	Actor[] tmpArray
	Actor[] actors
	sslBaseAnimation[] anims
	int idx = 0

	if (!qst.IsRunning())
		qst.Start()
		tmpArray = (qst as YACRHelperSearch).Gather()
		qst.Stop()
	endif
	ArraySort(tmpArray)
	idx = ArrayCount(tmpArray)
	
	if (idx == 3)
		actors = new Actor[5]
		actors[4] = tmpArray[2]
		actors[3] = tmpArray[1]
		actors[2] = tmpArray[0]
		actors[1] = aggr
		actors[0] = victim
		anims = self._pickAnimationsByActors(actors)
		self.Log("###3### " + anims)
		if !(anims)
			idx = 2
		endif
	endif
		
	if (idx == 2)
		actors = new Actor[4]
		actors[3] = tmpArray[1]
		actors[2] = tmpArray[0]
		actors[1] = aggr
		actors[0] = victim
		anims = self._pickAnimationsByActors(actors)
		self.Log("###2### " + anims)
		if !(anims)
			idx = 1
		endif
	endif

	if (idx == 1)
		actors = new Actor[3]
		actors[2] = tmpArray[0]
		actors[1] = aggr
		actors[0] = victim
		anims = self._pickAnimationsByActors(actors, Aggressive = true)
		self.Log("###1### " + anims)
		if !(anims)
			idx = 0
		endif
	endif

	if (idx == 0)
		actors = new Actor[2]
		actors[1] = aggr
		actors[0] = victim
	endif
	
	return actors
EndFunction

sslBaseAnimation[] Function _pickAnimationsByActors(Actor[] actors, bool aggressive = false)
	sslBaseAnimation[] anims
	Actor act = actors[1]
	
	if (act.HasKeyWord(ActorTypeNPC))
		anims = SexLab.PickAnimationsByActors(actors, Aggressive = aggressive)
	else
		Race actRace = act.GetRace()
		anims = SexLab.GetCreatureAnimationsByRace(actors.Length, actRace)
	endif
	
	return anims
EndFunction

; from creationkit.com, author is Chesko || Form[] => Actor[]
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

; from creationkit.com, author is Chesko
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
Faction Property sla_Arousal  Auto  
Keyword Property ActorTypeNPC  Auto  

Quest Property SSLYACRDaedraBreaker  Auto  
SPELL Property SSLYACRParalyseMagic  Auto  

ReferenceAlias[] Property Teammates  Auto  
ReferenceAlias Property PlayerAggressor  Auto  
SPELL Property PlayerHelperAngrySpell  Auto  

Quest Property SSLYACRHelperHumanMain  Auto  
Quest Property SSLYACRHelperHumanSearcher  Auto  
ReferenceAlias Property SSLYACRHelperHumanMainAggr  Auto  
Quest Property SSLYACRHelperCreatureMain  Auto  
Quest Property SSLYACRHelperCreatureSearcher  Auto  
ReferenceAlias Property SSLYACRHelperCreatureMainAggr  Auto  

Faction Property CurrentFollowerFaction  Auto  
Faction Property CurrentHireling  Auto  
