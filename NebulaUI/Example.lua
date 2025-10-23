local library = loastring(game:HttpGet("https://raw.githubusercontent.com/JustLuaDeveloper/Libraries/refs/heads/main/NebulaUI/src.lua"))()
-- documentation
local window = library:window({
    name = os.date('script - %b %d %Y'),
    size = UDim2.new(0, 500, 0, 370)
})

local watermark = library:watermark({
    default = os.date('script - %b %d %Y - %H:%M:%S')
})

-- Tabs
local Aiming = window:tab({name = "Aiming"})
local Misc = window:tab({name = "Misc"})
local Settings = window:tab({name = "Settings"})

-- Aiming
do
    local column = Aiming:column()
    column:section({name = "Target Selection"})
        :toggle({name = "Toggle With Keybind", flag = "aim_toggle_key", callback = function()
            print("Toggle With Keybind On/Off")
        end})
        :keybind({name = "Aiming Key", flag = "aim_key", callback = function()
            if bounding_box_fill then
                bounding_box_fill.CFrame = CFrame.new(9e9, 9e9, 9e9)
            end
        end})
        :toggle({name = "Normal Toggle", flag = "aim_normal_toggle", callback = function()
            print("Toggle On/Off")
        end})
        :slider({name = "Slide", min = 0, max = 1000, default = 40, interval = 1, suffix = "ms", flag = "aim_slide", callback = function()
            print("This Is A Slide")
        end})
        :dropdown({name = "Multi Dropdown", flag = "aim_multi_dropdown", items = {"Juju", "Temple", "Eagle", "Unnamed"}, multi = true})
        :toggle({name = "Toggle With ColorPicker", flag = "aim_toggle_color"})
        :colorpicker({name = "Color Picker", flag = "aim_color", color = Color3.fromHex("#000000")})
        :dropdown({name = "Dropdown", flag = "aim_dropdown", items = {"One", "Two", "Three"}, multi = false, callback = function()
            print("Selected")
        end})
        :textbox({name = "TextBox", flag = "aim_textbox"})

    local column2 = Aiming:column()
    column2:section({name = "Section"}):toggle({name = "Toggle", flag = "aim_extra_toggle1"})
    column2:section({name = "Section"}):toggle({name = "Toggle", flag = "aim_extra_toggle2"})
end

-- Misc
do
    local column = Misc:column()
    column:section({name = "Combat"})
        :toggle({name = "Speed", flag = "speed_toggle"})
        :keybind({name = "Speed", flag = "speed_bind", mode = "toggle"})
        :slider({name = "Amount", flag = "speed_value", min = 0, max = 100, default = 10, interval = 1})
        :toggle({name = "Auto Jump", flag = "auto_jump"})
        :toggle({name = "Fly", flag = "fly_toggle"})
        :keybind({name = "Fly", flag = "fly_bind", mode = "toggle"})
        :slider({name = "Fly Amount", flag = "fly_value", min = 0, max = 100, default = 20, interval = 1})
        :toggle({name = "No Slow", flag = "no_slow"})
        :toggle({name = "No Jump Cooldown", flag = "no_jump_cooldown", callback = function(bool)
            if lp and lp.Character and lp.Character:FindFirstChild("Humanoid") then
                lp.Character.Humanoid.UseJumpPower = not bool
            end
        end})
        :toggle({name = "Auto Reload", flag = "auto_reload"})
        :toggle({name = "Auto Shoot", flag = "auto_shoot"})
        :slider({name = "Delay", flag = "auto_shoot_delay", min = 0, max = 1000, default = 50, interval = 1, suffix = "ms"})
        :toggle({name = "Auto Armor", flag = "auto_armor"})
        :toggle({name = "Anti Void Kill", flag = "anti_void_kill", callback = function(bool)
            if ws then
                ws.FallenPartsDestroyHeight = bool and -50000 or -500
            end
        end})
        :toggle({name = "Infinite Zoom", flag = "infinite_zoom", callback = function(bool)
            if lp and lp.CameraMaxZoomDistance then
                lp.CameraMaxZoomDistance = bool and 9e9 or 30
            end
        end})
end

-- Settings
do
    local column = Settings:column()
    local section = column:section({name = "Options"})
    local old_config = library:get_config()
    _, config_holder = section:list({flag = "config_name_list"})
    section:textbox({flag = "config_name_text_box"})
    section:button_holder({})
    section:button({name = "Create", callback = function()
        writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:get_config())
        library:config_list_update()
    end})
    section:button({name = "Delete", callback = function()
        delfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg")
        library:config_list_update()
    end})
    section:button_holder({})
    section:button({name = "Load", callback = function()
        library:load_config(readfile(library.directory .. "/configs/" .. flags["config_name_list"] .. ".cfg"))
    end})
    section:button({name = "Save", callback = function()
        writefile(library.directory .. "/configs/" .. flags["config_name_text_box"] .. ".cfg", library:get_config())
        library:config_list_update()
    end})
    section:button_holder({})
    section:button({name = "Unload Config", callback = function()
        library:load_config(old_config)
    end})
    section:button({name = "Unload Menu", callback = function()
        for _, gui in next, library.guis do gui:Destroy() end
        for _, connection in next, library.connections do connection:Disconnect() end
        if milkyboy then
            for _, instance in next, milkyboy.instances or {} do instance:Destroy() end
            for _, drawing in next, milkyboy.drawings or {} do drawing:Remove() end
        end
    end})
end

do
    local column = Settings:column()
    column:section({name = "Theme"})
        :label({name = "Accent"})
        :colorpicker({name = "Accent", color = themes.preset.accent, flag = "accent", callback = function(color)
            library:update_theme("accent", color)
        end})
        :label({name = "Contrast"})
        :colorpicker({name = "Low", color = themes.preset.low_contrast, flag = "low_contrast", callback = function()
            if flags["high_contrast"] and flags["low_contrast"] then
                library:update_theme("contrast", rgbseq{
                    rgbkey(0, flags["low_contrast"].Color),
                    rgbkey(1, flags["high_contrast"].Color)
                })
            end
        end})
        :colorpicker({name = "High", color = themes.preset.high_contrast, flag = "high_contrast", callback = function()
            library:update_theme("contrast", rgbseq{
                rgbkey(0, flags["low_contrast"].Color),
                rgbkey(1, flags["high_contrast"].Color)
            })
        end})
        :label({name = "Inline"})
        :colorpicker({name = "Inline", color = themes.preset.inline, callback = function(color)
            library:update_theme("inline", color)
        end})
        :label({name = "Outline"})
        :colorpicker({name = "Outline", color = themes.preset.outline, callback = function(color)
            library:update_theme("outline", color)
        end})
        :label({name = "Text Color"})
        :colorpicker({name = "Main", color = themes.preset.text, callback = function(color)
            library:update_theme("text", color)
        end})
        :colorpicker({name = "Outline", color = themes.preset.text_outline, callback = function(color)
            library:update_theme("text_outline", color)
        end})
        :label({name = "Glow"})
        :colorpicker({name = "Glow", color = themes.preset.glow, callback = function(color)
            library:update_theme("glow", color)
        end})
        :label({name = "UI Bind"})
        :keybind({callback = function(bool)
            if library.frame then
                library.frame.Enabled = bool
            end
        end})
        :toggle({name = "Keybind List", flag = "keybind_list", callback = function(bool)
            if library.keybind_list_frame then
                library.keybind_list_frame.Visible = bool
            end
        end})
end

library:config_list_update()

