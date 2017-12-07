Scriptname YACRPlayer extends ReferenceAlias  

Form PreSource = None
string SelfName
bool PlayerIsMale = false
bool IsInCurrentFollowerFaction = false
bool AlreadyInEnemyFaction = false
bool EndlessSexLoop = false
sslThreadController updateController

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	Actor akAggr = akAggressor as Actor
	Actor selfact = self.GetActorRef()
	SelfName = selfact.GetActorBase().GetName()
	Weapon wpn = akSource as Weapon
	bool isplayer = self._isPlayer()
	
	if (PlayerIsMale || akAggressor == None || akProjectile || PreSource ==  akSource || !wpn)
		AppUtil.Log("not if " + SelfName)
		return
	elseif (isplayer)
		if (selfact.GetActorBase().GetSex() != 1) 
			AppUtil.Log("not if, player isn't woman " + SelfName)
			PlayerIsMale = true
			return
		elseif (selfact.GetAV("Health") <= 0)
			AppUtil.Log("not if, player is dying " + SelfName)
			return
		endif
	elseif (selfact.IsGhost() || selfact.IsDead())
		AppUtil.Log("not if, isghost or dead " + SelfName)
		return
	elseif (akAggr.IsPlayerTeammate() || akAggr == PlayerActor)
		AppUtil.Log("not if, onhit from teammate or player " + SelfName)
		return
	elseif (selfact.IsInKillMove() || akAggr.IsInKillMove())
		AppUtil.Log("not if, detect killmoving " + SelfName)
		return
	endif

	GotoState("Busy")
	PreSource = akSource
	float healthper = selfact.GetAVPercentage("health") * 100
	Faction aggrFaction = AppUtil.GetEnemyType(akAggr)
	
	if (aggrFaction && !abHitBlocked && healthper < Config.GetHealthLimit(isplayer) \
		&& wpn.GetWeaponType() < 7) ; exclude Bow/Staff/Crossbow
		
		AppUtil.Log("onhit success " + SelfName)
		
		int rndintRP = Utility.RandomInt(1, 100)
		int rndintAB = Utility.RandomInt(1, 100)
		Armor selfarmor = selfact.GetWornForm(0x00000004) as Armor

		if (selfact.IsInFaction(SSLAnimatingFaction)) ; first check
			if (selfact.IsWeaponDrawn())
				AppUtil.Log("detect invalid SSLAnimatingFaction, delete " + SelfName)
				selfact.RemoveFromFaction(SSLAnimatingFaction)
			else
				AppUtil.Log("StopCombat " + SelfName)
				selfact.StopCombat()
				akAggr.StopCombat()
			endif
		elseif (selfarmor)
			if (rndintRP < Config.GetRapeChanceNotNaked(isplayer))
				AppUtil.Log("doSex " + SelfName)
				self.doSex(akAggr, aggrFaction)
			elseif (Config.GetEnableArmorBreak(isplayer))
				int[] chances = Config.GetBreakChances(isplayer)
				if ((selfarmor.HasKeyWord(ArmorClothing) && rndintAB < chances[0]) || \
					(selfarmor.HasKeyWord(ArmorLight) && rndintAB < chances[1]) || \
					(selfarmor.HasKeyWord(ArmorHeavy) && rndintAB < chances[2]))
					
					selfact.RemoveItem(selfarmor)
					AppUtil.Log(" Armor break " + SelfName)
				endif
			endif
		elseif (!selfarmor && rndintRP < Config.GetRapeChance(isplayer))
			AppUtil.Log("doSex " + SelfName)
			self.doSex(akAggr, aggrFaction)
		endif
	endif
	
	Utility.Wait(0.5)
	PreSource = None
	GotoState("")
EndEvent

State Busy
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		AppUtil.Log("busy " + SelfName)
		; do nothing
	EndEvent
EndState

bool Function _isPlayer()
	if (HookName == "Player")
		return true
	else
		return false
	endif
EndFunction

Function _readySexVictim(Faction fact)
	Actor act = self.GetActorRef()
	act.AddSpell(SSLYACRKillmoveArmorSpell, false) ; silently
	act.SetGhost(true)
	AlreadyInEnemyFaction = false
	
	if (self._isPlayer())
		fact.SetReaction(SSLYACRCalmFaction, 3) ; set friend
		act.AddToFaction(SSLYACRCalmFaction)
		
		Game.ForceThirdPerson()
		Game.DisablePlayerControls(true, true, true, false, true, false, true, false)
		; move, fight, camswitch, look, sneak, menu, activate, jornal
	else
		if (act.IsInFaction(CurrentFollowerFaction))
			act.RemoveFromFaction(CurrentFollowerFaction)
			IsInCurrentFollowerFaction = true
		endif
		act.SetPlayerTeammate(false)
		if (act.IsInFaction(fact))
			AlreadyInEnemyFaction = true
		else
			act.AddToFaction(fact)
		endif
	endif
	
	act.StopCombat()
	act.StopCombatAlarm()
EndFunction

Function _endSexVictim(Faction fact = None)
	Actor act = self.GetActorRef()
	if (self._isPlayer())
		act.RemoveFromFaction(SSLYACRCalmFaction)
		fact.SetReaction(SSLYACRCalmFaction, 0) ; set neutral
		Game.EnablePlayerControls()
	else
		if (!AlreadyInEnemyFaction && fact)
			act.RemoveFromFaction(fact)
		endif
		act.SetPlayerTeammate(true)
		if (IsInCurrentFollowerFaction)
			act.AddToFaction(CurrentFollowerFaction)
		endif
	endif
	
	act.RemoveSpell(SSLYACRKillmoveArmorSpell)
	act.SetGhost(false)
EndFunction

; _readySexAggr / _endSexAggr to StopCombatEffect.psc

Function doSex(Actor aggr, Faction aggrFaction)
	Actor act = self.GetActorRef()
	
	if (act.IsGhost() || aggr.IsGhost())
		AppUtil.Log("ghosted Actor found, pass doSex " + SelfName)
	elseif (Aggressor.GetActorRef() || aggr.IsDead())
		AppUtil.Log("already filled ref or dead actor, pass doSex " + SelfName)
	elseif (act.IsInFaction(SSLAnimatingFaction)) ; second check
		AppUtil.Log("actloser already animating, pass doSex " + SelfName)
	else
		Aggressor.ForceRefTo(aggr)
		self._readySexVictim(aggrFaction)
		
		sslBaseAnimation[] anims
		if (aggr.HasKeyWord(ActorTypeNPC))
			anims =  SexLab.GetAnimationsByTags(2, "MF,Aggressive", "Oral", true)
		else
			anims =  SexLab.GetAnimationsByTags(2, "")
		endif
		actor[] sexActors = new actor[2]
		sexActors[0] = act
		sexActors[1] = aggr
		
		AppUtil.Log("run SexLab " + SelfName)
		int tid = self._quickSex(sexActors, anims, victim = act)
		sslThreadController controller = SexLab.GetController(tid)
		
		; wait for sync, max 12 sec.
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		
		if (controller)
			Utility.Wait(1.0)
			; self._endSexAggr(aggr)
			aggr.SetGhost(false) ; _endSexAggr()
			AppUtil.Log("aggr setghost disable " + SelfName)
		else
			AppUtil.Log("###FIXME### controller not found, recover setup " + SelfName)
			self.EndSexEvent(aggr)
		endif
	endif
EndFunction

Function doSexLoop(Faction fact)
	Actor[] helpers = AppUtil.GetHelpers(fact)
	self._forceRefHelpers(helpers) ; and reject none values
	Utility.Wait(0.5)
	
	AppUtil.Log("LOOPING run SexLab aggr " + aggr)
	Actor aggr = Aggressor.GetActorRef()
	Actor victim = self.GetActorRef()
	
	int helpersCount = AppUtil.ArrayCount(helpers)
	sslBaseAnimation[] anims = self._buildAnimation(aggr, helpersCount)
	actor[] sexActors = self._buildActors(aggr, victim, helpersCount)
	
	AppUtil.Log("LOOPING run SexLab " + SelfName)
	int tid = self._quickSex(sexActors, anims, victim = victim)
	sslThreadController controller = SexLab.GetController(tid)
	
	; wait for sync, max 12 sec.
	self._waitSetup(controller)
	self._waitSetup(controller)
	self._waitSetup(controller)
	self._waitSetup(controller)
	
	if (controller)
		Utility.Wait(1.0)
		; self._endSexAggr(aggr)
		aggr.SetGhost(false)
		
		int idx = helpers.Length
		while idx
			idx -= 1
			helpers[idx].SetGhost(false)
		endwhile
			
		AppUtil.Log("LOOPING aggr setghost disable " + SelfName)
	else
		AppUtil.Log("LOOPING ###FIXME### controller not found, recover setup " + SelfName)
		self.EndSexEvent(aggr)
	endif
EndFunction

; by the nine! ugly elefant code! where are array#delete, array[var]... 
Function _forceRefHelpers(Actor[] sppt)
	if (sppt)
		if (sppt[0])
			Helper1.ForceRefTo(sppt[0])
			if (sppt[1])
				Helper2.ForceRefTo(sppt[1])
				if (sppt[2])
					Helper3.ForceRefTo(sppt[2])
				endif
			elseif (sppt[2])
				Helper2.ForceRefTo(sppt[2])
			endif
		elseif (sppt[1])
			Helper1.ForceRefTo(sppt[1])
			if (sppt[2])
				Helper2.ForceRefTo(sppt[2])
			endif
		elseif (sppt[2])
			Helper1.ForceRefTo(sppt[2])
		endif
	endif
EndFunction

sslBaseAnimation[] Function _buildAnimation(Actor male, int count)
	sslBaseAnimation[] anims
	
	if (count)
		if (count == 3)
			if (male.HasKeyWord(ActorTypeNPC))
				anims = SexLab.GetAnimationsByTags(5, "MMMMF")
			else
				anims = SexLab.GetAnimationsByTags(5, "FCCCC")
			endif
		elseif (count == 2)
			if (male.HasKeyWord(ActorTypeNPC))
				anims = SexLab.GetAnimationsByTags(4, "MMMF")
			else
				anims = SexLab.GetAnimationsByTags(4, "FCCC")
			endif
		elseif (count == 1)
			if (male.HasKeyWord(ActorTypeNPC))
				anims = SexLab.GetAnimationsByTags(3, "MMF,Aggressive")
			else
				anims = SexLab.GetAnimationsByTags(3, "FCC")
			endif
		endif
	else
		if (male.HasKeyWord(ActorTypeNPC))
			anims = SexLab.GetAnimationsByTags(2, "MF,Aggressive", "Oral")
		else
			anims = SexLab.GetAnimationsByTags(2, "FC")
		endif
	endif
	
	return anims
EndFunction

Actor[] Function _buildActors(Actor male, Actor female, int count)
	Actor[] sexActors
	
	if (count)
		if (count == 3)
			sexActors = new Actor[5]
			sexActors[0] = female
			sexActors[1] = male
			sexActors[2] = Helper1.GetActorRef()
			sexActors[3] = Helper2.GetActorRef()
			sexActors[4] = Helper3.GetActorRef()
		elseif (count == 2)
			sexActors = new Actor[4]
			sexActors[0] = female
			sexActors[1] = male
			sexActors[2] = Helper1.GetActorRef()
			sexActors[3] = Helper2.GetActorRef()
		elseif (count == 1)
			sexActors = new Actor[3]
			sexActors[0] = female
			sexActors[1] = male
			sexActors[2] = Helper1.GetActorRef()
		endif
	else
		sexActors = new Actor[2]
		sexActors[0] = female
		sexActors[1] = male
	endif
	
	return sexActors
EndFunction

; code from SexLab's StartSex with disable beduse, disable leadin, and YACR Hook
int function _quickSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = none)
	sslThreadModel Thread = SexLab.NewThread()
	if !Thread
		return -1
	elseIf !Thread.AddActors(Positions, Victim)
		return -1
	endIf
	Thread.SetAnimations(Anims)
	Thread.DisableBedUse(true)
	Thread.DisableLeadIn()
	
	Thread.SetHook("YACR" + HookName)
	RegisterForModEvent("HookStageStart_YACR" + HookName, "StageStartEventYACR")
	RegisterForModEvent("HookAnimationEnd_YACR" + HookName, "EndSexEventYACR")
	
	if Thread.StartThread()
		return Thread.tid
	endIf
	return -1
endFunction

Function _waitSetup(sslThreadController controller)
	if (controller)
		string threadstate = controller.GetState()
		
		if (threadstate == "Ending")
			AppUtil.Log("###FIXME### state already ended, pass " + SelfName)
		elseif (threadstate != "animating")
			AppUtil.Log("wait setup " + SelfName + ", current state " + threadstate)
			Utility.Wait(3.0)
		else
			AppUtil.Log("wait setup " + SelfName + ", break, go ahead.")
		endif
	else
		AppUtil.Log("###FIXME### wait setup, no controller " + SelfName)
	endif
EndFunction

Event StageStartEventYACR(int tid, bool HasPlayer)
	updateController = SexLab.GetController(tid)
	sslThreadController controller = updateController
	int stagecnt = controller.Animation.StageCount
	
	if (controller.Stage == stagecnt && Config.GetEnableEndlessRape(self._isPlayer()))
		Utility.Wait(3.0)
		int rndint = Utility.RandomInt(1, 100)
		if (rndint < 20) ; 20%
			AppUtil.Log("endless sex loop...one more " + SelfName)
			controller.AdvanceStage(true)
		elseif (rndint < 45) ; 25%
			AppUtil.Log("endless sex loop...one more from 2nd " + SelfName)
			controller.GoToStage(stagecnt - 2)
		elseif (rndint < 75) ; 30%
			EndlessSexLoop = true
			controller.EndAnimation()
		else ; 25%
			AppUtil.Log("endless sex loop...change anim " + SelfName)
			controller.GoToStage(stagecnt - 2)
			controller.ChangeAnimation()
			RegisterForSingleUpdate(5.0)
		endif
	endif
EndEvent

; from rapespell, genius!
Event OnUpdate()
	if (updateController)
		updateController.OnUpdate()
		RegisterForSingleUpdate(5.0)
	endif
EndEvent

Event EndSexEventYACR(int tid, bool HasPlayer)
	self.EndSexEvent(SexLab.GetController(tid).Positions[1])
EndEvent

Function EndSexEvent(Actor aggr)
	AppUtil.Log("EndSexEvent Loser " + SelfName)
	Faction fact = AppUtil.GetEnemyType(aggr)
	
	if (EndlessSexLoop)
		EndlessSexLoop = false
		self.doSexLoop(fact)
	else ; Aggr's OnHit
		self._endSexVictim(fact)
		
		AppUtil.CleanFlyingDeadBody(aggr)
		self._cleanDeadBody(Helper1)
		self._cleanDeadBody(Helper2)
		self._cleanDeadBody(Helper3)

		Aggressor.Clear()
		Helper1.Clear()
		Helper2.Clear()
		Helper3.Clear()
		
		GotoState("Busy")
		Utility.Wait(2.0)
		PreSource = None
		GotoState("")
	endif
EndFunction

Function _cleanDeadBody(ReferenceAlias enemy)
	Actor act = enemy.GetActorRef()
	if (act)
		AppUtil.CleanFlyingDeadBody(act)
	endif
EndFunction

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if (aeCombatState == 0)
		Actor selfact = self.GetActorRef()
		selfact.EnableAI(false)
		selfact.EnableAI()
		AppUtil.Log("OnCombatStateChanged, reset ai " + SelfName)
	endif
EndEvent

Event OnCellDetach()
	Actor aggr = Aggressor.GetActorRef()

	if (aggr)
		self._endSexVictim(AppUtil.GetEnemyType(aggr))
	else
		self._endSexVictim(None)
	endif
EndEvent


YACRConfig Property Config Auto
YACRUtil Property AppUtil Auto
SexLabFramework Property SexLab  Auto
Faction property SSLAnimatingFaction Auto
Actor Property PlayerActor  Auto

ReferenceAlias Property Aggressor  Auto
ReferenceAlias Property Helper1  Auto  
ReferenceAlias Property Helper2  Auto  
ReferenceAlias Property Helper3  Auto  

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

Keyword Property ArmorClothing  Auto  
Keyword Property ArmorHeavy  Auto  
Keyword Property ArmorLight  Auto  

SPELL Property SSLYACRStopCombatMagic  Auto  ; no longer needed
SPELL Property SSLYACRKillmoveArmorSpell  Auto
String Property HookName  Auto

Keyword Property ActorTypeNPC  Auto  
Faction Property CurrentFollowerFaction  Auto  

Faction Property SSLYACRCalmFaction  Auto  
