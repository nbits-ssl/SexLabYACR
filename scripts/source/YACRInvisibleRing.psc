Scriptname YACRInvisibleRing extends ObjectReference  

Event OnEquipped(Actor akActor)
	Game.GetPlayer().SetAV("Invisibility", 1.0)
EndEvent

Event OnUnequipped(Actor akActor)
	Game.GetPlayer().SetAV("Invisibility", 0.0)
EndEvent