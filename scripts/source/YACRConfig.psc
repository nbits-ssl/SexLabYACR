Scriptname YACRConfig extends SKI_ConfigBase  

bool Property debugLogFlag = true Auto
bool Property enableNoNakedRape = false Auto
bool Property enableArmorBreak = true Auto
int Property armorBreakChanceCloth = 50 Auto
int Property armorBreakChanceLightArmor = 20 Auto
int Property armorBreakChanceHeavyArmor = 10 Auto
int Property rapeChance = 50 Auto
int Property rapeChanceNotNaked = 10 Auto

int debugLogFlagID
int enableNoNakedRapeID
int enableArmorBreakID
int armorBreakChanceClothID
int armorBreakChanceLightArmorID
int armorBreakChanceHeavyArmorID
int rapeChanceID
int rapeChanceNotNakedID

event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	SetCursorPosition(0)

	AddHeaderOption("General: ")
	
	rapeChanceID = AddSliderOption("Rape chance (%)", rapeChance)
	
	enableNoNakedRapeID = AddToggleOption("Enable rape to not naked", enableNoNakedRape)
	rapeChanceNotNakedID = AddSliderOption(" Not naked rape chance (%)", rapeChanceNotNaked)
	
	enableArmorBreakID = AddToggleOption("Enable armor break", enableArmorBreak)
	armorBreakChanceClothID = AddSliderOption(" Cloth chance (%)", armorBreakChanceCloth)
	armorBreakChanceLightArmorID = AddSliderOption(" LightArmor chance (%)", armorBreakChanceLightArmor)
	armorBreakChanceHeavyArmorID = AddSliderOption(" HeavyArmor chance (%)", armorBreakChanceHeavyArmor)
	
	debugLogFlagID = AddToggleOption("Output papyrus log", debugLogFlag)
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