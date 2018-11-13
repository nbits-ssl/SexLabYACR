Scriptname YACRConfig extends SKI_ConfigBase  

bool Property modEnabled = true Auto
bool Property debugNotifFlag = true Auto
bool Property debugLogFlag = false Auto
bool Property registNotifFlag = true Auto
bool Property knockDownAll = true Auto

; Player ========================================
bool Property enablePlayerRape = true Auto
bool Property knockDownOnly = true Auto

int Property matchedSex = 0 Auto
int Property healthLimit = 50 Auto
int Property healthLimitBottom = 0 Auto
bool Property enableEndlessRape = true Auto

int Property rapeChance = 50 Auto
int Property rapeChanceNotNaked = 10 Auto
int Property rapeChancePA = 75 Auto
int Property rapeChanceNotNakedPA = 25 Auto

bool Property enableArmorBreak = true Auto
bool Property enableArmorUnequipMode = false Auto

int Property armorBreakChanceCloth = 50 Auto
int Property armorBreakChanceLightArmor = 20 Auto
int Property armorBreakChanceHeavyArmor = 10 Auto
int Property armorBreakChanceClothPA = 75 Auto
int Property armorBreakChanceLightArmorPA = 30 Auto
int Property armorBreakChanceHeavyArmorPA = 20 Auto

; Follower ========================================
int Property matchedSexNPC = 0 Auto
int Property healthLimitNPC = 50 Auto
int Property healthLimitBottomNPC = 0 Auto
bool Property enableEndlessRapeNPC = true Auto

int Property rapeChanceNPC = 50 Auto
int Property rapeChanceNotNakedNPC = 10 Auto
int Property rapeChanceNPCPA = 75 Auto
int Property rapeChanceNotNakedNPCPA = 25 Auto

bool Property enableArmorBreakNPC = true Auto
bool Property enableArmorUnequipModeNPC = false Auto

int Property armorBreakChanceClothNPC = 50 Auto
int Property armorBreakChanceLightArmorNPC = 20 Auto
int Property armorBreakChanceHeavyArmorNPC = 10 Auto
int Property armorBreakChanceClothNPCPA = 75 Auto
int Property armorBreakChanceLightArmorNPCPA = 30 Auto
int Property armorBreakChanceHeavyArmorNPCPA = 20 Auto

; ========================================

int Property keyCodeRegist = 278 Auto
int Property keyCodeHelp = 274 Auto
int Property keyCodeSubmit = 280 Auto
bool Property enableSimpleSlaverySupport = false Auto
int Property simpleSlaveryChance = 100 Auto
bool Property enableDrippingWASupport = false Auto

Race[] Property DisableRaces  Auto  
Bool[] Property DisableRacesConfig  Auto  

int enableDisableID

int knockDownAllID
int debugLogFlagID
int debugNotifFlagID
int registNotifFlagID

int keyCodeRegistID
int keyCodeHelpID
int keyCodeSubmitID
int enableSimpleSlaverySupportID
int simpleSlaveryChanceID
int enableDrippingWASupportID

; Player ========================================
int enablePlayerRapeID
int knockDownOnlyID

int matchedSexID
int healthLimitID
int healthLimitBottomID
int enableEndlessRapeID

int rapeChanceID
int rapeChanceNotNakedID
int rapeChancePAID
int rapeChanceNotNakedPAID

int enableArmorBreakID
int enableArmorUnequipModeID

int armorBreakChanceClothID
int armorBreakChanceLightArmorID
int armorBreakChanceHeavyArmorID
int armorBreakChanceClothPAID
int armorBreakChanceLightArmorPAID
int armorBreakChanceHeavyArmorPAID

; Follower ========================================
int matchedSexNPCID
int healthLimitNPCID
int healthLimitBottomNPCID
int enableEndlessRapeNPCID

int rapeChanceNPCID
int rapeChanceNotNakedNPCID
int rapeChanceNPCPAID
int rapeChanceNotNakedNPCPAID

int enableArmorBreakNPCID
int enableArmorUnequipModeNPCID

int armorBreakChanceClothNPCID
int armorBreakChanceLightArmorNPCID
int armorBreakChanceHeavyArmorNPCID
int armorBreakChanceClothNPCPAID
int armorBreakChanceLightArmorNPCPAID
int armorBreakChanceHeavyArmorNPCPAID

; ========================================

int[] disableEnemyRacesIDS
string[] matchedSexList

YACRUtil Property AppUtil Auto

int Function GetVersion()
	return AppUtil.GetVersion()
EndFunction 

Event OnVersionUpdate(int a_version)
	if (CurrentVersion == 0) ; new game
		debug.notification("SexLab YACR [" + a_version + "] installed.")
	elseif (a_version != CurrentVersion)
		OnConfigInit()
		if (self.modEnabled)
			(SSLYACRQuestManager as YACRInit).Reboot()
			debug.notification("SexLab YACR updated to [" + a_version + "], YACR has rebooted.")
		else
			debug.notification("SexLab YACR updated to [" + a_version + "], but YACR is disabled.")
		endif
	endif
EndEvent

Event OnConfigInit()
	knockDownAll = true ; always from 2.0alpha3
	
	Pages = new string[4]
	Pages[0] = "$YACRRapeChance"
	Pages[1] = "$YACRArmorBreak"
	Pages[2] = "$YACREnemy"
	Pages[3] = "$YACRSystem"
	
	matchedSexList = new string[3]
	matchedSexList[0] = "$YACRSexStraight"
	matchedSexList[1] = "$YACRSexBoth"
	matchedSexList[2] = "$YACRSexHomo"
	
	disableEnemyRacesIDS = new int[20]
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
		enableEndlessRapeID = AddToggleOption("$EndlessRape", enableEndlessRape)
		
		AddHeaderOption("$RapeChance")
		rapeChanceID = AddSliderOption("$Naked", rapeChance)
		rapeChanceNotNakedID = AddSliderOption("$NotNaked", rapeChanceNotNaked)

		AddHeaderOption("$RapeChancePA")
		rapeChancePAID = AddSliderOption("$Naked", rapeChancePA)
		rapeChanceNotNakedPAID = AddSliderOption("$NotNaked", rapeChanceNotNakedPA)
		
		SetCursorPosition(1)
		
		knockDownOnlyID = AddToggleOption("$KnockDownOnly", knockDownOnly)
		
		AddHeaderOption("$Follower")
		matchedSexNPCID = AddMenuOption("$MatchedSex", matchedSexList[matchedSexNPC])
		healthLimitNPCID = AddSliderOption("$HealthLimit", healthLimitNPC)
		healthLimitBottomNPCID = AddSliderOption("$HealthLimitBottom", healthLimitBottomNPC)
		enableEndlessRapeNPCID = AddToggleOption("$EndlessRape", enableEndlessRapeNPC)
		
		AddHeaderOption("$RapeChance")
		rapeChanceNPCID = AddSliderOption("$Naked", rapeChanceNPC)
		rapeChanceNotNakedNPCID = AddSliderOption("$NotNaked", rapeChanceNotNakedNPC)
		
		AddHeaderOption("$RapeChancePA")
		rapeChanceNPCPAID = AddSliderOption("$Naked", rapeChanceNPCPA)
		rapeChanceNotNakedNPCPAID = AddSliderOption("$NotNaked", rapeChanceNotNakedNPCPA)
		
	elseif (page == "$YACRArmorBreak")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$PlayerCharactor")
		enableArmorBreakID = AddToggleOption("$Enable", enableArmorBreak)
		enableArmorUnequipModeID = AddToggleOption("$EnableArmorUnequipMode", enableArmorUnequipMode)
		
		AddHeaderOption("$YACRArmorBreakAttack")
		armorBreakChanceClothID = AddSliderOption("$Cloth", armorBreakChanceCloth)
		armorBreakChanceLightArmorID = AddSliderOption("$LightArmor", armorBreakChanceLightArmor)
		armorBreakChanceHeavyArmorID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmor)
		
		AddHeaderOption("$YACRArmorBreakPowerAttack")
		armorBreakChanceClothPAID = AddSliderOption("$Cloth", armorBreakChanceClothPA)
		armorBreakChanceLightArmorPAID = AddSliderOption("$LightArmor", armorBreakChanceLightArmorPA)
		armorBreakChanceHeavyArmorPAID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmorPA)
		
		SetCursorPosition(1)
		
		AddHeaderOption("$Follower")
		enableArmorBreakNPCID = AddToggleOption("$Enable", enableArmorBreakNPC)
		enableArmorUnequipModeNPCID = AddToggleOption("$EnableArmorUnequipMode", enableArmorUnequipModeNPC)
		
		AddHeaderOption("$YACRArmorBreakAttack")
		armorBreakChanceClothNPCID = AddSliderOption("$Cloth", armorBreakChanceClothNPC)
		armorBreakChanceLightArmorNPCID = AddSliderOption("$LightArmor", armorBreakChanceLightArmorNPC)
		armorBreakChanceHeavyArmorNPCID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmorNPC)
		
		AddHeaderOption("$YACRArmorBreakPowerAttack")
		armorBreakChanceClothNPCPAID = AddSliderOption("$Cloth", armorBreakChanceClothNPCPA)
		armorBreakChanceLightArmorNPCPAID = AddSliderOption("$LightArmor", armorBreakChanceLightArmorNPCPA)
		armorBreakChanceHeavyArmorNPCPAID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmorNPCPA)

	elseif	(page == "$YACREnemy")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$YACREnemyRaces")
		
		int len = DisableRaces.Length
		int idx = 0
		string raceName
		while idx != len
			raceName = DisableRaces[idx].GetName()
			disableEnemyRacesIDS[idx] = AddToggleOption(raceName, DisableRacesConfig[idx])
			idx += 1
		endwhile
		;AppUtil.Log(disableEnemyRacesIDS)
		
	elseif (page == "$YACRSystem")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$YACRSystem")
		
		;modEnabled = SSLYACR.IsRunning()
		;enableDisableID = AddToggleOption("$EnableDisableMain", modEnabled)
		
		keyCodeRegistID = AddKeyMapOption("$KeyCodeRegist", keyCodeRegist)
		keyCodeHelpID = AddKeyMapOption("$KeyCodeHelp", keyCodeHelp)
		keyCodeSubmitID = AddKeyMapOption("$KeyCodeSubmit", keyCodeSubmit)
		
		enableSimpleSlaverySupportID = AddToggleOption("$EnableSimpleSlaverySupport", enableSimpleSlaverySupport)
		simpleSlaveryChanceID = AddSliderOption("$SimpleSlaveryChance", simpleSlaveryChance)
		
		enableDrippingWASupportID = AddToggleOption("$EnableDrippingWASupport", enableDrippingWASupport)
		
		AddEmptyOption()
		
		AddHeaderOption("$YACRDebug")
		registNotifFlagID = AddToggleOption("$OutputRegistNotif", registNotifFlag)
		; debugNotifFlagID = AddToggleOption("$OutputPapyrusNotif", debugNotifFlag)
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
				AddTextOption(act.GetLeveledActorBase().GetName(), "")
			endif
			n += 1
		endWhile
	endif
EndEvent

string Function GetFlavor(string fkey)
	if (fkey == "REGISTING")
		return "$REGISTING"
	elseif (fkey == "REGISTING_FAIL")
		return "$REGISTING_FAIL"
	elseif (fkey == "CALLHELP")
		return "$CALLHELP"
	elseif (fkey == "CALLHELP_FAIL")
		return "$CALLHELP_FAIL"
	elseif (fkey == "GIVEUP")
		return "$GIVEUP"
	endif
EndFunction

int Function GetGlobal(string str)
	if (str == "OneMore")
		return SSLYACROneMore.GetValue() as int
	elseif (str == "OneMore2")
		return SSLYACROneMoreFromSecond.GetValue() as int
	elseif (str == "MultiPlay")
		return SSLYACRMultiPlay.GetValue() as int
	elseif (str == "5P")
		return SSLYACRMultiPlay5P.GetValue() as int
	elseif (str == "4P")
		return SSLYACRMultiPlay4P.GetValue() as int
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

int Function GetRapeChance(bool IsPlayer = true, bool IsPowerAttack = false)
	if (IsPlayer)
		if (!IsPowerAttack)
			return self.rapeChance
		else
			return self.rapeChancePA
		endif
	else
		if (!IsPowerAttack)
			return self.rapeChanceNPC
		else
			return self.rapeChanceNPCPA
		endif
	endif
EndFunction

int Function GetRapeChanceNotNaked(bool IsPlayer = true, bool IsPowerAttack = false)
	if (IsPlayer)
		if (!IsPowerAttack)
			return self.rapeChanceNotNaked
		else
			return self.rapeChanceNotNakedPA
		endif
	else
		if (!IsPowerAttack)
			return self.rapeChanceNotNakedNPC
		else
			return self.rapeChanceNotNakedNPCPA
		endif
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

int[] Function GetBreakChances(bool IsPlayer = true, bool IsPowerAttack = false)
	int[] chances = new int[3]
	
	if (IsPlayer)
		if (!IsPowerAttack)
			chances[0] = self.armorBreakChanceCloth
			chances[1] = self.armorBreakChanceLightArmor
			chances[2] = self.armorBreakChanceHeavyArmor
		else
			chances[0] = self.armorBreakChanceClothPA
			chances[1] = self.armorBreakChanceLightArmorPA
			chances[2] = self.armorBreakChanceHeavyArmorPA
		endif
	else
		if (!IsPowerAttack)
			chances[0] = self.armorBreakChanceClothNPC
			chances[1] = self.armorBreakChanceLightArmorNPC
			chances[2] = self.armorBreakChanceHeavyArmorNPC
		else
			chances[0] = self.armorBreakChanceClothNPCPA
			chances[1] = self.armorBreakChanceLightArmorNPCPA
			chances[2] = self.armorBreakChanceHeavyArmorNPCPA
		endif
	endif
	
	return chances
EndFunction

Event OnOptionHighlight(int option)
	;if (option == knockDownAllID)
	;	SetInfoText("$KnockDownAllInfo")
	if (option == enablePlayerRapeID)
		SetInfoText("$EnablePlayerRapeInfo")
	elseif (option == knockDownOnlyID)
		SetInfoText("$KnockDownOnlyInfo")
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
	elseif (option == registNotifFlagID)
		SetInfoText("$OutputRegistNotifInfo")
	;elseif (option == debugNotifFlagID)
	;	SetInfoText("$OutputPapyrusNotifInfo")
	;elseif (option == enableDisableID)
	;	SetInfoText("$EnableDisableMainInfo")
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
	elseif (disableEnemyRacesIDS.Find(option) > -1)
		SetInfoText("$DisableRacesInfo")
	elseif (option == enableDrippingWASupportID)
		SetInfoText("$EnableDrippingWASupportInfo")
	endif
EndEvent

Event OnOptionSelect(int option)
	;AppUtil.Log(option)
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
	elseif (option == knockDownOnlyID)
		knockDownOnly = !knockDownOnly
		SetToggleOptionValue(option, knockDownOnly)
		
	elseif (option == enableArmorUnequipModeID)
		enableArmorUnequipMode = !enableArmorUnequipMode
		SetToggleOptionValue(option, enableArmorUnequipMode)
	elseif (option == enableArmorUnequipModeNPCID)
		enableArmorUnequipModeNPC = !enableArmorUnequipModeNPC
		SetToggleOptionValue(option, enableArmorUnequipModeNPC)

	elseif (option == enableSimpleSlaverySupportID)
		enableSimpleSlaverySupport = !enableSimpleSlaverySupport
		SetToggleOptionValue(option, enableSimpleSlaverySupport)
	elseif (option == enableDrippingWASupportID)
		enableDrippingWASupport = !enableDrippingWASupport
		SetToggleOptionValue(option, enableDrippingWASupport)
		
	;elseif (option == knockDownAllID)
	;	knockDownAll = !knockDownAll
	;	SetToggleOptionValue(option, knockDownAll)
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(option, debugLogFlag)
	;elseif (option == debugNotifFlagID)
	;	debugNotifFlag = !debugNotifFlag
	;	SetToggleOptionValue(option, debugNotifFlag)
	elseif (option == registNotifFlagID)
		registNotifFlag = !registNotifFlag
		SetToggleOptionValue(option, registNotifFlag)

	;/
	elseif (option == enableDisableID)
		; modEnabled = SSLYACR.IsRunning()
		if (modEnabled)  ; is running
			if (SSLYACR.IsRunning())
				AppUtil.WakeUpAll()
				SSLYACR.Stop()
			endif
			debug.notification("SexLab YACR has stopped.")
		else
			if !(SSLYACR.IsRunning())
				SSLYACR.Start()
			endif
			debug.notification("SexLab YACR has started.")
		endif
		
		modEnabled = !modEnabled
		SetToggleOptionValue(option, modEnabled)
	/;
	
	elseif (disableEnemyRacesIDS.Find(option) > -1)
		int idx = disableEnemyRacesIDS.Find(option)
		bool opt = DisableRacesConfig[idx]
		DisableRacesConfig[idx] = !opt
		SetToggleOptionValue(option, !opt)
	endif
EndEvent

Event OnOptionSliderOpen(int option)
	; Player --------------------------------------
	if (option == healthLimitID)
		self._setSliderDialogWithPercentage(healthLimit)
	elseif (option == healthLimitBottomID)
		self._setSliderDialogWithPercentage(healthLimitBottom)

	elseif (option == rapeChanceID)
		self._setSliderDialogWithPercentage(rapeChance)
	elseif (option == rapeChanceNotNakedID)
		self._setSliderDialogWithPercentage(rapeChanceNotNaked)
	; PA
	elseif (option == rapeChancePAID)
		self._setSliderDialogWithPercentage(rapeChancePA)
	elseif (option == rapeChanceNotNakedPAID)
		self._setSliderDialogWithPercentage(rapeChanceNotNakedPA)

	elseif (option == armorBreakChanceClothID)
		self._setSliderDialogWithPercentage(armorBreakChanceCloth)
	elseif (option == armorBreakChanceLightArmorID)
		self._setSliderDialogWithPercentage(armorBreakChanceLightArmor)
	elseif (option == armorBreakChanceHeavyArmorID)
		self._setSliderDialogWithPercentage(armorBreakChanceHeavyArmor)
	; PA
	elseif (option == armorBreakChanceClothPAID)
		self._setSliderDialogWithPercentage(armorBreakChanceClothPA)
	elseif (option == armorBreakChanceLightArmorPAID)
		self._setSliderDialogWithPercentage(armorBreakChanceLightArmorPA)
	elseif (option == armorBreakChanceHeavyArmorPAID)
		self._setSliderDialogWithPercentage(armorBreakChanceHeavyArmorPA)

	; Follower --------------------------------------
	elseif (option == healthLimitNPCID)
		self._setSliderDialogWithPercentage(healthLimitNPC)
	elseif (option == healthLimitBottomNPCID)
		self._setSliderDialogWithPercentage(healthLimitBottomNPC)
		
	elseif (option == rapeChanceNPCID)
		self._setSliderDialogWithPercentage(rapeChanceNPC)
	elseif (option == rapeChanceNotNakedNPCID)
		self._setSliderDialogWithPercentage(rapeChanceNotNakedNPC)
	; PA
	elseif (option == rapeChanceNPCPAID)
		self._setSliderDialogWithPercentage(rapeChanceNPCPA)
	elseif (option == rapeChanceNotNakedNPCPAID)
		self._setSliderDialogWithPercentage(rapeChanceNotNakedNPCPA)

	elseif (option == armorBreakChanceClothNPCID)
		self._setSliderDialogWithPercentage(armorBreakChanceClothNPC)
	elseif (option == armorBreakChanceLightArmorNPCID)
		self._setSliderDialogWithPercentage(armorBreakChanceLightArmorNPC)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		self._setSliderDialogWithPercentage(armorBreakChanceHeavyArmorNPC)
	; PA
	elseif (option == armorBreakChanceClothNPCPAID)
		self._setSliderDialogWithPercentage(armorBreakChanceClothNPCPA)
	elseif (option == armorBreakChanceLightArmorNPCPAID)
		self._setSliderDialogWithPercentage(armorBreakChanceLightArmorNPCPA)
	elseif (option == armorBreakChanceHeavyArmorNPCPAID)
		self._setSliderDialogWithPercentage(armorBreakChanceHeavyArmorNPCPA)


	elseif (option == simpleSlaveryChanceID)
		self._setSliderDialogWithPercentage(simpleSlaveryChance)
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
	; Player --------------------------------------
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
	; PA
	elseif (option == rapeChancePAID)
		rapeChancePA = value as int
		SetSliderOptionValue(option, rapeChancePA)
	elseif (option == rapeChanceNotNakedPAID)
		rapeChanceNotNakedPA = value as int
		SetSliderOptionValue(option, rapeChanceNotNakedPA)
		
	elseif (option == armorBreakChanceClothID)
		armorBreakChanceCloth = value as int
		SetSliderOptionValue(option, armorBreakChanceCloth)
	elseif (option == armorBreakChanceLightArmorID)
		armorBreakChanceLightArmor = value as int
		SetSliderOptionValue(option, armorBreakChanceLightArmor)
	elseif (option == armorBreakChanceHeavyArmorID)
		armorBreakChanceHeavyArmor = value as int
		SetSliderOptionValue(option, armorBreakChanceHeavyArmor)
	; PA
	elseif (option == armorBreakChanceClothPAID)
		armorBreakChanceClothPA = value as int
		SetSliderOptionValue(option, armorBreakChanceClothPA)
	elseif (option == armorBreakChanceLightArmorPAID)
		armorBreakChanceLightArmorPA = value as int
		SetSliderOptionValue(option, armorBreakChanceLightArmorPA)
	elseif (option == armorBreakChanceHeavyArmorPAID)
		armorBreakChanceHeavyArmorPA = value as int
		SetSliderOptionValue(option, armorBreakChanceHeavyArmorPA)

	; Follower --------------------------------------
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
	; PA
	elseif (option == rapeChanceNPCPAID)
		rapeChanceNPCPA = value as int
		SetSliderOptionValue(option, rapeChanceNPCPA)
	elseif (option == rapeChanceNotNakedNPCPAID)
		rapeChanceNotNakedNPCPA = value as int
		SetSliderOptionValue(option, rapeChanceNotNakedNPCPA)
		
	elseif (option == armorBreakChanceClothNPCID)
		armorBreakChanceClothNPC = value as int
		SetSliderOptionValue(option, armorBreakChanceClothNPC)
	elseif (option == armorBreakChanceLightArmorNPCID)
		armorBreakChanceLightArmorNPC = value as int
		SetSliderOptionValue(option, armorBreakChanceLightArmorNPC)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		armorBreakChanceHeavyArmorNPC = value as int
		SetSliderOptionValue(option, armorBreakChanceHeavyArmorNPC)
	; PA
	elseif (option == armorBreakChanceClothNPCPAID)
		armorBreakChanceClothNPCPA = value as int
		SetSliderOptionValue(option, armorBreakChanceClothNPCPA)
	elseif (option == armorBreakChanceLightArmorNPCPAID)
		armorBreakChanceLightArmorNPCPA = value as int
		SetSliderOptionValue(option, armorBreakChanceLightArmorNPCPA)
	elseif (option == armorBreakChanceHeavyArmorNPCPAID)
		armorBreakChanceHeavyArmorNPCPA = value as int
		SetSliderOptionValue(option, armorBreakChanceHeavyArmorNPCPA)

	elseif (option == simpleSlaveryChanceID)
		simpleSlaveryChance = value as int
		SetSliderOptionValue(option, simpleSlaveryChance)
	endif
EndEvent

event OnOptionMenuOpen(int option)
	if (option == matchedSexID)
		SetMenuDialogStartIndex(matchedSex)
	elseif (option == matchedSexNPCID)
		SetMenuDialogStartIndex(matchedSexNPC)
	endif
	
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
	endif
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

Quest Property SSLYACRQuestManager  Auto  
Quest Property SSLYACR  Auto  

GlobalVariable Property SSLYACROneMore  Auto  
GlobalVariable Property SSLYACROneMoreFromSecond  Auto  
GlobalVariable Property SSLYACRMultiPlay  Auto  
GlobalVariable Property SSLYACRMultiPlay5P  Auto  
GlobalVariable Property SSLYACRMultiPlay4P  Auto  
