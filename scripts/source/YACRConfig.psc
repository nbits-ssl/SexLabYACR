Scriptname YACRConfig extends SKI_ConfigBase  

bool Property debugNotifFlag = true Auto
bool Property debugLogFlag = false Auto
bool Property registNotifFlag = true Auto
bool Property knockDownAll = true Auto

bool Property enablePlayerRape = false Auto

bool Property enableArmorBreak = true Auto
bool Property enableArmorUnequipMode = false Auto
bool Property enableEndlessRape = true Auto
int Property armorBreakChanceCloth = 50 Auto
int Property armorBreakChanceLightArmor = 20 Auto
int Property armorBreakChanceHeavyArmor = 10 Auto
int Property rapeChance = 50 Auto
int Property rapeChanceNotNaked = 10 Auto
int Property healthLimit = 50 Auto
int Property healthLimitBottom = 0 Auto
int Property matchedSex = 0 Auto

bool Property enableArmorBreakNPC = true Auto
bool Property enableArmorUnequipModeNPC = false Auto
bool Property enableEndlessRapeNPC = true Auto
int Property armorBreakChanceClothNPC = 50 Auto
int Property armorBreakChanceLightArmorNPC = 20 Auto
int Property armorBreakChanceHeavyArmorNPC = 10 Auto
int Property rapeChanceNPC = 50 Auto
int Property rapeChanceNotNakedNPC = 10 Auto
int Property healthLimitNPC = 50 Auto
int Property healthLimitBottomNPC = 0 Auto
int Property matchedSexNPC = 0 Auto

int Property keyCodeRegist = 277 Auto
int Property keyCodeHelp = 274 Auto
int Property keyCodeSubmit = 281 Auto
bool Property enableSimpleSlaverySupport = false Auto
int Property simpleSlaveryChance = 100 Auto

int knockDownAllID
int debugLogFlagID
int debugNotifFlagID
int registNotifFlagID

int keyCodeRegistID
int keyCodeHelpID
int keyCodeSubmitID
int enableSimpleSlaverySupportID
int simpleSlaveryChanceID

int enablePlayerRapeID

int enableArmorBreakID
int enableArmorUnequipModeID
int enableEndlessRapeID
int armorBreakChanceClothID
int armorBreakChanceLightArmorID
int armorBreakChanceHeavyArmorID
int rapeChanceID
int rapeChanceNotNakedID
int healthLimitID
int healthLimitBottomID
int matchedSexID

int enableArmorBreakNPCID
int enableArmorUnequipModeNPCID
int enableEndlessRapeNPCID
int armorBreakChanceClothNPCID
int armorBreakChanceLightArmorNPCID
int armorBreakChanceHeavyArmorNPCID
int rapeChanceNPCID
int rapeChanceNotNakedNPCID
int healthLimitNPCID
int healthLimitBottomNPCID
int matchedSexNPCID

int[] availableEnemyFactionsIDS
int[] multiplayEnemyFactionsIDS
string[] matchedSexList

YACRUtil Property AppUtil Auto

int Function GetVersion()
	return AppUtil.GetVersion()
EndFunction 

Event OnVersionUpdate(int a_version)
	OnConfigInit()
	(SSLYACRQuestManager as YACRInit).Reboot()
	debug.notification("SexLab YACR updated to " + a_version)
EndEvent

Event OnConfigInit()
	Pages = new string[4]
	Pages[0] = "$YACRRapeChance"
	Pages[1] = "$YACRArmorBreak"
	Pages[2] = "$YACREnemy"
	Pages[3] = "$YACRSystem"
	
	availableEnemyFactionsIDS = new int[50]
	multiplayEnemyFactionsIDS = new int[50]
	
	matchedSexList = new string[3]
	matchedSexList[0] = "$YACRSexStraight"
	matchedSexList[1] = "$YACRSexBoth"
	matchedSexList[2] = "$YACRSexHomo"
EndEvent

Event OnPageReset(string page)
	if (page == "" || page == "$YACRRapeChance")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		enablePlayerRapeID = AddToggleOption("$EnablePlayerRape", enablePlayerRape)
		
		AddHeaderOption("$PlayerCharactor")
		matchedSexID = AddMenuOption("$MatchedSex", matchedSexList[matchedSex])
		healthLimitID = AddSliderOption("$HealthLimit", healthLimit)
		healthLimitBottomID = AddSliderOption("$HealthLimitBottom", healthLimitBottom)
		
		AddHeaderOption("$RapeChance")
		rapeChanceID = AddSliderOption("$Naked", rapeChance)
		rapeChanceNotNakedID = AddSliderOption("$NotNaked", rapeChanceNotNaked)
		enableEndlessRapeID = AddToggleOption("$EndlessRape", enableEndlessRape)
		
		SetCursorPosition(1)
		AddEmptyOption()
		
		AddHeaderOption("$Follower")
		matchedSexNPCID = AddMenuOption("$MatchedSex", matchedSexList[matchedSexNPC])
		healthLimitNPCID = AddSliderOption("$HealthLimit", healthLimitNPC)
		healthLimitBottomNPCID = AddSliderOption("$HealthLimitBottom", healthLimitBottomNPC)
		
		AddHeaderOption("$RapeChance")
		rapeChanceNPCID = AddSliderOption("$Naked", rapeChanceNPC)
		rapeChanceNotNakedNPCID = AddSliderOption("$NotNaked", rapeChanceNotNakedNPC)
		enableEndlessRapeNPCID = AddToggleOption("$EndlessRape", enableEndlessRapeNPC)
		
	elseif (page == "$YACRArmorBreak")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$PlayerCharactor")
		enableArmorBreakID = AddToggleOption("$Enable", enableArmorBreak)
		enableArmorUnequipModeID = AddToggleOption("$EnableArmorUnequipMode", enableArmorUnequipMode)
		armorBreakChanceClothID = AddSliderOption("$Cloth", armorBreakChanceCloth)
		armorBreakChanceLightArmorID = AddSliderOption("$LightArmor", armorBreakChanceLightArmor)
		armorBreakChanceHeavyArmorID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmor)
		
		SetCursorPosition(1)

		AddHeaderOption("$Follower")
		enableArmorBreakNPCID = AddToggleOption("$Enable", enableArmorBreakNPC)
		enableArmorUnequipModeNPCID = AddToggleOption("$EnableArmorUnequipMode", enableArmorUnequipModeNPC)
		armorBreakChanceClothNPCID = AddSliderOption("$Cloth", armorBreakChanceClothNPC)
		armorBreakChanceLightArmorNPCID = AddSliderOption("$LightArmor", armorBreakChanceLightArmorNPC)
		armorBreakChanceHeavyArmorNPCID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmorNPC)
	elseif	(page == "$YACREnemy")
		SetCursorFillMode(LEFT_TO_RIGHT)
		SetCursorPosition(0)
		
		Faction[] aefacts = AppUtil.AvailableEnemyFactions
		bool[] aefactsConfig = AppUtil.AvailableEnemyFactionsConfig
		
		int len = aefacts.Length
		int idx = 0
		string factname
		while idx != len
			factname = self._getFactionName(aefacts[idx])
			availableEnemyFactionsIDS[idx] = AddToggleOption(factname, aefactsConfig[idx])
			idx += 1
		endwhile
		; AppUtil.Log(availableEnemyFactionsIDS)
	elseif	(page == "$Multiplay")
		SetCursorFillMode(LEFT_TO_RIGHT)
		SetCursorPosition(0)
		
		Faction[] mpfacts = AppUtil.MultiplayEnemyFactions
		int[] mpfactsConfig = AppUtil.MultiplayEnemyFactionsConfig

		int len = mpfacts.Length
		int idx = 0
		string factname
		while idx != len
			if (idx == 0) ; ActorTypeNPC
				multiplayEnemyFactionsIDS[idx] = AddSliderOption("$ActorTypeNPCFaction", mpfactsConfig[idx])
			else
				factname = self._getFactionName(mpfacts[idx])
				multiplayEnemyFactionsIDS[idx] = AddSliderOption(factname, mpfactsConfig[idx])
			endif
			idx += 1
		endwhile
		; AppUtil.Log(multiplayEnemyFactionsIDS)
	elseif (page == "$YACRSystem")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$YACRSystem")
		
		keyCodeRegistID = AddKeyMapOption("$KeyCodeRegist", keyCodeRegist)
		keyCodeHelpID = AddKeyMapOption("$KeyCodeHelp", keyCodeHelp)
		keyCodeSubmitID = AddKeyMapOption("$KeyCodeSubmit", keyCodeSubmit)
		
		enableSimpleSlaverySupportID = AddToggleOption("$EnableSimpleSlaverySupport", enableSimpleSlaverySupport)
		simpleSlaveryChanceID = AddSliderOption("$SimpleSlaveryChance", simpleSlaveryChance)
		
		AddEmptyOption()
		
		AddHeaderOption("$YACRDebug")
		registNotifFlagID = AddToggleOption("$OutputRegistNotif", registNotifFlag)
		debugNotifFlagID = AddToggleOption("$OutputPapyrusNotif", debugNotifFlag)
		debugLogFlagID = AddToggleOption("$OutputPapyrusLog", debugLogFlag)
		; knockDownAllID = AddToggleOption("$KnockDownAll", knockDownAll) ; not support from 2.0alpha1
		
		SetCursorPosition(1)
		AddHeaderOption("$YACRTeammates")

		Actor act
		ReferenceAlias ref
		int n = 0
		int len = AppUtil.Teammates.Length
		
		while n != len
			ref = AppUtil.Teammates[n]
			act = ref.GetActorRef()
			if (act)
				AddTextOption(act.GetActorBase().GetName(), "")
			endif
			n += 1
		endWhile
	endif
EndEvent

; why empty, Bethesda !!
string Function _getFactionName(Faction fact)
	if (fact == BanditFaction)
		return "$BanditFaction"
	elseif (fact == VampireFaction)
		return "$VampireFaction"
	elseif (fact == DLC1VampireFaction)
		return "$DLC1VampireFaction"
	elseif (fact == SilverHandFaction)
		return "$SilverHandFaction"
	elseif (fact == MS08AlikrFaction)
		return "$MS08AlikrFaction"
	elseif (fact == MS09NorthwatchFaction)
		return "$MS09NorthwatchFaction"
	else
		return fact.GetName()
	endif
EndFunction

int Function GetHealthLimit(bool IsPlayer = true)
	if (IsPlayer)
		return self.healthLimit
	else
		return self.healthLimitNPC
	endif
EndFunction

int Function GetHealthLimitBottom(bool IsPlayer = true)
	if (IsPlayer)
		return self.healthLimitBottom
	else
		return self.healthLimitBottomNPC
	endif
EndFunction

int Function GetRapeChance(bool IsPlayer = true)
	if (IsPlayer)
		return self.rapeChance
	else
		return self.rapeChanceNPC
	endif
EndFunction

int Function GetRapeChanceNotNaked(bool IsPlayer = true)
	if (IsPlayer)
		return self.rapeChanceNotNaked
	else
		return self.rapeChanceNotNakedNPC
	endif
EndFunction

bool Function GetEnableEndlessRape(bool IsPlayer = true)
	if (IsPlayer)
		return self.enableEndlessRape
	else
		return self.enableEndlessRapeNPC
	endif
EndFunction

int Function GetMatchedSex(bool IsPlayer = true)
	if (IsPlayer)
		return self.matchedSex
	else
		return self.matchedSexNPC
	endif
EndFunction

bool Function GetEnableArmorUnequipMode(bool IsPlayer = true)
	if (IsPlayer)
		return self.enableArmorUnequipMode
	else
		return self.enableArmorUnequipModeNPC
	endif
EndFunction

bool Function GetEnableArmorBreak(bool IsPlayer = true)
	if (IsPlayer)
		return self.enableArmorBreak
	else
		return self.enableArmorBreakNPC
	endif
EndFunction

int[] Function GetBreakChances(bool IsPlayer = true)
	int[] chances = new int[3]
	
	if (IsPlayer)
		chances[0] = self.armorBreakChanceCloth
		chances[1] = self.armorBreakChanceLightArmor
		chances[2] = self.armorBreakChanceHeavyArmor
	else
		chances[0] = self.armorBreakChanceClothNPC
		chances[1] = self.armorBreakChanceLightArmorNPC
		chances[2] = self.armorBreakChanceHeavyArmorNPC
	endif
	
	return chances
EndFunction

Event OnOptionHighlight(int option)
	;if (option == knockDownAllID)
	;	SetInfoText("$KnockDownAllInfo")
	if (option == enablePlayerRapeID)
		SetInfoText("$EnablePlayerRapeInfo")
	elseif (option == enableArmorUnequipModeID || option == enableArmorUnequipModeNPCID)
		SetInfoText("$EnableArmorUnequipModeInfo")
	elseif (option == matchedSexID || option == matchedSexNPCID)
		SetInfoText("$MatchedSexInfo")
	elseif (option == healthLimitID || option == healthLimitNPCID)
		SetInfoText("$HealthLimitInfo")
	elseif (option == healthLimitBottomID || option == healthLimitBottomNPCID)
		SetInfoText("$HealthLimitBottomInfo")
	elseif (option == enableEndlessRapeID || option == enableEndlessRapeNPCID)
		SetInfoText("$EndlessRapeInfo")
	elseif (availableEnemyFactionsIDS.Find(option) > -1)
		SetInfoText("$AvailableEnemyFactions")
	elseif (multiplayEnemyFactionsIDS.Find(option) > -1)
		SetInfoText("$MultiplayEnemyFactions")
	elseif (option == registNotifFlagID)
		SetInfoText("$OutputRegistNotifInfo")
	elseif (option == debugNotifFlagID)
		SetInfoText("$OutputPapyrusNotifInfo")
	elseif (option == keyCodeRegistID)
		SetInfoText("$KeyCodeRegistInfo")
	elseif (option == keyCodeHelpID)
		SetInfoText("$KeyCodeHelpInfo")
	elseif (option == keyCodeSubmitID)
		SetInfoText("$KeyCodeSubmitInfo")
	elseif (option == enableSimpleSlaverySupportID)
		SetInfoText("$EnableSimpleSlaverySupportInfo")
	elseif (option == simpleSlaveryChanceID)
		SetInfoText("$SimpleSlaveryChanceInfo")
	endif
EndEvent

Event OnOptionSelect(int option)
	if (option == enableArmorBreakID)
		enableArmorBreak = !enableArmorBreak
		SetToggleOptionValue(option, enableArmorBreak)
	elseif (option == enableEndlessRapeID)
		enableEndlessRape = !enableEndlessRape
		SetToggleOptionValue(option, enableEndlessRape)
		
	elseif (option == enableArmorBreakNPCID)
		enableArmorBreakNPC = !enableArmorBreakNPC
		SetToggleOptionValue(option, enableArmorBreakNPC)
	elseif (option == enableEndlessRapeNPCID)
		enableEndlessRapeNPC = !enableEndlessRapeNPC
		SetToggleOptionValue(option, enableEndlessRapeNPC)
		
	elseif (option == enablePlayerRapeID)
		enablePlayerRape = !enablePlayerRape
		SetToggleOptionValue(option, enablePlayerRape)
		
	elseif (option == enableArmorUnequipModeID)
		enableArmorUnequipMode = !enableArmorUnequipMode
		SetToggleOptionValue(option, enableArmorUnequipMode)
	elseif (option == enableArmorUnequipModeNPCID)
		enableArmorUnequipModeNPC = !enableArmorUnequipModeNPC
		SetToggleOptionValue(option, enableArmorUnequipModeNPC)

	elseif (option == enableSimpleSlaverySupportID)
		enableSimpleSlaverySupport = !enableSimpleSlaverySupport
		SetToggleOptionValue(option, enableSimpleSlaverySupport)
		
	elseif (option == knockDownAllID)
		knockDownAll = !knockDownAll
		SetToggleOptionValue(option, knockDownAll)
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(option, debugLogFlag)
	elseif (option == debugNotifFlagID)
		debugNotifFlag = !debugNotifFlag
		SetToggleOptionValue(option, debugNotifFlag)
	elseif (option == registNotifFlagID)
		registNotifFlag = !registNotifFlag
		SetToggleOptionValue(option, registNotifFlag)
		
	elseif (availableEnemyFactionsIDS.Find(option) > -1)
		int idx = availableEnemyFactionsIDS.Find(option)
		bool opt = AppUtil.AvailableEnemyFactionsConfig[idx]
		AppUtil.AvailableEnemyFactionsConfig[idx] = !opt
		SetToggleOptionValue(availableEnemyFactionsIDS.Find(option), !opt)
	endif
EndEvent

Event OnOptionSliderOpen(int option)
	if (option == healthLimitID)
		self._setSliderDialogWithPercentage(healthLimit)
	elseif (option == healthLimitBottomID)
		self._setSliderDialogWithPercentage(healthLimitBottom)
	elseif (option == rapeChanceID)
		self._setSliderDialogWithPercentage(rapeChance)
	elseif (option == rapeChanceNotNakedID)
		self._setSliderDialogWithPercentage(rapeChanceNotNaked)
	elseif (option == armorBreakChanceClothID)
		self._setSliderDialogWithPercentage(armorBreakChanceCloth)
	elseif (option == armorBreakChanceLightArmorID)
		self._setSliderDialogWithPercentage(armorBreakChanceLightArmor)
	elseif (option == armorBreakChanceHeavyArmorID)
		self._setSliderDialogWithPercentage(armorBreakChanceHeavyArmor)

	elseif (option == healthLimitNPCID)
		self._setSliderDialogWithPercentage(healthLimitNPC)
	elseif (option == healthLimitBottomNPCID)
		self._setSliderDialogWithPercentage(healthLimitBottomNPC)
	elseif (option == rapeChanceNPCID)
		self._setSliderDialogWithPercentage(rapeChanceNPC)
	elseif (option == rapeChanceNotNakedNPCID)
		self._setSliderDialogWithPercentage(rapeChanceNotNakedNPC)
	elseif (option == armorBreakChanceClothNPCID)
		self._setSliderDialogWithPercentage(armorBreakChanceClothNPC)
	elseif (option == armorBreakChanceLightArmorNPCID)
		self._setSliderDialogWithPercentage(armorBreakChanceLightArmorNPC)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		self._setSliderDialogWithPercentage(armorBreakChanceHeavyArmorNPC)

	elseif (option == simpleSlaveryChanceID)
		self._setSliderDialogWithPercentage(simpleSlaveryChance)
	
	elseif (multiplayEnemyFactionsIDS.Find(option) > -1)
		int idx = multiplayEnemyFactionsIDS.Find(option)
		self._setSliderDialogWithHelpers(AppUtil.MultiplayEnemyFactionsConfig[idx])
	endif
EndEvent

Function _setSliderDialogWithPercentage(int x)
	SetSliderDialogStartValue(x)
	SetSliderDialogDefaultValue(x)
	
	SetSliderDialogRange(0.0, 100.0)
	SetSliderDialogInterval(1.0)
EndFunction

Function _setSliderDialogWithHelpers(int x)
	SetSliderDialogStartValue(x)
	SetSliderDialogDefaultValue(x)
	
	SetSliderDialogRange(0.0, 3.0)
	SetSliderDialogInterval(1.0)
EndFunction

Event OnOptionSliderAccept(int option, float value)
	if (option == healthLimitID)
		healthLimit = value as int
		SetSliderOptionValue(option, healthLimit)
	elseif (option == healthLimitBottomID)
		healthLimitBottom = value as int
		SetSliderOptionValue(option, healthLimitBottom)
	elseif (option == rapeChanceID)
		rapeChance = value as int
		SetSliderOptionValue(option, rapeChance)
	elseif (option == rapeChanceNotNakedID)
		rapeChanceNotNaked = value as int
		SetSliderOptionValue(option, rapeChanceNotNaked)
	elseif (option == armorBreakChanceClothID)
		armorBreakChanceCloth = value as int
		SetSliderOptionValue(option, armorBreakChanceCloth)
	elseif (option == armorBreakChanceLightArmorID)
		armorBreakChanceLightArmor = value as int
		SetSliderOptionValue(option, armorBreakChanceLightArmor)
	elseif (option == armorBreakChanceHeavyArmorID)
		armorBreakChanceHeavyArmor = value as int
		SetSliderOptionValue(option, armorBreakChanceHeavyArmor)
		
	elseif (option == healthLimitNPCID)
		healthLimitNPC = value as int
		SetSliderOptionValue(option, healthLimitNPC)
	elseif (option == healthLimitBottomNPCID)
		healthLimitBottomNPC = value as int
		SetSliderOptionValue(option, healthLimitBottomNPC)
	elseif (option == rapeChanceNPCID)
		rapeChanceNPC = value as int
		SetSliderOptionValue(option, rapeChanceNPC)
	elseif (option == rapeChanceNotNakedNPCID)
		rapeChanceNotNakedNPC = value as int
		SetSliderOptionValue(option, rapeChanceNotNakedNPC)
	elseif (option == armorBreakChanceClothNPCID)
		armorBreakChanceClothNPC = value as int
		SetSliderOptionValue(option, armorBreakChanceClothNPC)
	elseif (option == armorBreakChanceLightArmorNPCID)
		armorBreakChanceLightArmorNPC = value as int
		SetSliderOptionValue(option, armorBreakChanceLightArmorNPC)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		armorBreakChanceHeavyArmorNPC = value as int
		SetSliderOptionValue(option, armorBreakChanceHeavyArmorNPC)

	elseif (option == simpleSlaveryChanceID)
		simpleSlaveryChance = value as int
		SetSliderOptionValue(option, simpleSlaveryChance)
		
	elseif (multiplayEnemyFactionsIDS.Find(option) > -1)
		int idx = multiplayEnemyFactionsIDS.Find(option)
		AppUtil.MultiplayEnemyFactionsConfig[idx] = value as int
		SetSliderOptionValue(multiplayEnemyFactionsIDS[idx], value as int)
	endif
EndEvent

event OnOptionMenuOpen(int option)
	if (option == matchedSexID)
		SetMenuDialogStartIndex(matchedSex)
	elseif (option == matchedSexNPCID)
		SetMenuDialogStartIndex(matchedSexNPC)
	endIf
	
	SetMenuDialogDefaultIndex(0)
	SetMenuDialogOptions(matchedSexList)
endEvent

event OnOptionMenuAccept(int option, int index)
	if (option == matchedSexID)
		matchedSex = index
		SetMenuOptionValue(option, matchedSexList[matchedSex])
	elseif (option == matchedSexNPCID)
		matchedSexNPC = index
		SetMenuOptionValue(option, matchedSexList[matchedSexNPC])
	endIf
endEvent

Event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	if (option == keyCodeRegistID)
		keyCodeRegist = keyCode
	elseif (option == keyCodeHelpID)
		keyCodeHelp = keyCode
	elseif (option == keyCodeSubmitID)
		keyCodeSubmit = keyCode
	endif
	SetKeymapOptionValue(option, keyCode)
EndEvent

Faction Property BanditFaction  Auto  
Faction Property VampireFaction  Auto  
Faction Property DLC1VampireFaction  Auto  
Faction Property SilverHandFaction  Auto  
Faction Property MS08AlikrFaction  Auto  
Faction Property MS09NorthwatchFaction  Auto  

Quest Property SSLYACRQuestManager  Auto  
