Scriptname YACRAggrressor extends ReferenceAlias  

Form PreSource = None
string SelfName

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked) 
	
	Actor selfact = self.GetActorRef()
	if (selfact)
		SelfName = selfact.GetActorBase().GetName()
	endif
	
	Spell spl = akSource as Spell
	
	if (PreSource == akSource)
		return
	elseif (spl && !spl.IsHostile())
		AppUtil.Log("enemy onhit pass, not hostile spell " + SelfName)
		return
	elseif (selfact.IsGhost())
		AppUtil.Log("enemy onhit pass, isghost " + SelfName)
		return
	endif
	
	GotoState("Busy")
	PreSource = akSource
	AppUtil.Log("enemy onhit success " + SelfName)
	
	if (selfact)
		if selfact.HasKeyWordString("SexLabActive")
			AppUtil.Log("enemy OnHit, Stop " + SelfName)
			; selfact.SetGhost(true) ; in rare case, also un-setghost case happened ###
			sslThreadController controller = SexLab.GetActorController(selfact)
			controller.EndAnimation()
			; selfact.SetGhost(false) ;  in Alias's spell YACRStopCombatEffect
		endif
	endif
	
	Utility.Wait(0.5)
	PreSource = None
	GotoState("")
EndEvent

State Busy
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
		AppUtil.Log("enemy busy " + SelfName)
		; do nothing
	EndEvent
EndState

Event OnDying(Actor akKiller)
	ObjectReference wobj = self.GetActorRef() as ObjectReference
	wobj.SetPosition(wobj.GetPositionX(), wobj.GetPositionY() + 10.0, wobj.GetPositionZ())
	debug.sendAnimationEvent(wobj, "ragdoll")
	AppUtil.Log("enemy OnDying, sendAnimationEvent " + self.GetActorRef().GetActorBase().GetName())
EndEvent

Event OnDeath(Actor akKiller)
	AppUtil.Log("enemy OnDeath, Clear " + self.GetActorRef().GetActorBase().GetName())
	self.Clear()
EndEvent

Event OnCellDetach()
	self.GetActorRef().SetGhost(false)
EndEvent

SexLabFramework Property SexLab  Auto 
YACRUtil Property AppUtil Auto