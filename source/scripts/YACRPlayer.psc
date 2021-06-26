Scriptname YACRPlayer extends ReferenceAlias  

Form PreSource = None
string SelfName
bool AlreadyInPrisonerFaction = false ; not use
bool EndlessSexLoop = false
bool AlreadyKeyDown = false
float ForceUpdatePeriod = 30.0
float PCBleedOutUpdatePeriod = 5.0
float BleedOutUpdatePeriod = 10.0
int StartingHealthForRegist = 0
int StartingArousalForRegist = 0
int PlayerRegistPoint = 0
Faction baseFaction
sslThreadController UpdateController

int EABDBaseStatus = 0
int EABDSeeTroughStatus = 0
int EABDInTop = 0
int EABDInBot = 0

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	Actor akAggr = akAggressor as Actor
	Actor selfact = self.GetActorRef()
	Weapon wpn = akSource as Weapon
	Explosion exp = akSource as Explosion
	Spell spl = akSource as Spell
	
	SelfName = selfact.GetLeveledActorBase().GetName()
	
	if (akAggressor == None || PreSource ==  akSource || selfact.IsGhost() || selfact.IsDead() || \
		akAggr.IsPlayerTeammate() || akAggr == PlayerActor || selfact.IsInKillMove() || akAggr.IsInKillMove() || \
		akAggr.IsFlying() || akAggr.IsOnMount())
		AppUtil.Log("not if " + SelfName)
		return
	elseif (!selfact.HasKeyWord(ActorTypeNPC))
		AppUtil.Log("not if, non ActorTypeNPC " + SelfName)
		return
	elseif (self.IsPlayer && (!Config.enablePlayerRape || selfact.IsInFaction(SSLYACRDyingFaction)))
		AppUtil.Log("not if, Player " + SelfName)
		return
	elseif (spl && !spl.IsHostile())
		AppUtil.Log("not if, not Hostile spell")
		return
	endif
	
	GotoState("Busy")
	
	PreSource = akSource
	float healthper = selfact.GetAVPercentage("health") * 100
	if (healthper > 100.0)
		healthper = 100.0
	endif
	AppUtil.Log("### healthper " + healthper + " " + SelfName + " abPowerAttack = " + abPowerAttack)
	
	if (!abHitBlocked && self._validateAttack(akAggr, wpn, akProjectile))
		self._onHit(selfact, akAggr, healthper, abPowerAttack)
	endif
	
	Utility.Wait(1)
	PreSource = None
	GotoState("")
EndEvent

bool Function _validateAttack(Actor aggr, Weapon wpn, Projectile akProjectile)
	Actor selfact = self.GetActorRef()
	float distanceLimit = Config.GetAttackDistanceLimit(self.IsPlayer)
	
	int weapontype
	if (wpn)
		weapontype = wpn.GetWeaponType()
	endif

	if (akProjectile || (wpn && weapontype > 6)) ; staff or magic or bow or crossbow
		if (selfact.GetDistance(aggr) > distanceLimit)
			return false
		endif
	elseif (wpn && wpn == Unarmed) ; fist or creature's attack or mystery unarmed spell (explode)
		if (distanceLimit < 225)
			distanceLimit = 225
		endif
		
		if (aggr.HasKeyWord(ActorTypeNPC) && selfact.GetDistance(aggr) > distanceLimit)
			AppUtil.Log("not if, unarmed spell (explode) " + SelfName + " (" + selfact.GetDistance(aggr) + ")")
			return false
		endif
	endif
	
	return true
EndFunction

Function _onHit(Actor selfact, Actor akAggr, float healthper, bool abPowerAttack)
	AppUtil.Log("onhit success " + SelfName)

	if (self.IsPlayer)
		LastAggr = akAggr ; for WeCantDie
	endif
	
	int rndintRP = Utility.RandomInt()
	int rndintAB = Utility.RandomInt()
	
	Armor selfarmor = selfact.GetWornForm(0x00000004) as Armor
	bool isNaked = !selfarmor as bool

	if (Config.EnableEABD && self.IsPlayer)
		EABDBaseStatus = StorageUtil.GetIntValue(none, "EABDNakedStatus", 0)
		EABDSeeTroughStatus = StorageUtil.GetIntValue(none, "EABDstStatus", 0)
		EABDInTop = StorageUtil.GetIntValue(none, "EABDInnerStatusTop", 0)
		EABDInBot = StorageUtil.GetIntValue(none, "EABDInnerStatusBot", 0)
		if (EABDBaseStatus != 0) || (EABDSeeTroughStatus != 0) || (EABDInTop != 0) || (EABDInBot != 0)
			isNaked = true
		endif
	endif
	
	if (selfact.IsInFaction(SSLAnimatingFaction))   ; first check
		if selfact.HasKeyWordString("SexLabActive")  ; other sexlab's sex
			AppUtil.Log("detect other SexLab's Sex, EndAnimation " + SelfName)
			sslThreadController controller = SexLab.GetActorController(selfact)
			controller.EndAnimation()
		else  ; not animating, this is yacr's bug
			AppUtil.Log("detect invalid SSLAnimatingFaction, delete " + SelfName)
			selfact.RemoveFromFaction(SSLAnimatingFaction)
			; ##FIXME## Instead ActorLib.ValidateActor ?
		endif
	elseif !(isNaked)
		if (self._shouldBleedOut(healthper, rndintRP, false, abPowerAttack))
			AppUtil.Log("doBleedOut " + SelfName)
			self.doBleedOut(akAggr)
		elseif (self._shouldArmorBreak(selfarmor, rndintAB, abPowerAttack))
			AppUtil.Log(" Armor break " + SelfName)
			if (Config.GetEnableArmorUnequipMode(self.IsPlayer))
				selfact.UnEquipItem(selfarmor)
			else
				selfact.RemoveItem(selfarmor)
			endif
		endif
	elseif (isNaked && self._shouldBleedOut(healthper, rndintRP, true, abPowerAttack))
		AppUtil.Log("doBleedOut " + SelfName)
		self.doBleedOut(akAggr)
	endif
EndFunction

bool Function _shouldArmorBreak(Armor selfarmor, int rndint, bool abPowerAttack)
	if (Config.GetEnableArmorBreak(self.IsPlayer))
		int[] chances = Config.GetBreakChances(self.IsPlayer, abPowerAttack)
		
		return ((selfarmor.HasKeyWord(ArmorClothing) && rndint < chances[0]) || \
			(selfarmor.HasKeyWord(ArmorLight) && rndint < chances[1]) || \
			(selfarmor.HasKeyWord(ArmorHeavy) && rndint < chances[2]))
	else
		return false
	endif
EndFunction

bool Function _shouldBleedOut(float healthper, int rndint, bool naked, bool abPowerAttack)
	int rapechance
	if (naked)
		rapechance = Config.GetRapeChance(self.IsPlayer, abPowerAttack)
	else
		rapechance = Config.GetRapeChanceNotNaked(self.IsPlayer, abPowerAttack)
	endif

	if (naked)
		if (self.IsPlayer && Config.EnableEABD)
			if (EABDBaseStatus == 3)
				rapechance = Config.GetRapeChance(self.IsPlayer, abPowerAttack)
			elseif (EABDBaseStatus == 1 || EABDBaseStatus == 2)
				rapechance = Config.GetRapeChanceTBless(abPowerAttack)
			elseif (EABDSeeTroughStatus != 0)
				rapechance = Config.GetRapeChanceSeeThrough(abPowerAttack)
			elseif (EABDInTop != 0) || (EABDInBot != 0)
				rapechance = Config.GetRapeChanceUnderwear(abPowerAttack)
			endif
		else
			rapechance = Config.GetRapeChance(self.IsPlayer, abPowerAttack)
		endif
	else
		rapechance = Config.GetRapeChanceNotNaked(self.IsPlayer, abPowerAttack)
	endif


	return (healthper <= Config.GetHealthLimit(self.IsPlayer) && \
		healthper > Config.GetHealthLimitBottom(self.IsPlayer) && \
		rndint < rapechance)
EndFunction

State Busy
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		AppUtil.Log("busy " + SelfName)
		; do nothing
	EndEvent
EndState


Function _readySexVictim()
	Actor act = self.GetActorRef()
	
	if (Config.enableUtilOneSupport)
		; is in StageStartEvent
	else
		act.SetGhost(true)
	endif
	
	if (!self.IsPlayer || Config.knockDownAll)
		VictimAlias.ForceRefTo(act)
	endif
	
	if (self.IsPlayer)
		if (Config.knockDownAll)
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
	
	if (self.IsPlayer)
		if (Config.knockDownAll)
			AppUtil.WakeUpAll()
		endif
		UnregisterForKey(Config.keyCodeRegist)
		UnregisterForKey(Config.keyCodeHelp)
		UnregisterForKey(Config.keyCodeSubmit)
	elseif (act.IsInFaction(SSLYACRPurgedFollowerFaction))
		AppUtil.rejoinFollower(act, baseFaction)
		act.RemoveFromFaction(SSLYACRPurgedFollowerFaction)
	endif
	
	self._clearAudience()
	VictimAlias.Clear()
	act.SetGhost(false)
	
	RegisterForSingleUpdate(0.5) ; for Unregist ForceUpdateController
EndFunction

Function _stopCombatOneMore(Actor aggr, Actor victim)
	aggr.StopCombat()
	aggr.StopCombatAlarm()
	victim.StopCombat()
	victim.StopCombatAlarm()
EndFunction

; _readySexAggr / _endSexAggr to StopCombatEffect.psc


; for we can't die

bool Function ValidateDeathSex()
	bool _isPlayer = self.IsPlayer
	if (!_isPlayer)
		return false ;  fool proof
	elseif !(Config.enableWeCantDieSupport && Utility.RandomInt() <= Config.weCantDieChance)
		return false
	endif
	
	Actor selfact = self.GetActorRef()
	if (!LastAggr || LastAggr.GetDistance(selfact) > Config.GetAttackDistanceLimit(_isPlayer) + 500 || \
		(_isPlayer && (!Config.enablePlayerRape || selfact.IsInFaction(SSLYACRDyingFaction))) || \
		selfact.IsGhost() || selfact.IsDead() || selfact.IsInKillMove() || LastAggr.IsInKillMove() || \
		!selfact.HasKeyWord(ActorTypeNPC) || LastAggr.IsPlayerTeammate() || !self._isValidActors(selfact, LastAggr))
		
		return false
	endif
	
	return true
EndFunction

bool Function _isInWeCantDie()
	if (!self.IsPlayer)
		return false
	elseif (!self.GetActorRef().IsInFaction(SSLYACRDyingFaction))
		return false
	endif
	
	return true
EndFunction

Function deathBleedOut()
	Actor victim = self.GetActorRef()
	
	if (Aggressor.ForceRefIfEmpty(LastAggr))
		debug.SendAnimationEvent(victim, "BleedOutStart")
		Game.ForceThirdPerson()
		
		victim.ResetHealthAndLimbs() ; cause runtime error?
		self._readySexVictim()
		
		victim.AddToFaction(SSLYACRDyingFaction)
		if (Config.knockDownOnly)
			self.doPCKnockDown(LastAggr)
		else
			self.doSex(LastAggr)
		endif
	else
		AppUtil.Log("### deathBleedOut(), already filled aggr reference, pass")
	endif
EndFunction

; / for we can't die


Function doBleedOut(Actor aggr)
	Actor victim = self.GetActorRef()
	
 	if (!self._isValidActors(victim, aggr))
		return
	endif
	
	if (Aggressor.ForceRefIfEmpty(aggr))
		if (self.IsPlayer)
			debug.SendAnimationEvent(victim, "BleedOutStart")
			Game.ForceThirdPerson()
			self._storePlayerRegist(victim)
		endif
		
		self._readySexVictim()
		
		if (self.IsPlayer && Config.knockDownOnly)
			self.doPCKnockDown(aggr)
		else
			self.doSex(aggr)
		endif
	else
		AppUtil.Log("already filled aggr reference, pass doBleedOut " + SelfName)
	endif
EndFunction

Function doPCKnockDown(Actor aggr)
	Game.DisablePlayerControls()
	Actor victim = PlayerActor

	self._stopCombatOneMore(aggr, victim)
	if (victim.IsWeaponDrawn())
		victim.SheatheWeapon()
	endif
	Utility.Wait(1.0)
	aggr.SetGhost(false) ; _endSexAggr()
	Aggressor.Clear()
	AppUtil.Log("aggr setghost disable & clear alias " + SelfName)
	RegisterForSingleUpdate(PCBleedOutUpdatePeriod)
EndFunction

Function doSex(Actor aggr)
	Actor victim = self.GetActorRef()
	
	actor[] sexActors = new actor[2]
	sexActors[0] = victim
	sexActors[1] = aggr
	sslBaseAnimation[] anims = AppUtil.BuildAnimation(sexActors)
	
	AppUtil.Log("run SexLab " + SelfName)
	int tid = self._quickSex(sexActors, anims, victim = victim)
	sslThreadController controller = SexLab.GetController(tid)
	AppUtil.Log("run SexLab [" + tid + "] " + SelfName)
	
	if (controller)
		; wait for sync, max 12 sec.
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		
		if (self.IsPlayer)
			self._stopCombatOneMore(aggr, victim)
		endif
		Utility.Wait(1.0)
		aggr.SetGhost(false) ; _endSexAggr()
		AppUtil.Log("aggr setghost disable " + SelfName)
	else
		AppUtil.Log("###FIXME### controller not found, recover setup " + SelfName)
		self.EndSexEvent(aggr)
	endif
EndFunction

bool Function _isValidActors(Actor victim, Actor aggr)
	if (victim.IsGhost() || aggr.IsGhost())
		AppUtil.Log("ghosted Actor found, pass doBleedOut " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
		return false
	elseif (Aggressor.GetActorRef() || aggr.IsDead() || !aggr.Is3DLoaded() || aggr.IsDisabled())
		AppUtil.Log("already filled ref, dead actor, or not loaded, pass doBleedOut " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
		return false
	elseif (victim.IsInFaction(SSLAnimatingFaction)) ; second check
		AppUtil.Log("victim already animating, pass doBleedOut " + SelfName)
		aggr.RemoveFromFaction(SSLYACRActiveFaction) ; from OnEnterBleedOut
		return false
	elseif (!AppUtil.ValidateAggr(victim, aggr, Config.GetMatchedSex(self.IsPlayer)))
		return false
	endif
	
	return true
EndFunction

Function _storePlayerRegist(Actor selfact)
	StartingHealthForRegist = (selfact.GetAVPercentage("health") * 100) as int
	StartingArousalForRegist = 100 - AppUtil.GetArousal(selfact)
	PlayerRegistPoint = (StartingArousalForRegist + StartingHealthForRegist) / 2
	AppUtil.Log("PlayerRegistPoint stored : " + PlayerRegistPoint)
	AppUtil.Log("                  Health : " + StartingHealthForRegist)
	AppUtil.Log("                  Arousal: " + StartingArousalForRegist)
EndFunction

Function doSexLoop()
	Actor[] actors
	Actor aggr = Aggressor.GetActorRef()
	Actor victim = self.GetActorRef()
	
	actors = AppUtil.GetHelpersCombined(victim, aggr)
	
	int helpersCount = actors.Length - 2
	if (helpersCount > 0)
		self._forceRefHelpers(actors)
		
		AppUtil.Log("LOOPING run SexLab aggr " + aggr + ", helpers count " + helpersCount)
		AppUtil.Log("LOOPING actors: " + actors)
	else
		actors = new Actor[2]
		actors[0] = victim
		actors[1] = aggr
		
		AppUtil.Log("LOOPING run SexLab aggr " + aggr + ", none helpers (can't get lock)")
	endif
	
	sslBaseAnimation[] anims = AppUtil.BuildAnimation(actors)
	int tid = self._quickSex(actors, anims, victim = victim, CenterOn = aggr)
	sslThreadController controller = SexLab.GetController(tid)
	
	AppUtil.Log("LOOPING run SexLab [" + tid + "] " + SelfName)
	
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

; code from SexLab's StartSex with disable beduse, disable leadin, SortActors for fm, and YACR Hook
int function _quickSex(Actor[] Positions, sslBaseAnimation[] Anims, Actor Victim = None, Actor CenterOn = None)
	sslThreadModel Thread = SexLab.NewThread()
	if !Thread
		return -1
	elseIf !Thread.AddActors(SexLab.SortActors(Positions), Victim)
		return -1
	endif
	Thread.SetAnimations(Anims)
	Thread.DisableBedUse(true)
	Thread.DisableLeadIn()
	Thread.DisableRagdollEnd()
	Thread.CenterOnObject(CenterOn)
	
	Thread.SetHook("YACR" + HookName)
	RegisterForModEvent("HookStageStart_YACR" + HookName, "StageStartEventYACR")
	RegisterForModEvent("HookAnimationEnd_YACR" + HookName, "EndSexEventYACR")
	RegisterForModEvent("HookOrgasmStart_YACR" + HookName, "LastStageStartEventYACR")
	
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
	Actor selfact = self.GetActorRef()
	Actor aggr = Aggressor.GetActorRef()
	
	UnregisterForUpdate()
	UpdateController = SexLab.GetController(tid)
	sslThreadController controller = UpdateController
	int stagecnt = controller.Animation.StageCount
	int currentstage = controller.Stage
	AppUtil.Log("StageStartEvent: " + SelfName + ", " + currentstage + "/" + stagecnt)
	
	self._reEnableHotkeysForKeyControlConfigUser(controller)
	; disable by _sexloop(), during _sexloop functions's stage advancing
	
	if (Config.enableDrippingWASupport || Config.enableUtilOneSupport)
		if (currentstage < stagecnt - 1)
			selfact.SetGhost(true)
		endif
	endif
	
	if (!aggr || aggr.GetAV("health") <= 0)
		AppUtil.Log("###FIXME### missing aggr, force end event " + SelfName)
		controller.EndAnimation()
		self.EndSexEvent(aggr)
		return
	endif
	
	; for Onhit missing de-ghost
	if (currentstage > 1 && aggr.IsGhost())
		aggr.SetGhost(false)
		AppUtil.Log("###FIXME### Onhit missing de-ghost " + SelfName)
	endif
	
	if (self.IsPlayer)
		AlreadyKeyDown = false
		if (Config.knockDownAll)
			AppUtil.KnockDownAll()
		endif
	endif
	
	if (currentstage == 1)
		self._getAudience()
	endif
	
	if (currentstage == stagecnt && Config.GetEnableEndlessRape(self.IsPlayer))
		self._getAudience()
		self._sexLoop(selfact, aggr, controller)
	endif
EndEvent

Event LastStageStartEventYACR(int tid, bool HasPlayer)
	AppUtil.Log("LastStageStartEvent: " + SelfName)
	Actor selfact = self.GetActorRef()
	sslThreadController controller = SexLab.GetController(tid)

	selfact.SetGhost(false)
	SexLab.ActorLib.ApplyCum(controller.Positions[0], controller.Animation.GetCum(0))
	
	if (!Config.enableDrippingWASupport && !Config.enableUtilOneSupport)
		selfact.SetGhost(true)
	endif
EndEvent

Function _sexLoop(Actor selfact, Actor aggr, sslThreadController controller)
	AppUtil.Log("endless sex loop for " + SelfName)
	self._disableHotkeysForKeyControlConfigUser(controller)
	; disable advance stage key, during _sexloop functions's stage advancing
	controller.UnregisterForUpdate()
	
	float laststagewait = SexLab.Config.StageTimerAggr[4]
	if (laststagewait > 1)
		Utility.Wait(laststagewait - 1.5) 
	endif
	if !(Aggressor.GetActorRef())
		AppUtil.Log("Aggr already escape because some reason " + SelfName)
		return
	endif
	
	if (Config.enableSendOrgasm)
		controller.SendThreadEvent("OrgasmEnd") ; for Aroused
	endif
	
	int rndint = Utility.RandomInt()
	if (rndint < Config.GetGlobal("OneMore"))
		self._sexLoopOneMore(controller)
	elseif (rndint < Config.GetGlobal("OneMoreFromSecond"))
		self._sexLoopOneMoreFromSecond(controller)
	else
		int origLength = controller.Positions.Length
		
		if (rndint < Config.GetGlobal("MultiPlay"))
			Actor[] actors = AppUtil.GetHelpersCombined(selfact, aggr, fullquery = true)
			AppUtil.Log("endless sex loop...actors are " + actors)
			
			if (AppUtil.ArrayCount(actors) > 2)
				self._sexLoopSendToMultiplay(controller)
			else
				self._sexLoopChangeAnim(controller)
			endif
		else
			self._sexLoopChangeAnim(controller)
		endif
	endif
EndFunction

Function _sexLoopOneMore(sslThreadController controller)
	AppUtil.Log("endless sex loop...one more " + SelfName)
	controller.AdvanceStage(true) ; has self controller.onUpdate
EndFunction

Function _sexLoopOneMoreFromSecond(sslThreadController controller)
	AppUtil.Log("endless sex loop...one more from 2nd " + SelfName)
	int stagecnt = controller.Animation.StageCount
	controller.GoToStage(stagecnt - 2) ; has self controller.onUpdate
	RegisterForSingleUpdate(ForceUpdatePeriod)
EndFunction

Function _sexLoopChangeAnim(sslThreadController controller) ; thank you obachan
	AppUtil.Log("endless sex loop...change anim " + SelfName)
	controller.SetAnimation(-1)
	controller.SendThreadEvent("AnimationChange")
	controller.Stage = 2
	controller.Action("Advancing")
	RegisterForSingleUpdate(ForceUpdatePeriod)
EndFunction

Function _sexLoopSendToMultiplay(sslThreadController controller)
	AppUtil.Log("endless sex loop...change to Multiplay " + SelfName)
	EndlessSexLoop = true
	controller.RegisterForSingleUpdate(0.2) ; finish current sex
EndFunction

Function _disableHotkeysForKeyControlConfigUser(sslThreadController controller)
	if (self.IsPlayer && SexLab.Config.DisablePlayer == false)
		if (SexLab.Config.AutoAdvance == false)
			controller.AutoAdvance = true
		endif
		controller.DisableHotkeys()
		AppUtil.Log("AutoAdvance check, disable hotkeys " + SelfName)
	endif
EndFunction

Function _reEnableHotkeysForKeyControlConfigUser(sslThreadController controller)
	if (self.IsPlayer && SexLab.Config.DisablePlayer == false && Config.GetEnableEndlessRape(self.IsPlayer))
		if (SexLab.Config.AutoAdvance == false)
			controller.AutoAdvance = false
		endif
		controller.EnableHotkeys()
		AppUtil.Log("AutoAdvance check, enable hotkeys " + SelfName)
	endif
EndFunction

bool Function _knockDownOnlyMode()
	return ((PlayerActor.GetAnimationVariableBool("IsBleedingOut") || !Game.IsActivateControlsEnabled()) && Config.knockDownOnly)
EndFunction


Event OnKeyDown(int keyCode)
	Actor selfact = self.GetActorRef()
	Actor aggr = Aggressor.GetActorRef()
	bool knockdownonly = self._knockDownOnlyMode()

	if (!self.IsPlayer || (!aggr && !knockdownonly) || Utility.IsInMenuMode())
		return
	elseif !(selfact.HasKeyWordString("SexLabActive") || knockdownonly)
		AppUtil.Log("not in anim")
		return
	elseif (aggr && aggr.IsGhost())
		AppUtil.Log("aggr is ghost, please wait")
		return
	elseif (AlreadyKeyDown)
		AppUtil.Log("Already key down, wait for next stage")
		return
	endif
	
	if (!self._isInWeCantDie())
		if (keyCode == Config.keyCodeRegist)
			self._pressRegistKey(aggr)
		elseif (keyCode == Config.keyCodeHelp)
			self._pressHelpKey(aggr)
		elseif (keyCode == Config.keyCodeSubmit)
			self._pressSubmitKey(aggr)
		endif
	else
		if (keyCode == Config.keyCodeRegist)
			self._pressDeathRegistKey(aggr)
		endif
	endif
EndEvent

Function _pressRegistKey(Actor aggr)
	AppUtil.Log("OnkeyDown: Regist")
	AlreadyKeyDown = true
	AppUtil.Flavor(Config.GetFlavor("REGISTING"))
	Utility.Wait(2.0)
	int registpt 
	
	if (Config.knockDownOnly)
		registpt = (PlayerActor.GetAVPercentage("health") * 100) as int
	else
		registpt = PlayerRegistPoint
	endif
	
	if (Utility.RandomInt() < registpt)
		self._escapePlayer(aggr)
	else
		AppUtil.Flavor(Config.GetFlavor("REGISTING_FAIL"))
	endif
EndFunction

Function _pressDeathRegistKey(Actor aggr)
	AppUtil.Log("OnkeyDown: Regist(death)")
	AlreadyKeyDown = true
	AppUtil.Flavor(Config.GetFlavor("REGISTING_DEATH"))
	Utility.Wait(1.0)
	
	self._escapePlayer(aggr)
EndFunction

Function _pressHelpKey(Actor aggr)
	AppUtil.Log("OnkeyDown: CallHelp")
	AlreadyKeyDown = true
	AppUtil.Flavor(Config.GetFlavor("CALLHELP"))
	Actor helper = AppUtil.CallHelp(aggr)
	
	if (helper)
		AppUtil.Log("CallHelp, helper is " + helper.GetActorBase().GetName())
		Utility.Wait(0.5)
		self._escapePlayer(aggr)
	else
		Utility.Wait(2.0)
		AppUtil.Flavor(Config.GetFlavor("CALLHELP_FAIL"))
	endif
EndFunction

Function _pressSubmitKey(Actor aggr)
	AppUtil.Log("OnkeyDown: Submit")
	AlreadyKeyDown = true
	AppUtil.Flavor(Config.GetFlavor("GIVEUP"))
	Utility.Wait(3.0)
	
	self._submitPlayer(aggr)
EndFunction


Function _escapePlayer(Actor aggr) ; (almost rewritten by >>96.860)
	Actor selfact = PlayerActor
	
	if (self._knockDownOnlyMode())
		debug.SendAnimationEvent(selfact, "BleedOutStop")
		Game.EnablePlayerControls()
		Utility.Wait(3.0)
		self._endSexVictim()
		
	elseif (self._stopPlayerRape(aggr))
		; Wait 0.8 sec when stop animation. (0.5+ sec for more safety?)
		Utility.Wait(0.8)
		; Check aggr is dead (for SuccubusHeart)
		if(!aggr.IsDead() && !aggr.IsBleedingOut())	; aggr alive!
			float fAngle = selfact.GetAngleZ()
			float fX = selfact.GetPositionX() - Math.Sin(fAngle) * 30
			float fY = selfact.GetPositionY() - Math.Cos(fAngle) * 30
			float fZ = selfact.GetPositionZ()
			if (fAngle < 180)
				fAngle += 180
			else
				fAngle -= 180
			endif
			selfact.SetPosition(fX,fY,fZ) ; set player's position to aggr's back
			aggr.SetAngle(0.0,0.0,fAngle) ; invert aggr's angle, face to face
			Utility.Wait(0.3) ; stand by stand by .....
			if (!self._isInWeCantDie())
				AppUtil.PlayImpactSound(selfact as ObjectReference) ; play impact sound
				selfact.PushActorAway(aggr, 2.5) ; ..... go!
			endif
		endif
		
		self._sexistGuardsDialogueStop()
	endif
EndFunction

Function _sexistGuardsDialogueStop() ; thank you!! >> 106.407
	if (Game.GetModByName("SexistGuards.esp") < 255)
		AppUtil.Log("SexistGuards.esp detected, stop dialogue loop")
		GlobalVariable SGStageTracker = Game.GetFormFromFile(0x00024234, "SexistGuards.esp") as GlobalVariable
		SGStageTracker.SetValue(0)
	endif
EndFunction

Function _submitPlayer(Actor aggr)
	Actor selfact = PlayerActor
	
	if (self._knockDownOnlyMode() || self._stopPlayerRape(aggr))
		if (Config.enableSimpleSlaverySupport && \
			Utility.RandomInt() <= Config.simpleSlaveryChance)
			
			selfact.UnequipAll()
			sendModEvent("SSLV Entry")
		else
			Utility.Wait(1.25)
			LastAggr = none ; for wcd
			float health = selfact.GetAV("health")
			selfact.DamageAV("health", health + 30.0)
			; selfact.Kill() ; not action in wcd
		endif
	endif
EndFunction

bool Function _stopPlayerRape(Actor aggr)
	Actor selfact = PlayerActor
	
	if selfact.HasKeyWordString("SexLabActive")
		AppUtil.Log("Player escaped, Stop rape")
		; AppUtil.PlayImpactSound(selfact as ObjectReference)  ; not here for SuccubusHeart
		sslThreadController controller = SexLab.GetActorController(selfact)
		controller.EndAnimation()
		return true
	endif
	
	return false
EndFunction

Function _getAudience()
	AppUtil.Log("get audience " + SelfName)
	if (AudienceQuest.IsRunning())
		AudienceQuest.Stop()
	endif
	AudienceQuest.Start()
	;if (self.IsPlayer)
	;	Actor aggr = Aggressor.GetActorRef()
	;	Actor victim = self.GetActorRef()
	;	self._stopCombatOneMore(aggr, victim)
	;endif
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
	AppUtil.Log("EndSexEvent(Event) " + SelfName)
	if (HasPlayer && EndlessSexLoop)
		debug.SendAnimationEvent(self.GetActorRef(), "BleedOutStart")
	endif
	self.EndSexEvent(Aggressor.GetActorRef())  ; Position is change when PC=>M, NPC=>F animation
EndEvent

Function EndSexEvent(Actor aggr)
	Actor selfact = self.GetActorRef()
	if (EndlessSexLoop && aggr)
		AppUtil.Log("EndSexEvent, Goto to loop " + SelfName)
		EndlessSexLoop = false
		self._clearHelpers()
		
		if (!self.IsPlayer && Config.knockDownAll && PlayerActor.HasKeyWordString("SexLabActive"))
			; AppUtil.KnockDownAll()
			AppUtil.KnockDown(selfact, PlayerActor)
		endif
		
		self.doSexLoop()
	else ; Aggr's OnHit or Not EndlessRape
		AppUtil.Log("EndSexEvent, truely end " + SelfName)
		self._endSexVictim()
		
		self._cleanDeadBody(aggr)
		self._cleanDeadBody(Helper1)
		self._cleanDeadBody(Helper2)
		self._cleanDeadBody(Helper3)
		
		Aggressor.Clear()
		self._clearHelpers()
		
		if (!self.IsPlayer && Config.knockDownAll && PlayerActor.HasKeyWordString("SexLabActive"))
			; AppUtil.KnockDownAll()
			AppUtil.KnockDown(selfact, PlayerActor)
		endif
		
		bool isInWeCantDie = self._isInWeCantDie()
		
		GotoState("Busy")
		if (!isInWeCantDie)
			Utility.Wait(2.0)
		endif
		PreSource = None
		GotoState("")
		
		if (isInWeCantDie)
			selfact.RemoveFromFaction(SSLYACRDyingFaction)
			sendModEvent("WeCantDieDeath")
		endif
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
		Utility.Wait(Utility.RandomFloat(0.0, 1.0)) ; for Stability
		victim.EnableAI(false)
		victim.EnableAI()
		AppUtil.Log("OnCombatStateChanged, reset ai " + SelfName)
	endif
EndEvent

; from rapespell, genius!
Event OnUpdate()
	AppUtil.Log("# OnUpdate YACRPlayer " + SelfName)
	if (UpdateController && UpdateController.GetState() == "animating")
		AppUtil.Log("OnUpdate, UpdateController is alive " + SelfName)
		UpdateController.OnUpdate()
		RegisterForSingleUpdate(ForceUpdatePeriod)
	elseif (!self.IsPlayer && self.GetActorRef().IsBleedingOut())
		AppUtil.Log("OnUpdate, _searchBleedOutPartner " + SelfName)
		self._searchBleedOutPartner()
	elseif (self.IsPlayer && self._knockDownOnlyMode())
		AlreadyKeyDown = false
		if (Config.knockDownAll)
			AppUtil.KnockDownAll()
		endif
		
		RegisterForSingleUpdate(PCBleedOutUpdatePeriod)
	else
		AppUtil.Log("OnUpdate, Unregister for single update loop " + SelfName)
		UnregisterForUpdate() ; for ForceUpdateController
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

Event OnEnterBleedOut()
	self._searchBleedOutPartner()
EndEvent

Function _searchBleedOutPartner()
	if (self.IsPlayer)
		return
	endif
	Actor victim = self.GetActorRef()
	ObjectReference center = victim as ObjectReference
	
	Actor aggr = self._getBleedOutPartner()
	if (aggr)
		; 2nd check
		if (!aggr.HasKeyWordString("SexLabActive") && !aggr.IsInFaction(SSLYACRActiveFaction))
			AppUtil.Log("OnEnterBleedOut, actor found " + SelfName)
			aggr.AddToFaction(SSLYACRActiveFaction)
			self.doBleedOut(aggr)
		else
			AppUtil.Log("OnEnterBleedOut, valid faction actor not found " + SelfName)
			RegisterForSingleUpdate(BleedOutUpdatePeriod)
		endif
	else
		AppUtil.Log("OnEnterBleedOut, valid actor not found " + SelfName)
		RegisterForSingleUpdate(BleedOutUpdatePeriod)
	endif
	; AppUtil.Log("OnEnterBleedOut, ended _searchBleedOutPartner " + SelfName)
EndFunction

Actor Function _getBleedOutPartner()
	Actor aggr
	Actor victim = Self.GetActorRef()
	Actor[] npcs = MiscUtil.ScanCellNPCs(victim as ObjectReference, 1500.0)

	int len = npcs.Length
	int idx = 0
	AppUtil.Log("_getBleedOutPartner, actors length " + len)
	while idx < len
		aggr = npcs[idx]
		if (!aggr.IsInCombat() && !aggr.IsGhost() && \
			!aggr.HasKeyWordString("SexLabActive") && !aggr.IsInFaction(SSLYACRActiveFaction) && \
			aggr != PlayerActor && !aggr.IsPlayerTeammate() && !AppUtil.ValidateHorse(aggr) && \
			!aggr.IsDead() && aggr.Is3DLoaded() && !aggr.IsDisabled() && \
			AppUtil.ValidateAggr(victim, aggr, Config.GetMatchedSex(self.IsPlayer)))
			
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
Actor Property LastAggr  Auto  ; default none

ReferenceAlias Property Aggressor  Auto
ReferenceAlias Property VictimAlias  Auto  
ReferenceAlias Property Helper1  Auto  
ReferenceAlias Property Helper2  Auto  
ReferenceAlias Property Helper3  Auto  

Keyword Property ArmorClothing  Auto  
Keyword Property ArmorHeavy  Auto  
Keyword Property ArmorLight  Auto  
Keyword Property ActorTypeNPC  Auto  

Bool Property IsPlayer  Auto  
String Property HookName  Auto
SPELL Property SSLYACRParalyseMagic  Auto  

Faction Property SSLYACRActiveFaction  Auto  
Faction Property SSLYACRDyingFaction  Auto  
Faction Property SSLYACRPurgedFollowerFaction  Auto  

Quest Property AudienceQuest  Auto  
WEAPON Property Unarmed  Auto  

; not use
SPELL Property SSLYACRKillmoveArmorSpell  Auto
SPELL Property SSLYACRPlayerSlowMagic  Auto  
Faction Property SSLYACRCalmFaction  Auto  
YACRExtraNaked Property ExtraNaked Auto
