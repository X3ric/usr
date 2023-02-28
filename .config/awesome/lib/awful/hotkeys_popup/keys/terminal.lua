local hotkeys_popup = require("lib.awful.hotkeys_popup.widget")
local term_rule = { class = {"kitty"} }
for group_name, group_data in pairs({
    ["#Terminal"] = { color = "#9b42f5", rule_any = term_rule },
    ["#Kitty"] = { color = "#9b42f5", rule_any = term_rule },
    ["#Kitty scrolling"] = { color = "#9b42f5", rule_any = term_rule },
    ["#Kitty tabs"] = { color = "#9b42f5", rule_any = term_rule },
    ["#Kitty windows"] = { color = "#9b42f5", rule_any = term_rule },
    ["#Kitty opacity"] = { color = "#9b42f5", rule_any = term_rule },
}) do
    hotkeys_popup.add_group_rules(group_name, group_data)
end

local term_keys = {

    ["#Terminal"] = {{
        modifiers = { "Ctrl" },
        keys = {
            c = "Kill command",
            z = "Suspend command",
            d = "Delete char at cursor",
            l = "Clears screen",
            a = "Move cursor at beginning",
            e = "Move cursor at end",
            k = "Erase ater cursor",
            w = "Erase word before cursor",
            y = "Paste last tingh cutted",
            p = "Previous command history",
            n = "Next command history",
            r = "Search in history"      
        }
    }},

    ["#Kitty"] = {{
        modifiers = { "Ctrl" , "Shift"},
        keys = {
           F1 = "show help",
           F2 = "Edit kitty config",
           F5 = "Reload kitty config",
           F6 = "Debug kitty config",
            c = "copy",
            v = "paste",
            s = "copy selected",
            o = "Pass selection to program",
      ['+'] = "Increase font size",
      ['-'] = "Decrease font size",
    Backspace = "Restore font size",
            u = "Input unicode char",
            e = "Open url",
       Delete = "Reset terminal", 
       Escape = "Open kitty shell",     
        }
    }},

    ["#Kitty opacity"] = {{
        modifiers = { "Ctrl" , "Shift" , "a"},
        keys = {
            m = "Increase",
            l = "Decrease",
        ['1'] = "Full opacity",
            d = "Reset opacity",   
        }
    }},

    ["#Kitty scrolling"] = {{
        modifiers = { "Ctrl" , "Shift" },
        keys = {
          Up = "Line up",
        Down = "Decrease",
        Next = "page up",
       Prior = "page down",
        home = "top",
     ['end'] = "bottom",
           z = "previous shell",
           x = "next shell",
           h = "Browse scrollback in less",   
           g = "Browse last cmd output",
        }
    }},

    ["#Kitty tabs"] = {{
        modifiers = { "Ctrl" , "Shift" },
        keys = {
           t = "New tab",
           q = "Close tab",
       right = "next tab",
        left = "pevious tab",
           l = "next layout",
       ['.'] = "move tab forward",
       [','] = "move tab backward",
        }
    },{
        modifiers = { "Ctrl" , "Shift" , "alt" },
        keys = {
           t = "Set tab title",    
        }
    }},

    ["#Kitty windows"] = {{
        modifiers = { "Ctrl" , "Shift" },
        keys = {
      Return = "New window",
           n = "New OS window",
           w = "Close window",
     ['['] = "pevious window",
     [']'] = "next window",
           f = "move window forward",
           b = "move window backward",
       ['`'] = "Move window to top",
          F7 = "Visually focus window",
          F8 = "Visually swap window",
     ['0/9'] = "Focus specific window",
        }
    }}

    

}

hotkeys_popup.add_hotkeys(term_keys)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
