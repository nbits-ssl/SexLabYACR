Scriptname YACRPlayer extends ReferenceAlias  

Form PreSource = None
string SelfName
bool PlayerIsMale = false
bool IsInCurrentFollowerFaction = false
bool IsInCurrentHireling = false
bool AlreadyInEnemyFaction = false
bool EndlessSexLoop = false
sslThreadController UpdateController
float ForceUpdatePeriod = 30.0
float BleedOutUpdatePeriod = 10.0

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	Actor akAggr = akAggressor as Actor
	Actor selfact = self.GetActorRef()
	SelfName = selfact.GetActorBase().GetName()
	Weapon wpn = akSource as Weapon
	bool isplayer = self._isPlayer()
	
	if (PlayerIsMale || akAggressor == None || akProjectile || PreSource ==  akSource || !wpn)
		AppUtil.Log("not if " + SelfName)
		return
	elseif (isplayer && selfact.GetActorBase().GetSex() != 1) 
		AppUtil.Log("not if, player isn't woman " + SelfName)
		PlayerIsMale = true
		return
	elseif (selfact.GetAV("Health") <= 0)
		AppUtil.Log("not if, player is dying or follower on bleedoutstart" + SelfName)
		return
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
	
	if (!abHitBlocked && healthper < Config.GetHealthLimit(isplayer) && wpn.GetWeaponType() < 7) ; exclude Bow/Staff/Crossbow
		Faction aggrFaction = AppUtil.GetEnemyType(akAggr)
		if (aggrFaction)
			AppUtil.Log("onhit success " + SelfName)
			
			int rndintRP = Utility.RandomInt()
			int rndintAB = Utility.RandomInt()
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
	self._disableControls()
	
	if (act.IsInFaction(fact))
		AlreadyInEnemyFaction = true
	elseif (!self._isPlayer())
		act.AddToFaction(fact)
	endif
	
	if (self._isPlayer())
		; fact.SetReaction(SSLYACRCalmFaction, 2) ; set ally
		; SSLYACRCalmFaction.SetReaction(fact, 2)
		act.AddToFaction(SSLYACRCalmFaction)
		act.AddSpell(SSLYACRPlayerSlowMagic, false)
		if (Config.knockDownAll)
			act.AddToFaction(fact)
			AppUtil.KnockDownAll()
		endif
	else
		if (act.IsInFaction(CurrentFollowerFaction))
			act.RemoveFromFaction(CurrentFollowerFaction)
			IsInCurrentFollowerFaction = true
		endif
		if (act.IsInFaction(CurrentHireling))
			act.RemoveFromFaction(CurrentHireling)
			IsInCurrentHireling = true
		endif
		
		act.SetPlayerTeammate(false)
	endif
	
	act.StopCombat()
	act.StopCombatAlarm()

	if (self._isPlayer() && Config.KnockDownAll)
		AppUtil.BanishAllDaedra()
	endif
EndFunction

Function _endSexVictim(Faction fact = None)
	Actor act = self.GetActorRef()
	
	if (!AlreadyInEnemyFaction && fact)
		act.RemoveFromFaction(fact)
	endif
	
	if (self._isPlayer())
		act.RemoveFromFaction(SSLYACRCalmFaction)
		; fact.SetReaction(SSLYACRCalmFaction, 0) ; set neutral
		; SSLYACRCalmFaction.SetReaction(fact, 0)
		act.RemoveSpell(SSLYACRPlayerSlowMagic)
		act.SetAV("Invisibility", 0.0)
		act.SetAlpha(1.0)
		if (Config.knockDownAll)
			AppUtil.WakeUpAll()
		endif
		Game.EnablePlayerControls()
	else
		act.SetPlayerTeammate(true)
		if (IsInCurrentFollowerFaction)
			act.AddToFaction(CurrentFollowerFaction)
		endif
		if (IsInCurrentHireling)
			act.AddToFaction(CurrentHireling)
		endif
	endif
	
	self._clearAudience()
	act.RemoveSpell(SSLYACRKillmoveArmorSpell)
	act.SetGhost(false)
EndFunction

Function _disableControls()
	if (self._isPlayer())
		Game.ForceThirdPerson()
		; Game.DisablePlayerControls()
		; Game.DisablePlayerControls(true, true, true, false, true, false, true, false)
		; move, fight, camswitch, look, sneak, menu, activate, jornal
	endif
EndFunction

Function _stopCombatOneMore(Actor aggr, Actor victim)
	aggr.StopCombat()
	aggr.StopCombatAlarm()
	victim.StopCombat()
	victim.StopCombatAlarm()
EndFunction

; _readySexAggr / _endSexAggr to StopCombatEffect.psc

Function doSex(Actor aggr, Faction aggrFaction)
	Actor victim = self.GetActorRef()
	SelfName = victim.GetActorBase().GetName()
	
	if (victim.IsGhost() || aggr.IsGhost())
		AppUtil.Log("ghosted Actor found, pass doSex " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
	elseif (Aggressor.GetActorRef() || aggr.IsDead())
		AppUtil.Log("already filled ref or dead actor, pass doSex " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
	elseif (victim.IsInFaction(SSLAnimatingFaction)) ; second check
		AppUtil.Log("actloser already animating, pass doSex " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
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
		sexActors[0] = victim
		sexActors[1] = aggr
		
		AppUtil.Log("run SexLab " + SelfName)
		int tid = self._quickSex(sexActors, anims, victim = victim)
		sslThreadController controller = SexLab.GetController(tid)
		
		; wait for sync, max 12 sec.
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		
		if (controller)
			if (self._isPlayer())
				victim.SetAV("Invisibility", 1.0)
			endif
			self._stopCombatOneMore(aggr, victim)
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
	self._disableControls()
	Actor aggr = Aggressor.GetActorRef()
	Actor victim = self.GetActorRef()
	
	Actor[] helpers = AppUtil.GetHelpers(aggr, fact)
	int helpersCount = self._forceRefHelpers(helpers) ; and reject none values
	
	AppUtil.Log("LOOPING run SexLab aggr " + aggr + ", count " + helpersCount)
	
	sslBaseAnimation[] anims = self._buildAnimation(aggr, helpersCount)
	actor[] sexActors = self._buildActors(aggr, victim, helpersCount)
	
	if (self._isPlayer())
		victim.SetAV("Invisibility", 0.0)
		victim.SetAlpha(1.0)
	endif
	AppUtil.Log("LOOPING run SexLab " + SelfName)
	int tid = self._quickSex(sexActors, anims, victim = victim, CenterOn = aggr)
	sslThreadController controller = SexLab.GetController(tid)
	
	; wait for sync, max 12 sec.
	self._waitSetup(controller)
	self._waitSetup(controller)
	self._waitSetup(controller)
	self._waitSetup(controller)
	
	if (controller)
		if (self._isPlayer())
			victim.SetAV("Invisibility", 1.0)
		endif
		self._stopCombatOneMore(aggr, victim)
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

int Function _forceRefHelpers(Actor[] sppt)
	int len = AppUtil.ArrayCount(sppt)
	
	if (len == 3)
		Helper1.ForceRefTo(sppt[0])
		Helper2.ForceRefTo(sppt[1])
		Helper3.ForceRefTo(sppt[2])
	elseif (len == 2)
		Helper1.ForceRefTo(sppt[0])
		Helper2.ForceRefTo(sppt[1])
	elseif (len == 1)
		Helper1.ForceRefTo(sppt[0])
	endif
	
	return len
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
int function _quickSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = None, Actor CenterOn = None)
	sslThreadModel Thread = SexLab.NewThread()
	if !Thread
		return -1
	elseIf !Thread.AddActors(Positions, Victim)
		return -1
	endIf
	Thread.SetAnimations(Anims)
	Thread.DisableBedUse(true)
	Thread.DisableLeadIn()
	Thread.CenterOnObject(CenterOn)
	
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
	self._getAudience()
	UpdateController = SexLab.GetController(tid)
	sslThreadController controller = UpdateController
	int stagecnt = controller.Animation.StageCount
	Actor aggr = controller.Positions[1]
	
	; for Onhit missing de-ghost
	if (controller.Stage > 1 && aggr.IsGhost())
		aggr.SetGhost(false)
	endif
	
	if (controller.Stage == stagecnt && Config.GetEnableEndlessRape(self._isPlayer()))
		AppUtil.Log("endless sex loop... " + SelfName)
		int rndint = Utility.RandomInt()
		Faction fact = AppUtil.GetEnemyType(aggr)
		
		if (rndint < 5) ; 20%
			AppUtil.Log("endless sex loop...one more " + SelfName)
			controller.AdvanceStage(true)
		elseif (rndint < 10) ; 25%
			AppUtil.Log("endless sex loop...one more from 2nd " + SelfName)
			controller.GoToStage(stagecnt - 2)
			RegisterForSingleUpdate(ForceUpdatePeriod)
		else
			Actor[] helpers = AppUtil.GetHelpers(aggr, fact)
			AppUtil.Log("endless sex loop... helpers are " + helpers)
			if (rndint < 90 && fact && AppUtil.ArrayCount(helpers)) ; 30%
				AppUtil.Log("endless sex loop...change to Multiplay " + SelfName)
				EndlessSexLoop = true
			else ; 25%
				AppUtil.Log("endless sex loop...change anim " + SelfName)
				controller.ChangeAnimation()
				RegisterForSingleUpdate(ForceUpdatePeriod)
			endif
		endif
	endif
EndEvent

; from rapespell, genius!
Event OnUpdate()
	if (UpdateController)
		AppUtil.Log("OnUpdate, UpdateController is alive " + SelfName)
		UpdateController.OnUpdate()
		RegisterForSingleUpdate(ForceUpdatePeriod)
	endif
	
	if (self.GetActorRef().IsBleedingOut())
		self._searchBleedOutPartner()
	endif
EndEvent

Function _getAudience()
	AppUtil.Log("get audience " + SelfName)
	if (AudienceQuest.IsRunning())
		AudienceQuest.Stop()
	endIf
	AudienceQuest.Start()
	if (self._isPlayer())
		Actor aggr = Aggressor.GetActorRef()
		Actor victim = self.GetActorRef()
		self._stopCombatOneMore(aggr, victim)
	endif
EndFunction

Function _clearAudience()
	AppUtil.Log("clear audience " + SelfName)
	if (AudienceQuest.IsRunning())
		AudienceQuest.Stop()
	endIf
EndFunction

Function _clearHelpers()
	Helper1.Clear()
	Helper2.Clear()
	Helper3.Clear()
EndFunction

Event EndSexEventYACR(int tid, bool HasPlayer)
	AppUtil.Log("EndSexEvent " + SelfName)
	sslThreadController controller = SexLab.GetController(tid)
	if (HasPlayer && EndlessSexLoop)
		debug.SendAnimationEvent(controller.Positions[0], "BleedOutStart")
	endif
	self.EndSexEvent(controller.Positions[1])
EndEvent

Function EndSexEvent(Actor aggr)
	Faction fact = AppUtil.GetEnemyType(aggr)
	
	if (EndlessSexLoop)
		AppUtil.Log("EndSexEvent, Goto to loop " + SelfName)
		EndlessSexLoop = false
		self._clearHelpers()
		
		if (!self._isPlayer() && Config.knockDownAll && PlayerActor.HasKeyWordString("SexLabActive"))
			AppUtil.KnockDownAll()
		endif
		
		self.doSexLoop(fact)
	else ; Aggr's OnHit or Not EndlessRape
		AppUtil.Log("EndSexEvent, truely end " + SelfName)
		self._endSexVictim(fact)
		
		AppUtil.CleanFlyingDeadBody(aggr)
		self._cleanDeadBody(Helper1)
		self._cleanDeadBody(Helper2)
		self._cleanDeadBody(Helper3)

		Aggressor.Clear()
		self._clearHelpers()
		
		if (!self._isPlayer() && Config.knockDownAll && PlayerActor.HasKeyWordString("SexLabActive"))
			AppUtil.KnockDownAll()
		endif
		
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

Event OnEnterBleedOut()
	self._searchBleedOutPartner()
EndEvent

Function _searchBleedOutPartner()
	if (self._isPlayer())
		return
	endif
	Actor victim = self.GetActorRef()
	ObjectReference center = victim as ObjectReference
	Utility.Wait(Utility.RandomInt(1, 4))
	
	Actor aggr = self._getBleedOutPartner(0)
	if (aggr)
		; 2nd check
		if (!aggr.HasKeyWordString("SexLabActive") && !aggr.IsInFaction(SSLYACRActiveFaction))
			AppUtil.Log("OnEnterBleedOut, actor found " + SelfName)
			aggr.AddToFaction(SSLYACRActiveFaction)
			aggr.PathToReference(victim, 0.5)
			Utility.Wait(Utility.RandomInt(2, 5))
			self.doSex(aggr, AppUtil.GetEnemyType(aggr))
		else
			AppUtil.Log("OnEnterBleedOut, valid faction actor not found " + SelfName)
			RegisterForSingleUpdate(BleedOutUpdatePeriod)
		endif
	else
		AppUtil.Log("OnEnterBleedOut, valid actor not found " + SelfName)
		RegisterForSingleUpdate(BleedOutUpdatePeriod)
	endif
EndFunction

Actor Function _getBleedOutPartner(int Gender = -1, Keyword kwd = None)
	Actor aggr
	Actor victim = Self.GetActorRef()
	Actor[] npcs = MiscUtil.ScanCellNPCs(victim as ObjectReference, 1000.0)

	int len = npcs.Length
	int idx = 0
	while idx < len
		aggr = npcs[idx]
		if (AppUtil.GetEnemyType(aggr) && \
			!aggr.IsInCombat() && !aggr.HasKeyWordString("SexLabActive") && \
			AppUtil.CheckSex(aggr, Gender) && !aggr.IsInFaction(SSLYACRActiveFaction))
			
			return aggr
		endif
		idx += 1
	endwhile
	
	return None
EndFunction

Event OnCellDetach()
	Actor aggr = Aggressor.GetActorRef()
	
	; EndSexEvent is usually runned by OnCellDetach(), but this is papyrus. 2nd check.
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

Keyword Property ArmorClothing  Auto  
Keyword Property ArmorHeavy  Auto  
Keyword Property ArmorLight  Auto  
Keyword Property ActorTypeNPC  Auto  

String Property HookName  Auto

SPELL Property SSLYACRKillmoveArmorSpell  Auto
SPELL Property SSLYACRPlayerSlowMagic  Auto  

Faction Property CurrentFollowerFaction  Auto  
Faction Property CurrentHireling  Auto  
Faction Property SSLYACRCalmFaction  Auto  
Faction Property SSLYACRActiveFaction  Auto  

Quest Property AudienceQuest  Auto  
