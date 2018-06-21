--╔═══╗╔══╗╔═╗╔═╗╔═══╗╔╗   ╔═══╗     ╔═══╗╔╗ ╔╗╔═══╗╔══╗
--║╔═╗║╚╣─╝║║╚╝║║║╔═╗║║║   ║╔══╝     ║╔═╗║║║ ║║║╔═╗║╚╣─╝
--║╚══╗ ║║ ║╔╗╔╗║║╚═╝║║║   ║╚══╗     ║║ ║║║╚═╝║║╚═╝║ ║║ 
--╚══╗║ ║║ ║║║║║║║╔══╝║║ ╔╗║╔══╝     ║╚═╝║║╔═╗║║╔╗╔╝ ║║ 
--║╚═╝║╔╣─╗║║║║║║║║   ║╚═╝║║╚══╗     ║╔═╗║║║ ║║║║║╚╗╔╣─╗
--╚═══╝╚══╝╚╝╚╝╚╝╚╝   ╚═══╝╚═══╝     ╚╝ ╚╝╚╝ ╚╝╚╝╚═╝╚══╝
-- Changelog V1.1
-- +The option to choose OpenPredict or GoSPred is added
--
-- V1.0 released to GoS.



-- [[ Champion ]]
if GetObjectName(GetMyHero()) ~= "Ahri" then return end

-- [[ Lib & Other ]]
require ("OpenPredict")
require ("DamageLib")
function AhriScriptPrint(msg)
	print("<font color=\"#00ffff\">Ahri Script:</font><font color=\"#ffffff\"> "..msg.."</font>")

end
AhriScriptPrint("Made by EweEwe")

--  [[ AutoUpdate ]]
local version = "1.1"
function AutoUpdate(data)
	if tonumber(data) > tonumber(version) then
		PrintChat("<font color='#00ffff'>New version found!"  .. data)
        PrintChat("<font color='#00ffff'>Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/EweWexD/Ahri/master/Ahri.lua", SCRIPT_PATH .. "Ahri.lua", function() PrintChat("<font color='#00ffff'>DUpdate Complete, please 2x F6!") return end)
    else
    	PrintChat("<font color='#00ffff'>No updates found!")
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/EweWexD/Ahri/master/Ahri.version")


-- [[ Menu ]]
local AhriMenu = Menu("Ahri", "Simple Ahri")
-- [[ Combo ]]
AhriMenu:SubMenu("Combo", "[Ahri] Combo Settings")
AhriMenu.Combo:Boolean("Q", "Use Q", true)
AhriMenu.Combo:Boolean("W", "Use W", true)
AhriMenu.Combo:Boolean("E", "Use E", true)
AhriMenu.Combo:Boolean("R", "Use R", true)
AhriMenu.Combo:Slider("ME", "Minimum Enemies: R", 1, 0, 5, 1)
AhriMenu.Combo:Slider("HP","HP-Manager: R", 40, 0, 100, 5)
-- [[ Harass ]]
AhriMenu:SubMenu("Harass", "[Ahri] Harass Settings")
AhriMenu.Harass:Boolean("Q", "Use Q", true)
AhriMenu.Harass:Boolean("W", "Use W", true)
AhriMenu.Harass:Boolean("E", "Use E", true)
AhriMenu.Harass:Slider("Mana", "Min. Mana", 50, 0, 100, 1)
-- [[ LaneClear ]]
AhriMenu:SubMenu("Farm", "[Ahri] Farm Settings")
AhriMenu.Farm:Boolean("Q", "Use Q", true)
AhriMenu.Farm:Slider("Mana", "Min. Mana", 50, 0, 100, 1)
-- [[ KillSteal ]]
AhriMenu:SubMenu("KS", "[Ahri] Kill Steal Settings")
AhriMenu.KS:Boolean("Q", "Use Q", true)
AhriMenu.KS:Boolean("W", "Use W", true)
-- [[ Prediction ]]
AhriMenu:SubMenu("Prediction", "[Ahri] Q & E Prediction")
AhriMenu.Prediction:DropDown("PredQ", "Prediction Q:", 2, {"OpenPredict", "GoSPred"})
AhriMenu.Prediction:DropDown("PredE", "Prediction E:", 2, {"OpenPredict", "GoSPred"})
-- [[ AutoLevel ]]
AhriMenu:SubMenu("AutoLevel", "[Ahri] AutoLevel")
AhriMenu.AutoLevel:Boolean("DisableAUTOMAX", "Auto max abilities R>Q>E>W", false)
-- [[ Draw ]]
AhriMenu:SubMenu("Draw", "[Ahri] Drawing Settings")
AhriMenu.Draw:Boolean("Q", "Draw Q", false)
AhriMenu.Draw:Boolean("W", "Draw W", false)
AhriMenu.Draw:Boolean("E", "Draw E", false)
AhriMenu.Draw:Boolean("R", "Draw R", false)
AhriMenu.Draw:Boolean("Disable", "Disable all drawingw", false)

-- [[ AutoLevel ]]
local levelsc = {_Q, _E, _W, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W }

-- [[ Spell details ]]
local Spells = {
	Q = {range = 880, delay = 0.25, speed = 1700, width = 100 },
	W = {range = 700},
	E = {range = 975, delay = 0.25, speed = 1600, width = 60},
	R = {range = 450},
}

-- [[ Orbwalker ]]
function Mode()
	if _G.IOW_Loaded and IOW:Mode() then
		return IOW:Mode()
	elseif _G.PW_Loaded and PW:Mode() then
		return PW:Mode()
	elseif _G.DAC_Loaded and DAC:Mode() then
		return DAC:Mode()
	elseif _G.AutoCarry_Loaded and DACR:Mode() then
		return DACR:Mode()
	elseif _G.SLW_Loaded and SLW:Mode() then
		return SLW:Mode()
	end
end

-- [[ Tick ]]
OnTick(function()
	KS()
	AutoLevel()
	target = GetCurrentTarget()
			 Combo()
			 Harass()
			 Farm()
		end)

-- [[ AutoLevel ]]
function AutoLevel()
	if AhriMenu.AutoLevel.DisableAUTOMAX:Value() then return end
	if GetLevelPoints(myHero) > 0 then
		DelayAction(function() LevelSpell(levelsc[GetLevel(myHero) + 1 - GetLevelPoints(myHero)]) end, 0.5)
	end
end

-- [[ Ahri Q ]]
function AhriQ()
	if AhriMenu.Prediction.PredQ:Value() == 1 then
		local QPred = GetLinearAOEPrediction(target, Spells.Q)
		if QPred.hitChance > 0.9 then
			CastSkillShot(_Q, QPred.castPos)
		end
	elseif AhriMenu.Prediction.PredQ:Value() == 2 then
		local PredQ = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), Spells.Q.speed, Spells.Q.delay*1000, Spells.Q.range, Spells.Q.width,false,true)
		if PredQ.hitChance == 1 then
			CastSkillShot(_Q, QPred.PredPos)
		end
	end
end
-- [[ Ahri W ]]
function AhriW()
	CastTargetSpell(target, _W)
end
-- [[ Ahri E ]]
function AhriE()
	if AhriMenu.Prediction.PredE:Value() == 1 then
		local EPred = GetLinearAOEPrediction(target, Spells.E)
		if EPred.hitChance > 0.9 then
			CastSkillShot(_E, EPred.castPos)
		end
	elseif AhriMenu.Prediction.PredE:Value() == 2 then
		local PredE = GetPredictionForPlayer(GetOrigin(myHero), target, GetMoveSpeed(target), Spells.E.speed, Spells.E.delay*1000, Spells.E.range, Spells.E.width,true,false)
		if PredQ.hitChance == 1 then
			CastSkillShot(_Q, EPred.PredPos)
		end
	end
end

-- [[ Combo ]]
function Combo()
	if Mode() == "Combo" then
		-- [[ Use E ]]
		if AhriMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, Spells.E.range) then
			AhriE()
			end
		-- [[ Use Q ]]
		if AhriMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, Spells.Q.range) then
			AhriQ()
			end
		-- [[ Use W ]]
		if AhriMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, Spells.W.range) then
			AhriW()
			end
		-- [[ Use R ]]
		if AhriMenu.Combo.R:Value() then
			if CanUseSpell(myHero,_R) == Ready then
				if ValidTarget(target, Spells.R.range+GetRange(myHero)) then
					if 100*GetCurrentHp(target)/GetMaxHP(target) < AhriMenu.Combo.HP:Value() then
						if EnemiesAraund(myHEro, Spells.R.range+GetRange(myHero)) >= AhriMenu.Combo.ME:Value() then
							CastSkillShot(_R, GetMousePos())
						end
					end
				end
			end
		end
	end
end

-- [[ Harass ]]
function Harass()
	if Mode() == "Harass" then
		if (myHero.mana/myHero.maxMana >= AhriMenu.Harass.Mana:Value() /100) then
			-- [[ Use Q ]]
			if AhriMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, Spells.Q.range) then
				AhriQ()
			end
			-- [[ Use W ]]
			if AhriMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, Spells.W.range) then
				AhriW()
			end
			-- [[ Use E ]]
			if AhriMenu.Harass.E:Value() and Ready(_E) and ValidTarget(target, Spells.E.range) then
				AhriE()
			end
		end
	end
end

-- [[ LaneClear ]]
function Farm()
	if Mode() == "LaneClear" then
		if AhriMenu.Farm.Q:Value() then
			for _, minion in pairs(minionManager.objects) do
				if GetTeam(minion) == MINION_ENEMY then
					if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > AhriMenu.Farm.Mana:Value() then
						if ValidTarget(minion, Spells.Q.range) then
							if CanUseSpell(myHero,_Q) == READY then
								CastSkillShot(_Q, GetOrigin(minion))
							end
						end
					end
				end
			end
		end
	end
end

-- [[ KillSteals ]]
function KS()
	for _, enemy in pairs(GetEnemyHeroes()) do
		-- [[ Use Q ]]
		if AhriMenu.KS.Q:Value() and Ready(_Q) and ValidTarget(enemy, Spells.Q.range) then
			if GetCurrentHP(enemy) < getdmg("Q", enemy, myHero) then
				AhriQ()
				end
			end
		-- [[ Use W ]]
		if AhriMenu.KS.Q:Value() and Ready(_W) and ValidTarget(enemy, Spells.W.range) then
			if GetCurrentHP(enemy) < getdmg("W", enemy, myHero) then
				AhriW()
				end
			end
		end
	end

-- [[ Drawings ]]
OnDraw(function(myHero)
	if myHero.dead or AhriMenu.Draw.Disable:Value() then return end
	local pos = GetOrigin(myHero)
	-- [[ Draw Q ]]
	if AhriMenu.Draw.Q:Value() then DrawCircle(pos, Spells.Q.range, 1, 25, 0xC822D04A) end
	-- [[ Draw W ]]
	if AhriMenu.Draw.W:Value() then DrawCircle(pos, Spells.W.range, 1, 25, 0xFF007FAD) end
	-- [[ Draw E ]]
	if AhriMenu.Draw.E:Value() then DrawCircle(pos, Spells.E.range, 1, 25, 0xC8DE38C0) end
	-- [[ Draw R ]]
	if AhriMenu.Draw.R:Value() then DrawCircle(pos, Spells.R.range, 1, 25, 0xFF91C9DD) end
end)
