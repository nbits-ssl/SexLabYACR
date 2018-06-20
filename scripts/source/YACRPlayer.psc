Scriptname YACRPlayer extends ReferenceAlias  

Form PreSource = None
string SelfName
bool AlreadyInPrisonerFaction = false
bool EndlessSexLoop = false
bool AlreadyKeyDown = false
float ForceUpdatePeriod = 30.0
float BleedOutUpdatePeriod = 10.0
int StartingHealthForRegist = 0
int StartingArousalForRegist = 0
int PlayerRegistPoint = 0
Faction baseFaction
sslThreadController UpdateController

bool PlayerIsMale = false ; not use from alpha.3
bool IsInCurrentFollowerFaction = false ;  not use from 2.0alpha1 ==> baseFaction
bool IsInCurrentHireling = false ; not use from 2.0alpha1 ==> baseFaction
bool AlreadyInEnemyFaction = false ; not use from 2.0alpha1 ==> dunPrisonerFaction

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	Actor akAggr = akAggressor as Actor
	Actor selfact = self.GetActorRef()
	SelfName = selfact.GetActorBase().GetName()
	Weapon wpn = akSource as Weapon
	
	if (akAggressor == None || akProjectile || PreSource ==  akSource || !wpn || \
		selfact.IsGhost() || selfact.IsDead() || akAggr.IsPlayerTeammate() || akAggr == PlayerActor || \
		selfact.IsInKillMove() || akAggr.IsInKillMove() || (self.IsPlayer && !Config.enablePlayerRape))
	
		AppUtil.Log("not if " + SelfName)
		return
	elseif (selfact.GetAV("Health") <= 0)
		AppUtil.Log("not if, player is dying or follower on bleedoutstart " + SelfName)
		return
	endif

	GotoState("Busy")
	
	PreSource = akSource
	float healthper = selfact.GetAVPercentage("health") * 100
	
	if (!abHitBlocked && wpn.GetWeaponType() < 7) ; exclude Bow/Staff/Crossbow
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
				if (healthper < Config.GetHealthLimit(self.IsPlayer) && \
					rndintRP < Config.GetRapeChanceNotNaked(self.IsPlayer))
					
					AppUtil.Log("doSex " + SelfName)
					self.doSex(akAggr, aggrFaction)
				elseif (Config.GetEnableArmorBreak(self.IsPlayer))
					int[] chances = Config.GetBreakChances(self.IsPlayer)
					if ((selfarmor.HasKeyWord(ArmorClothing) && rndintAB < chances[0]) || \
						(selfarmor.HasKeyWord(ArmorLight) && rndintAB < chances[1]) || \
						(selfarmor.HasKeyWord(ArmorHeavy) && rndintAB < chances[2]))
						
						if (Config.GetEnableArmorUnequipMode(self.IsPlayer))
							selfact.UnEquipItem(selfarmor)
						else
							selfact.RemoveItem(selfarmor)
						endif
						AppUtil.Log(" Armor break " + SelfName)
					endif
				endif
			elseif (!selfarmor && healthper < Config.GetHealthLimit(self.IsPlayer) && \
				rndintRP < Config.GetRapeChance(self.IsPlayer))
				
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

Function _readySexVictim()
	Actor act = self.GetActorRef()
	Faction fact = dunPrisonerFaction
	act.AddSpell(SSLYACRKillmoveArmorSpell, false) ; silently
	act.SetGhost(true)
	AlreadyInPrisonerFaction = false
	self._disableControls()
	
	if (act.IsInFaction(fact))
		AlreadyInEnemyFaction = true
	elseif (!self.IsPlayer)
		act.AddToFaction(fact)
	endif
	
	if (self.IsPlayer)
		act.AddToFaction(SSLYACRCalmFaction)
		act.AddSpell(SSLYACRPlayerSlowMagic, false)
		if (Config.knockDownAll)
			act.AddToFaction(fact)
			AppUtil.KnockDownAll()
			AppUtil.BanishAllDaedra()
		endif
		RegisterForKey(Config.keyCodeRegist)
		RegisterForKey(Config.keyCodeHelp)
		RegisterForKey(Config.keyCodeSubmit)
		AlreadyKeyDown = false
	else
		act.AddToFaction(SSLYACRPurgedFollowerFaction)
		baseFaction = AppUtil.purgeFollower(act)
	endif
	
	act.StopCombat()
	act.StopCombatAlarm()
EndFunction

Function _endSexVictim()
	Actor act = self.GetActorRef()
	
	if (!AlreadyInPrisonerFaction)
		act.RemoveFromFaction(dunPrisonerFaction)
	endif
	
	if (self.IsPlayer)
		act.RemoveFromFaction(SSLYACRCalmFaction)
		act.RemoveSpell(SSLYACRPlayerSlowMagic)
		if (Config.knockDownAll)
			AppUtil.WakeUpAll()
		endif
		Game.EnablePlayerControls()
		UnregisterForKey(Config.keyCodeRegist)
		UnregisterForKey(Config.keyCodeHelp)
		UnregisterForKey(Config.keyCodeSubmit)
	else
		AppUtil.rejoinFollower(act, baseFaction)
		act.RemoveFromFaction(SSLYACRPurgedFollowerFaction)
	endif
	
	self._clearAudience()
	act.RemoveSpell(SSLYACRKillmoveArmorSpell)
	act.SetGhost(false)
EndFunction

Function _disableControls()
	if (self.IsPlayer)
		Game.ForceThirdPerson()
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
		return
	elseif (Aggressor.GetActorRef() || aggr.IsDead())
		AppUtil.Log("already filled ref or dead actor, pass doSex " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
		return
	elseif (victim.IsInFaction(SSLAnimatingFaction)) ; second check
		AppUtil.Log("victim already animating, pass doSex " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
		return
	elseif (aggr.HasKeyWord(ActorTypeNPC) && !AppUtil.ValidateSex(victim, aggr, Config.GetMatchedSex(self.IsPlayer)))
		AppUtil.Log("invalid actor's sex, pass doSex " + SelfName)
		return
	elseif (!aggr.HasKeyWord(ActorTypeNPC) && SexLab.ValidateActor(aggr) < -16) ; not support(or none anime) creature
		AppUtil.Log("aggr creature not supported or no valid animation, pass doSex " + SelfName)
		return
	endif
	
	if (Aggressor.ForceRefIfEmpty(aggr))
		if (self.IsPlayer)
			debug.SendAnimationEvent(victim, "BleedOutStart")
			self._storePlayerRegist(victim)
		endif
		
		self._readySexVictim()
		
		sslBaseAnimation[] anims = self._buildAnimation(aggr)
		actor[] sexActors = new actor[2]
		sexActors[0] = victim
		sexActors[1] = aggr
		
		AppUtil.Log("run SexLab " + SelfName)
		int tid = self._quickSex(sexActors, anims, victim = victim)
		sslThreadController controller = SexLab.GetController(tid)
		
		if (controller)
			; wait for sync, max 12 sec.
			self._waitSetup(controller)
			self._waitSetup(controller)
			self._waitSetup(controller)
			self._waitSetup(controller)
			
			if (self.IsPlayer)
				self._stopCombatOneMore(aggr, victim)
			endif
			; self._stopCombatOneMore(aggr, victim)
			Utility.Wait(1.0)
			; self._endSexAggr(aggr)
			aggr.SetGhost(false) ; _endSexAggr()
			AppUtil.Log("aggr setghost disable " + SelfName)
		else
			AppUtil.Log("###FIXME### controller not found, recover setup " + SelfName)
			self.EndSexEvent(aggr)
		endif
	else
		AppUtil.Log("already filled aggr reference, pass doSex " + SelfName)
	endif
EndFunction

Function _storePlayerRegist(Actor selfact)
	StartingHealthForRegist = (selfact.GetAVPercentage("health") * 100) as int
	StartingArousalForRegist = 100 - AppUtil.GetArousal(selfact)
	PlayerRegistPoint = (StartingArousalForRegist + StartingHealthForRegist) / 2
	AppUtil.Log("PlayerRegistPoint stored : " + PlayerRegistPoint)
	AppUtil.Log("                  Health : " + StartingHealthForRegist)
	AppUtil.Log("                  Arousal: " + StartingArousalForRegist)
EndFunction

Function doSexLoop(Faction fact)
	self._disableControls()
	Actor aggr = Aggressor.GetActorRef()
	Actor victim = self.GetActorRef()
	
	Actor[] actors = AppUtil.GetHelpersCombined(victim, aggr, fact)
	self._forceRefHelpers(actors)
	int helpersCount = actors.Length - 2
	
	AppUtil.Log("LOOPING run SexLab aggr " + aggr + ", helpers count " + helpersCount)
	
	sslBaseAnimation[] anims = self._buildAnimation(aggr, helpersCount)
	
	AppUtil.Log("LOOPING run SexLab " + SelfName)
	int tid = self._quickSex(actors, anims, victim = victim, CenterOn = aggr)
	sslThreadController controller = SexLab.GetController(tid)
	
	if (controller)
		; wait for sync, max 12 sec.
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		
		self._stopCombatOneMore(aggr, victim)
		Utility.Wait(1.0)
		
		int idx = actors.Length
		while idx != 1 ; actors[0] is victim
			idx -= 1
			actors[idx].SetGhost(false)
		endwhile
			
		AppUtil.Log("LOOPING aggr setghost disable " + SelfName)
	else
		AppUtil.Log("LOOPING ###FIXME### controller not found, recover setup " + SelfName)
		AppUtil.Notif("Missing Anim: " + SelfName + " " + self._debugBuildAnimationTags(aggr, helpersCount))
		self.EndSexEvent(aggr)
	endif
EndFunction

int Function _forceRefHelpers(Actor[] sppt)
	self._clearHelpers()
	int len = AppUtil.ArrayCount(sppt)
	
	if (len == 5)
		Helper1.ForceRefTo(sppt[2])
		Helper2.ForceRefTo(sppt[3])
		Helper3.ForceRefTo(sppt[4])
	elseif (len == 4)
		Helper1.ForceRefTo(sppt[2])
		Helper2.ForceRefTo(sppt[3])
	elseif (len == 3)
		Helper1.ForceRefTo(sppt[2])
	endif
	
	return len
EndFunction

sslBaseAnimation[] Function _buildAnimation(Actor male, int count = 0)
	sslBaseAnimation[] anims
	
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
	elseif (count == 0)
		if (male.HasKeyWord(ActorTypeNPC))
			anims = SexLab.GetAnimationsByTags(2, "MF,Aggressive", "Oral", true)
		else
			anims = SexLab.GetAnimationsByTags(2, "FC", "Oral", true)
		endif
	endif
	
	return anims
EndFunction

string Function _debugBuildAnimationTags(Actor male, int count = 0)
	if (count == 3)
		if (male.HasKeyWord(ActorTypeNPC))
			return "MMMMF"
		else
			return "FCCCC"
		endif
	elseif (count == 2)
		if (male.HasKeyWord(ActorTypeNPC))
			return "MMMF"
		else
			return "FCCC"
		endif
	elseif (count == 1)
		if (male.HasKeyWord(ActorTypeNPC))
			return "MMF,Aggressive"
		else
			return "FCC"
		endif
	elseif (count == 0)
		if (male.HasKeyWord(ActorTypeNPC))
			return "MF,Aggressive - Oral"
		else
			return "FC - Oral"
		endif
	endif
	
	return "invalid count"
EndFunction

; code from SexLab's StartSex with disable beduse, disable leadin, and YACR Hook
int function _quickSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = None, Actor CenterOn = None)
	sslThreadModel Thread = SexLab.NewThread()
	if !Thread
		return -1
	elseIf !Thread.AddActors(Positions, Victim)
		return -1
	endif
	Thread.SetAnimations(Anims)
	Thread.DisableBedUse(true)
	Thread.DisableLeadIn()
	Thread.CenterOnObject(CenterOn)
	
	Thread.SetHook("YACR" + HookName)
	RegisterForModEvent("HookStageStart_YACR" + HookName, "StageStartEventYACR")
	RegisterForModEvent("HookAnimationEnd_YACR" + HookName, "EndSexEventYACR")
	
	if Thread.StartThread()
		return Thread.tid
	endif
	return -1
EndFunction

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
	AppUtil.Log("StageStartEvent: " + SelfName)
	UnregisterForUpdate()
	self._getAudience()
	UpdateController = SexLab.GetController(tid)
	sslThreadController controller = UpdateController
	int stagecnt = controller.Animation.StageCount
	int cumid = controller.Animation.GetCum(0)

	Actor selfact = self.GetActorRef()
	Actor aggr = controller.Positions[1]
	
	; for Onhit missing de-ghost
	if (controller.Stage > 1 && aggr.IsGhost())
		aggr.SetGhost(false)
		AppUtil.Log("###FIXME### Onhit missing de-ghost " + SelfName)
	endif
	if (self.IsPlayer)
		AlreadyKeyDown = false
		if (Config.knockDownAll)
			AppUtil.KnockDownAll()
		endif
	endif
	
	if (controller.Stage == stagecnt && Config.GetEnableEndlessRape(self.IsPlayer))
		AppUtil.Log("endless sex loop... " + SelfName)
		int rndint = Utility.RandomInt()
		Faction fact = AppUtil.GetEnemyType(aggr)
		
		selfact.SetGhost(false)
		SexLab.ActorLib.ApplyCum(selfact, cumid)
		selfact.SetGhost(true)

		controller.UnregisterForUpdate()
		float laststagewait = SexLab.Config.StageTimerAggr[4]
		if (laststagewait > 1)
			Utility.Wait(laststagewait - 2.0) 
		endif
		
		if (rndint < 5) ; 20%
			AppUtil.Log("endless sex loop...one more " + SelfName)
			controller.AdvanceStage(true) ; has self controller.onUpdate
		elseif (rndint < 10) ; 25%
			AppUtil.Log("endless sex loop...one more from 2nd " + SelfName)
			controller.GoToStage(stagecnt - 2) ; has self controller.onUpdate
			RegisterForSingleUpdate(ForceUpdatePeriod)
		else
			Actor[] actors = AppUtil.GetHelpersCombined(selfact, aggr, fact)
			AppUtil.Log("endless sex loop... actors are " + actors)
			if (rndint < 90 && fact && (AppUtil.ArrayCount(actors) - 2) > 0) ; 30%
				AppUtil.Log("endless sex loop...change to Multiplay " + SelfName)
				EndlessSexLoop = true
				controller.RegisterForSingleUpdate(0.2)
			else ; 25%
				AppUtil.Log("endless sex loop...change anim " + SelfName)
				controller.ChangeAnimation() ; has self controller.onUpdate
				RegisterForSingleUpdate(ForceUpdatePeriod)
			endif
		endif
		; thank you obachan
		; GetHelpersCombined() is heavy, when test with 40 npcs sometimes 1.5sec is too short time.
	endif
EndEvent

Event OnKeyDown(int keyCode)
	Actor selfact = self.GetActorRef()
	if (!self.IsPlayer || Utility.IsInMenuMode())
		return
	elseif !(selfact.HasKeyWordString("SexLabActive"))
		AppUtil.Log("not in anim")
		return
	elseif (AlreadyKeyDown)
		AppUtil.Log("Already key down, wait for next stage")
		return
	endif
	
	if (keyCode == Config.keyCodeRegist)
		AppUtil.Log("OnkeyDown: Regist")
		AlreadyKeyDown = true
		debug.Notification(SelfName + " is registing...")
		Actor aggr = Aggressor.GetActorRef()
		Utility.Wait(2.0)
		if (aggr && Utility.RandomInt() < PlayerRegistPoint)
			self._escapePlayer(aggr)
		else
			debug.Notification(SelfName + " could not escape...")
		endif
	elseif (keyCode == Config.keyCodeHelp)
		AppUtil.Log("OnkeyDown: CallHelp")
		AlreadyKeyDown = true
		debug.Notification(SelfName + " is calling help...")
		Actor aggr = Aggressor.GetActorRef()
		if (aggr)
			Actor helper = AppUtil.CallHelp(aggr)
			if (helper)
				AppUtil.Log("CallHelp, helper is " + helper.GetActorBase().GetName())
				Utility.Wait(0.5)
				self._escapePlayer(aggr)
			else
				Utility.Wait(2.0)
				debug.Notification("Nobody helps you...")
			endif
		endif
	elseif (keyCode == Config.keyCodeSubmit)
		AppUtil.Log("OnkeyDown: Submit")
		AlreadyKeyDown = true
		debug.Notification(SelfName + " gave up on everything...")
		Utility.Wait(3.0)
		self._submitPlayer()
	endif
EndEvent

Function _escapePlayer(Actor aggr)
	Actor selfact = PlayerActor
	if (self._stopPlayerRape(selfact))
		selfact.PushActorAway(aggr, 5.0)
		;debug.sendAnimationEvent(selfact, "IdleStaggerBack")
	endif
EndFunction

Function _submitPlayer()
	Actor selfact = self.GetActorRef()
	if (self._stopPlayerRape(selfact))
		if (Config.enableSimpleSlaverySupport && \
			Utility.RandomInt() <= Config.simpleSlaveryChance)
			
			selfact.UnequipAll()
			sendModEvent("SSLV Entry")
		else
			Utility.Wait(1.25)
			selfact.Kill()
		endif
	endif
EndFunction

bool Function _stopPlayerRape(Actor selfact)
	bool ret

	if (selfact)
		if selfact.HasKeyWordString("SexLabActive")
			AppUtil.Log("Player escaped, Stop rape")
			sslThreadController controller = SexLab.GetActorController(selfact)
			controller.EndAnimation()
			ret = true
		endif
	endif
	
	return ret
EndFunction

; from rapespell, genius!
Event OnUpdate()
	if (UpdateController && UpdateController.GetState() == "animating")
		AppUtil.Log("OnUpdate, UpdateController is alive " + SelfName)
		UpdateController.OnUpdate()
		RegisterForSingleUpdate(ForceUpdatePeriod)
	endif
	
	if (self.GetActorRef().IsBleedingOut())
		self._searchBleedOutPartner()
	endif
EndEvent

Event OnPackageChange(Package oldpkg) ; for missing _endSexVictim() when EndSexEvent
	Actor victim
	Actor aggr = Aggressor.GetActorRef()
	if (aggr)
		Utility.Wait(2.0)
	endif
	if (!Aggressor.GetActorRef() && !self.IsPlayer)
		victim = self.GetActorRef()
		if (!victim.IsPlayerTeammate() && victim.IsInFaction(SSLYACRPurgedFollowerFaction))
			AppUtil.Log("######### OnPackageChange, detect non-teammate follower, recovery " + SelfName)
			self._endSexVictim()
			victim.StopCombat()
			victim.EnableAI(false)
			victim.EnableAI()
		endif
	endif
EndEvent

Function _getAudience()
	AppUtil.Log("get audience " + SelfName)
	if (AudienceQuest.IsRunning())
		AudienceQuest.Stop()
	endif
	AudienceQuest.Start()
	if (self.IsPlayer)
		Actor aggr = Aggressor.GetActorRef()
		Actor victim = self.GetActorRef()
		self._stopCombatOneMore(aggr, victim)
	endif
EndFunction

Function _clearAudience()
	AppUtil.Log("clear audience " + SelfName)
	if (AudienceQuest.IsRunning())
		AudienceQuest.Stop()
	endif
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

; aggrのほうにonhitプロパティをつけて、Endlesssex判定を失くす・escapeはどうする？
; knockdownallをやめて、ここでは個別にノックダウンさせる

Function EndSexEvent(Actor aggr)
	Faction fact = AppUtil.GetEnemyType(aggr)
	
	if (EndlessSexLoop)
		AppUtil.Log("EndSexEvent, Goto to loop " + SelfName)
		EndlessSexLoop = false
		self._clearHelpers()
		
		if (!self.IsPlayer && Config.knockDownAll && PlayerActor.HasKeyWordString("SexLabActive"))
			AppUtil.KnockDownAll()
		endif
		
		self.doSexLoop(fact)
	else ; Aggr's OnHit or Not EndlessRape
		AppUtil.Log("EndSexEvent, truely end " + SelfName)
		self._endSexVictim()
		
		AppUtil.CleanFlyingDeadBody(aggr)
		self._cleanDeadBody(Helper1)
		self._cleanDeadBody(Helper2)
		self._cleanDeadBody(Helper3)

		Aggressor.Clear()
		self._clearHelpers()
		
		if (!self.IsPlayer && Config.knockDownAll && PlayerActor.HasKeyWordString("SexLabActive"))
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
	Actor victim = self.GetActorRef()
	
	if (aeCombatState == 0 && !victim.HasKeyWordString("SexLabActive"))
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
	if (self.IsPlayer)
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
	; EndSexEvent is usually runned by OnCellDetach(), but this is papyrus. 2nd check.
	self._endSexVictim()
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

Bool Property IsPlayer  Auto  
String Property HookName  Auto

SPELL Property SSLYACRKillmoveArmorSpell  Auto
SPELL Property SSLYACRPlayerSlowMagic  Auto  

Faction Property CurrentFollowerFaction  Auto  ; not use from 2.0alpha1
Faction Property CurrentHireling  Auto  ; not use from 2.0alpha1
Faction Property SSLYACRCalmFaction  Auto  
Faction Property SSLYACRActiveFaction  Auto  
Faction Property SSLYACRPurgedFollowerFaction  Auto  

Quest Property AudienceQuest  Auto  
Faction Property dunPrisonerFaction  Auto  ; not use from 2.0alpha1
Faction Property dunPrisonerExtendedFaction  Auto  
