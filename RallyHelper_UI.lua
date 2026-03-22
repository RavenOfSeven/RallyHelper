RHGlobal = RHGlobal or {}
RHGlobal.Unconfirmed = RHGlobal.Unconfirmed or {}

local ui
local sizeUI

local ONY_ICON = "Interface\\Icons\\INV_Misc_Head_Dragon_Red"
local NEF_ICON = "Interface\\Icons\\INV_Misc_Head_Dragon_Blue"
local WB_ICON  = "Interface\\Icons\\Spell_Nature_BloodLust"

local DEFAULT_W = 420
local DEFAULT_H = 190
local DEFAULT_SCALE = 1.0

local floor = math.floor

local function IsLocked()
  return RallyHelperDB and RallyHelperDB.locked
end

local function FormatTime(sec)
  if not sec or sec <= 0 then return "ready", 0 end
  local h = floor(sec / 3600)
  local m = floor((sec - h * 3600) / 60)
  if h > 0 then return h .. "h " .. m .. "m", sec end
  return m .. "m", sec
end

local function Colorize(text, sec)
  if not sec or sec <= 0 then
    return "|cff33ff33" .. text .. "|r"
  elseif sec < 1800 then
    return "|cffffff33" .. text .. "|r"
  else
    return "|cffff3333" .. text .. "|r"
  end
end

local function FormatAgo(ts)
  if not ts then return "unknown" end
  local d = time() - ts
  if d < 60 then return d .. "s ago" end
  if d < 3600 then return floor(d / 60) .. "m ago" end
  local h = floor(d / 3600)
  local m = floor((d - h * 3600) / 60)
  return h .. "h " .. m .. "m ago"
end

local function EnsureDB()
  RallyHelperDB = RallyHelperDB or {}
  RallyHelperDB.ui = RallyHelperDB.ui or { w = DEFAULT_W, h = DEFAULT_H, scale = DEFAULT_SCALE }
  return RallyHelperDB.ui
end

local function ApplyPfUISkin(frame)
  if not frame or not pfUI or not pfUI.api then return end
  if pfUI.api.SkinFrame then pcall(pfUI.api.SkinFrame, frame) end
end

local function ApplyLayout()
  if not ui or not ui.initialized then return end

  local W = ui:GetWidth()
  local PAD, GAP = 16, 20
  local COL_W = (W - PAD * 2 - GAP) / 2
  local COL1_X, COL2_X = PAD, PAD + COL_W + GAP

  ui.onyIcon:SetPoint("TOPLEFT", ui, "TOPLEFT", COL1_X + COL_W/2 - 40, -30)
  ui.onyTitle:SetPoint("TOPLEFT", ui, "TOPLEFT", COL1_X, -30)
  ui.onyTitle:SetWidth(COL_W)

  ui.nefIcon:SetPoint("TOPLEFT", ui, "TOPLEFT", COL2_X + COL_W/2 - 40, -30)
  ui.nefTitle:SetPoint("TOPLEFT", ui, "TOPLEFT", COL2_X, -30)
  ui.nefTitle:SetWidth(COL_W)

  ui.onySW:SetPoint("TOPLEFT", ui, "TOPLEFT", COL1_X, -54)
  ui.onySW:SetWidth(COL_W)

  ui.onyOG:SetPoint("TOPLEFT", ui, "TOPLEFT", COL1_X, -70)
  ui.onyOG:SetWidth(COL_W)

  ui.nefSW:SetPoint("TOPLEFT", ui, "TOPLEFT", COL2_X, -54)
  ui.nefSW:SetWidth(COL_W)

  ui.nefOG:SetPoint("TOPLEFT", ui, "TOPLEFT", COL2_X, -70)
  ui.nefOG:SetWidth(COL_W)

  ui.zg:SetPoint("TOPLEFT", ui, "TOPLEFT", PAD, -98)
  ui.zg:SetWidth(W - PAD*2)

  ui.dmf:SetPoint("TOPLEFT", ui, "TOPLEFT", PAD, -114)
  ui.dmf:SetWidth(W - PAD*2)

  ui.wb:SetPoint("TOPLEFT", ui, "TOPLEFT", PAD, -138)
  ui.wb:SetWidth(W - PAD*2)
end

function UpdateTexts()
  if not ui or not ui.initialized or not RallyHelperDB then return end
  local DB = RallyHelperDB
  local t = time()

  local function FormatUnconfirmed(ev, label)
    local u = RHGlobal.Unconfirmed[ev]
    if not u then return nil end
    return "|cFFAAAAAA" .. label .. ": unconfirmed (" .. FormatAgo(u.ts) .. ")|r"
  end

  ui.onySW:SetText(
    FormatUnconfirmed("ONY_A", "Stormwind")
    or ("Stormwind: " .. Colorize(FormatTime(DB.lastOnyA and DB.lastOnyA + 7200 - t)))
  )

  ui.onyOG:SetText(
    FormatUnconfirmed("ONY_H", "Orgrimmar")
    or ("Orgrimmar: " .. Colorize(FormatTime(DB.lastOnyH and DB.lastOnyH + 7200 - t)))
  )

  ui.nefSW:SetText(
    FormatUnconfirmed("NEF_A", "Stormwind")
    or ("Stormwind: " .. Colorize(FormatTime(DB.lastNefA and DB.lastNefA + 7200 - t)))
  )

  ui.nefOG:SetText(
    FormatUnconfirmed("NEF_H", "Orgrimmar")
    or ("Orgrimmar: " .. Colorize(FormatTime(DB.lastNefH and DB.lastNefH + 7200 - t)))
  )

  ui.zg:SetText("ZG last drop: " .. (DB.lastZG and FormatAgo(DB.lastZG) or "unknown"))

  ui.dmf:SetText(
    "DMF last seen: "
    .. (DB.lastDMFTime and (FormatAgo(DB.lastDMFTime) .. " in " .. (DB.lastDMFZone or "unknown")) or "unknown")
  )

  ui.wb:SetText(
    FormatUnconfirmed("WB", "Warchief's Blessing")
    or ("Warchief's Blessing: " .. Colorize(FormatTime(DB.lastWB and DB.lastWB + 10800 - t)))
  )
end

function CreateUI()
  local S = EnsureDB()

  ui = ui or CreateFrame("Frame", "RallyHelperFrame", UIParent)
  ui:SetWidth(S.w)
  ui:SetHeight(S.h)
  ui:SetClampedToScreen(true)
  ui:SetMovable(true)
  ui:SetScale(S.scale or 1.0)

  if S.x and S.y then
    ui:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", S.x, S.y)
  else
    ui:SetPoint("CENTER")
  end

  ui.bgFrame = ui.bgFrame or CreateFrame("Frame", nil, ui)
  ui.bgFrame:SetAllPoints()
  ui.bgFrame:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    insets = { left=4, right=4, top=4, bottom=4 }
  })
  ui.bgFrame:SetBackdropColor(0,0,0,0.75)
  ui.bgFrame:SetAlpha(0.18)

  if not ui.initialized then
    ui.initialized = true

    local function CreateFS(r, g, b)
      local f = ui:CreateFontString(nil, "OVERLAY")
      f:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
      if r then f:SetTextColor(r, g, b) end
      f:SetJustifyH("CENTER")
      return f
    end

    ui.onyIcon = ui:CreateTexture(nil, "ARTWORK")
    ui.onyIcon:SetTexture(ONY_ICON)
    ui.onyIcon:SetWidth(16)
    ui.onyIcon:SetHeight(16)

    ui.nefIcon = ui:CreateTexture(nil, "ARTWORK")
    ui.nefIcon:SetTexture(NEF_ICON)
    ui.nefIcon:SetWidth(16)
    ui.nefIcon:SetHeight(16)

    ui.onyTitle = CreateFS()
    ui.onyTitle:SetText("Onyxia")

    ui.nefTitle = CreateFS()
    ui.nefTitle:SetText("Nefarian")

    ui.onySW = CreateFS(0.3, 0.6, 1)
    ui.onyOG = CreateFS(1, 0.3, 0.3)
    ui.nefSW = CreateFS(0.3, 0.6, 1)
    ui.nefOG = CreateFS(1, 0.3, 0.3)

    ui.zg  = CreateFS(0.2, 1, 0.2)
    ui.dmf = CreateFS(0.7, 0.4, 1)
    ui.wb  = CreateFS(1, 0.6, 0.1)

    ui:EnableMouse(true)
    ui:RegisterForDrag("LeftButton")

    ui:SetScript("OnDragStart", function()
      if not IsLocked() then ui:StartMoving() end
    end)

    ui:SetScript("OnDragStop", function()
      ui:StopMovingOrSizing()
      S.x, S.y = ui:GetLeft(), ui:GetBottom()
    end)

    ui:SetScript("OnEnter", function()
      ui.bgFrame:SetAlpha(1.0)
    end)

    ui:SetScript("OnLeave", function()
      ui.bgFrame:SetAlpha(0.18)
    end)

    ui:SetScript("OnUpdate", function()
      if (GetTime() - (ui._last or 0)) > 0.5 then
        ui._last = GetTime()
        UpdateTexts()
      end
    end)
  end

  ApplyLayout()
  UpdateTexts()
  ApplyPfUISkin(ui)
end

local unconfUI

RallyHelperDB = RallyHelperDB or {}
RallyHelperDB.unconfFilter = RallyHelperDB.unconfFilter or {
  ALLIANCE = true,
  HORDE = true,
  ZG = true,
  WB = true,
}

local FILTER = RallyHelperDB.unconfFilter
local MAX_UNCONFIRMED = 20

function CreateUnconfirmedUI()
  if unconfUI then return end

  unconfUI = CreateFrame("Frame", "RallyHelperUnconfirmedFrame", UIParent)
  unconfUI:SetWidth(320)
  unconfUI:SetHeight(240)
  unconfUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  unconfUI:SetFrameStrata("DIALOG")
  unconfUI:SetMovable(true)
  unconfUI:EnableMouse(true)
  unconfUI:RegisterForDrag("LeftButton")
  unconfUI:SetScript("OnDragStart", function() unconfUI:StartMoving() end)
  unconfUI:SetScript("OnDragStop", function() unconfUI:StopMovingOrSizing() end)

  unconfUI:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true, tileSize = 16, edgeSize = 16,
    insets = { left=4, right=4, top=4, bottom=4 }
  })
  unconfUI:SetBackdropColor(0, 0, 0, 0.35)

  local function AddCheck(label, key, x)
    local cb = CreateFrame("CheckButton", nil, unconfUI, "UICheckButtonTemplate")
    cb:SetPoint("TOPLEFT", unconfUI, "TOPLEFT", x, -6)
    cb:SetChecked(FILTER[key])

    cb.text = cb:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    cb.text:SetPoint("LEFT", cb, "RIGHT", 2, 0)
    cb.text:SetText(label)

    cb:SetScript("OnClick", function()
      FILTER[key] = cb:GetChecked()
      RallyHelper_UpdateUnconfirmed()
    end)
  end

  AddCheck("Alliance", "ALLIANCE", 10)
  AddCheck("Horde",    "HORDE",    100)
  AddCheck("ZG",       "ZG",       180)
  AddCheck("Warchief", "WB",       240)

  local scroll = CreateFrame("ScrollFrame", nil, unconfUI)
  scroll:SetPoint("TOPLEFT", unconfUI, "TOPLEFT", 8, -32)
  scroll:SetPoint("BOTTOMRIGHT", unconfUI, "BOTTOMRIGHT", -28, 8)

  local child = CreateFrame("Frame", nil, scroll)
  child:SetWidth(280)
  child:SetHeight(600)
  scroll:SetScrollChild(child)

  unconfUI.child = child
  unconfUI.scroll = scroll

  local slider = CreateFrame("Slider", nil, unconfUI, "UIPanelScrollBarTemplate")
  slider:SetPoint("TOPRIGHT", unconfUI, "TOPRIGHT", -4, -40)
  slider:SetPoint("BOTTOMRIGHT", unconfUI, "BOTTOMRIGHT", -4, 20)
  slider:SetMinMaxValues(0, 200)
  slider:SetValueStep(10)
  slider:SetWidth(16)

  slider:SetScript("OnValueChanged", function(_, v)
  if not unconfUI.scroll then return end
  local child = unconfUI.scroll:GetScrollChild()
  if not child then return end
  if v == nil then return end
  if v < 0 then v = 0 end
  unconfUI.scroll:SetVerticalScroll(v)
end)


  scroll:SetScript("OnMouseWheel", function(_, delta)
  if not unconfUI.slider then return end
  local new = unconfUI.slider:GetValue() - delta * 20
  if new < 0 then new = 0 end
  unconfUI.slider:SetValue(new)
end)
  unconfUI.slider = slider
end




function RallyHelper_UpdateUnconfirmed()
  if not unconfUI then return end

  local child = unconfUI.child
  if not child then return end

  for _, f in ipairs(child.lines or {}) do f:Hide() end
  child.lines = child.lines or {}

  local list = {}
  for ev, data in pairs(RHGlobal.Unconfirmed) do
    table.insert(list, { ev = ev, ts = data.ts, zone = data.zone })
  end

  table.sort(list, function(a, b) return a.ts > b.ts end)

  while table.getn(list) > MAX_UNCONFIRMED do
    table.remove(list)
  end

  local i = 0

  for _, entry in ipairs(list) do
    local ev = entry.ev
    local ts = entry.ts

    local label, color, category

    if ev == "ONY_A" then
      label = "Ony_Alliance"
      color = "|cff3399ff"
      category = "ALLIANCE"
    elseif ev == "NEF_A" then
      label = "Nef_Alliance"
      color = "|cff3399ff"
      category = "ALLIANCE"
    elseif ev == "ONY_H" then
      label = "Ony_Horde"
      color = "|cffff3333"
      category = "HORDE"
    elseif ev == "NEF_H" then
      label = "Nef_Horde"
      color = "|cffff3333"
      category = "HORDE"
    elseif ev == "ZG" then
      label = "ZG"
      color = "|cff33ff33"
      category = "ZG"
    elseif ev == "WB" then
      label = "Warchief"
      color = "|cffffaa33"
      category = "WB"
    else
      label = ev
      color = "|cFFAAAAAA"
      category = "OTHER"
    end

    if FILTER[category] then
      i = i + 1

      local line = child.lines[i]
      if not line then
        line = child:CreateFontString(nil, "OVERLAY")
        line:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
        line:SetJustifyH("LEFT")
        child.lines[i] = line
      end

      local count = 0
      if verify and verify[ev] then
        count = table.getn(verify[ev])
      end

      line:SetPoint("TOPLEFT", child, "TOPLEFT", 0, - (i - 1) * 18)

      line:SetText(
        color .. label .. "|r" ..
        "  |cFFAAAAAA" .. count .. "/2 Unconfirmed  " .. FormatAgo(ts) .. "|r"
      )
      line:Show()
    end
  end

  if i == 0 then
    unconfUI.slider:SetMinMaxValues(0, 0)
    unconfUI.slider:SetValue(0)
    return
  end

  unconfUI.slider:SetMinMaxValues(0, math.max(0, i * 18 - 180))
end



function RallyHelper_ToggleUnconfirmed()
  if not unconfUI then CreateUnconfirmedUI() end
  if unconfUI:IsShown() then
    unconfUI:Hide()
  else
    RallyHelper_UpdateUnconfirmed()
    unconfUI:Show()
  end
end

local sizeUI

function CreateSizeUI()
  if sizeUI then return end

  local S = EnsureDB()

  sizeUI = CreateFrame("Frame", "RallyHelperSizeFrame", UIParent)
  sizeUI:SetWidth(340)
  sizeUI:SetHeight(240)
  sizeUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  sizeUI:SetFrameStrata("DIALOG")

  sizeUI:SetBackdrop({
    bgFile="Interface\\DialogFrame\\UI-DialogBox-Background",
    edgeFile="Interface\\DialogFrame\\UI-DialogBox-Border",
    tile=true, tileSize=32, edgeSize=32,
    insets={left=11,right=12,top=12,bottom=11}
  })

  sizeUI:EnableMouse(true)
  sizeUI:SetMovable(true)
  sizeUI:RegisterForDrag("LeftButton")
  sizeUI:SetScript("OnDragStart", function() sizeUI:StartMoving() end)
  sizeUI:SetScript("OnDragStop", function() sizeUI:StopMovingOrSizing() end)

  local function CreateFS(parent, size, r, g, b)
    local f = parent:CreateFontString(nil, "OVERLAY")
    f:SetFont("Fonts\\FRIZQT__.TTF", size or 12, "OUTLINE")
    if r then f:SetTextColor(r, g, b) end
    f:SetJustifyH("LEFT")
    return f
  end

  local title = sizeUI:CreateFontString(nil, "OVERLAY", "GameFontNormal")
  title:SetPoint("TOP", 0, -15)
  title:SetText("RallyHelper UI Settings")

  local widthText = CreateFS(sizeUI, 14)
  widthText:SetPoint("TOPLEFT", 20, -50)
  widthText:SetText("Width")

  local widthSlider = CreateFrame("Slider", nil, sizeUI, "OptionsSliderTemplate")
  widthSlider:SetPoint("TOPLEFT", 20, -70)
  widthSlider:SetWidth(300)
  widthSlider:SetMinMaxValues(300, 700)
  widthSlider:SetValueStep(10)

  widthSlider:SetScript("OnValueChanged", function()
    local v = floor(widthSlider:GetValue() + 0.5)
    S.w = v
    if ui then ui:SetWidth(v); ApplyLayout() end
  end)

  local heightText = CreateFS(sizeUI, 14)
  heightText:SetPoint("TOPLEFT", 20, -110)
  heightText:SetText("Height")

  local heightSlider = CreateFrame("Slider", nil, sizeUI, "OptionsSliderTemplate")
  heightSlider:SetPoint("TOPLEFT", 20, -130)
  heightSlider:SetWidth(300)
  heightSlider:SetMinMaxValues(140, 400)
  heightSlider:SetValueStep(10)

  heightSlider:SetScript("OnValueChanged", function()
    local v = floor(heightSlider:GetValue() + 0.5)
    S.h = v
    if ui then ui:SetHeight(v); ApplyLayout() end
  end)

  local scaleText = CreateFS(sizeUI, 14)
  scaleText:SetPoint("TOPLEFT", 20, -160)
  scaleText:SetText("Scale")

  local scaleSlider = CreateFrame("Slider", nil, sizeUI, "OptionsSliderTemplate")
  scaleSlider:SetPoint("TOPLEFT", 20, -180)
  scaleSlider:SetWidth(300)
  scaleSlider:SetMinMaxValues(0.7, 1.3)
  scaleSlider:SetValueStep(0.05)

  scaleSlider:SetScript("OnValueChanged", function()
    local v = floor(scaleSlider:GetValue() * 100 + 0.5) / 100
    S.scale = v
    if ui then ui:SetScale(v) end
  end)

  local close = CreateFrame("Button", nil, sizeUI, "UIPanelButtonTemplate")
  close:SetWidth(80)
  close:SetHeight(24)
  close:SetPoint("BOTTOM", 0, 15)
  close:SetText("Close")
  close:SetScript("OnClick", function() sizeUI:Hide() end)

  widthSlider:SetValue(S.w or DEFAULT_W)
  heightSlider:SetValue(S.h or DEFAULT_H)
  scaleSlider:SetValue(S.scale or DEFAULT_SCALE)
end

_G.RallyHelper_ToggleUI = function()
  if not ui then CreateUI() end
  if ui:IsShown() then ui:Hide() else ui:Show() end
end

_G.RallyHelper_ToggleSizeUI = function()
  if not sizeUI then CreateSizeUI() end
  if sizeUI:IsShown() then sizeUI:Hide() else sizeUI:Show() end
end

_G.RallyHelper_UpdateUI = UpdateTexts
_G.RH_CreateUI = CreateUI
