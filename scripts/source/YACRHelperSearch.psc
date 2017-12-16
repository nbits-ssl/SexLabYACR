Scriptname YACRHelperSearch extends Quest  

Actor[] Function Gather()
	Actor[] helpers
	Actor ahelper1 = Helper1.GetActorRef()
	Actor ahelper2 = Helper2.GetActorRef()
	Actor ahelper3 = Helper3.GetActorRef()
	
	debug.trace("!!yacr " + ahelper1)
	debug.trace("!!yacr " + ahelper2)
	debug.trace("!!yacr " + ahelper3)
	
	int i = 0
	
	if (ahelper3)
		helpers = new Actor[3]
		helpers[0] = ahelper1
		helpers[1] = ahelper2
		helpers[2] = ahelper3
	elseif (ahelper2)
		helpers = new Actor[2]
		helpers[0] = ahelper1
		helpers[1] = ahelper2
	elseif (ahelper1)
		helpers = new Actor[1]
		helpers[0] = ahelper1
	endif
	
	return helpers
EndFunction

ReferenceAlias Property Helper1  Auto  
ReferenceAlias Property Helper2  Auto  
ReferenceAlias Property Helper3  Auto  
