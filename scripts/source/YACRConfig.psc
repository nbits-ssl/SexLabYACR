Scriptname YACRConfig extends SKI_ConfigBase  

bool Property debugLogFlag = true Auto
bool Property knockDownAll = true Auto

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

int knockDownAllID
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

int[] availableEnemyFactionsIDS
int[] multiplayEnemyFactionsIDS

YACRUtil Property AppUtil Auto

int Function GetVersion()
	return 6
EndFunction 

Event OnVersionUpdate(int a_version)
	OnConfigInit()
EndEvent

Event OnConfigInit()
	Pages = new string[3]
	Pages[0] = "$General"
	Pages[1] = "$Enemy"
	Pages[2] = "$Multiplay"
	
	availableEnemyFactionsIDS = new int[50]
	multiplayEnemyFactionsIDS = new int[50]
EndEvent

Event OnPageReset(string page)
	if (page == "" || page == "$General")
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

		knockDownAllID = AddToggleOption("$KnockDownAll", knockDownAll)
		
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
	elseif	(page == "$Enemy")
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
			factname = self._getFactionName(mpfacts[idx])
			multiplayEnemyFactionsIDS[idx] = AddSliderOption(factname, mpfactsConfig[idx])
			idx += 1
		endwhile
		; AppUtil.Log(multiplayEnemyFactionsIDS)
	endif
EndEvent

; why empty, Bethesda !!
string Function _getFactionName(Faction fact)
	if (fact == BanditFaction)
		return "$BanditFaction"
	elseif (fact == VampireFaction)
		return "$VampireFaction"
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

Event OnOptionHighlight(int option)
	if (option == knockDownAllID)
		SetInfoText("$KnockDownAllInfo")
	elseif (option == healthLimitID || option == healthLimitNPCID)
		SetInfoText("$HealthLimitInfo")
	elseif (option == enableEndlessRapeID || option == enableEndlessRapeNPCID)
		SetInfoText("$EndlessRapeInfo")
	elseif (availableEnemyFactionsIDS.Find(option) > -1)
		SetInfoText("$AvailableEnemyFactions")
	elseif (multiplayEnemyFactionsIDS.Find(option) > -1)
		SetInfoText("$MultiplayEnemyFactions")
	endif
EndEvent

Event OnOptionSelect(int option)
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
		
	elseif (option == knockDownAllID)
		knockDownAll = !knockDownAll
		SetToggleOptionValue(knockDownAllID, knockDownAll)
	elseif (option == debugLogFlagID)
		debugLogFlag = !debugLogFlag
		SetToggleOptionValue(debugLogFlagID, debugLogFlag)
		
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
		SetSliderOptionValue(healthLimitID, healthLimit)
	elseif (option == rapeChanceID)
		rapeChance = value as int
		SetSliderOptionValue(rapeChanceID, rapeChance)
	elseif (option == rapeChanceNotNakedID)
		rapeChanceNotNaked = value as int
		SetSliderOptionValue(rapeChanceNotNakedID, rapeChanceNotNaked)
	elseif (option == armorBreakChanceClothID)
		armorBreakChanceCloth = value as int
		SetSliderOptionValue(armorBreakChanceClothID, armorBreakChanceCloth)
	elseif (option == armorBreakChanceLightArmorID)
		armorBreakChanceLightArmor = value as int
		SetSliderOptionValue(armorBreakChanceLightArmorID, armorBreakChanceLightArmor)
	elseif (option == armorBreakChanceHeavyArmorID)
		armorBreakChanceHeavyArmor = value as int
		SetSliderOptionValue(armorBreakChanceHeavyArmorID, armorBreakChanceHeavyArmor)
		
	elseif (option == healthLimitNPCID)
		healthLimitNPC = value as int
		SetSliderOptionValue(healthLimitNPCID, healthLimitNPC)
	elseif (option == rapeChanceNPCID)
		rapeChanceNPC = value as int
		SetSliderOptionValue(rapeChanceNPCID, rapeChanceNPC)
	elseif (option == rapeChanceNotNakedNPCID)
		rapeChanceNotNakedNPC = value as int
		SetSliderOptionValue(rapeChanceNotNakedNPCID, rapeChanceNotNakedNPC)
	elseif (option == armorBreakChanceClothNPCID)
		armorBreakChanceClothNPC = value as int
		SetSliderOptionValue(armorBreakChanceClothNPCID, armorBreakChanceClothNPC)
	elseif (option == armorBreakChanceLightArmorNPCID)
		armorBreakChanceLightArmorNPC = value as int
		SetSliderOptionValue(armorBreakChanceLightArmorNPCID, armorBreakChanceLightArmorNPC)
	elseif (option == armorBreakChanceHeavyArmorNPCID)
		armorBreakChanceHeavyArmorNPC = value as int
		SetSliderOptionValue(armorBreakChanceHeavyArmorNPCID, armorBreakChanceHeavyArmorNPC)
		
	elseif (multiplayEnemyFactionsIDS.Find(option) > -1)
		int idx = multiplayEnemyFactionsIDS.Find(option)
		AppUtil.MultiplayEnemyFactionsConfig[idx] = value as int
		SetSliderOptionValue(multiplayEnemyFactionsIDS[idx], value as int)
	endif
EndEvent

Faction Property BanditFaction  Auto  
Faction Property VampireFaction  Auto  
