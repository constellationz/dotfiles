-- Easy commands
do
    -- Keys can be typed by themselves without parenthesis to call a function in the console
    -- [string]: () -> ()
    local shortcuts = {
        -- Reload config
        reload = hs.reload,

        -- Eject all volumes
        eject = function()
            for path, volume in pairs(hs.fs.volume.allVolumes()) do
                if path == "/" then
                    goto continue
                end
                local didEject, err = hs.fs.volume.eject(path)
                if didEject then
                    print("ejected " .. path)
                elseif err then
                    print("error ejecting " .. path .. ": " .. err)
                end
                ::continue::
            end
            return true
        end,
    }

    -- Metatable for globals
    local global_meta = {
        __index = function(self, key)
            local shortcut = shortcuts[key]
            if shortcut and type(shortcut) == "function" then
                shortcut()
            end
        end,
    }

    setmetatable(_G, global_meta)
end

-- Easy shortcuts
do
    function console()
        hs.application.open("Hammerspoon")
    end

    function text()
        hs.application.open("TextEdit")
    end

    function editor()
        hs.application.open("Zed")
    end

    function browser()
        hs.application.open("Chromium")
    end

    function finder()
        hs.application.open("Finder")
    end

    function terminal()
        hs.application.open("Terminal")
    end

    -- mnemonic keybinds
    -- t - textedit
    -- e - editor
    -- b - browser
    -- c - hammerspoon console
    -- enter - enter a command
    -- space - spotlight (for files)
    --
    -- NOTES:
    -- cmd+shift+b conflicts with *bookmarks* and *sidebar* keybinds
    -- cmd+shift+e conflicts with *explorer* keybind
    -- cmd+shift+t conflicts with *re-open closed tab*
    hs.hotkey.bind({ "cmd", "alt" }, "t", nil, text)
    hs.hotkey.bind({ "cmd", "alt" }, "e", nil, editor)
    hs.hotkey.bind({ "cmd", "alt" }, "b", nil, browser)
    hs.hotkey.bind({ "cmd", "alt" }, "c", nil, console)
    hs.hotkey.bind({ "cmd", "shift" }, "space", nil, finder)
    hs.hotkey.bind({ "cmd", "shift" }, "return", nil, terminal)
end
