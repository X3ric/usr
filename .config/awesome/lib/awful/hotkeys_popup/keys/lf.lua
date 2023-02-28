local hotkeys_popup = require("lib.awful.hotkeys_popup.widget")
local lf_rule = { name = { 'lf' } }
for group_name, group_data in pairs({
    ["#lf"] = { color="#6042f5", rule_any=lf_rule },
    ["#lf Ctrl"] = { color="#6042f5", rule_any=lf_rule },
    ["#lf Ctrl cmd"] = { color="#6042f5", rule_any=lf_rule },
    ["#lf Alt cmd"] = { color="#6042f5", rule_any=lf_rule },
}) do
    hotkeys_popup.add_group_rules(group_name, group_data)
end

local lf_keys = {
    ["#lf"] = {{
        modifiers = {},
        keys = {
            za     = "info size:time",
            zh     = "hidden",
            zn     = "info",
            zr     = "reverse",
            zs     = "info size",
            zt     = "info time",
            q      = "quit",
            k      = "move with arrows",
            y      = "copy",
            p      = "paste",
            c      = "clear",
            space  = "select",
            u      = "unselect",
            v      = "invert",
            r      = "rename",
            f      = "find",
            F      = "find back",
            [';']  = "find next",
            [',']  = "find prev",
            h      = "updir",
            l      = "open",
            gh     = "cd",
            gg     = "top",
            G      = "bootm",
            [':']  = "read",
            ['$']  = "shell",
            ['%']  = "shell pipe",
            ['!']  = "shell wait",
            ['&amp;'] = "shell async",
            ['/']  = "search",
            ['?']  = "search back",
            N  = "search prev",
            n  = "search next",
            m  = "mark save",
            ["'"]  = "mark load",
            ['"']  = "mark remove",
            t      = "tag toggle",
        }
    }},

    ["#lf Ctrl"] = {{
        modifiers = { "Ctrl" },
        keys = {
            b      = "page up",
            f      = "page down",
            y      = "scroll up",
            e      = "scroll down",
            u      = "half up",
            d      = "half down",
            l      = "redraw",
            r      = "reload",
        }
    }},

    ["#lf Ctrl cmd"] = {{
        modifiers = { "Ctrl" },
        keys = {
            j      = "enter",
            c      = "interrupt",
            n      = "history next",
            p      = "history prev",
            b      = "Left",
            f      = "Right",
            e      = "end",
            a      = "home",
            u      = "delete home",
            d      = "delete",
            k      = "delete end",
            w      = "delete word",
            y      = "yank",
            t      = "transpose",
            r      = "reload",
        }
    }},

    ["#lf Alt cmd"] = {{
        modifiers = { Mod1 },
        keys = {
            u      = "uppercase-word",
            l      = "lowercase-word",
            t      = "transpose word",
            f      = "word",
            b      = "word back",
            d      = "delete word",
            c      = "capitalize word",
        }
    }},
}

hotkeys_popup.add_hotkeys(lf_keys)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80

