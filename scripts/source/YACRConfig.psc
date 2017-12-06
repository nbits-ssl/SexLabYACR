Scriptname YACRConfig extends SKI_ConfigBase  

bool Property debugLogFlag = true Auto

bool Property enableArmorBreak = true Auto
bool Property enableEndlessRape = true Auto
int Property armorBreakChanceCloth = 50 Auto
int Property armorBreakChanceLightArmor = 20 Auto
int Property armorBreakChanceHeavyArmor = 10 Auto
int Property rapeChance = 50 Auto
int Property rapeChanceNotNaked = 10 Auto
int Property healthLimit = 50 Auto

bool Property enableArmorBreakNPC = true Auto
bool Property enableEndlessRapeNPC = true Auto
int Property armorBreakChanceClothNPC = 50 Auto
int Property armorBreakChanceLightArmorNPC = 20 Auto
int Property armorBreakChanceHeavyArmorNPC = 10 Auto
int Property rapeChanceNPC = 50 Auto
int Property rapeChanceNotNakedNPC = 10 Auto
int Property healthLimitNPC = 50 Auto

int debugLogFlagID

int enableArmorBreakID
int enableEndlessRapeID
int armorBreakChanceClothID
int armorBreakChanceLightArmorID
int armorBreakChanceHeavyArmorID
int rapeChanceID
int rapeChanceNotNakedID
int healthLimitID

int enableArmorBreakNPCID
int enableEndlessRapeNPCID
int armorBreakChanceClothNPCID
int armorBreakChanceLightArmorNPCID
int armorBreakChanceHeavyArmorNPCID
int rapeChanceNPCID
int rapeChanceNotNakedNPCID
int healthLimitNPCID

;event OnConfigInit()
;	Pages = new string[2]
;	Pages[0] = ""
;	Pages[1] = ""
;endEvent

event OnPageReset(string page)
	;if (page == "" || page == "General")
		SetCursorFillMode(TOP_TO_BOTTOM)
		SetCursorPosition(0)

		debugLogFlagID = AddToggleOption("$OutputPapyrusLog", debugLogFlag)

		AddHeaderOption("$Player")
		healthLimitID = AddSliderOption("$HealthLimit", healthLimit)
		
		AddHeaderOption("$RapeChance")
		rapeChanceID = AddSliderOption("$Naked", rapeChance)
		rapeChanceNotNakedID = AddSliderOption("$NotNaked", rapeChanceNotNaked)
		enableEndlessRapeID = AddToggleOption("$EndlessRape", enableEndlessRape)
		
		AddHeaderOption("$ArmorBreak")
		enableArmorBreakID = AddToggleOption("$Enable", enableArmorBreak)
		armorBreakChanceClothID = AddSliderOption("$Cloth", armorBreakChanceCloth)
		armorBreakChanceLightArmorID = AddSliderOption("$LightArmor", armorBreakChanceLightArmor)
		armorBreakChanceHeavyArmorID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmor)
		
		SetCursorPosition(1)
		AddEmptyOption()
		
		AddHeaderOption("$Follower")
		healthLimitNPCID = AddSliderOption("$HealthLimit", healthLimitNPC)
		
		AddHeaderOption("$RapeChance")
		rapeChanceNPCID = AddSliderOption("$Naked", rapeChanceNPC)
		rapeChanceNotNakedNPCID = AddSliderOption("$NotNaked", rapeChanceNotNakedNPC)
		enableEndlessRapeNPCID = AddToggleOption("$EndlessRape", enableEndlessRapeNPC)
		
		AddHeaderOption("$ArmorBreak")
		enableArmorBreakNPCID = AddToggleOption("$Enable", enableArmorBreakNPC)
		armorBreakChanceClothNPCID = AddSliderOption("$Cloth", armorBreakChanceClothNPC)
		armorBreakChanceLightArmorNPCID = AddSliderOption("$LightArmor", armorBreakChanceLightArmorNPC)
		armorBreakChanceHeavyArmorNPCID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmorNPC)
	;endif
endevent

int Function GetHealthLimit(bool IsPlayer = true)
	if (IsPlayer)
		return self.healthLimit
	else
		return self.healthLimitNPC
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

event OnOptionHighlight(int option)
	if (option == healthLimitID || option == healthLimitNPCID)
		SetInfoText("$HealthLimitInfo")
	elseif (option == enableEndlessRapeID || option == enableEndlessRapeNPCID)
		SetInfoText("$EndlessRapeInfo")
	endif
endevent

event OnOptionSelect(int option)
	if (option == enableArmorBreakID)
		enableArmorBreak = !enableArmorBreak
		SetToggleOptionValue(enableArmorBreakID, enableArmorBreak)
	elseif (option == enableEndlessRapeID)
		enableEndlessRape = !enableEndlessRape
		SetToggleOptionValue(enableEndlessRapeID, enableEndlessRape)
		
	elseif (option == enableArmorBreakNPCID)
		enableArmorBreakNPC = !enableArmorBreakNPC
		SetToggleOptionValue(enableArmorBreakNPCID, enableArmorBreakNPC)
	elseif (option == enableEndlessRapeNPCID)
		enableEndlessRapeNPC = !enableEndlessRapeNPC
		SetToggleOptionValue(enableEndlessRapeNPCID, enableEndlessRapeNPC)
		
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(debugLogFlagID, debugLogFlag)
	endif
endevent

event OnOptionSliderOpen(int option)
	if (option == rapeChanceID)
		SetSliderDialogStartValue(rapeChance)
		SetSliderDialogDefaultValue(rapeChance)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == rapeChanceNotNakedID)
		SetSliderDialogStartValue(rapeChanceNotNaked)
		SetSliderDialogDefaultValue(rapeChanceNotNaked)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == armorBreakChanceClothID)
		SetSliderDialogStartValue(armorBreakChanceCloth)
		SetSliderDialogDefaultValue(armorBreakChanceCloth)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == armorBreakChanceLightArmorID)
		SetSliderDialogStartValue(armorBreakChanceLightArmor)
		SetSliderDialogDefaultValue(armorBreakChanceLightArmor)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == armorBreakChanceHeavyArmorID)
		SetSliderDialogStartValue(armorBreakChanceHeavyArmor)
		SetSliderDialogDefaultValue(armorBreakChanceHeavyArmor)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)

	elseif (option == rapeChanceNPCID)
		SetSliderDialogStartValue(rapeChanceNPC)
		SetSliderDialogDefaultValue(rapeChanceNPC)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == rapeChanceNotNakedNPCID)
		SetSliderDialogStartValue(rapeChanceNotNakedNPC)
		SetSliderDialogDefaultValue(rapeChanceNotNakedNPC)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == armorBreakChanceClothNPCID)
		SetSliderDialogStartValue(armorBreakChanceClothNPC)
		SetSliderDialogDefaultValue(armorBreakChanceClothNPC)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == armorBreakChanceLightArmorNPCID)
		SetSliderDialogStartValue(armorBreakChanceLightArmorNPC)
		SetSliderDialogDefaultValue(armorBreakChanceLightArmorNPC)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		SetSliderDialogStartValue(armorBreakChanceHeavyArmorNPC)
		SetSliderDialogDefaultValue(armorBreakChanceHeavyArmorNPC)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	endif
endevent

event OnOptionSliderAccept(int option, float value)
	if (option == rapeChanceID)
		rapeChance = value as Int
		SetSliderOptionValue(rapeChanceID, rapeChance)
	elseif (option == rapeChanceNotNakedID)
		rapeChanceNotNaked = value as Int
		SetSliderOptionValue(rapeChanceNotNakedID, rapeChanceNotNaked)
	elseif (option == armorBreakChanceClothID)
		armorBreakChanceCloth = value as Int
		SetSliderOptionValue(armorBreakChanceClothID, armorBreakChanceCloth)
	elseif (option == armorBreakChanceLightArmorID)
		armorBreakChanceLightArmor = value as Int
		SetSliderOptionValue(armorBreakChanceLightArmorID, armorBreakChanceLightArmor)
	elseif (option == armorBreakChanceHeavyArmorID)
		armorBreakChanceHeavyArmor = value as Int
		SetSliderOptionValue(armorBreakChanceHeavyArmorID, armorBreakChanceHeavyArmor)
		
	elseif (option == rapeChanceNPCID)
		rapeChanceNPC = value as Int
		SetSliderOptionValue(rapeChanceNPCID, rapeChanceNPC)
	elseif (option == rapeChanceNotNakedNPCID)
		rapeChanceNotNakedNPC = value as Int
		SetSliderOptionValue(rapeChanceNotNakedNPCID, rapeChanceNotNakedNPC)
	elseif (option == armorBreakChanceClothNPCID)
		armorBreakChanceClothNPC = value as Int
		SetSliderOptionValue(armorBreakChanceClothNPCID, armorBreakChanceClothNPC)
	elseif (option == armorBreakChanceLightArmorNPCID)
		armorBreakChanceLightArmorNPC = value as Int
		SetSliderOptionValue(armorBreakChanceLightArmorNPCID, armorBreakChanceLightArmorNPC)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		armorBreakChanceHeavyArmorNPC = value as Int
		SetSliderOptionValue(armorBreakChanceHeavyArmorNPCID, armorBreakChanceHeavyArmorNPC)
	endif
endevent