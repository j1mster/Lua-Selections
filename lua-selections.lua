local module                = {}

local uv                    = require('uv')

local Stdout                = _G.process.stdout.handle ---@diagnostic disable-line: undefined-field
local stdin                 = uv.new_tty(0, true)

local messages              = {}
local inputobject           = nil

local Colors = {
    black = 30,
    red = 31,
    green = 32,
    yellow = 33,
    blue = 34,
    magenta = 35,
    cyan = 36,
    white = 37,
    pink = 95,
    orange = 91,
    brightBlue = 94
}


local function clamp(x, min, max)
    return (x>max and max) or (x<min and min) or x
end
local function stripAnsiCodes(str)
    return str:gsub('\27%[%d+;%d+m', ''):gsub('\27%[0m', '')
end

local function getLongestX(localinputobject) -- Equally sep. values by the longest string on the x
        local longestX = 0

        for _, v in pairs(localinputobject.options) do
            local a = stripAnsiCodes(v.name)
            longestX = (#a>longestX and #a) or (longestX)
            
            for _, k in pairs(v.subOptions) do
                local n = stripAnsiCodes(k.name)
                longestX = (#n>longestX and #n) or (longestX)
            end
        end

        return longestX
end

local function getOptions(localinputobject)
    local active = localinputobject.active
    local str = ""

    local longestX = getLongestX(localinputobject)

    for i, option in pairs(localinputobject.options) do
        local row = ""
        local optionNameRaw = option.name
        local paddedOptionName = optionNameRaw .. string.rep(" ", (longestX + 5) - #stripAnsiCodes(optionNameRaw))

        if active and localinputobject.selectionIndex.Y == i and localinputobject.selectionIndex.X == 1 then
            paddedOptionName = module.color(optionNameRaw, "orange") .. string.rep(" ", (longestX + 5) - #stripAnsiCodes(optionNameRaw))
        end

        row = row .. string.format("\t [%d] %s", i, paddedOptionName)

        for n, m in pairs(option.subOptions) do
            local subNameRaw = m.name
            local paddedSubName = subNameRaw .. string.rep(" ", (longestX + 5) - #stripAnsiCodes(subNameRaw))

            if active and localinputobject.selectionIndex.Y == i and localinputobject.selectionIndex.X == (n + 1) then
                paddedSubName = module.color(subNameRaw, "orange") .. string.rep(" ", (longestX + 5) - #stripAnsiCodes(subNameRaw))
            end

            row = row .. paddedSubName
        end

        str = str .. row .. "\n"
    end

    return str
end


local function getSelected(localinputobject)
    local x, y = localinputobject.selectionIndex.X, localinputobject.selectionIndex.Y

    for i, option in pairs(localinputobject.options) do 
        if i==y then 
            if x==1 then 
                return option 
            else 
                for m, sub in pairs(option.subOptions) do 
                    if x==(m+1) then 
                        return option, sub 
                    end 
                end 
            end 
        end 
    end 
end 

local function refresh()
    module.clear()

    for _, v in pairs(messages) do
        Stdout:write(v .. "\n\n")
    end
    if (inputobject and inputobject.active) then
        local str = inputobject.name .. "\n" .. getOptions(inputobject) .. "\n\nUse arrow keys to navigate."

        Stdout:write(str)
    end
end

local function closeprompt()
    uv.read_stop(stdin)
    uv.tty_set_mode(stdin, 0) 

    if inputobject and inputobject.active then 
        inputobject.active = false
        
        local callback = inputobject.callback 
        local option, sub = getSelected(inputobject) 
        local options = getOptions(inputobject)
        local finalValue = (sub or option)
        local msg = inputobject.name .. "\n" .. options .. "\nUser> " .. module.color(finalValue.name or "(none)", "cyan")  .. "\n\n"
        
        inputobject.finalValue = finalValue
        inputobject = nil 
        table.insert(messages,  msg)

        callback(finalValue.name)
    end 

    refresh()
end 


function module.clear()
    os.execute("cls")
end

function module.input(key)
    local promptActive = (inputobject and inputobject.active) 
    local newX, newY = nil, nil
    local currentY = inputobject and inputobject.selectionIndex.Y
    local currentX = inputobject and inputobject.selectionIndex.X

    if key == "\003" or key == "♥" then
        module:write("Exiting") 
        uv.read_stop(stdin)
        uv.tty_set_mode(stdin, 0)
        uv.close(stdin)
        uv.stop()
    elseif (key=="\n" or key=="\r") and promptActive then 
        closeprompt()
    
    elseif tonumber(key) and promptActive then
        Y = clamp(tonumber(key), 1, #inputobject.options)
        X = 1
    elseif promptActive then
        local modifierY = ((key:lower()=="up" or key=="\027[A") and -1) or ((key:lower()=="down" or key=="\027[B") and 1) or 0
        local modifierX = ((key:lower()=="left" or key=="\027[D") and -1) or ((key:lower()=="right" or key=="\027[C") and 1) or 0

        newY = clamp(currentY+modifierY, 1, #(inputobject.options)) 

        local Suboptions = (inputobject.options[newY].subOptions) or {}
        local SuboptionCount = #Suboptions

        if SuboptionCount<1 then 
            SuboptionCount = 1 
        else 
            SuboptionCount = SuboptionCount + 1 
        end 


        newX = clamp(currentX+modifierX, 1, SuboptionCount)  
    end; 


    if (inputobject and inputobject.active)  then 


        newX = newX or inputobject.selectionIndex.X 
        newY = newY or inputobject.selectionIndex.Y 

        inputobject.selectionIndex = {X = newX, Y = newY}
    end

    refresh()
end

function module.color(Text, Color)
    return string.format('\27[%i;%im%s\27[0m', 1, Colors[Color] or Colors.white, Text)
end

function module:write(...)
    return pcall(function(a)
        for i, v in pairs(a) do
            table.insert(messages,  tostring(v) .. "\n\n\n") 
        end
        refresh()
    end, {...})
end

function module:prompt(name, options, callback) -- Set options to nil for text
    if inputobject and inputobject.active then 
        closeprompt()
    end 


    if type(options)=="function"  then 
        callback = options
        options = nil
    end 

    if not callback then return error("Must have callback") end 

    if not options then
        io.write(name .. "\nUser> ")
        local userInp = io.read() 

        table.insert(messages, name .. "\nUser> " .. module.color(userInp or "(none)", "cyan"))
        callback(userInp)

        refresh()
        return userInp
    end

    local optionsY = nil
    local optionsX = nil

    if options.Y or options.X then 
        optionsY = options.Y or {}
        optionsX = options.X or {}
    else 
        optionsY = options
        optionsX = {}
    end 


    

    optionsY = optionsY or {}
    optionsX = optionsX or {}

    uv.tty_set_mode(stdin, 1)
    uv.read_start(stdin, function(err, data)
        if err then error(err) end 
        if data then 
            module.input(data)
        end 
    end) 

    local options = {}

    for i, v in pairs(optionsY or {}) do 
        local thisOptionsX = {}

        if optionsX and optionsX[i] then 
            for n, m in pairs(optionsX[i]) do 
                thisOptionsX[n] =  {name = m}
            end 
        end 
        options[i] = {name = v, subOptions = thisOptionsX}
    end 

    inputobject = {
        name = name, 
        active = true, 
        options = options,
        selectionIndex = {X = 1, Y = 1}, 
        callback = callback
    }

    refresh()
end


refresh()



return module
