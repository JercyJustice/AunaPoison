-- AunaPoison AddOn for Turtle WoW
-- Shows poison stacks for main and off-hand weapons

-- Saved variables
AunaPoisonDB = AunaPoisonDB or {
    selectedMainPoison = nil,
    selectedOffPoison = nil,
    warnTime = 2,
    warnStacks = 5,
    showWarnings = true
}

local selectedMainPoison = nil
local selectedOffPoison = nil

-- Main frame
local AunaPoison = CreateFrame("Frame", "AunaPoisonFrame", UIParent)
AunaPoison:SetWidth(170)
AunaPoison:SetHeight(50)
AunaPoison:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -100)

AunaPoison:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 16,
    insets = { left = 4, right = 4, top = 4, bottom = 4 }
})
AunaPoison:SetBackdropColor(0, 0, 0, 0.8)
AunaPoison:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)

-- Title
local title = AunaPoison:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
title:SetPoint("TOP", AunaPoison, "TOP", 0, -7)
title:SetText("AunaPoison")
title:SetTextColor(1, 1, 0, 1)

-- Settings Button
local settingsBtn = CreateFrame("Button", "AunaPoisonSettingsBtn", AunaPoison)
settingsBtn:SetWidth(22)
settingsBtn:SetHeight(22)
settingsBtn:SetPoint("CENTER", AunaPoison, "CENTER", 0, -8)

settingsBtn:SetBackdrop({
    bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
    edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
    tile = true,
    tileSize = 16,
    edgeSize = 12,
    insets = { left = 2, right = 2, top = 2, bottom = 2 }
})
settingsBtn:SetBackdropColor(0.3, 0, 0, 0.8)
settingsBtn:SetBackdropBorderColor(0.6, 0, 0, 1)

settingsBtn:SetScript("OnEnter", function()
    this:SetBackdropColor(0.5, 0, 0, 0.9)
end)
settingsBtn:SetScript("OnLeave", function()
    this:SetBackdropColor(0.3, 0, 0, 0.8)
end)

local settingsText = settingsBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
settingsText:SetPoint("CENTER", settingsBtn, "CENTER", 0, 0)
settingsText:SetText("S")
settingsText:SetTextColor(1, 1, 1, 1)

-- Warning indicators (center screen)
local mainWarningIcon = CreateFrame("Frame", nil, UIParent)
mainWarningIcon:SetWidth(50)
mainWarningIcon:SetHeight(70)
mainWarningIcon:SetPoint("CENTER", UIParent, "CENTER", -60, 100)
mainWarningIcon:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
mainWarningIcon:SetBackdropColor(1, 0, 0, 0.8)
mainWarningIcon:Hide()

local mainWarningStacks = mainWarningIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
mainWarningStacks:SetPoint("TOP", mainWarningIcon, "TOP", 0, -5)
mainWarningStacks:SetText("0")
mainWarningStacks:SetTextColor(1, 1, 0, 1)

local mainWarningText = mainWarningIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
mainWarningText:SetPoint("CENTER", mainWarningIcon, "CENTER", 0, 0)
mainWarningText:SetText("MH")
mainWarningText:SetTextColor(1, 1, 1, 1)

local mainWarningTime = mainWarningIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
mainWarningTime:SetPoint("BOTTOM", mainWarningIcon, "BOTTOM", 0, 5)
mainWarningTime:SetText("0:00")
mainWarningTime:SetTextColor(1, 1, 0, 1)

local offWarningIcon = CreateFrame("Frame", nil, UIParent)
offWarningIcon:SetWidth(50)
offWarningIcon:SetHeight(70)
offWarningIcon:SetPoint("CENTER", UIParent, "CENTER", 60, 100)
offWarningIcon:SetBackdrop({bgFile = "Interface\\Tooltips\\UI-Tooltip-Background"})
offWarningIcon:SetBackdropColor(1, 0, 0, 0.8)
offWarningIcon:Hide()

local offWarningStacks = offWarningIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
offWarningStacks:SetPoint("TOP", offWarningIcon, "TOP", 0, -5)
offWarningStacks:SetText("0")
offWarningStacks:SetTextColor(1, 1, 0, 1)

local offWarningText = offWarningIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
offWarningText:SetPoint("CENTER", offWarningIcon, "CENTER", 0, 0)
offWarningText:SetText("OH")
offWarningText:SetTextColor(1, 1, 1, 1)

local offWarningTime = offWarningIcon:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
offWarningTime:SetPoint("BOTTOM", offWarningIcon, "BOTTOM", 0, 5)
offWarningTime:SetText("0:00")
offWarningTime:SetTextColor(1, 1, 0, 1)

-- Settings frame
local settingsFrame = nil

local function CreateSettingsFrame()
    if settingsFrame then
        settingsFrame:Hide()
        settingsFrame = nil
    end
    
    settingsFrame = CreateFrame("Frame", "AunaPoisonSettings", UIParent)
    settingsFrame:SetWidth(250)
    settingsFrame:SetHeight(200)
    settingsFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    
    settingsFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    settingsFrame:SetBackdropColor(0, 0, 0, 0.8)
    settingsFrame:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    
    local title = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOP", settingsFrame, "TOP", 0, -7)
    title:SetText("Settings")
    title:SetTextColor(1, 1, 0, 1)
    
    local closeBtn = CreateFrame("Button", nil, settingsFrame)
    closeBtn:SetWidth(20)
    closeBtn:SetHeight(20)
    closeBtn:SetPoint("TOPRIGHT", settingsFrame, "TOPRIGHT", -8, -5)
    closeBtn:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    closeBtn:SetBackdropColor(0.3, 0, 0, 0.8)
    closeBtn:SetBackdropBorderColor(0.6, 0, 0, 1)
    
    local closeBtnText = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    closeBtnText:SetPoint("CENTER", closeBtn, "CENTER", 0, 0)
    closeBtnText:SetText("X")
    closeBtnText:SetTextColor(1, 1, 1, 1)
    
    closeBtn:SetScript("OnEnter", function()
        this:SetBackdropColor(0.5, 0, 0, 0.9)
    end)
    closeBtn:SetScript("OnLeave", function()
        this:SetBackdropColor(0.3, 0, 0, 0.8)
    end)
    closeBtn:SetScript("OnClick", function()
        settingsFrame:Hide()
        settingsFrame = nil
    end)
    
    local warnCheckbox = CreateFrame("CheckButton", nil, settingsFrame)
    warnCheckbox:SetWidth(16)
    warnCheckbox:SetHeight(16)
    warnCheckbox:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 15, -35)
    warnCheckbox:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
    warnCheckbox:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
    warnCheckbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
    warnCheckbox:SetChecked(AunaPoisonDB.showWarnings)
    
    local warnLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    warnLabel:SetPoint("LEFT", warnCheckbox, "RIGHT", 5, 0)
    warnLabel:SetText("Show warning indicators")
    warnLabel:SetTextColor(1, 1, 1, 1)
    
    local stackLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    stackLabel:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 15, -65)
    stackLabel:SetText("Warn when stacks below:")
    stackLabel:SetTextColor(1, 1, 1, 1)
    
    local stackEditBox = CreateFrame("EditBox", nil, settingsFrame, "InputBoxTemplate")
    stackEditBox:SetWidth(40)
    stackEditBox:SetHeight(20)
    stackEditBox:SetPoint("TOPLEFT", stackLabel, "BOTTOMLEFT", 5, -5)
    stackEditBox:SetText(tostring(AunaPoisonDB.warnStacks))
    stackEditBox:SetAutoFocus(false)
    
    local timeLabel = settingsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    timeLabel:SetPoint("TOPLEFT", settingsFrame, "TOPLEFT", 15, -110)
    timeLabel:SetText("Warn when time below (min):")
    timeLabel:SetTextColor(1, 1, 1, 1)
    
    local timeEditBox = CreateFrame("EditBox", nil, settingsFrame, "InputBoxTemplate")
    timeEditBox:SetWidth(40)
    timeEditBox:SetHeight(20)
    timeEditBox:SetPoint("TOPLEFT", timeLabel, "BOTTOMLEFT", 5, -5)
    timeEditBox:SetText(tostring(AunaPoisonDB.warnTime))
    timeEditBox:SetAutoFocus(false)
    
    local saveBtn = CreateFrame("Button", nil, settingsFrame)
    saveBtn:SetWidth(80)
    saveBtn:SetHeight(25)
    saveBtn:SetPoint("BOTTOM", settingsFrame, "BOTTOM", 0, 15)
    saveBtn:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    saveBtn:SetBackdropColor(0, 0.3, 0, 0.8)
    saveBtn:SetBackdropBorderColor(0, 0.6, 0, 1)
    
    local saveBtnText = saveBtn:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    saveBtnText:SetPoint("CENTER", saveBtn, "CENTER", 0, 0)
    saveBtnText:SetText("Save")
    saveBtnText:SetTextColor(1, 1, 1, 1)
    
    saveBtn:SetScript("OnEnter", function()
        this:SetBackdropColor(0, 0.5, 0, 0.9)
    end)
    saveBtn:SetScript("OnLeave", function()
        this:SetBackdropColor(0, 0.3, 0, 0.8)
    end)
    saveBtn:SetScript("OnClick", function()
        AunaPoisonDB.showWarnings = warnCheckbox:GetChecked()
        AunaPoisonDB.warnStacks = tonumber(stackEditBox:GetText()) or 5
        AunaPoisonDB.warnTime = tonumber(timeEditBox:GetText()) or 2
        SaveBindings(2)
        DEFAULT_CHAT_FRAME:AddMessage("AunaPoison settings saved!")
        settingsFrame:Hide()
        settingsFrame = nil
    end)
    
    settingsFrame:SetMovable(true)
    settingsFrame:EnableMouse(true)
    settingsFrame:RegisterForDrag("LeftButton")
    settingsFrame:SetScript("OnDragStart", function()
        this:StartMoving()
    end)
    settingsFrame:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
    end)
    
    settingsFrame:Show()
end

settingsBtn:SetScript("OnClick", function()
    CreateSettingsFrame()
end)

-- Icon for main hand
local mainIcon = CreateFrame("Frame", "MainPoisonIcon", AunaPoison)
mainIcon:SetWidth(20)
mainIcon:SetHeight(20)
mainIcon:SetPoint("RIGHT", settingsBtn, "LEFT", -10, 0)

local mainIconTexture = mainIcon:CreateTexture(nil, "ARTWORK")
mainIconTexture:SetAllPoints(mainIcon)
mainIconTexture:SetTexture("Interface\\Icons\\INV_Weapon_ShortBlade_05")

local mainButton = CreateFrame("Button", "MainPoisonButton", mainIcon)
mainButton:SetAllPoints(mainIcon)
mainButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Icon for off hand
local offIcon = CreateFrame("Frame", "OffPoisonIcon", AunaPoison)
offIcon:SetWidth(20)
offIcon:SetHeight(20)
offIcon:SetPoint("LEFT", settingsBtn, "RIGHT", 10, 0)

local offIconTexture = offIcon:CreateTexture(nil, "ARTWORK")
offIconTexture:SetAllPoints(offIcon)
offIconTexture:SetTexture("Interface\\Icons\\INV_Weapon_ShortBlade_05")

local offButton = CreateFrame("Button", "OffPoisonButton", offIcon)
offButton:SetAllPoints(offIcon)
offButton:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square")

-- Text for main hand
local mainHandText = AunaPoison:CreateFontString(nil, "OVERLAY", "GameFontNormal")
mainHandText:SetPoint("RIGHT", mainIcon, "LEFT", -5, 0)
mainHandText:SetText("0")
mainHandText:SetTextColor(1, 1, 1, 1)
mainHandText:SetJustifyH("RIGHT")

-- Text for off hand
local offHandText = AunaPoison:CreateFontString(nil, "OVERLAY", "GameFontNormal")
offHandText:SetPoint("LEFT", offIcon, "RIGHT", 5, 0)
offHandText:SetText("0")
offHandText:SetTextColor(1, 1, 1, 1)
offHandText:SetJustifyH("LEFT")

-- Function to update weapon icons
local function UpdateWeaponIcons()
    local mainHandTexture = GetInventoryItemTexture("player", 16)
    if mainHandTexture then
        mainIconTexture:SetTexture(mainHandTexture)
    else
        mainIconTexture:SetTexture("Interface\\Icons\\INV_Weapon_ShortBlade_05")
    end
    
    local offHandTexture = GetInventoryItemTexture("player", 17)
    if offHandTexture then
        offIconTexture:SetTexture(offHandTexture)
    else
        offIconTexture:SetTexture("Interface\\Icons\\INV_Weapon_ShortBlade_05")
    end
end

-- Poison selector
local poisonSelector = nil

local function CreatePoisonSelector(isMainHand)
    local poisonNames = {
        "Instant Poison", "Instant Poison II", "Instant Poison III", "Instant Poison IV", 
        "Instant Poison V", "Instant Poison VI", "Deadly Poison", "Deadly Poison II",
        "Deadly Poison III", "Deadly Poison IV", "Crippling Poison", "Crippling Poison II",
        "Mind-numbing Poison", "Mind-numbing Poison II", "Mind-numbing Poison III",
        "Wound Poison", "Dissolvent Poison", "Dissolvent Poison II", 
        "Corrosive Poison", "Agitating Poison"
    }
    
    local poisonIcons = {
        "Interface\\AddOns\\AunaPoison\\Icons\\InstantPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\InstantPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\InstantPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\InstantPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\InstantPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\InstantPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\DeadlyPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\DeadlyPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\DeadlyPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\DeadlyPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\CripplingPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\CripplingPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\MindnumbingPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\MindnumbingPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\MindnumbingPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\WoundPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\DissolventPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\DissolventPoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\CorrosivePoison",
        "Interface\\AddOns\\AunaPoison\\Icons\\AgitatingPoison"
    }
    
    if poisonSelector then
        poisonSelector:Hide()
        poisonSelector = nil
    end
    
    local numPoisons = 20
    local itemHeight = 18
    local topPadding = 35
    local bottomPadding = 15
    local frameHeight = topPadding + (numPoisons * itemHeight) + bottomPadding
    
    poisonSelector = CreateFrame("Frame", "PoisonSelectorFrame", UIParent)
    poisonSelector:SetWidth(250)
    poisonSelector:SetHeight(frameHeight)
    poisonSelector:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    
    poisonSelector:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    poisonSelector:SetBackdropColor(0, 0, 0, 0.8)
    poisonSelector:SetBackdropBorderColor(0.4, 0.4, 0.4, 1)
    
    local title = poisonSelector:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    title:SetPoint("TOP", poisonSelector, "TOP", 0, -7)
    title:SetText(isMainHand and "Main Hand Poison" or "Off Hand Poison")
    title:SetTextColor(1, 1, 0, 1)
    
    local closeBtn = CreateFrame("Button", nil, poisonSelector)
    closeBtn:SetWidth(20)
    closeBtn:SetHeight(20)
    closeBtn:SetPoint("TOPRIGHT", poisonSelector, "TOPRIGHT", -8, -5)
    closeBtn:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 12,
        insets = { left = 2, right = 2, top = 2, bottom = 2 }
    })
    closeBtn:SetBackdropColor(0.3, 0, 0, 0.8)
    closeBtn:SetBackdropBorderColor(0.6, 0, 0, 1)
    
    local closeBtnText = closeBtn:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
    closeBtnText:SetPoint("CENTER", closeBtn, "CENTER", 0, 0)
    closeBtnText:SetText("X")
    closeBtnText:SetTextColor(1, 1, 1, 1)
    
    closeBtn:SetScript("OnEnter", function()
        this:SetBackdropColor(0.5, 0, 0, 0.9)
    end)
    closeBtn:SetScript("OnLeave", function()
        this:SetBackdropColor(0.3, 0, 0, 0.8)
    end)
    closeBtn:SetScript("OnClick", function()
        poisonSelector:Hide()
        poisonSelector = nil
    end)
    
    local contentFrame = CreateFrame("Frame", nil, poisonSelector)
    contentFrame:SetPoint("TOPLEFT", poisonSelector, "TOPLEFT", 15, -30)
    contentFrame:SetPoint("BOTTOMRIGHT", poisonSelector, "BOTTOMRIGHT", -15, 15)
    
    local checkboxes = {}
    
    for i = 1, numPoisons do
        local poison = poisonNames[i]
        if poison then
            local frame = CreateFrame("Frame", nil, contentFrame)
            frame:SetWidth(220)
            frame:SetHeight(20)
            frame:SetPoint("TOPLEFT", contentFrame, "TOPLEFT", 0, -(i-1) * itemHeight)
            
            local checkbox = CreateFrame("CheckButton", nil, frame)
            checkbox:SetWidth(16)
            checkbox:SetHeight(16)
            checkbox:SetPoint("LEFT", frame, "LEFT", 0, 0)
            checkbox:SetNormalTexture("Interface\\Buttons\\UI-CheckBox-Up")
            checkbox:SetPushedTexture("Interface\\Buttons\\UI-CheckBox-Down")
            checkbox:SetCheckedTexture("Interface\\Buttons\\UI-CheckBox-Check")
            
            checkboxes[i] = checkbox
            
            local currentSelection = isMainHand and selectedMainPoison or selectedOffPoison
            if currentSelection == poison then
                checkbox:SetChecked(true)
            end
            
            local iconFrame = CreateFrame("Frame", nil, frame)
            iconFrame:SetWidth(16)
            iconFrame:SetHeight(16)
            iconFrame:SetPoint("LEFT", checkbox, "RIGHT", 3, 0)
            
            local iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
            iconTexture:SetAllPoints(iconFrame)
            
            if poisonIcons[i] then
                iconTexture:SetTexture(poisonIcons[i])
            end
            
            iconFrame:SetBackdrop({
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                edgeSize = 8,
                insets = { left = 1, right = 1, top = 1, bottom = 1 }
            })
            iconFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.5)
            
            local text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
            text:SetPoint("LEFT", iconFrame, "RIGHT", 3, 0)
            text:SetText(poison)
            text:SetTextColor(1, 1, 1, 1)
            
            frame:SetScript("OnEnter", function()
                text:SetTextColor(1, 1, 0, 1)
            end)
            frame:SetScript("OnLeave", function()
                text:SetTextColor(1, 1, 1, 1)
            end)
            
            checkbox:SetScript("OnClick", function()
                for j = 1, numPoisons do
                    if checkboxes[j] and checkboxes[j] ~= this then
                        checkboxes[j]:SetChecked(false)
                    end
                end
                
                this:SetChecked(true)
                
                if isMainHand then
                    selectedMainPoison = poison
                    AunaPoisonDB.selectedMainPoison = poison
                    DEFAULT_CHAT_FRAME:AddMessage("Main Hand: " .. poison .. " selected")
                else
                    selectedOffPoison = poison
                    AunaPoisonDB.selectedOffPoison = poison
                    DEFAULT_CHAT_FRAME:AddMessage("Off Hand: " .. poison .. " selected")
                end
            end)
        end
    end
    
    poisonSelector:SetMovable(true)
    poisonSelector:EnableMouse(true)
    poisonSelector:RegisterForDrag("LeftButton")
    poisonSelector:SetScript("OnDragStart", function()
        this:StartMoving()
    end)
    poisonSelector:SetScript("OnDragStop", function()
        this:StopMovingOrSizing()
    end)
    
    poisonSelector:Show()
end

-- Apply poison function
local function ApplyPoison(isMainHand)
    local selectedPoison = isMainHand and selectedMainPoison or selectedOffPoison
    if selectedPoison then
        for bag = 0, 4 do
            for slot = 1, GetContainerNumSlots(bag) do
                local itemName = GetContainerItemLink(bag, slot)
                if itemName and string.find(itemName, selectedPoison) then
                    UseContainerItem(bag, slot)
                    if isMainHand then
                        PickupInventoryItem(16)
                    else
                        PickupInventoryItem(17)
                    end
                    return
                end
            end
        end
        DEFAULT_CHAT_FRAME:AddMessage("Poison '" .. selectedPoison .. "' not found in inventory!")
    else
        DEFAULT_CHAT_FRAME:AddMessage("No poison selected!")
    end
end

-- Button handlers
mainButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
mainButton:SetScript("OnClick", function()
    if arg1 == "LeftButton" then
        ApplyPoison(true)
    elseif arg1 == "RightButton" then
        CreatePoisonSelector(true)
    end
end)

offButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
offButton:SetScript("OnClick", function()
    if arg1 == "LeftButton" then
        ApplyPoison(false)
    elseif arg1 == "RightButton" then
        CreatePoisonSelector(false)
    end
end)

-- Make window draggable
AunaPoison:SetMovable(true)
AunaPoison:EnableMouse(true)
AunaPoison:RegisterForDrag("LeftButton")
AunaPoison:SetScript("OnDragStart", function()
    this:StartMoving()
end)
AunaPoison:SetScript("OnDragStop", function()
    this:StopMovingOrSizing()
end)

-- Check poison charges
local function CheckPoisonCharges()
    local mainHandCharges, mainHandName = 0, "No Poison"
    local offHandCharges, offHandName = 0, "No Poison"
    
    local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
    
    if hasMainHandEnchant and mainHandCharges then
        mainHandCharges = mainHandCharges
        mainHandName = "Poison active"
    else
        mainHandCharges = 0
        mainHandName = "No Poison"
    end
    
    if hasOffHandEnchant and offHandCharges then
        offHandCharges = offHandCharges  
        offHandName = "Poison active"
    else
        offHandCharges = 0
        offHandName = "No Poison"
    end
    
    -- Check warnings and update stacks/time display
    if AunaPoisonDB.showWarnings then
        -- Main hand warning
        if hasMainHandEnchant then
            local timeLeft = mainHandExpiration / 1000 / 60
            
            -- Update stacks and time displays
            mainWarningStacks:SetText(tostring(mainHandCharges))
            local minutes = math.floor(timeLeft)
            local seconds = math.floor((timeLeft - minutes) * 60)
            mainWarningTime:SetText(string.format("%d:%02d", minutes, seconds))
            
            local shouldWarn = (timeLeft <= AunaPoisonDB.warnTime) or (mainHandCharges <= AunaPoisonDB.warnStacks)
            if shouldWarn then
                mainWarningIcon:Show()
            else
                mainWarningIcon:Hide()
            end
        else
            mainWarningStacks:SetText("0")
            mainWarningTime:SetText("0:00")
            mainWarningIcon:Show()
        end
        
        -- Off hand warning  
        if hasOffHandEnchant then
            local timeLeft = offHandExpiration / 1000 / 60
            
            -- Update stacks and time displays
            offWarningStacks:SetText(tostring(offHandCharges))
            local minutes = math.floor(timeLeft)
            local seconds = math.floor((timeLeft - minutes) * 60)
            offWarningTime:SetText(string.format("%d:%02d", minutes, seconds))
            
            local shouldWarn = (timeLeft <= AunaPoisonDB.warnTime) or (offHandCharges <= AunaPoisonDB.warnStacks)
            if shouldWarn then
                offWarningIcon:Show()
            else
                offWarningIcon:Hide()
            end
        else
            local offHandTexture = GetInventoryItemTexture("player", 17)
            offWarningStacks:SetText("0")
            offWarningTime:SetText("0:00")
            if offHandTexture then
                offWarningIcon:Show()
            else
                offWarningIcon:Hide()
            end
        end
    else
        mainWarningIcon:Hide()
        offWarningIcon:Hide()
    end
    
    -- Update text
    if mainHandCharges > 0 then
        mainHandText:SetText(mainHandCharges)
        if mainHandCharges <= 5 then
            mainHandText:SetTextColor(1, 0.3, 0.3, 1)
        else
            mainHandText:SetTextColor(0.3, 1, 0.3, 1)
        end
    else
        mainHandText:SetText("0")
        mainHandText:SetTextColor(0.7, 0.7, 0.7, 1)
    end
    
    local offHandTexture = GetInventoryItemTexture("player", 17)
    if offHandTexture then
        if offHandCharges > 0 then
            offHandText:SetText(offHandCharges)
            if offHandCharges <= 5 then
                offHandText:SetTextColor(1, 0.3, 0.3, 1)
            else
                offHandText:SetTextColor(0.3, 1, 0.3, 1)
            end
        else
            offHandText:SetText("0")
            offHandText:SetTextColor(0.7, 0.7, 0.7, 1)
        end
    else
        offHandText:SetText("-")
        offHandText:SetTextColor(0.5, 0.5, 0.5, 1)
    end
    
    -- Update weapon icons
    UpdateWeaponIcons()
end

-- Update timer
local updateTimer = 0
AunaPoison:SetScript("OnUpdate", function()
    updateTimer = updateTimer + arg1
    if updateTimer >= 0.5 then
        CheckPoisonCharges()
        updateTimer = 0
    end
end)

-- Events
AunaPoison:RegisterEvent("PLAYER_LOGIN")
AunaPoison:RegisterEvent("PLAYER_LOGOUT")
AunaPoison:RegisterEvent("UNIT_INVENTORY_CHANGED")
AunaPoison:RegisterEvent("PLAYER_AURAS_CHANGED")

AunaPoison:SetScript("OnEvent", function()
    if event == "PLAYER_LOGIN" then
        DEFAULT_CHAT_FRAME:AddMessage("AunaPoison loaded!")
        selectedMainPoison = AunaPoisonDB.selectedMainPoison
        selectedOffPoison = AunaPoisonDB.selectedOffPoison
        UpdateWeaponIcons()
    elseif event == "PLAYER_LOGOUT" then
        AunaPoisonDB.selectedMainPoison = selectedMainPoison
        AunaPoisonDB.selectedOffPoison = selectedOffPoison
    elseif event == "UNIT_INVENTORY_CHANGED" then
        UpdateWeaponIcons()
    end
    CheckPoisonCharges()
end)

-- Slash commands
SLASH_AUNAPOISON1 = "/ap"
SLASH_AUNAPOISON2 = "/aunapoison"
SlashCmdList["AUNAPOISON"] = function(msg)
    if msg == "show" then
        AunaPoison:Show()
        DEFAULT_CHAT_FRAME:AddMessage("AunaPoison shown")
    elseif msg == "hide" then
        AunaPoison:Hide()
        DEFAULT_CHAT_FRAME:AddMessage("AunaPoison hidden")
    elseif msg == "debug" then
        local hasMainHandEnchant, mainHandExpiration, mainHandCharges, hasOffHandEnchant, offHandExpiration, offHandCharges = GetWeaponEnchantInfo()
        DEFAULT_CHAT_FRAME:AddMessage("=== AunaPoison Debug ===")
        DEFAULT_CHAT_FRAME:AddMessage("Main Hand: " .. tostring(hasMainHandEnchant) .. " - Charges: " .. tostring(mainHandCharges) .. " - Time: " .. tostring(mainHandExpiration))
        DEFAULT_CHAT_FRAME:AddMessage("Off Hand: " .. tostring(hasOffHandEnchant) .. " - Charges: " .. tostring(offHandCharges) .. " - Time: " .. tostring(offHandExpiration))
        DEFAULT_CHAT_FRAME:AddMessage("Selected Main: " .. tostring(selectedMainPoison or "none"))
        DEFAULT_CHAT_FRAME:AddMessage("Selected Off: " .. tostring(selectedOffPoison or "none"))
        DEFAULT_CHAT_FRAME:AddMessage("Settings - Warn Time: " .. tostring(AunaPoisonDB.warnTime) .. "min, Warn Stacks: " .. tostring(AunaPoisonDB.warnStacks) .. ", Show Warnings: " .. tostring(AunaPoisonDB.showWarnings))
        
        if hasMainHandEnchant then
            local timeLeft = mainHandExpiration / 1000 / 60
            local shouldWarnTime = timeLeft <= AunaPoisonDB.warnTime
            local shouldWarnStacks = mainHandCharges <= AunaPoisonDB.warnStacks
            DEFAULT_CHAT_FRAME:AddMessage("Main Hand - Time left: " .. string.format("%.1f", timeLeft) .. "min, Warn Time: " .. tostring(shouldWarnTime) .. ", Warn Stacks: " .. tostring(shouldWarnStacks))
        end
        
        if hasOffHandEnchant then
            local timeLeft = offHandExpiration / 1000 / 60
            local shouldWarnTime = timeLeft <= AunaPoisonDB.warnTime
            local shouldWarnStacks = offHandCharges <= AunaPoisonDB.warnStacks
            DEFAULT_CHAT_FRAME:AddMessage("Off Hand - Time left: " .. string.format("%.1f", timeLeft) .. "min, Warn Time: " .. tostring(shouldWarnTime) .. ", Warn Stacks: " .. tostring(shouldWarnStacks))
        end
    elseif msg == "testwarning" then
        DEFAULT_CHAT_FRAME:AddMessage("Forcing warning indicators to show...")
        mainWarningIcon:Show()
        offWarningIcon:Show()
    elseif msg == "hidewarning" then
        DEFAULT_CHAT_FRAME:AddMessage("Hiding warning indicators...")
        mainWarningIcon:Hide()
        offWarningIcon:Hide()
    else
        DEFAULT_CHAT_FRAME:AddMessage("AunaPoison Commands:")
        DEFAULT_CHAT_FRAME:AddMessage("/ap show/hide - Show/hide addon")
        DEFAULT_CHAT_FRAME:AddMessage("/ap debug - Debug info") 
        DEFAULT_CHAT_FRAME:AddMessage("/ap testwarning - Force show warnings")
        DEFAULT_CHAT_FRAME:AddMessage("/ap hidewarning - Hide warnings")
    end
end

AunaPoison:Show()