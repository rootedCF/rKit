print ("|cff0E8D0Er|r|cff8D8D8DKit|r v2.0 loaded successfully.")
--[[
	rKit LUA Configuration File.
	No GUI, only text mods. More detailed instructions
	will be in the commented section of each section. One day. For now use your head.
--]]

--/\Enable and/or disable features/\
local PartnerCD = 1
local Tweaks = 1
local UnitFrames = 1
local Macro = 1
local ArenaTrinkets = 1
local DRTracker = 1
local Combat = 1
local Interrupt = 1
local ArenaColors = 1
local RogueTrack = 1
local OmniCC = 0 --Disabled due to not working
local ClassPortrait = 1
local DebuffSize = 1
local MicroHide = 0
local sDanceBar = 0
local decyka = 0

--General Modifications without on/off switch
BuffFrame:SetScale(1.2)
TemporaryEnchantFrame:SetScale(1.2)
PlayerFrameRoleIcon:SetAlpha(0)
--PetFrame:ClearAllPoints()
PetFrame:SetPoint("TOPLEFT",PlayerFrame,-90,0)

--##Dev Scripts##


--#1 /\Partner CD's/\
if (PartnerCD == 1) then
local frame = CreateFrame("FRAME", "EnemyCooldowns")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
local function eventHandler(self, event, ...)
USS="UNIT_SPELLCAST_SUCCEEDED";OE="OnEvent";F="Frame";CF=CreateFrame;BO="Border";xb=630;yb=320;sb=21;ib=1;ii=1   
function TrS(f,x,y,cd,T,s,h)f:SetPoint("BOTTOMLEFT",x,y)f:SetSize(s,s)f.c=CF("Cooldown",cd,nil,"CooldownFrameTemplate")f.c:SetAllPoints(f)f.t=f:CreateTexture(nil,BO)f.t:SetAllPoints()f.t:SetTexture(T);if not h then f:Hide();end f:RegisterEvent(USS)end
function Ts(f,cd,U,N,S,TI)if CPz(N,S,U) then f:Show();CooldownFrame_SetTimer(cd,GetTime(),TI,1)f.elapsed = 0 f:SetScript('OnUpdate', function(self, elapsed)if self.elapsed > TI+1 then self:SetScript('OnUpdate', nil) self:Hide();else self.elapsed = self.elapsed + elapsed end end)end end
function CPz(N,S,U)if(N==S and (U=="party1" or U=="party2"))then return true else return false end end
--Mage CD's/\
--t15p="Interface\\Icons\\ability_mage_deepfreeze";t15=CF(F);TrS(t15,380,425,"cd15",t15p,22,true);t15:SetScript(OE,function(self,event,...) Ts(t15,cd15,select(1,...),select(5,...),20217,30) end);
---Deep
t21p="Interface\\Icons\\ability_mage_deepfreeze";t21=CF(F);TrS(t21,380,425,"cd21",t21p,sb,false);t21:SetScript(OE,function(self,event,...) Ts(t21,cd21,select(1,...),select(5,...),44572,30) end);

--Priest CD's/\
---Horror
t36p="Interface\\Icons\\spell_shadow_psychichorrors";t36=CF(F);TrS(t36,380,425,"cd36",t36p,sb,false);t36:SetScript(OE,function(self,event,...) Ts(t36,cd36,select(1,...),select(5,...),64044,35) end);
--SomeOtherClassCD's/\
end
frame:SetScript("OnEvent", eventHandler)
end

--[[#2 /\Tweaks/\)
if (Tweaks == 1) then
--combat text font
local fontName = "Fonts\\ARIALN.TTF"
local fontHeight = 25
local fFlags = ""
local function FS_SetFont()
	DAMAGE_TEXT_FONT = fontName
	COMBAT_TEXT_HEIGHT = fontHeight
	COMBAT_TEXT_CRIT_MAXHEIGHT = fontHeight + 1
	COMBAT_TEXT_CRIT_MINHEIGHT = fontHeight - 1
	local fName, fHeight, fFlags = CombatTextFont:GetFont()
	CombatTextFont:SetFont(fontName, fontHeight, fFlags)
end
FS_SetFont()
--combat text location
local f = CreateFrame("FRAME");
f:SetScript("OnEvent", function(self,event,...)
local arg1 =...;        
     if (arg1=="Blizzard_CombatText") then
        f:UnregisterEvent("ADDON_LOADED");
        hooksecurefunc("CombatText_UpdateDisplayedMessages",
        function ()
        COMBAT_TEXT_LOCATIONS =
        {startX  = 0,
        --startY = 384 * COMBAT_TEXT_Y_SCALE, endX =0,endY = 159 * COMBAT_TEXT_Y_SCALE};
        startY = 164 * COMBAT_TEXT_Y_SCALE, endX =0,endY = 80 * COMBAT_TEXT_Y_SCALE}; 
        end)end end)
f:RegisterEvent("ADDON_LOADED");
end
--]]
--#3 /\Unit Frames/\
if (UnitFrames == 1) then
MainMenuBarLeftEndCap:SetAlpha(0)
MainMenuBarRightEndCap:SetAlpha(0)
for i=0,3 do _G["MainMenuBarTexture"..i]:SetAlpha(0)end
for i=0,3 do _G["MainMenuMaxLevelBar"..i]:SetAlpha(0)end
CompactRaidFrameContainer:SetScale(0.85)
ObjectiveTrackerFrame:SetScale(0.75)
ObjectiveTrackerBlocksFrame.QuestHeader:SetAlpha(0)
hooksecurefunc("PlayerFrame_ResetPosition", function(self)
 self:ClearAllPoints()
 self:SetPoint("CENTER", -370, 20)
 TargetFrame:ClearAllPoints()
 TargetFrame:SetPoint("BOTTOMRIGHT",PlayerFrame,100,-45)
 FocusFrame:ClearAllPoints()
 FocusFrame:SetPoint("BOTTOMRIGHT",PlayerFrame,750,0)
 --PetFrame:ClearAllPoints()
 --PetFrame:SetPoint("TOPLEFT",PlayerFrame,-90,0)
end)
 StanceButton1:ClearAllPoints()
 StanceButton1:SetPoint("BOTTOMLEFT",MultiBarBottomLeftButton2,-500,0)
 StanceButton1.SetPoint = function() end
--player frame tweaks
hooksecurefunc("PlayerFrame_UpdateStatus", function() 
if IsResting("player") then PlayerStatusTexture:Hide()PlayerRestIcon:Hide()PlayerRestGlow:Hide()PlayerStatusGlow:Hide() 
elseif PlayerFrame.inCombat then PlayerStatusTexture:Hide()PlayerAttackIcon:Show()PlayerRestIcon:Hide()PlayerAttackGlow:Hide()
PlayerRestGlow:Hide()PlayerStatusGlow:Hide()PlayerAttackBackground:Hide() end end)
-- background tweaks 
hooksecurefunc('TargetFrame_CheckFaction', function(self)
  if ( not UnitPlayerControlled(self.unit) 
  and UnitIsTapped(self.unit) 
  and not UnitIsTappedByPlayer(self.unit) 
  and not UnitIsTappedByAllThreatList(self.unit) ) then
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
    if ( self.portrait ) then
      self.portrait:SetVertexColor(0.5, 0.5, 0.5);
    end
  else
    self.nameBackground:SetVertexColor(0.0, 0.0, 0.0, 0.5);
    if ( self.portrait ) then
      self.portrait:SetVertexColor(1.0, 1.0, 1.0);
    end
  end  
end)
-- hp 
local f=function(v)if(v>=1e4) then return ('%.1fk'):format(v/1e3):gsub('%.?0+([km])$','%1')  else return v end end
		hooksecurefunc("TextStatusBar_UpdateTextString",function(s)
   		if not GetCVarBool("statusTextPercentage") then
    		if s.TextString and s.currValue then
       		s.TextString:SetText(f(s.currValue))			
    	  end
   	 end
end)
local hptext = TargetFrameHealthBar:CreateFontString("TargetHealthPercentageFontString", "OVERLAY")
hptext:SetPoint("RIGHT", TargetFrameHealthBar, "RIGHT", 28, 0)
hptext:SetFont("Fonts\\font.ttf", 12, "OUTLINE")
hptext:SetShadowColor(0,0,0)
hptext:SetShadowOffset(1,-1)
hptext:SetTextColor(0.1,1.0,0.1)
hptext:SetJustifyH("RIGHT")

TargetFrameHealthBar:RegisterEvent("PLAYER_TARGET_CHANGED")
TargetFrameHealthBar:RegisterEvent("UNIT_HEALTH")




--class colored hp bars 
local UnitIsPlayer,UnitIsConnected, UnitClass, RAID_CLASS_COLORS = UnitIsPlayer,UnitIsConnected,UnitClass, RAID_CLASS_COLORS
local _, class, c
local function colour(statusbar, unit, name)
      if UnitIsPlayer(unit) and UnitIsConnected(unit) and unit == statusbar.unit and UnitClass(unit) then
          _, class = UnitClass(unit) c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
          statusbar:SetStatusBarColor(c.r, c.g, c.b)		  
		  statusbar = _G["PlayerFrame".."HealthBar"]:SetStatusBarColor(0.1, 1.0, 0.1)--playerframe fix	  
      end 	  
end
hooksecurefunc("UnitFrameHealthBar_Update", colour)
hooksecurefunc("HealthBar_OnValueChanged", function(self)colour(self, self.unit)end)
--class colored names
hooksecurefunc("UnitFrame_Update", function(self)
if UnitClass(self.unit) then
local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(self.unit))]
self.name:SetTextColor(c.r,c.g,c.b,1) self.name:SetFont("Fonts\\font.ttf", 12)end end)
end

--#4 /\Macro/\
if (Macro == 1) then
hooksecurefunc('ActionButton_UpdateHotkeys', function(self)
    local macro = _G[self:GetName()..'Name']
    if macro then macro:Hide() end
end)
end

--#5 /\PvP Trinkets/\
if (ArenaTrinkets == 1) then
-- // ArenaTrinkets
-- // Lorti - 2013
ArenaTrinkets = CreateFrame("Frame", nil, UIParent)
function ArenaTrinkets:Initialize()
for i = 1, MAX_ARENA_ENEMIES do
local ArenaFrame = _G["ArenaEnemyFrame"..i]
self:CreateIcon(ArenaFrame)
end
end
function ArenaTrinkets:CreateIcon(frame)
local trinket = CreateFrame("Cooldown", nil, frame, "CooldownFrameTemplate")
trinket:SetFrameLevel(frame:GetFrameLevel() + 3)
trinket:SetDrawEdge(false)
trinket:ClearAllPoints()
trinket:SetPoint("LEFT", frame, "RIGHT", 0, -1)
trinket:SetSize(22, 22)

trinket.Icon = CreateFrame("Frame", nil, trinket)
trinket.Icon:SetFrameLevel(trinket:GetFrameLevel() - 1)
trinket.Icon:SetAllPoints()
trinket.Icon.Texture = trinket.Icon:CreateTexture(nil, "BORDER")
trinket.Icon.Texture:SetPoint("TOPLEFT", -3, 2)
trinket.Icon.Texture:SetSize(24, 24)
SetPortraitToTexture(trinket.Icon.Texture, UnitFactionGroup('player') == "Horde" and "Interface\\Icons\\inv_jewelry_trinketpvp_02" or "Interface\\Icons\\inv_jewelry_trinketpvp_01")

trinket.Icon.Border = CreateFrame("Frame", nil, trinket.Icon)
trinket.Icon.Border:SetFrameLevel(trinket:GetFrameLevel() + 1)
trinket.Icon.Border:SetAllPoints()
trinket.Icon.Border.Texture = trinket.Icon.Border:CreateTexture(nil, "ARTWORK")
trinket.Icon.Border.Texture:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
if IsAddOnLoaded("Lorti UI") then
trinket.Icon.Border.Texture:SetVertexColor(.005,.005,.005)
end
trinket.Icon.Border.Texture:SetPoint("TOPLEFT", -9, 7)
trinket.Icon.Border.Texture:SetSize(63, 63)
local id = frame:GetID()
self["arena"..id] = trinket

if ( trinket ) then
trinket.Icon:SetParent(trinket:GetParent())
trinket.Icon:SetScale(1)
trinket.Icon:SetFrameLevel(trinket:GetFrameLevel() - 1)
else
for i = 1, MAX_ARENA_ENEMIES do
trinket.Icon:SetParent(trinket:GetParent())
trinket.Icon:SetScale(1)
trinket.Icon:SetFrameLevel(trinket:GetFrameLevel() - 1)
end
end
end
function ArenaTrinkets:ShowTrinkets()
for i = 1, MAX_ARENA_ENEMIES do
self["arena"..i].Icon:Show()
self["arena"..i]:Show()
self["arena"..i]:SetCooldown(0, 0)
end
end
function ArenaTrinkets:HideTrinkets()
for i = 1, MAX_ARENA_ENEMIES do
self["arena"..i].Icon:Hide()
self["arena"..i]:Hide()
self["arena"..i]:SetCooldown(0, 0)
end
end
ArenaTrinkets:SetScript("OnEvent", function(self, event, ...) return self[event](self, ...) end)
function ArenaTrinkets:UNIT_SPELLCAST_SUCCEEDED(unitID, spell)
if not ArenaTrinkets[unitID] then return end

if spell == GetSpellInfo(42292) or spell == GetSpellInfo(59752) then -- Trinket and EMFH
CooldownFrame_SetTimer(self[unitID], GetTime(), 120, 1)
elseif spell == GetSpellInfo(7744) then -- WOTF
CooldownFrame_SetTimer(self[unitID], GetTime(), 30, 1)
end
end
function ArenaTrinkets:PLAYER_ENTERING_WORLD()
local _, instanceType = IsInInstance()
if instanceType == "arena" then
ArenaEnemyFrame1:SetScale(1.20)
ArenaEnemyFrame2:SetScale(1.20)
ArenaEnemyFrame3:SetScale(1.20)
ArenaEnemyFrame4:SetScale(1.20)
ArenaEnemyFrame5:SetScale(1.20)
ArenaPrepFrame1:SetScale(1.20)
ArenaPrepFrame2:SetScale(1.20)
ArenaPrepFrame3:SetScale(1.20)
ArenaPrepFrame4:SetScale(1.20)
ArenaPrepFrame5:SetScale(1.20)

ArenaEnemyFrame1PetFrame:SetScale(1.20)
ArenaEnemyFrame2PetFrame:SetScale(1.20)
ArenaEnemyFrame3PetFrame:SetScale(1.20)
ArenaEnemyFrame4PetFrame:SetScale(1.20)
ArenaEnemyFrame5PetFrame:SetScale(1.20)

ArenaEnemyFrame1:ClearAllPoints()
ArenaEnemyFrame1:SetPoint("TOPRIGHT", -220, -36)
ArenaEnemyFrame1.SetPoint = function() end 
ArenaEnemyFrame2:ClearAllPoints()
ArenaEnemyFrame2:SetPoint("BOTTOMLEFT", ArenaEnemyFrame1, "BOTTOMLEFT", 0, -50)
ArenaEnemyFrame2.SetPoint = function() end
ArenaEnemyFrame3:ClearAllPoints()
ArenaEnemyFrame3:SetPoint("BOTTOMLEFT", ArenaEnemyFrame1, "BOTTOMLEFT", 0, -100)
ArenaEnemyFrame3.SetPoint = function() end
ArenaEnemyFrame4:ClearAllPoints()
ArenaEnemyFrame4:SetPoint("BOTTOMLEFT", ArenaEnemyFrame1, "BOTTOMLEFT", 0, -150)
ArenaEnemyFrame4.SetPoint = function() end
ArenaEnemyFrame5:ClearAllPoints()
ArenaEnemyFrame5:SetPoint("BOTTOMLEFT", ArenaEnemyFrame1, "BOTTOMLEFT", 0, -200)
ArenaEnemyFrame5.SetPoint = function() end
ArenaPrepFrame1:ClearAllPoints() 
ArenaPrepFrame1:SetPoint("TOPRIGHT", -220, -36)
ArenaPrepFrame1.SetPoint = function() end
ArenaPrepFrame2:ClearAllPoints() 
ArenaPrepFrame2:SetPoint("TOPRIGHT", ArenaPrepFrame1, "TOPRIGHT", 0, -50)
ArenaPrepFrame2.SetPoint = function() end
ArenaPrepFrame3:ClearAllPoints() 
ArenaPrepFrame3:SetPoint("TOPRIGHT", ArenaPrepFrame1, "TOPRIGHT", 0, -100)
ArenaPrepFrame3.SetPoint = function() end
ArenaPrepFrame4:ClearAllPoints() 
ArenaPrepFrame4:SetPoint("TOPRIGHT", ArenaPrepFrame1, "TOPRIGHT", 0, -150)
ArenaPrepFrame4.SetPoint = function() end
ArenaPrepFrame5:ClearAllPoints() 
ArenaPrepFrame5:SetPoint("TOPRIGHT", ArenaPrepFrame1, "TOPRIGHT", 0, -200)
ArenaPrepFrame5.SetPoint = function() end
self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
ArenaTrinkets:ShowTrinkets()
SetBinding("TAB", "TARGETNEARESTENEMYPLAYER")
else
ArenaTrinkets:HideTrinkets()
SetBinding("TAB", "TARGETNEARESTENEMY")
if ( self:IsEventRegistered("UNIT_SPELLCAST_SUCCEEDED") ) then
self:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
end
end
end
ArenaTrinkets:RegisterEvent("PLAYER_ENTERING_WORLD")
function ArenaTrinkets:PLAYER_LOGIN()
if not IsAddOnLoaded("Blizzard_ArenaUI") then
LoadAddOn("Blizzard_ArenaUI")
end
self:Initialize()
end
ArenaTrinkets:RegisterEvent("PLAYER_LOGIN")
end

--#6 /\DRTracker/\
if (DRTracker == 1) then
local DRTracker = CreateFrame("Cooldown", "DRTracker", UIParent)
local DRs = {}
local lastChangedFrame = nil
DRTracker:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
DRTracker:RegisterEvent("ADDON_LOADED")
local spellIds = { -- DR Categories listed here http://eu.battle.net/wow/en/forum/topic/11267997531
	-- Many thanks to those that assisted the creation of the original list from LoseControl.
	-- Categories: Stun (1), Silence (2), Disorient/Fear (3), Incapacitate/Polymorph (4), Roots (5)
	-- Death Knight
	[108194] = "Stun",		-- Asphyxiate
	[115001] = "Stun",		-- Remorseless Winter
	[47476]  = "Silence",	-- Strangulate
	[96294]  = "Root",		-- Chains of Ice (Chilblains)
	-- Death Knight Ghoul
	[91800]  = "Stun",		-- Gnaw
	[91797]  = "Stun",		-- Monstrous Blow (Dark Transformation)
	[91807]  = "Root",		-- Shambling Rush (Dark Transformation)
	-- Druid
	[113801] = "Stun",		-- Bash (Force of Nature - Feral Treants)
	[102795] = "Stun",		-- Bear Hug
	[33786]  = "Disorient",	-- Cyclone
	[99]     = "Incap",		-- Disorienting (Incapacitating) Roar
	[22570]  = "Stun",		-- Maim
	[5211]   = "Stun",		-- Mighty Bash
	[163505]   = "Stun",	-- Rake
	[114238] = "Silence",	-- Fae Silence (Glyph of Fae Silence)
	[81261]  = "Silence",	-- Solar Beam
	[339]    = "Root",		-- Entangling Roots
	[113770] = "Root",		-- Entangling Roots (Force of Nature - Balance Treants)
	[19975]  = "Root",		-- Entangling Roots (Nature's Grasp)
	[45334]  = "Root",		-- Immobilized (Wild Charge - Bear)
	[102359] = "Root",		-- Mass Entanglement
	-- Hunter
	[117526] = "Stun",		-- Binding Shot
	[3355]   = "Incap",		-- Freezing Trap
	[1513]   = "Disorient",	-- Scare Beast
	[19386]  = "Incap",		-- Wyvern Sting
	[34490]  = "Silence",	-- Silencing Shot
	[19185]  = "Root",		-- Entrapment
	[64803]  = "Root",		-- Entrapment
	[128405] = "Root",		-- Narrow Escape
	-- Mage
	[118271] = "Stun",		-- Combustion Impact
	[44572]  = "Stun",		-- Deep Freeze
	[31661]  = "Disorient",	-- Dragon's Breath
	[118]    = "Incap",		-- Polymorph
	[61305]  = "Incap",		-- Polymorph: Black Cat
	[28272]  = "Incap",		-- Polymorph: Pig
	[61721]  = "Incap",		-- Polymorph: Rabbit
	[61780]  = "Incap",		-- Polymorph: Turkey
	[28271]  = "Incap",		-- Polymorph: Turtle
	[82691]  = "Incap",		-- Ring of Frost
	[102051] = "Silence",	-- Frostjaw (also a root)
	[122]    = "Root",		-- Frost Nova
	[111340] = "Root",		-- Ice Ward
	-- Mage Water Elemental
	[33395]  = "Root",		-- Freeze
	-- Monk
	[123393] = "Incap",		-- Breath of Fire (Glyph of Breath of Fire)
	[119392] = "Stun",		-- Charging Ox Wave
	[120086] = "Stun",		-- Fists of Fury
	[119381] = "Stun",		-- Leg Sweep
	[115078] = "Incap",		-- Paralysis
	[137460] = "Incap",		-- Silenced (Ring of Peace)
	[116706] = "Root",		-- Disable
	[123407] = "Root",		-- Spinning Fire Blossom
	-- Paladin
	[105421] = "Disorient",	-- Blinding Light
	[115752] = "Stun",		-- Blinding Light (Glyph of Blinding Light)
	[105593] = "Stun",		-- Fist of Justice
	[853]    = "Stun",		-- Hammer of Justice
	[119072] = "Stun",		-- Holy Wrath
	[20066]  = "Incap",		-- Repentance
	[10326]  = "Disorient",	-- Turn Evil
	[145067] = "Disorient",	-- Turn Evil (Evil is a Point of View)
	[31935]  = "Silence",	-- Avenger's Shield
	-- Priest
	[605]    = "Incap",		-- Dominate Mind
	[88625]  = "Incap",		-- Holy Word: Chastise
	[64044]  = "Incap",		-- Psychic Horror
	[8122]   = "Disorient",	-- Psychic Scream
	[113792] = "Disorient",	-- Psychic Terror (Psyfiend)
	[9484]   = "Disorient",	-- Shackle Undead
	[15487]  = "Silence",	-- Silence
	[87194]  = "Root",		-- Glyph of Mind Blast
	[114404] = "Root",		-- Void Tendril's Grasp
	-- Rogue
	[2094]   = "Disorient",	-- Blind
	[1833]   = "Stun",		-- Cheap Shot
	[1776]   = "Incap",		-- Gouge
	[408]    = "Stun",		-- Kidney Shot
	[6770]   = "Incap",		-- Sap
	[1330]   = "Silence",		-- Garrote - Silence
	-- Shaman
	[51514]  = "Incap",		-- Hex
	[118905] = "Stun",		-- Static Charge (Capacitor Totem)
	[64695]  = "Root",		-- Earthgrab (Earthgrab Totem)
	[63685]  = "Root",		-- Freeze (Frozen Power)
	-- Shaman Primal Earth Elemental
	[118345] = "Stun",		-- Pulverize
	-- Warlock
	[710]    = "Incap",		-- Banish
	[137143] = "Incap",		-- Blood Horror
	[5782]   = "Disorient",	-- Fear
	[118699] = "Disorient",	-- Fear
	[130616] = "Disorient",	-- Fear (Glyph of Fear)
	[5484]   = "Disorient",	-- Howl of Terror
	[22703]  = "Stun",		-- Infernal Awakening
	[6789]   = "Incap",		-- Mortal Coil
	[132412] = "Disorient",	-- Seduction (Grimoire of Sacrifice)
	[30283]  = "Stun",		-- Shadowfury
	[132409] = "Silence",	-- Spell Lock (Grimoire of Sacrifice)
	[31117]  = "Silence",	-- Unstable Affliction
	-- Warlock Pets
	[89766]  = "Stun",		-- Axe Toss (Felguard/Wrathguard)
	[115268] = "Disorient",	-- Mesmerize (Shivarra)
	[6358]   = "Disorient",	-- Seduction (Succubus)
	[115782] = "Silence",	-- Optical Blast (Observer)
	[24259]  = "Silence",	-- Spell Lock (Felhunter)
	-- Warrior
	--[7922]   = "Root",	-- Charge Stun
	[5246]   = "Disorient",	-- Intimidating Shout (aoe)
	[20511]  = "Disorient",	-- Intimidating Shout (targeted)
	[132168] = "Stun",		-- Shockwave
	[107570] = "Stun",		-- Storm Bolt
	[132169] = "Stun",		-- Storm Bolt
	[18498]  = "Silence",	-- Silenced - Gag Order (PvE only)
	[107566] = "Root",		-- Staggering Shout
	[105771] = "Root",		-- Warbringer
	-- Other
	[107079] = "Incap",		-- Quaking Palm
	[13327]  = "Stun",		-- Reckless Charge
	[20549]  = "Stun",		-- War Stomp
	[25046]  = "Silence",	-- Arcane Torrent (Energy)
	[28730]  = "Silence",	-- Arcane Torrent (Mana)
	[50613]  = "Silence",	-- Arcane Torrent (Runic Power)
	[69179]  = "Silence",	-- Arcane Torrent (Rage)
	[80483]  = "Silence",	-- Arcane Torrent (Focus)
	[129597] = "Silence",	-- Arcane Torrent (Chi)
	[39965]  = "Root",		-- Frost Grenade
	[55536]  = "Root",		-- Frostweave Net
	[13099]  = "Root",		-- Net-o-Matic
}

function DRTracker:GetSpellCategory(spellID) -- Returns CC category of the spellIDs listed above
	return spellID and spellIds[spellID] or nil
end

function DRTracker:OnEvent(event, ...) -- Runs things, and stuff.
	self[event](self, ...)
end
DRTracker:SetScript("OnEvent", DRTracker.OnEvent)

function DRTracker:ADDON_LOADED(addonName) -- Anchor DR trackers
    if addonName == "Blizzard_ArenaUI" then
		local arenaFrame
		for i = 1, 5 do
		arenaFrame = "ArenaEnemyFrame"..i
		--local loc = -30 -- (Depreciated) Distance between the left edge of each frame. Should match the width of the frame.
			for j = 1, 5 do
				local DR = CreateFrame("Frame", arenaFrame.."DR"..j, ArenaEnemyFrames)
				DR:ClearAllPoints()
				DR:SetPoint("LEFT", arenaFrame, "RIGHT", 36, 0)
				DR:SetSize(35, 35) -- (Width, Height) of each frame. A perfect square is preferable, otherwise the spell icon will look stretched.
				DR.border = DR:CreateTexture(nil, "LOW")
				DR.border:SetAllPoints()
				DR.border:SetTexture("Interface\\BUTTONS\\UI-Quickslot-Depress.png")
				DR.icon = DR:CreateTexture(nil, "BACKGROUND")
				DR.shown = false
				DR.severity = 1
				DR.unit = i
				DR.cate = j
				DR.applied = 0
				DR.sweep = CreateFrame("Cooldown", nil, DR, "CooldownFrameTemplate")
				DR.sweep:ClearAllPoints()
				DR.sweep:SetAllPoints(DR)
				local function OnShow(self)
					local curX = 36
					for b=1,5 do
						local curFrame = DRs["arena"..DR.unit..b]
						if curFrame.shown == true and b ~= self.cate then
							curX = curX + 36
						end
					end
					self:ClearAllPoints()
					self:SetPoint("LEFT", "ArenaEnemyFrame"..self.unit, "RIGHT", curX, 0)
					self.shown = true
					self.applied = GetTime()
				end
				DR:HookScript("OnShow", OnShow)

				local function OnHide(self)
					for b = 1,5 do
						local curFrame = DRs["arena"..self.unit..b]
						if curFrame and curFrame.shown == true and curFrame.applied > self.applied then
							local _, _, _, x = curFrame:GetPoint(1)
							curFrame:ClearAllPoints()
							curFrame:SetPoint("LEFT", "ArenaEnemyFrame"..curFrame.unit, "RIGHT", x-36, 0)
						end
					end
					self:ClearAllPoints()
					self:SetPoint("LEFT", "ArenaEnemyFrame"..self.unit, "RIGHT", 36, -10)
				end
				DR:HookScript("OnHide", OnHide)
				
				local function DREnd(self, elapsed)
					if self.sweep:GetCooldownDuration() == 0 and self.shown == true then
						self:Hide()
						self.shown = false
						self.severity = 1
					end
				end
				DR:HookScript("OnUpdate", DREnd)
				
				DR:Hide()
				DRs["arena"..i..j] = DR
			end
		end
	end
end

function DRTracker:SetTexture(Frame, spellID) -- Sets displayed icon to last spell.
	if Frame.shown == true then
		Frame.dur = Frame.sweep:GetCooldownDuration()
		Frame:Hide()
	end
	lastChangedFrame = Frame
	local _, _, icon, _, _, _, _, _, _ = GetSpellInfo(spellID)
	Frame.icon:ClearAllPoints()
	Frame.icon:SetAllPoints()
	Frame.icon:SetTexture(icon)
	Frame:Show()
	if Frame.severity == 1 then
		Frame.border:SetVertexColor(1, 1, 0, 1)
		Frame.severity = 2
	elseif Frame.severity == 2 then
		Frame.border:SetVertexColor(1, .4, 0, 1)
		Frame.severity = 3
	elseif Frame.severity == 3 then
		Frame.border:SetVertexColor(1, 0, 0, 1)
	end
end

function DRTracker:TimerStart(GUID, spellID, spellName) -- Primary function; begins CD sweep and icon updates. Not a good idea to edit any of this.
	local _, instanceType = IsInInstance()
	if instanceType ~= "arena" then
		return
	end
	local cat = DRTracker:GetSpellCategory(spellID)
	if(UnitGUID("arena1") == GUID) then
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff("arena1", spellName)
		if(cat=="Stun") then
			DRTracker:SetTexture(DRs["arena1"..1], spellID)
			CooldownFrame_SetTimer(DRs["arena1"..1].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Silence") then
			DRTracker:SetTexture(DRs["arena1"..2], spellID)
			CooldownFrame_SetTimer(DRs["arena1"..2].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Disorient") then
			DRTracker:SetTexture(DRs["arena1"..3], spellID)
			CooldownFrame_SetTimer(DRs["arena1"..3].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Incap") then
			DRTracker:SetTexture(DRs["arena1"..4], spellID)
			CooldownFrame_SetTimer(DRs["arena1"..4].sweep, GetTime(), 17+duration, 1)
		else
			DRTracker:SetTexture(DRs["arena1"..5], spellID)
			CooldownFrame_SetTimer(DRs["arena1"..5].sweep, GetTime(), 17+duration, 1)
		end
	elseif(UnitGUID("arena2") == GUID) then
	local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff("arena2", spellName)
		if(cat=="Stun") then
			DRTracker:SetTexture(DRs["arena2"..1], spellID)
			CooldownFrame_SetTimer(DRs["arena2"..1].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Silence") then
			DRTracker:SetTexture(DRs["arena2"..2], spellID)
			CooldownFrame_SetTimer(DRs["arena2"..2].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Disorient") then
			DRTracker:SetTexture(DRs["arena2"..3], spellID)
			CooldownFrame_SetTimer(DRs["arena2"..3].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Incap") then
			DRTracker:SetTexture(DRs["arena2"..4], spellID)
			CooldownFrame_SetTimer(DRs["arena2"..4].sweep, GetTime(), 17+duration, 1)
		else
			DRTracker:SetTexture(DRs["arena2"..5], spellID)
			CooldownFrame_SetTimer(DRs["arena2"..5].sweep, GetTime(), 17+duration, 1)
		end
	elseif(UnitGUID("arena3") == GUID) then
	local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff("arena3", spellName)
		if(cat=="Stun") then
			DRTracker:SetTexture(DRs["arena3"..1], spellID)
			CooldownFrame_SetTimer(DRs["arena3"..1].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Silence") then
			DRTracker:SetTexture(DRs["arena3"..2], spellID)
			CooldownFrame_SetTimer(DRs["arena3"..2].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Disorient") then
			DRTracker:SetTexture(DRs["arena3"..3], spellID)
			CooldownFrame_SetTimer(DRs["arena3"..3].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Incap") then
			DRTracker:SetTexture(DRs["arena3"..4], spellID)
			CooldownFrame_SetTimer(DRs["arena3"..4].sweep, GetTime(), 17+duration, 1)
		else
			DRTracker:SetTexture(DRs["arena3"..5], spellID)
			CooldownFrame_SetTimer(DRs["arena3"..5].sweep, GetTime(), 17+duration, 1)
		end
	elseif(UnitGUID("arena4") == GUID) then
	local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff("arena4", spellName)
		if(cat=="Stun") then
			DRTracker:SetTexture(DRs["arena4"..1], spellID)
			CooldownFrame_SetTimer(DRs["arena4"..1].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Silence") then
			DRTracker:SetTexture(DRs["arena4"..2], spellID)
			CooldownFrame_SetTimer(DRs["arena4"..2].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Disorient") then
			DRTracker:SetTexture(DRs["arena4"..3], spellID)
			CooldownFrame_SetTimer(DRs["arena4"..3].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Incap") then
			DRTracker:SetTexture(DRs["arena4"..4], spellID)
			CooldownFrame_SetTimer(DRs["arena4"..4].sweep, GetTime(), 17+duration, 1)
		else
			DRTracker:SetTexture(DRs["arena4"..5], spellID)
			CooldownFrame_SetTimer(DRs["arena4"..5].sweep, GetTime(), 17+duration, 1)
		end
	elseif(UnitGUID("arena5") == GUID) then
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, shouldConsolidate, spellID, canApplyAura, isBossDebuff, value1, value2, value3 = UnitDebuff("arena5", spellName)
		if(cat=="Stun") then
			DRTracker:SetTexture(DRs["arena5"..1], spellID)
			CooldownFrame_SetTimer(DRs["arena5"..1].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Silence") then
			DRTracker:SetTexture(DRs["arena5"..2], spellID)
			CooldownFrame_SetTimer(DRs["arena5"..2].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Disorient") then
			DRTracker:SetTexture(DRs["arena5"..3], spellID)
			CooldownFrame_SetTimer(DRs["arena5"..3].sweep, GetTime(), 17+duration, 1)
		elseif(cat=="Incap") then
			DRTracker:SetTexture(DRs["arena5"..4], spellID)
			CooldownFrame_SetTimer(DRs["arena5"..4].sweep, GetTime(), 17+duration, 1)
		else
			DRTracker:SetTexture(DRs["arena5"..5], spellID)
			CooldownFrame_SetTimer(DRs["arena5"..5].sweep, GetTime(), 17+duration, 1)
		end
	end
	return
end

function DRTracker:GetDRs()
	return DRTracker and DRs
end

function DRTracker:COMBAT_LOG_EVENT_UNFILTERED(timeStamp, eventType, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID, spellName, spellSchool, auraType)
	if eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_AURA_REFRESH" then -- Crowd control landed, time to do stuff.
		if auraType == "DEBUFF" and DRTracker:GetSpellCategory(spellID) then
			DRTracker:TimerStart(destGUID, spellID, spellName)
		end
	end
end
end

--#7 /\Combat Script/\
if (Combat == 1) then
CTT=CreateFrame("Frame")CTT:SetParent(TargetFrame)CTT:SetPoint("Left",TargetFrame,-30,5)CTT:SetSize(25,25)CTT.t=CTT:CreateTexture(nil,BORDER)CTT.t:SetAllPoints()CTT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")CTT:Hide()
local function FrameOnUpdate(self) if UnitAffectingCombat("target") then self:Show() else self:Hide() end end local g = CreateFrame("Frame") g:SetScript("OnUpdate", function(self) FrameOnUpdate(CTT) end)
CFT=CreateFrame("Frame")CFT:SetParent(FocusFrame)CFT:SetPoint("Left",FocusFrame,-30,5)CFT:SetSize(25,25)CFT.t=CFT:CreateTexture(nil,BORDER)CFT.t:SetAllPoints()CFT.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")CFT:Hide()
local function FrameOnUpdate(self) if UnitAffectingCombat("focus") then self:Show() else self:Hide() end end local g = CreateFrame("Frame") g:SetScript("OnUpdate", function(self) FrameOnUpdate(CFT) end)
end

--#8 /\Interrupt Announcer/\
if (Interrupt == 1) then
local f = CreateFrame("Frame")
local function Update(self, event, ...)
		if event == "COMBAT_LOG_EVENT_UNFILTERED" then		
		local timestamp, eventType, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, _, spellID, spellName, _, extraskillID, extraSkillName = ...
		if eventType == "SPELL_INTERRUPT" and sourceName == UnitName("player") then
			SendChatMessage("Interrupted >> "..GetSpellLink(extraskillID).."!", "PARTY")
		end
	end
end
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", Update)
end

--#9 /\Class Colors in Arena Frames/\
if (ArenaColors == 1) then
local frame = CreateFrame("FRAME")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("PLAYER_FOCUS_CHANGED")
frame:RegisterEvent("ARENA_OPPONENT_UPDATE")
frame:RegisterEvent("PLAYER_CONTROL_GAINED")
frame:RegisterEvent("PLAYER_CONTROL_LOST")
frame:RegisterEvent("ADDON_LOADED");
local function DoArenaColorHook()
        hooksecurefunc("ArenaEnemyFrame_Unlock",
                function(self)
                        local color=RAID_CLASS_COLORS[select(2,UnitClass(self.unit)) or ""]
                        if color then
                                self.healthbar:SetStatusBarColor(color.r,color.g,color.b)
                                self.healthbar.lockColor=true
                        end                                            
                end
        )
end
local function eventHandler(self, event, arg, ...)
        if event == "ADDON_LOADED" then
                if arg == "Blizzard_ArenaUI" then
                        self:UnregisterEvent(event);
                        DoArenaColorHook();
                end
        end            
end
if IsAddOnLoaded("Blizzard_ArenaUI") then
        DoArenaColorHook();
end
frame:SetScript("OnEvent", eventHandler)
end

--#10 /\Rogue Tracking/\
if (RogueTrack == 1) then

local snd = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
snd:SetDrawEdge(false)
snd:ClearAllPoints()
snd:SetPoint("BOTTOMRIGHT",PlayerFrame,120,0)
snd:SetSize(40,40)
snd.Icon = CreateFrame("Frame", nil, snd)
snd.Icon:SetFrameLevel(snd:GetFrameLevel() - 1)
snd:SetFrameStrata("HIGH")
snd.Icon:SetAllPoints()
snd.Icon.Texture = snd.Icon:CreateTexture(nil, "ARTWORK")
snd.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,120,0)
snd.Icon.Texture:SetSize(40,40)
snd.Icon.Texture:SetTexture("Interface\\Icons\\ability_rogue_slicedice")
snd.Icon.Border = CreateFrame("Frame", nil, snd.Icon)
snd.Icon.Border:SetAllPoints()
snd.Icon.Border.Texture = snd.Icon.Border:CreateTexture(nil, Border)
snd:RegisterEvent("UNIT_AURA")
snd:SetScript("OnEvent", function(self, event, unit)
snd.CheckAura(unit)
end)
function snd.CheckAura(unit)
local spellname = GetSpellInfo(5171)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitBuff("player", spellname)
if id and unitCaster == "player" then
snd:Show()
snd:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
snd:Hide()
end

--TRINKET PROC
local trink = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
trink:SetDrawEdge(false)
trink:ClearAllPoints()
--trink:SetPoint("BOTTOMRIGHT",PlayerFrame,149,6)
trink:SetPoint("BOTTOMRIGHT",PlayerFrame,479,29)
trink:SetSize(64,64)
trink.Icon = CreateFrame("Frame", nil, trink)
trink.Icon:SetFrameLevel(trink:GetFrameLevel() - 1)
trink:SetFrameStrata("HIGH")
trink.Icon:SetAllPoints()
trink.Icon.Texture = trink.Icon:CreateTexture(nil, "ARTWORK")
--trink.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,149,6)
trink.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,479,29)
trink.Icon.Texture:SetSize(64,64)
trink.Icon.Texture:SetTexture("Interface\\Icons\\ability_creature_poison_06")
trink.Icon.Border = CreateFrame("Frame", nil, trink.Icon)
trink.Icon.Border:SetAllPoints()
trink.Icon.Border.Texture = trink.Icon.Border:CreateTexture(nil, Border)
trink:RegisterEvent("UNIT_AURA")
trink:SetScript("OnEvent", function(self, event, unit)
trink.CheckAura(unit)
end)
function trink.CheckAura(unit)
local spellname = GetSpellInfo(177038)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitBuff("player", spellname)
if id and unitCaster == "player" then
trink:Show()
trink:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
trink:Hide()
end
--ADRENALINE
local rush = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
rush:SetDrawEdge(false)
rush:ClearAllPoints()
--rush:SetPoint("BOTTOMRIGHT",PlayerFrame,149,6)
rush:SetPoint("BOTTOMRIGHT",PlayerFrame,479,93)
rush:SetSize(64,64)
rush.Icon = CreateFrame("Frame", nil, rush)
rush.Icon:SetFrameLevel(rush:GetFrameLevel() - 1)
rush:SetFrameStrata("HIGH")
rush.Icon:SetAllPoints()
rush.Icon.Texture = rush.Icon:CreateTexture(nil, "ARTWORK")
--rush.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,149,6)
rush.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,479,93)
rush.Icon.Texture:SetSize(64,64)
rush.Icon.Texture:SetTexture("Interface\\Icons\\spell_shadow_shadowworddominate")
rush.Icon.Border = CreateFrame("Frame", nil, rush.Icon)
rush.Icon.Border:SetAllPoints()
rush.Icon.Border.Texture = rush.Icon.Border:CreateTexture(nil, Border)
rush:RegisterEvent("UNIT_AURA")
rush:SetScript("OnEvent", function(self, event, unit)
rush.CheckAura(unit)
end)
function rush.CheckAura(unit)
local spellname = GetSpellInfo(13750)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitBuff("player", spellname)
if id and unitCaster == "player" then
rush:Show()
rush:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
rush:Hide()
end
--RING PROC
local ring = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
ring:SetDrawEdge(false)
ring:ClearAllPoints()
--ring:SetPoint("BOTTOMRIGHT",PlayerFrame,149,-28)
ring:SetPoint("BOTTOMRIGHT",PlayerFrame,479,-35)
ring:SetSize(64,64)
ring.Icon = CreateFrame("Frame", nil, ring)
ring.Icon:SetFrameLevel(ring:GetFrameLevel() - 1)
ring:SetFrameStrata("HIGH")
ring.Icon:SetAllPoints()
ring.Icon.Texture = ring.Icon:CreateTexture(nil, "ARTWORK")
--ring.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,149,-28)
ring.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,479,-35)
ring.Icon.Texture:SetSize(64,64)
ring.Icon.Texture:SetTexture("Interface\\Icons\\spell_holy_mindsooth")
ring.Icon.Border = CreateFrame("Frame", nil, ring.Icon)
ring.Icon.Border:SetAllPoints()
ring.Icon.Border.Texture = ring.Icon.Border:CreateTexture(nil, Border)
ring:RegisterEvent("UNIT_AURA")
ring:SetScript("OnEvent", function(self, event, unit)
ring.CheckAura(unit)
end)
function ring.CheckAura(unit)
local spellname = GetSpellInfo(177159)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitBuff("player", spellname)
if id and unitCaster == "player" then
ring:Show()
ring:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
ring:Hide()
end
-- blade flurry tracker
local blade = CreateFrame("Cooldown", nil, PlayerFrame)
blade:SetDrawEdge(false)
blade:ClearAllPoints()
blade:SetPoint("BOTTOMRIGHT",PlayerFrame,160,-40)
blade:SetSize(40,40)
blade.Icon = CreateFrame("Frame", nil, blade)
blade.Icon:SetFrameLevel(blade:GetFrameLevel() - 1)
blade:SetFrameStrata("HIGH")
blade.Icon:SetAllPoints()
blade.Icon.Texture = blade.Icon:CreateTexture(nil, "ARTWORK")
blade.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,160,-40)
blade.Icon.Texture:SetSize(40,40)
blade.Icon.Texture:SetTexture("Interface\\Icons\\ability_warrior_punishingblow")
blade.Icon.Border = CreateFrame("Frame", nil, blade.Icon)
blade.Icon.Border:SetAllPoints()
blade.Icon.Border.Texture = blade.Icon.Border:CreateTexture(nil, Border)
blade:RegisterEvent("UNIT_AURA")
blade:SetScript("OnEvent", function(self, event, unit)
blade.CheckAura(unit)
end)
function blade.CheckAura(unit)
local spellname = GetSpellInfo(13877)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitBuff("player", spellname)
if id and unitCaster == "player" then
blade:Show()
blade:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
blade:Hide()
end

--vendetta tracker
local vend = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
vend:SetDrawEdge(false)
vend:ClearAllPoints()
vend:SetPoint("BOTTOMRIGHT",PlayerFrame,160,-40)
vend:SetSize(40,40)
vend.Icon = CreateFrame("Frame", nil, vend)
vend.Icon:SetFrameLevel(vend:GetFrameLevel() - 1)
vend:SetFrameStrata("HIGH")
vend.Icon:SetAllPoints()
vend.Icon.Texture = vend.Icon:CreateTexture(nil, "ARTWORK")
vend.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,160,-40)
vend.Icon.Texture:SetSize(40,40)
vend.Icon.Texture:SetTexture("Interface\\Icons\\ability_rogue_deadliness")
vend.Icon.Border = CreateFrame("Frame", nil, vend.Icon)
vend.Icon.Border:SetAllPoints()
vend.Icon.Border.Texture = vend.Icon.Border:CreateTexture(nil, Border)
vend:RegisterEvent("UNIT_AURA")
vend:SetScript("OnEvent", function(self, event, unit)
vend.CheckAura(unit)
end)
function vend.CheckAura(unit)
local spellname = GetSpellInfo(79140)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitDebuff("target", spellname)
if id and unitCaster == "player" then
vend:Show()
vend:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
vend:Hide()
end
--rupture tracker
local rupt = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
rupt:SetDrawEdge(false)
rupt:ClearAllPoints()
rupt:SetPoint("BOTTOMRIGHT",PlayerFrame,160,40)
rupt:SetSize(40,40)
rupt.Icon = CreateFrame("Frame", nil, rupt)
rupt.Icon:SetFrameLevel(rupt:GetFrameLevel() - 1)
rupt:SetFrameStrata("HIGH")
rupt.Icon:SetAllPoints()
rupt.Icon.Texture = rupt.Icon:CreateTexture(nil, "ARTWORK")
rupt.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,160,40)
rupt.Icon.Texture:SetSize(40,40)
rupt.Icon.Texture:SetTexture("Interface\\Icons\\ability_rogue_rupture")
rupt.Icon.Border = CreateFrame("Frame", nil, rupt.Icon)
rupt.Icon.Border:SetAllPoints()
rupt.Icon.Border.Texture = rupt.Icon.Border:CreateTexture(nil, Border)
rupt:RegisterEvent("UNIT_AURA")
rupt:SetScript("OnEvent", function(self, event, unit)
rupt.CheckAura(unit)
end)
function rupt.CheckAura(unit)
local spellname = GetSpellInfo(1943)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitDebuff("target", spellname)
if id and unitCaster == "player" then
rupt:Show()
rupt:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
rupt:Hide()
end
--strike tracker
local strike = CreateFrame("Cooldown", nil, PlayerFrame, "CooldownFrameTemplate")
strike:SetDrawEdge(false)
strike:ClearAllPoints()
strike:SetPoint("BOTTOMRIGHT",PlayerFrame,160,40)
strike:SetSize(40,40)
strike.Icon = CreateFrame("Frame", nil, strike)
strike.Icon:SetFrameLevel(strike:GetFrameLevel() - 1)
strike:SetFrameStrata("HIGH")
strike.Icon:SetAllPoints()
strike.Icon.Texture = strike.Icon:CreateTexture(nil, "ARTWORK")
strike.Icon.Texture:SetPoint("BOTTOMRIGHT",PlayerFrame,160,40)
strike.Icon.Texture:SetSize(40,40)
strike.Icon.Texture:SetTexture("Interface\\Icons\\inv_sword_97")
strike.Icon.Border = CreateFrame("Frame", nil, strike.Icon)
strike.Icon.Border:SetAllPoints()
strike.Icon.Border.Texture = strike.Icon.Border:CreateTexture(nil, Border)
strike:RegisterEvent("UNIT_AURA")
strike:SetScript("OnEvent", function(self, event, unit)
strike.CheckAura(unit)
end)
function strike.CheckAura(unit)
local spellname = GetSpellInfo(84617)
local _, _, _, _, _, duration, expirationTime, unitCaster, _, _, id = UnitDebuff("target", spellname)
if id and unitCaster == "player" then
strike:Show()
strike:SetCooldown(expirationTime - duration - 0.5, duration)
return
end
strike:Hide()
end
end

--#12 /\Class Portraits/\
if (ClassPortrait == 1) then
hooksecurefunc("UnitFramePortrait_Update",function(self)
        if self.portrait then
                if UnitIsPlayer(self.unit) then                         
                        local t = CLASS_ICON_TCOORDS[select(2, UnitClass(self.unit))]
                        if t then
                                self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
                                self.portrait:SetTexCoord(unpack(t))
                        end
                else
                        self.portrait:SetTexCoord(0,1,0,1)
                end
        end
end)
end

--#13 /\Debuff Size/\
if (DebuffSize == 1) then
-- Target frame self-applied buffs/debuffs size:
LARGE_AURA_SIZE = 28
-- Target frame others buffs/debuffs size:
SMALL_AURA_SIZE = 17

-- These are used elsewhere in the TargetFrame.lua code, you shouldnt change them here
NUM_TOT_AURA_ROWS = 2
AURA_ROW_WIDTH = 122
AURA_OFFSET_Y = 3

-- Copy-paste of the Blizzard function, uncommented
-- Everything with maxRowWidth is removed because the value is changed during the initial run
hooksecurefunc("TargetFrame_UpdateAuraPositions", function(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
        local size;
        local offsetY = AURA_OFFSET_Y;
        local rowWidth = 0;
        local firstBuffOnRow = 1;
        for i=1, numAuras do
                if ( largeAuraList[i] ) then
                        size = LARGE_AURA_SIZE;
                        offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y;
                else
                        size = SMALL_AURA_SIZE;
                end
                if ( i == 1 ) then
                        rowWidth = size;
                else
                        rowWidth = rowWidth + size + offsetX;
                end
                if ( rowWidth > maxRowWidth ) then
                        updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically);
                        rowWidth = size;
                        firstBuffOnRow = i;
                        offsetY = AURA_OFFSET_Y;
                else
                updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically);
                end
        end
end)
end

--#14 /\Hide MicroBars/\ ##Good to turn on for streams to allow a fitting spot for 'Now Playing' for songs##
if (MicroHide == 1) then
	CharacterMicroButton:SetAlpha(0)
	SpellbookMicroButton:SetAlpha(0)
	TalentMicroButton:SetAlpha(0)
	AchievementMicroButton:SetAlpha(0)
	QuestLogMicroButton:SetAlpha(0)
	GuildMicroButton:SetAlpha(0)
	LFDMicroButton:SetAlpha(0)
	CollectionsMicroButton:SetAlpha(0)
	EJMicroButton:SetAlpha(0)
	StoreMicroButton:SetAlpha(0)
	MainMenuMicroButton:SetAlpha(0)
	
end

--Stuff

