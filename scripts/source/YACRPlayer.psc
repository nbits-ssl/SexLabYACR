Scriptname YACRPlayer extends ReferenceAlias  

Form PreSource = None
string SelfName
Faction AggrFaction = None
bool PlayerIsMale = false
bool IsInCurrentFollowerFaction = false

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)

	Actor akAggr = akAggressor as Actor
	Actor selfact = self.GetActorRef()
	SelfName = selfact.GetActorBase().GetName()
	Weapon wpn = akSource as Weapon
	
	if (PlayerIsMale || akAggressor == None || akProjectile || PreSource ==  akSource || !wpn)
		AppUtil.Log("not if " + SelfName)
		return
	elseif (self._isPlayer())
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
	AggrFaction = self._getEnemyType(akAggressor as Actor)
	
	if (AggrFaction && !abHitBlocked && wpn.GetWeaponType() < 7) ; exclude Bow/Staff/Crossbow
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
			if (Config.enableArmorBreak)
				if ((selfarmor.HasKeyWord(ArmorClothing) && rndintAB < Config.armorBreakChanceCloth) || \
					(selfarmor.HasKeyWord(ArmorLight) && rndintAB < Config.armorBreakChanceLightArmor) || \
					(selfarmor.HasKeyWord(ArmorHeavy) && rndintAB < Config.armorBreakChanceHeavyArmor))
					
					selfact.RemoveItem(selfarmor)
					AppUtil.Log(" Armor break " + SelfName)
				endif
			endif
			
			if (Config.enableNoNakedRape && rndintRP < Config.rapeChanceNotNaked)
				AppUtil.Log("doSex " + SelfName)
				self.doSex(selfact, akAggr, AggrFaction)
			endif
		elseif (!selfarmor && rndintRP < Config.rapeChance)
			AppUtil.Log("doSex " + SelfName)
			self.doSex(selfact, akAggr, AggrFaction)
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

Faction Function _getEnemyType(Actor act)
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

bool Function _isPlayer()
	if (HookName == "Player")
		return true
	else
		return false
	endif
EndFunction

Function _readySexAggr(Actor act)
	act.SetGhost(true)
	act.StopCombat()
	act.StopCombatAlarm()
EndFunction

Function _readySexVictim(Actor act, Faction fact)
	act.SetGhost(true)
	
	if (self._isPlayer())
		fact.SetReaction(SSLYACRCalmFaction, 3) ; set friend
		act.AddToFaction(SSLYACRCalmFaction)
		
		Game.ForceThirdPerson()
		;Game.DisablePlayerControls(1, 1, 1, 0, 1, 1, 0, 0)
	else
		if (act.IsInFaction(CurrentFollowerFaction))
			act.RemoveFromFaction(CurrentFollowerFaction)
			IsInCurrentFollowerFaction = true
		endif
		act.SetPlayerTeammate(false)
		act.AddToFaction(fact)
	endif
	
	act.StopCombat()
	act.StopCombatAlarm()
EndFunction

Function _endSexAggr(Actor act)
	act.SetGhost(false)
EndFunction

Function _endSexVictim(Actor act, Faction fact)
	if (self._isPlayer())
		act.RemoveFromFaction(SSLYACRCalmFaction)
		fact.SetReaction(SSLYACRCalmFaction, 0) ; set neutral
	else
		act.RemoveFromFaction(fact)
		act.SetPlayerTeammate(true)
		if (IsInCurrentFollowerFaction)
			act.AddToFaction(CurrentFollowerFaction)
		endif
	endif
	
	act.SetGhost(false)
EndFunction

Function doSex(Actor ActorLoser, Actor ActorWinner, Faction WinnerFaction)
	if (ActorLoser.IsGhost() || ActorWinner.IsGhost())
		AppUtil.Log("ghosted Actor found, pass doSex " + SelfName)
	elseif (Aggressor.GetActorRef() || ActorWinner.IsDead())
		AppUtil.Log("already filled ref or dead actor, pass doSex " + SelfName)
	elseif (ActorLoser.IsInFaction(SSLAnimatingFaction)) ; second check
		AppUtil.Log("actloser already animating, pass doSex " + SelfName)
	else
		ActorLoser.AddSpell(SSLYACRStopCombatMagic, false)
		Aggressor.ForceRefTo(ActorWinner)
		self._readySexVictim(ActorLoser, WinnerFaction)
		self._readySexAggr(ActorWinner)
		
		sslBaseAnimation[] anims
		if (ActorWinner.HasKeyWord(ActorTypeNPC))
			anims =  SexLab.GetAnimationsByTags(2, "MF,Aggressive", "Oral", true)
		else
			anims =  SexLab.GetAnimationsByTags(2, "")
		endif
		actor[] sexActors = new actor[2]
		sexActors[0] = ActorLoser
		sexActors[1] = ActorWinner
		
		AppUtil.Log("run SexLab " + SelfName)
		int tid = self._quickSex(sexActors, anims, victim = ActorLoser)
		sslThreadController controller = SexLab.GetController(tid)
		
		; wait for sync, max 12 sec.
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		self._waitSetup(controller)
		
		if (controller)
			Utility.Wait(1.0)
			self._endSexAggr(ActorWinner)
			AppUtil.Log("aggr setghost disable " + SelfName)
		else
			AppUtil.Log("###FIXME### controller not found, recover setup " + SelfName)
			self.EndSexEvent(ActorLoser, ActorWinner)
		endif
	endif
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
	sslThreadController Thread = SexLab.GetController(tid)
	int stagecnt = Thread.Animation.StageCount
	
	if (Thread.Stage == stagecnt)
		Utility.Wait(3.0)
		int rndint = Utility.RandomInt(1, 100)
		if (rndint < 10)
			AppUtil.Log("endless sex loop...one more " + SelfName)
			Thread.AdvanceStage(true)
		elseif (rndint < 30)
			AppUtil.Log("endless sex loop...one more from 2nd " + SelfName)
			Thread.GoToStage(stagecnt - 2)
		else
			AppUtil.Log("endless sex loop...change anim " + SelfName)
			Thread.ChangeAnimation()
		endif
	endif
EndEvent

Event EndSexEventYACR(int tid, bool HasPlayer)
	sslThreadController Thread = SexLab.GetController(tid)
	EndSexEvent(Thread.Positions[0], Thread.Positions[1])
EndEvent

Function EndSexEvent(Actor Loser, Actor Winner)
	Loser.RemoveSpell(SSLYACRStopCombatMagic)
	AppUtil.Log("EndSexEvent Loser " + Loser.GetActorBase().GetName())
	
	Faction fact = self._getEnemyType(Winner)
	self._endSexVictim(Loser, fact)
	self._endSexAggr(Winner) ; for OnHit SetGhost
	
	if (Winner.IsDead())
		ObjectReference wobj = Winner as ObjectReference
		wobj.SetPosition(wobj.GetPositionX(), wobj.GetPositionY() + 10.0, wobj.GetPositionZ())
		debug.sendAnimationEvent(wobj, "ragdoll")
		AppUtil.Log("EndSexEvent winner is dead " + Loser.GetActorBase().GetName())
	else
		AppUtil.Log("EndSexEvent winner is live " + Loser.GetActorBase().GetName())
	endif
	Aggressor.Clear()
	
	GotoState("Busy")
	Utility.Wait(2.0)
	PreSource = None
	GotoState("")
EndFunction

Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	if (aeCombatState == 0)
		Actor selfact = self.GetActorRef()
		selfact.EnableAI(false)
		selfact.EnableAI()
		AppUtil.Log("combatstatechanged, reset ai " + SelfName)
	endif
EndEvent


YACRConfig Property Config Auto
YACRUtil Property AppUtil Auto
SexLabFramework Property SexLab  Auto
Faction property SSLAnimatingFaction Auto
ReferenceAlias Property Aggressor  Auto
Actor Property PlayerActor  Auto

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

SPELL Property SSLYACRStopCombatMagic  Auto
SPELL Property SSLYACRKillmoveArmorSpell  Auto  ; no longer needed
String Property HookName  Auto

Keyword Property ActorTypeNPC  Auto  
Faction Property CurrentFollowerFaction  Auto  

Faction Property SSLYACRCalmFaction  Auto  
