Scriptname YACRConfig extends SKI_ConfigBase  

bool Property debugLogFlag = true Auto

bool Property enableNoNakedRape = false Auto
bool Property enableArmorBreak = true Auto
int Property armorBreakChanceCloth = 50 Auto
int Property armorBreakChanceLightArmor = 20 Auto
int Property armorBreakChanceHeavyArmor = 10 Auto
int Property rapeChance = 50 Auto
int Property rapeChanceNotNaked = 10 Auto
int Property healthLimit = 50 Auto

bool Property enableNoNakedRapeNPC = false Auto
bool Property enableArmorBreakNPC = true Auto
int Property armorBreakChanceClothNPC = 50 Auto
int Property armorBreakChanceLightArmorNPC = 20 Auto
int Property armorBreakChanceHeavyArmorNPC = 10 Auto
int Property rapeChanceNPC = 50 Auto
int Property rapeChanceNotNakedNPC = 10 Auto
int Property healthLimitNPC = 50 Auto

int debugLogFlagID

int enableNoNakedRapeID
int enableArmorBreakID
int armorBreakChanceClothID
int armorBreakChanceLightArmorID
int armorBreakChanceHeavyArmorID
int rapeChanceID
int rapeChanceNotNakedID
int healthLimitID

int enableNoNakedRapeNPCID
int enableArmorBreakNPCID
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
		enableNoNakedRapeID = AddToggleOption("$EnableRapeToNotNaked", enableNoNakedRape)
		rapeChanceID = AddSliderOption("$Naked", rapeChance)
		rapeChanceNotNakedID = AddSliderOption("$NotNaked", rapeChanceNotNaked)
		
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
		enableNoNakedRapeNPCID = AddToggleOption("$EnableRapeToNotNaked", enableNoNakedRapeNPC)
		rapeChanceNPCID = AddSliderOption("$Naked", rapeChanceNPC)
		rapeChanceNotNakedNPCID = AddSliderOption("$NotNaked", rapeChanceNotNakedNPC)
		
		AddHeaderOption("$ArmorBreak")
		enableArmorBreakNPCID = AddToggleOption("$Enable", enableArmorBreakNPC)
		armorBreakChanceClothNPCID = AddSliderOption("$Cloth", armorBreakChanceClothNPC)
		armorBreakChanceLightArmorNPCID = AddSliderOption("$LightArmor", armorBreakChanceLightArmorNPC)
		armorBreakChanceHeavyArmorNPCID = AddSliderOption("$HeavyArmor", armorBreakChanceHeavyArmorNPC)
	;endif
endevent

event OnOptionHighlight(int option)
	if (option == healthLimitID || option == healthLimitNPCID)
		SetInfoText("$HealthLimitInfo")
	endif
endevent

event OnOptionSelect(int option)
	if (option == enableArmorBreakID)
		enableArmorBreak = !enableArmorBreak
		SetToggleOptionValue(enableArmorBreakID, enableArmorBreak)
	elseif (option == enableNoNakedRapeID)
		enableNoNakedRape = !enableNoNakedRape
		SetToggleOptionValue(enableNoNakedRapeID, enableNoNakedRape)
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
	endif
endevent