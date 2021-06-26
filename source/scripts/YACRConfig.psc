Scriptname YACRConfig extends SKI_ConfigBase  

bool Property modEnabled = true Auto
bool Property debugNotifFlag = true Auto
bool Property debugLogFlag = false Auto
bool Property registNotifFlag = true Auto
bool Property knockDownAll = true Auto

; Player ========================================
bool Property enablePlayerRape = true Auto
bool Property knockDownOnly = false Auto

int Property matchedSex = 0 Auto
int Property healthLimit = 50 Auto
int Property healthLimitBottom = 0 Auto
bool Property enableEndlessRape = true Auto
int Property attackDistanceLimit = 750 Auto

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

; EABDialogue ========================================
bool Property EnableEABD = false auto
int Property rapeChanceTBless = 40 Auto
int Property rapeChanceSeeThrough = 30 Auto
int Property rapeChanceUnderwear = 20 Auto
int Property rapeChanceTBlessPA = 65 Auto
int Property rapeChanceSeeThroughPA = 55 Auto
int Property rapeChanceUnderwearPA = 45 Auto

; Follower ========================================
int Property matchedSexNPC = 0 Auto
int Property healthLimitNPC = 50 Auto
int Property healthLimitBottomNPC = 0 Auto
bool Property enableEndlessRapeNPC = true Auto
int Property attackDistanceLimitNPC = 0 Auto

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

bool Property enableWeCantDieSupport = false Auto
int Property weCantDieChance = 100 Auto
bool Property enableSimpleSlaverySupport = false Auto
int Property simpleSlaveryChance = 100 Auto
bool Property enableUtilOneSupport = false Auto
bool Property enableDrippingWASupport = false Auto
bool Property enableSendOrgasm = true Auto

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
int audienceDistanceID
int enableWeCantDieSupportID
int weCantDieChanceID
int enableSimpleSlaverySupportID
int simpleSlaveryChanceID
int enableUtilOneSupportID
int enableDrippingWASupportID
int enableSendOrgasmID

; Player ========================================
int enablePlayerRapeID
int knockDownOnlyID

int matchedSexID
int healthLimitID
int healthLimitBottomID
int enableEndlessRapeID
int attackDistanceLimitID

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

; EABDialogue ========================================
int EnableEABDID
int rapeChanceTBlessID
int rapeChanceSeeThroughID
int rapeChanceUnderwearID
int rapeChanceTBlessPAID
int rapeChanceSeeThroughPAID
int rapeChanceUnderwearPAID

; Follower ========================================
int matchedSexNPCID
int healthLimitNPCID
int healthLimitBottomNPCID
int enableEndlessRapeNPCID
int attackDistanceLimitNPCID

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

int configMaleSaveID
int configMaleLoadID
int configFemaleSaveID
int configFemaleLoadID

string configFileForMale = "../SexLabYACRMaleConfig.json"
string configFileForFemale = "../SexLabYACRFemaleConfig.json"

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
	
	Pages = new string[7]
	Pages[0] = "$YACRRapeChance"
	Pages[1] = "$YACREABD"
	Pages[2] = "$YACRArmorBreak"
	Pages[3] = "$YACREnemy"
	Pages[4] = "$YACRSystem"
	Pages[5] = "$YACRTeammates"
	Pages[6] = "$YACRProfile"
	
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
		
		enablePlayerRapeID = AddToggleOption("$YACREnablePlayerRape", enablePlayerRape)
		
		AddHeaderOption("$YACRPlayerCharactor")
		matchedSexID = AddMenuOption("$YACRMatchedSex", matchedSexList[matchedSex])
		healthLimitID = AddSliderOption("$YACRHealthLimit", healthLimit)
		healthLimitBottomID = AddSliderOption("$YACRHealthLimitBottom", healthLimitBottom)
		enableEndlessRapeID = AddToggleOption("$YACREndlessRape", enableEndlessRape)
		attackDistanceLimitID = AddSliderOption("$YACRAttackDistanceLimit", attackDistanceLimit)
		
		AddHeaderOption("$YACRRapeChance")
		rapeChanceID = AddSliderOption("$YACRNaked", rapeChance)
		rapeChanceNotNakedID = AddSliderOption("$YACRNotNaked", rapeChanceNotNaked)
		rapeChancePAID = AddSliderOption("$YACRNakedPowerAttack", rapeChancePA)
		rapeChanceNotNakedPAID = AddSliderOption("$YACRNotNakedPowerAttack", rapeChanceNotNakedPA)
		
		SetCursorPosition(1)
		
		knockDownOnlyID = AddToggleOption("$YACRKnockDownOnly", knockDownOnly)
		
		AddHeaderOption("$YACRFollower")
		matchedSexNPCID = AddMenuOption("$YACRMatchedSex", matchedSexList[matchedSexNPC])
		healthLimitNPCID = AddSliderOption("$YACRHealthLimit", healthLimitNPC)
		healthLimitBottomNPCID = AddSliderOption("$YACRHealthLimitBottom", healthLimitBottomNPC)
		enableEndlessRapeNPCID = AddToggleOption("$YACREndlessRape", enableEndlessRapeNPC)
		attackDistanceLimitNPCID = AddSliderOption("$YACRAttackDistanceLimit", attackDistanceLimitNPC)
		
		AddHeaderOption("$YACRRapeChance")
		rapeChanceNPCID = AddSliderOption("$YACRNaked", rapeChanceNPC)
		rapeChanceNotNakedNPCID = AddSliderOption("$YACRNotNaked", rapeChanceNotNakedNPC)
		rapeChanceNPCPAID = AddSliderOption("$YACRNakedPowerAttack", rapeChanceNPCPA)
		rapeChanceNotNakedNPCPAID = AddSliderOption("$YACRNotNakedPowerAttack", rapeChanceNotNakedNPCPA)
		
	elseif (page == "$YACREABD")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		if Game.GetModByName("EABdialogue.esp") < 255
			EnableEABDID = AddToggleOption("$YEABD_Use", EnableEABD)
		else
			EnableEABD = false
			EnableEABDID = AddToggleOption("$YEABD_Use", EnableEABD, OPTION_FLAG_DISABLED)
		endif
		
		AddHeaderOption("$YEABD_PCRapeChance")
		rapeChanceID = AddSliderOption("$YACRNaked", rapeChance)
		if (EnableEABD)
			rapeChanceTBlessID = AddSliderOption("$YEABD_TBless", rapeChanceTBless)
			rapeChanceSeeThroughID = AddSliderOption("$YEABD_SeeThrough", rapeChanceSeeThrough)
			rapeChanceUnderwearID = AddSliderOption("$YEABD_Underwear", rapeChanceUnderwear)
		else
			rapeChanceTBlessID = AddSliderOption("$YEABD_TBless", rapeChanceTBless, "{0}", OPTION_FLAG_DISABLED)
			rapeChanceSeeThroughID = AddSliderOption("$YEABD_SeeThrough", rapeChanceSeeThrough, "{0}",OPTION_FLAG_DISABLED)
			rapeChanceUnderwearID = AddSliderOption("$YEABD_Underwear", rapeChanceUnderwear, "{0}",OPTION_FLAG_DISABLED)
		endif
		rapeChanceNotNakedID = AddSliderOption("$YACRNotNaked", rapeChanceNotNaked)
		
		rapeChancePAID = AddSliderOption("$YACRNakedPowerAttack", rapeChancePA)
		if (EnableEABD)
			rapeChanceTBlessPAID = AddSliderOption("$YEABD_TBlessPowerAttack", rapeChanceTBlessPA)
			rapeChanceSeeThroughPAID = AddSliderOption("$YEABD_SeeThroughPowerAttack", rapeChanceSeeThroughPA)
			rapeChanceUnderwearPAID = AddSliderOption("$YEABD_UnderwearPowerAttack", rapeChanceUnderwearPA)
		else
			rapeChanceTBlessPAID = AddSliderOption("$YEABD_TBlessPowerAttack", rapeChanceTBlessPA, "{0}",OPTION_FLAG_DISABLED)
			rapeChanceSeeThroughPAID = AddSliderOption("$YEABD_SeeThroughPowerAttack", rapeChanceSeeThroughPA, "{0}",OPTION_FLAG_DISABLED)
			rapeChanceUnderwearPAID = AddSliderOption("$YEABD_UnderwearPowerAttack", rapeChanceUnderwearPA, "{0}",OPTION_FLAG_DISABLED)
		endif
		rapeChanceNotNakedPAID = AddSliderOption("$YACRNotNakedPowerAttack", rapeChanceNotNakedPA)

		SetCursorPosition(1)
		AddTextOption("$YEABD_FollowerInfo", "", OPTION_FLAG_DISABLED)
		
		AddHeaderOption("$YEABD_FollowerRapeChance")
		rapeChanceNPCID = AddSliderOption("$YACRNaked", rapeChanceNPC)
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		rapeChanceNotNakedNPCID = AddSliderOption("$YACRNotNaked", rapeChanceNotNakedNPC)
		rapeChanceNPCPAID = AddSliderOption("$YACRNakedPowerAttack", rapeChanceNPCPA)
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		rapeChanceNotNakedNPCPAID = AddSliderOption("$YACRNotNakedPowerAttack", rapeChanceNotNakedNPCPA)

	elseif (page == "$YACRArmorBreak")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)
		
		AddHeaderOption("$YACRPlayerCharactor")
		enableArmorBreakID = AddToggleOption("$YACREnable", enableArmorBreak)
		enableArmorUnequipModeID = AddToggleOption("$YACREnableArmorUnequipMode", enableArmorUnequipMode)
		
		AddHeaderOption("$YACRArmorBreakAttack")
		armorBreakChanceClothID = AddSliderOption("$YACRCloth", armorBreakChanceCloth)
		armorBreakChanceLightArmorID = AddSliderOption("$YACRLightArmor", armorBreakChanceLightArmor)
		armorBreakChanceHeavyArmorID = AddSliderOption("$YACRHeavyArmor", armorBreakChanceHeavyArmor)
		
		AddHeaderOption("$YACRArmorBreakPowerAttack")
		armorBreakChanceClothPAID = AddSliderOption("$YACRCloth", armorBreakChanceClothPA)
		armorBreakChanceLightArmorPAID = AddSliderOption("$YACRLightArmor", armorBreakChanceLightArmorPA)
		armorBreakChanceHeavyArmorPAID = AddSliderOption("$YACRHeavyArmor", armorBreakChanceHeavyArmorPA)
		
		SetCursorPosition(1)
		
		AddHeaderOption("$YACRFollower")
		enableArmorBreakNPCID = AddToggleOption("$YACREnable", enableArmorBreakNPC)
		enableArmorUnequipModeNPCID = AddToggleOption("$YACREnableArmorUnequipMode", enableArmorUnequipModeNPC)
		
		AddHeaderOption("$YACRArmorBreakAttack")
		armorBreakChanceClothNPCID = AddSliderOption("$YACRCloth", armorBreakChanceClothNPC)
		armorBreakChanceLightArmorNPCID = AddSliderOption("$YACRLightArmor", armorBreakChanceLightArmorNPC)
		armorBreakChanceHeavyArmorNPCID = AddSliderOption("$YACRHeavyArmor", armorBreakChanceHeavyArmorNPC)
		
		AddHeaderOption("$YACRArmorBreakPowerAttack")
		armorBreakChanceClothNPCPAID = AddSliderOption("$YACRCloth", armorBreakChanceClothNPCPA)
		armorBreakChanceLightArmorNPCPAID = AddSliderOption("$YACRLightArmor", armorBreakChanceLightArmorNPCPA)
		armorBreakChanceHeavyArmorNPCPAID = AddSliderOption("$YACRHeavyArmor", armorBreakChanceHeavyArmorNPCPA)

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
		
		keyCodeRegistID = AddKeyMapOption("$YACRKeyCodeRegist", keyCodeRegist)
		keyCodeHelpID = AddKeyMapOption("$YACRKeyCodeHelp", keyCodeHelp)
		keyCodeSubmitID = AddKeyMapOption("$YACRKeyCodeSubmit", keyCodeSubmit)
		audienceDistanceID = AddSliderOption("$YACRAudienceDistance", SSLYACRAudienceDistance.GetValue() as int)
		
		AddEmptyOption()
		
		AddHeaderOption("$YACRDebug")
		registNotifFlagID = AddToggleOption("$YACROutputRegistNotif", registNotifFlag)
		; debugNotifFlagID = AddToggleOption("$YACROutputPapyrusNotif", debugNotifFlag)
		debugLogFlagID = AddToggleOption("$YACROutputPapyrusLog", debugLogFlag)
		; knockDownAllID = AddToggleOption("$YACRKnockDownAll", knockDownAll) ; not support from 2.0alpha1
		
		SetCursorPosition(1)
		
		AddHeaderOption("$YACRModLink")
		
		enableWeCantDieSupportID = AddToggleOption("$YACREnableWeCantDieSupport", enableWeCantDieSupport)
		weCantDieChanceID = AddSliderOption("$YACRWeCantDieChance", weCantDieChance)
		enableSimpleSlaverySupportID = AddToggleOption("$YACREnableSimpleSlaverySupport", enableSimpleSlaverySupport)
		simpleSlaveryChanceID = AddSliderOption("$YACRSimpleSlaveryChance", simpleSlaveryChance)
		enableUtilOneSupportID = AddToggleOption("$YACREnableUtilOneSupport", enableUtilOneSupport)
		enableDrippingWASupportID = AddToggleOption("$YACREnableDrippingWASupport", enableDrippingWASupport)
		
		enableSendOrgasmID = AddToggleOption("$YACREnableSendOrgasm", enableSendOrgasm)
		
	elseif (page == "$YACRTeammates")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)

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
	elseif (page == "$YACRProfile")
		SetCursorFillMode(TOP_TO_BOTTOM)

		SetCursorPosition(0)
		AddHeaderOption("$YACRConfigFemale")
		configFemaleSaveID = AddTextOption("$YACRConfigSave", "$YACRDoIt")
		if (JsonUtil.JsonExists(configFileForFemale))
			configFemaleLoadID = AddTextOption("$YACRConfigLoad", "$YACRDoIt")
		else
			configFemaleLoadID = AddTextOption("$YACRConfigLoad", "$YACRDoIt", OPTION_FLAG_DISABLED)
		endif

		SetCursorPosition(1)
		AddHeaderOption("$YACRConfigMale")
		configMaleSaveID = AddTextOption("$YACRConfigSave", "$YACRDoIt")
		if (JsonUtil.JsonExists(configFileForMale))
			configMaleLoadID = AddTextOption("$YACRConfigLoad", "$YACRDoIt")
		else
			configMaleLoadID = AddTextOption("$YACRConfigLoad", "$YACRDoIt", OPTION_FLAG_DISABLED)
		endif
	endif
EndEvent

string Function GetFlavor(string fkey)
	if (fkey == "REGISTING")
		if (knockDownOnly)
			return "$YACRREGISTING_KDONLY"
		else
			return "$YACRREGISTING"
		endif
	elseif (fkey == "REGISTING_FAIL")
		if (knockDownOnly)
			return "$YACRREGISTING_FAIL_KDONLY"
		else
			return "$YACRREGISTING_FAIL"
		endif
	elseif (fkey == "CALLHELP")
		return "$YACRCALLHELP"
	elseif (fkey == "CALLHELP_FAIL")
		return "$YACRCALLHELP_FAIL"
	elseif (fkey == "GIVEUP")
		return "$YACRGIVEUP"
		
	elseif (fkey == "REGISTING_DEATH")
		return "$YACRREGISTING_DEATH"
	elseif (fkey == "CALLHELP_DEATH")
		return "$YACRCALLHELP_DEATH"
	elseif (fkey == "GIVEUP_DEATH")
		return "$YACRGIVEUP_DEATH"
	endif
EndFunction

int Function GetGlobal(string str)
	if (str == "OneMore")
		return SSLYACROneMore.GetValue() as int
	elseif (str == "OneMoreFromSecond")
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

int Function GetRapeChanceTBless(bool IsPowerAttack = false)
	if (!IsPowerAttack)
		return self.rapeChanceTBless
	else
		return self.rapeChanceTBlessPA
	endif
EndFunction

int Function GetRapeChanceSeeThrough(bool IsPowerAttack = false)
	if (!IsPowerAttack)
		return self.rapeChanceSeeThrough
	else
		return self.rapeChanceSeeThroughPA
	endif
EndFunction

int Function GetRapeChanceUnderwear(bool IsPowerAttack = false)
	if (!IsPowerAttack)
		return self.rapeChanceUnderwear
	else
		return self.rapeChanceUnderwearPA
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

int Function GetAttackDistanceLimit(bool IsPlayer = true)
	if (IsPlayer)
		return self.attackDistanceLimit
	else
		return self.attackDistanceLimitNPC
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
	if (option == enablePlayerRapeID)
		SetInfoText("$YACREnablePlayerRapeInfo")
	elseif (option == knockDownOnlyID)
		SetInfoText("$YACRKnockDownOnlyInfo")
	elseif (option == enableArmorUnequipModeID || option == enableArmorUnequipModeNPCID)
		SetInfoText("$YACREnableArmorUnequipModeInfo")
	elseif (option == matchedSexID || option == matchedSexNPCID)
		SetInfoText("$YACRMatchedSexInfo")
	elseif (option == healthLimitID || option == healthLimitNPCID)
		SetInfoText("$YACRHealthLimitInfo")
	elseif (option == healthLimitBottomID || option == healthLimitBottomNPCID)
		SetInfoText("$YACRHealthLimitBottomInfo")
	elseif (option == enableEndlessRapeID || option == enableEndlessRapeNPCID)
		SetInfoText("$YACREndlessRapeInfo")
	elseif (option == attackDistanceLimitID || option == attackDistanceLimitNPCID)
		SetInfoText("$YACRAttackDistanceLimitInfo")
		
	elseif (option == EnableEABDID)
		SetInfoText("$YEABD_UseInfo")
	elseif (option == rapeChanceTBlessID || option == rapeChanceTBlessPAID)
		SetInfoText("$YEABD_TBlessInfo")
	elseif (option == rapeChanceSeeThroughID || option == rapeChanceSeeThroughPAID)
		SetInfoText("$YEABD_SeeThroughInfo")
	elseif (option == rapeChanceUnderwearID || option == rapeChanceUnderwearPAID)
		SetInfoText("$YEABD_UnderwearInfo")
		
	elseif (option == registNotifFlagID)
		SetInfoText("$YACROutputRegistNotifInfo")
	;elseif (option == enableDisableID)
	;	SetInfoText("$EnableDisableMainInfo")
	elseif (option == keyCodeRegistID)
		SetInfoText("$YACRKeyCodeRegistInfo")
	elseif (option == keyCodeHelpID)
		SetInfoText("$YACRKeyCodeHelpInfo")
	elseif (option == keyCodeSubmitID)
		SetInfoText("$YACRKeyCodeSubmitInfo")
	elseif (option == audienceDistanceID)
		SetInfoText("$YACRAudienceDistanceInfo")
		
	elseif (option == enableWeCantDieSupportID)
		SetInfoText("$YACREnableWeCantDieSupportInfo")
	elseif (option == weCantDieChanceID)
		SetInfoText("$YACRWeCantDieChanceInfo")
	elseif (option == enableSimpleSlaverySupportID)
		SetInfoText("$YACREnableSimpleSlaverySupportInfo")
	elseif (option == simpleSlaveryChanceID)
		SetInfoText("$YACRSimpleSlaveryChanceInfo")
	elseif (disableEnemyRacesIDS.Find(option) > -1)
		SetInfoText("$YACRDisableRacesInfo")
	elseif (option == enableUtilOneSupportID)
		SetInfoText("$YACREnableUtilOneSupportInfo")
	elseif (option == enableDrippingWASupportID)
		SetInfoText("$YACREnableDrippingWASupportInfo")
	elseif (option == enableSendOrgasmID)
		SetInfoText("$YACREnableSendOrgasmInfo")
		
	elseif (option == configMaleSaveID || option == configFemaleSaveID)
		SetInfoText("$YACRConfigSaveInfo")
	elseif (option == configMaleLoadID || option == configFemaleLoadID)
		SetInfoText("$YACRConfigLoadInfo")

	endif
EndEvent

Event OnOptionSelect(int option)
	;AppUtil.Log(option)
	if (option == enableArmorBreakID)
		enableArmorBreak = !enableArmorBreak
		SetToggleOptionValue(option, enableArmorBreak)
	elseif (option == enableArmorBreakNPCID)
		enableArmorBreakNPC = !enableArmorBreakNPC
		SetToggleOptionValue(option, enableArmorBreakNPC)
		
	elseif (option == enableEndlessRapeID)
		enableEndlessRape = !enableEndlessRape
		SetToggleOptionValue(option, enableEndlessRape)
	elseif (option == enableEndlessRapeNPCID)
		enableEndlessRapeNPC = !enableEndlessRapeNPC
		SetToggleOptionValue(option, enableEndlessRapeNPC)
		
	elseif (option == enablePlayerRapeID)
		enablePlayerRape = !enablePlayerRape
		SetToggleOptionValue(option, enablePlayerRape)
	elseif (option == knockDownOnlyID)
		knockDownOnly = !knockDownOnly
		SetToggleOptionValue(option, knockDownOnly)

	elseif (option == EnableEABDID)
		EnableEABD = !EnableEABD
		SetToggleOptionValue(option, EnableEABD)
		ForcePageReset()
		
	elseif (option == enableArmorUnequipModeID)
		enableArmorUnequipMode = !enableArmorUnequipMode
		SetToggleOptionValue(option, enableArmorUnequipMode)
	elseif (option == enableArmorUnequipModeNPCID)
		enableArmorUnequipModeNPC = !enableArmorUnequipModeNPC
		SetToggleOptionValue(option, enableArmorUnequipModeNPC)

	elseif (option == enableWeCantDieSupportID)
		enableWeCantDieSupport = !enableWeCantDieSupport
		SetToggleOptionValue(option, enableWeCantDieSupport)
	elseif (option == enableSimpleSlaverySupportID)
		enableSimpleSlaverySupport = !enableSimpleSlaverySupport
		SetToggleOptionValue(option, enableSimpleSlaverySupport)
	elseif (option == enableUtilOneSupportID)
		enableUtilOneSupport = !enableUtilOneSupport
		SetToggleOptionValue(option, enableUtilOneSupport)
	elseif (option == enableDrippingWASupportID)
		enableDrippingWASupport = !enableDrippingWASupport
		SetToggleOptionValue(option, enableDrippingWASupport)
	elseif (option == enableSendOrgasmID)
		enableSendOrgasm = !enableSendOrgasm
		SetToggleOptionValue(option, enableSendOrgasm)
		
	;elseif (option == knockDownAllID)
	;	knockDownAll = !knockDownAll
	;	SetToggleOptionValue(option, knockDownAll)
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(option, debugLogFlag)
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
	
	elseif (option == configMaleSaveID)
		self.saveConfig(configFileForMale)
		SetTextOptionValue(option, "$YACRDone")
	elseif (option == configFemaleSaveID)
		self.saveConfig(configFileForFemale)
		SetTextOptionValue(option, "$YACRDone")
	elseif (option == configMaleLoadID)
		self.loadConfig(configFileForMale)
		SetTextOptionValue(option, "$YACRDone")
	elseif (option == configFemaleLoadID)
		self.loadConfig(configFileForFemale)
		SetTextOptionValue(option, "$YACRDone")

	endif
EndEvent

Event OnOptionSliderOpen(int option)
	; Player --------------------------------------
	if (option == attackDistanceLimitID)
		self._setSliderDialogWithDistance(attackDistanceLimit)
		
	elseif (option == healthLimitID)
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

	; EABD ------------------------------------------

	elseif (option == rapeChanceTBlessID)
		self._setSliderDialogWithPercentage(rapeChanceTBless)
	elseif (option == rapeChanceSeeThroughID)
		self._setSliderDialogWithPercentage(rapeChanceSeeThrough)
	elseif (option == rapeChanceUnderwearID)
		self._setSliderDialogWithPercentage(rapeChanceUnderwear)
	; PA
	elseif (option == rapeChanceTBlessPAID)
		self._setSliderDialogWithPercentage(rapeChanceTBlessPA)
	elseif (option == rapeChanceSeeThroughPAID)
		self._setSliderDialogWithPercentage(rapeChanceSeeThroughPA)
	elseif (option == rapeChanceUnderwearPAID)
		self._setSliderDialogWithPercentage(rapeChanceUnderwearPA)

	; Follower --------------------------------------
	elseif (option == attackDistanceLimitNPCID)
		self._setSliderDialogWithDistance(attackDistanceLimitNPC)
	
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

	elseif (option == audienceDistanceID)
		self._setSliderDialogWithDistance(SSLYACRAudienceDistance.GetValue() as int)
	
	elseif (option == weCantDieChanceID)
		self._setSliderDialogWithPercentage(weCantDieChance)
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

Function _setSliderDialogWithDistance(int x)
	SetSliderDialogStartValue(x)
	SetSliderDialogDefaultValue(x)
	
	SetSliderDialogRange(0.0, 2500.0)
	SetSliderDialogInterval(50.0)
EndFunction

Event OnOptionSliderAccept(int option, float value)
	int ivalue = value as int

	; Player --------------------------------------
	if (option == attackDistanceLimitID)
		attackDistanceLimit = ivalue
	elseif (option == healthLimitID)
		healthLimit = ivalue
	elseif (option == healthLimitBottomID)
		healthLimitBottom = ivalue
		
	elseif (option == rapeChanceID)
		rapeChance = ivalue
	elseif (option == rapeChanceNotNakedID)
		rapeChanceNotNaked = ivalue
	; PA
	elseif (option == rapeChancePAID)
		rapeChancePA = ivalue
	elseif (option == rapeChanceNotNakedPAID)
		rapeChanceNotNakedPA = ivalue
		
	elseif (option == armorBreakChanceClothID)
		armorBreakChanceCloth = ivalue
	elseif (option == armorBreakChanceLightArmorID)
		armorBreakChanceLightArmor = ivalue
	elseif (option == armorBreakChanceHeavyArmorID)
		armorBreakChanceHeavyArmor = ivalue
	; PA
	elseif (option == armorBreakChanceClothPAID)
		armorBreakChanceClothPA = ivalue
	elseif (option == armorBreakChanceLightArmorPAID)
		armorBreakChanceLightArmorPA = ivalue
	elseif (option == armorBreakChanceHeavyArmorPAID)
		armorBreakChanceHeavyArmorPA = ivalue

	; EABD ------------------------------------------
	elseif (option == rapeChanceTBlessID)
		rapeChanceTBless = ivalue
	elseif (option == rapeChanceSeeThroughID)
		rapeChanceSeeThrough = ivalue
	elseif (option == rapeChanceUnderwearID)
		rapeChanceUnderwear = ivalue
	
	; PA
	elseif (option == rapeChanceTBlessPAID)
		rapeChanceTBlessPA = ivalue
	elseif (option == rapeChanceSeeThroughPAID)
		rapeChanceSeeThroughPA = ivalue
	elseif (option == rapeChanceUnderwearPAID)
		rapeChanceUnderwearPA = ivalue

	; Follower --------------------------------------
	elseif (option == attackDistanceLimitNPCID)
		attackDistanceLimitNPC = ivalue
	elseif (option == healthLimitNPCID)
		healthLimitNPC = ivalue
	elseif (option == healthLimitBottomNPCID)
		healthLimitBottomNPC = ivalue
		
	elseif (option == rapeChanceNPCID)
		rapeChanceNPC = ivalue
	elseif (option == rapeChanceNotNakedNPCID)
		rapeChanceNotNakedNPC = ivalue
	; PA
	elseif (option == rapeChanceNPCPAID)
		rapeChanceNPCPA = ivalue
	elseif (option == rapeChanceNotNakedNPCPAID)
		rapeChanceNotNakedNPCPA = ivalue
		
	elseif (option == armorBreakChanceClothNPCID)
		armorBreakChanceClothNPC = ivalue
	elseif (option == armorBreakChanceLightArmorNPCID)
		armorBreakChanceLightArmorNPC = ivalue
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		armorBreakChanceHeavyArmorNPC = ivalue
	; PA
	elseif (option == armorBreakChanceClothNPCPAID)
		armorBreakChanceClothNPCPA = ivalue
	elseif (option == armorBreakChanceLightArmorNPCPAID)
		armorBreakChanceLightArmorNPCPA = ivalue
	elseif (option == armorBreakChanceHeavyArmorNPCPAID)
		armorBreakChanceHeavyArmorNPCPA = ivalue

	elseif (option == audienceDistanceID)
		SSLYACRAudienceDistance.SetValue(ivalue)
	elseif (option == weCantDieChanceID)
		weCantDieChance = ivalue
	elseif (option == simpleSlaveryChanceID)
		simpleSlaveryChance = ivalue
	endif
	
	SetSliderOptionValue(option, ivalue)
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

; Profile

Function saveConfig(string configFile)
	JsonUtil.SetIntValue(configFile, "modEnabled", modEnabled as int)
	JsonUtil.SetIntValue(configFile, "debugNotifFlag", debugNotifFlag as int)
	JsonUtil.SetIntValue(configFile, "debugLogFlag", debugLogFlag as int)
	JsonUtil.SetIntValue(configFile, "registNotifFlag", registNotifFlag as int)
	JsonUtil.SetIntValue(configFile, "knockDownAll", knockDownAll as int)

	JsonUtil.SetIntValue(configFile, "enablePlayerRape", enablePlayerRape as int)
	JsonUtil.SetIntValue(configFile, "knockDownOnly", knockDownOnly as int)

	JsonUtil.SetIntValue(configFile, "matchedSex", matchedSex)
	JsonUtil.SetIntValue(configFile, "healthLimit", healthLimit)
	JsonUtil.SetIntValue(configFile, "healthLimitBottom", healthLimitBottom)
	JsonUtil.SetIntValue(configFile, "enableEndlessRape", enableEndlessRape as int)
	JsonUtil.SetIntValue(configFile, "attackDistanceLimit", attackDistanceLimit)

	JsonUtil.SetIntValue(configFile, "rapeChance", rapeChance)
	JsonUtil.SetIntValue(configFile, "rapeChanceNotNaked", rapeChanceNotNaked)
	JsonUtil.SetIntValue(configFile, "rapeChancePA", rapeChancePA)
	JsonUtil.SetIntValue(configFile, "rapeChanceNotNakedPA", rapeChanceNotNakedPA)
	
	JsonUtil.SetIntValue(configFile, "EnableEABD", EnableEABD as int)
	JsonUtil.SetIntValue(configFile, "rapeChanceTBless", rapeChanceTBless)
	JsonUtil.SetIntValue(configFile, "rapeChanceSeeThrough", rapeChanceSeeThrough)
	JsonUtil.SetIntValue(configFile, "rapeChanceUnderwear", rapeChanceUnderwear)
	JsonUtil.SetIntValue(configFile, "rapeChanceTBlessPA", rapeChanceTBlessPA)
	JsonUtil.SetIntValue(configFile, "rapeChanceSeeThroughPA", rapeChanceSeeThroughPA)
	JsonUtil.SetIntValue(configFile, "rapeChanceUnderwearPA", rapeChanceUnderwearPA)

	JsonUtil.SetIntValue(configFile, "enableArmorBreak", enableArmorBreak as int)
	JsonUtil.SetIntValue(configFile, "enableArmorUnequipMode", enableArmorUnequipMode as int)

	JsonUtil.SetIntValue(configFile, "armorBreakChanceCloth", armorBreakChanceCloth)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceLightArmor", armorBreakChanceLightArmor)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceHeavyArmor", armorBreakChanceHeavyArmor)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceClothPA", armorBreakChanceClothPA)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceLightArmorPA", armorBreakChanceLightArmorPA)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceHeavyArmorPA", armorBreakChanceHeavyArmorPA)

	JsonUtil.SetIntValue(configFile, "matchedSexNPC", matchedSexNPC)
	JsonUtil.SetIntValue(configFile, "healthLimitNPC", healthLimitNPC)
	JsonUtil.SetIntValue(configFile, "healthLimitBottomNPC", healthLimitBottomNPC)
	JsonUtil.SetIntValue(configFile, "enableEndlessRapeNPC", enableEndlessRapeNPC as int)
	JsonUtil.SetIntValue(configFile, "attackDistanceLimitNPC", attackDistanceLimitNPC)

	JsonUtil.SetIntValue(configFile, "rapeChanceNPC", rapeChanceNPC)
	JsonUtil.SetIntValue(configFile, "rapeChanceNotNakedNPC", rapeChanceNotNakedNPC)
	JsonUtil.SetIntValue(configFile, "rapeChanceNPCPA", rapeChanceNPCPA)
	JsonUtil.SetIntValue(configFile, "rapeChanceNotNakedNPCPA", rapeChanceNotNakedNPCPA)

	JsonUtil.SetIntValue(configFile, "enableArmorBreakNPC", enableArmorBreakNPC as int)
	JsonUtil.SetIntValue(configFile, "enableArmorUnequipModeNPC", enableArmorUnequipModeNPC as int)

	JsonUtil.SetIntValue(configFile, "armorBreakChanceClothNPC", armorBreakChanceClothNPC)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceLightArmorNPC", armorBreakChanceLightArmorNPC)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceHeavyArmorNPC", armorBreakChanceHeavyArmorNPC)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceClothNPCPA", armorBreakChanceClothNPCPA)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceLightArmorNPCPA", armorBreakChanceLightArmorNPCPA)
	JsonUtil.SetIntValue(configFile, "armorBreakChanceHeavyArmorNPCPA", armorBreakChanceHeavyArmorNPCPA)

	JsonUtil.SetIntValue(configFile, "keyCodeRegist", keyCodeRegist)
	JsonUtil.SetIntValue(configFile, "keyCodeHelp", keyCodeHelp)
	JsonUtil.SetIntValue(configFile, "keyCodeSubmit", keyCodeSubmit)
	JsonUtil.SetIntValue(configFile, "SSLYACRAudienceDistance", SSLYACRAudienceDistance.GetValue() as int)

	JsonUtil.SetIntValue(configFile, "enableWeCantDieSupport", enableWeCantDieSupport as int)
	JsonUtil.SetIntValue(configFile, "weCantDieChance", weCantDieChance)
	JsonUtil.SetIntValue(configFile, "enableSimpleSlaverySupport", enableSimpleSlaverySupport as int)
	JsonUtil.SetIntValue(configFile, "simpleSlaveryChance", simpleSlaveryChance)
	JsonUtil.SetIntValue(configFile, "enableUtilOneSupport", enableUtilOneSupport as int)
	JsonUtil.SetIntValue(configFile, "enableDrippingWASupport", enableDrippingWASupport as int)
	JsonUtil.SetIntValue(configFile, "enableSendOrgasm", enableSendOrgasm as int)
	
	JsonUtil.SetIntValue(configFile, "SSLYACRAudienceChance1", SSLYACRAudienceChance1.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRAudienceChance2", SSLYACRAudienceChance2.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRAudienceChance3", SSLYACRAudienceChance3.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRAudienceChance4", SSLYACRAudienceChance4.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRAudienceChance5", SSLYACRAudienceChance5.GetValue() as int)
	
	JsonUtil.SetIntValue(configFile, "SSLYACROneMore", SSLYACROneMore.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACROneMoreFromSecond", SSLYACROneMoreFromSecond.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRMultiPlay", SSLYACRMultiPlay.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRMultiPlay5P", SSLYACRMultiPlay5P.GetValue() as int)
	JsonUtil.SetIntValue(configFile, "SSLYACRMultiPlay4P", SSLYACRMultiPlay4P.GetValue() as int)
	
	ExportBoolList(configFile, "DisableRacesConfig", DisableRacesConfig, DisableRacesConfig.Length)
	JsonUtil.Save(configFile)
EndFunction

Function loadConfig(string configFile)
	modEnabled = JsonUtil.GetIntValue(configFile, "modEnabled")
	debugNotifFlag = JsonUtil.GetIntValue(configFile, "debugNotifFlag")
	debugLogFlag = JsonUtil.GetIntValue(configFile, "debugLogFlag")
	registNotifFlag = JsonUtil.GetIntValue(configFile, "registNotifFlag")
	knockDownAll = JsonUtil.GetIntValue(configFile, "knockDownAll")

	enablePlayerRape = JsonUtil.GetIntValue(configFile, "enablePlayerRape")
	knockDownOnly = JsonUtil.GetIntValue(configFile, "knockDownOnly")

	matchedSex = JsonUtil.GetIntValue(configFile, "matchedSex")
	healthLimit = JsonUtil.GetIntValue(configFile, "healthLimit")
	healthLimitBottom = JsonUtil.GetIntValue(configFile, "healthLimitBottom")
	enableEndlessRape = JsonUtil.GetIntValue(configFile, "enableEndlessRape")
	attackDistanceLimit = JsonUtil.GetIntValue(configFile, "attackDistanceLimit")

	rapeChance = JsonUtil.GetIntValue(configFile, "rapeChance")
	rapeChanceNotNaked = JsonUtil.GetIntValue(configFile, "rapeChanceNotNaked")
	rapeChancePA = JsonUtil.GetIntValue(configFile, "rapeChancePA")
	rapeChanceNotNakedPA = JsonUtil.GetIntValue(configFile, "rapeChanceNotNakedPA")

	EnableEABD = JsonUtil.GetIntValue(configFile, "EnableEABD")
	rapeChanceTBless = JsonUtil.GetIntValue(configFile, "rapeChanceTBless")
	rapeChanceSeeThrough = JsonUtil.GetIntValue(configFile, "rapeChanceSeeThrough")
	rapeChanceUnderwear = JsonUtil.GetIntValue(configFile, "rapeChanceUnderwear")
	rapeChanceTBlessPA = JsonUtil.GetIntValue(configFile, "rapeChanceTBlessPA")
	rapeChanceSeeThroughPA = JsonUtil.GetIntValue(configFile, "rapeChanceSeeThroughPA")
	rapeChanceUnderwearPA = JsonUtil.GetIntValue(configFile, "rapeChanceUnderwearPA")

	enableArmorBreak = JsonUtil.GetIntValue(configFile, "enableArmorBreak")
	enableArmorUnequipMode = JsonUtil.GetIntValue(configFile, "enableArmorUnequipMode")

	armorBreakChanceCloth = JsonUtil.GetIntValue(configFile, "armorBreakChanceCloth")
	armorBreakChanceLightArmor = JsonUtil.GetIntValue(configFile, "armorBreakChanceLightArmor")
	armorBreakChanceHeavyArmor = JsonUtil.GetIntValue(configFile, "armorBreakChanceHeavyArmor")
	armorBreakChanceClothPA = JsonUtil.GetIntValue(configFile, "armorBreakChanceClothPA")
	armorBreakChanceLightArmorPA = JsonUtil.GetIntValue(configFile, "armorBreakChanceLightArmorPA")
	armorBreakChanceHeavyArmorPA = JsonUtil.GetIntValue(configFile, "armorBreakChanceHeavyArmorPA")

	matchedSexNPC = JsonUtil.GetIntValue(configFile, "matchedSexNPC")
	healthLimitNPC = JsonUtil.GetIntValue(configFile, "healthLimitNPC")
	healthLimitBottomNPC = JsonUtil.GetIntValue(configFile, "healthLimitBottomNPC")
	enableEndlessRapeNPC = JsonUtil.GetIntValue(configFile, "enableEndlessRapeNPC")
	attackDistanceLimitNPC = JsonUtil.GetIntValue(configFile, "attackDistanceLimitNPC")

	rapeChanceNPC = JsonUtil.GetIntValue(configFile, "rapeChanceNPC")
	rapeChanceNotNakedNPC = JsonUtil.GetIntValue(configFile, "rapeChanceNotNakedNPC")
	rapeChanceNPCPA = JsonUtil.GetIntValue(configFile, "rapeChanceNPCPA")
	rapeChanceNotNakedNPCPA = JsonUtil.GetIntValue(configFile, "rapeChanceNotNakedNPCPA")

	enableArmorBreakNPC = JsonUtil.GetIntValue(configFile, "enableArmorBreakNPC")
	enableArmorUnequipModeNPC = JsonUtil.GetIntValue(configFile, "enableArmorUnequipModeNPC")

	armorBreakChanceClothNPC = JsonUtil.GetIntValue(configFile, "armorBreakChanceClothNPC")
	armorBreakChanceLightArmorNPC = JsonUtil.GetIntValue(configFile, "armorBreakChanceLightArmorNPC")
	armorBreakChanceHeavyArmorNPC = JsonUtil.GetIntValue(configFile, "armorBreakChanceHeavyArmorNPC")
	armorBreakChanceClothNPCPA = JsonUtil.GetIntValue(configFile, "armorBreakChanceClothNPCPA")
	armorBreakChanceLightArmorNPCPA = JsonUtil.GetIntValue(configFile, "armorBreakChanceLightArmorNPCPA")
	armorBreakChanceHeavyArmorNPCPA = JsonUtil.GetIntValue(configFile, "armorBreakChanceHeavyArmorNPCPA")

	keyCodeRegist = JsonUtil.GetIntValue(configFile, "keyCodeRegist")
	keyCodeHelp = JsonUtil.GetIntValue(configFile, "keyCodeHelp")
	keyCodeSubmit = JsonUtil.GetIntValue(configFile, "keyCodeSubmit")
	SSLYACRAudienceDistance.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRAudienceDistance"))

	enableWeCantDieSupport = JsonUtil.GetIntValue(configFile, "enableWeCantDieSupport")
	weCantDieChance = JsonUtil.GetIntValue(configFile, "weCantDieChance")
	enableSimpleSlaverySupport = JsonUtil.GetIntValue(configFile, "enableSimpleSlaverySupport")
	simpleSlaveryChance = JsonUtil.GetIntValue(configFile, "simpleSlaveryChance")
	enableUtilOneSupport = JsonUtil.GetIntValue(configFile, "enableUtilOneSupport")
	enableDrippingWASupport = JsonUtil.GetIntValue(configFile, "enableDrippingWASupport")
	enableSendOrgasm = JsonUtil.GetIntValue(configFile, "enableSendOrgasm")

	SSLYACRAudienceChance1.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRAudienceChance1"))
	SSLYACRAudienceChance2.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRAudienceChance2"))
	SSLYACRAudienceChance3.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRAudienceChance3"))
	SSLYACRAudienceChance4.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRAudienceChance4"))
	SSLYACRAudienceChance5.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRAudienceChance5"))

	SSLYACROneMore.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACROneMore"))
	SSLYACROneMoreFromSecond.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACROneMoreFromSecond"))
	SSLYACRMultiPlay.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRMultiPlay"))
	SSLYACRMultiPlay5P.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRMultiPlay5P"))
	SSLYACRMultiPlay4P.SetValue(JsonUtil.GetIntValue(configFile, "SSLYACRMultiPlay4P"))
	
	ImportBoolList(configFile, "DisableRacesConfig", DisableRacesConfig, DisableRacesConfig.Length)
EndFunction

; Boolean Arrays from SexLab
function ExportBoolList(string FileName, string Name, bool[] Values, int len)
	JsonUtil.IntListClear(FileName, Name)
	int i
	while i < len
		JsonUtil.IntListAdd(FileName, Name, Values[i] as int)
		i += 1
	endWhile
endFunction
bool[] function ImportBoolList(string FileName, string Name, bool[] Values, int len)
	if JsonUtil.IntListCount(FileName, Name) == len
		if Values.Length != len
			Values = Utility.CreateBoolArray(len)
		endIf
		int i
		while i < len
			Values[i] = JsonUtil.IntListGet(FileName, Name, i) as bool
			i += 1
		endWhile
	endIf
	return Values
endFunction


Quest Property SSLYACRQuestManager  Auto  
Quest Property SSLYACR  Auto  

GlobalVariable Property SSLYACROneMore  Auto  
GlobalVariable Property SSLYACROneMoreFromSecond  Auto  
GlobalVariable Property SSLYACRMultiPlay  Auto  
GlobalVariable Property SSLYACRMultiPlay5P  Auto  
GlobalVariable Property SSLYACRMultiPlay4P  Auto  

GlobalVariable Property SSLYACRAudienceChance1 Auto
GlobalVariable Property SSLYACRAudienceChance2 Auto
GlobalVariable Property SSLYACRAudienceChance3 Auto
GlobalVariable Property SSLYACRAudienceChance4 Auto
GlobalVariable Property SSLYACRAudienceChance5 Auto

GlobalVariable Property SSLYACRAudienceDistance  Auto  
