-- morse
do
    -- Time of a morse bar
    local MORSE_BAR_DURATION = 0.3

    -- Time it takes for a morse code to clear and type
    local WAIT_TO_ENTER_DURATION = 1

    local NOISE_EVENT_START = 1
    local NOISE_EVENT_END = 2
    local NOISE_EVENT_POP = 3

    -- codes
    local MORSE_TRANSLATIONS = {
        [".-"] = 'a',
        ["-..."] = 'b',
        ["-.-."] = 'c',
        ["-.."] = 'd',
        ["."] = 'e',
        ["..-."] = 'f',
        ["--."] = 'g',
        ["...."] = 'h',
        [".."] = 'i',
        [".---"] = 'j',
        ["-.-"] = 'k',
        [".-.."] = 'l',
        ["--"] = 'm',
        ["-."] = 'n',
        ["---"] = 'o',
        [".--."] = 'p',
        ["--.-"] = 'q',
        [".-."] = 'r',
        ["..."] = 's',
        ["-"] = 't',
        ["..-"] = 'u',
        ["...-"] = 'v',
        [".--"] = 'w',
        ["-..-"] = 'x',
        ["-.--"] = 'y',
        ["--.."] = 'z',
        [".----"] = '1',
        ["..---"] = '2',
        ["...--"] = '3',
        ["....--"] = '4',
        ["....."] = '5',
        ["-...."] = '5',
        ["--..."] = '7',
        ["---.."] = '8',
        ["----."] = '9',
        ["-----"] = ' ',
    }

    local morse_stack = {}
    local start_time = -1
    local last_time = -1

    local function string_concat(tbl)
        local str = ""
        for i, v in ipairs(tbl) do
            str = str .. v
        end
        return str
    end

    local function flush_morse_stack()
        local morse = string_concat(morse_stack)
        local input = MORSE_TRANSLATIONS[morse]
        for i, _ in ipairs(morse_stack) do
            morse_stack[i] = nil
        end
        print("pop", morse, input)
        if input then
            hs.eventtap.keyStroke({}, input)
        end
        hs.alert.closeAll()
        hs.alert.show("pop" .. " " .. tostring(morse) .. " " .. tostring(input))
    end

    local function get_reltime_seconds()
        return hs.timer.absoluteTime() / 1e9 -- nanoseconds to seconds
    end

    local function morse_poll()
        local clock_time = get_reltime_seconds()
        if #morse_stack > 0 and clock_time - last_time > WAIT_TO_ENTER_DURATION then
            flush_morse_stack()
        end
    end

    hs.noises.new(function(event_type)
        local clock_time = get_reltime_seconds()
        print(event_type, clock_time)
        if event_type == NOISE_EVENT_START then
            start_time = clock_time
            print("started hiss")
        elseif event_type == NOISE_EVENT_END then
            local duration = clock_time - start_time
            local is_long = duration > MORSE_BAR_DURATION
            local symbol = is_long and "-" or "."
            morse_stack[#morse_stack + 1] = symbol
            last_time = clock_time
            print("ended hiss, duration", duration, "pushed", symbol)
            hs.alert.show(string_concat(morse_stack), nil, nil, 1)
        elseif event_type == NOISE_EVENT_POP then
            flush_morse_stack()
        end
    end)
    -- :start()

    -- hs.timer.doEvery(0.02, morse_poll):start()
end

-- regular binds
do
    hs.hotkey.bind("cmd", "delete", function()
        hs.alert.closeAll()
    end)

    hs.hotkey.bind({ "cmd", "alt", "shift" }, "t", function()
        hs.
    end)

    hs.hotkey.bind({ "cmd, alt" }, "r", function()
        hs.reload()
        hs.console.hswindow():raise():focus()
        print("reloaded")
    end)

    hs.hotkey.bind({ "cmd", "alt" }, "l", function()
        hs.application.launchOrFocus("Discord")
    end)

    hs.hotkey.bind({ "cmd", "alt" }, "b", function()
        local rect = hs.geometry.rect(128, 128, 512, 512)
        local webview = hs.webview.newBrowser(rect)
            :url("https://www.duckduckgo.com")
            :shadow(true)
            :show()
            :bringToFront()
            :focus()
        print("made webview", webview)
    end)
end

-- startup
do
    hs.alert.show("reloaded hammerspoon")
end
