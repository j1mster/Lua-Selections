local input = require("lua-selections")

local function doomSequence()
    input:write("Nice choice, loser.")
    input:write("You have unlocked the secret ending: Eternal Clown Mode.")
    repeat
        input:write("HONK HONK 🤡")
        os.execute("start ./catmilk.webp") -- you need the file here
    until false
end

local function offerRedemption(attempts)
    if attempts >= 3 then
        input:write("Alright that's it. You're officially banned from the cool kids club.")
        doomSequence()
    end

    input:prompt("Last chance. Will you finally cooperate?", {"no >:(", "fine whatever"}, function(answer)
        if answer == "no >:(" then
            input:write("bruh.")
            offerRedemption(attempts + 1)
        else
            input:write("Wow. Growth. Character development. Stunning.")
            input:write("You may proceed to the rest of the dumb adventure.")
        end
    end)
end

input:prompt("yo what's your name?", function(name)
    input:write("cool. hi " .. name .. ".")

    input:prompt("how many chicken nuggets could you eat in one sitting?", {"4", "10", "20", "69", "none, I'm vegan"}, function(nugCount)
        if nugCount == "none, I'm vegan" then
            input:write("bro just say you’re better than me and move on.")
        elseif nugCount == "69" then
            input:write("nice.")
        else
            input:write("respectable. slightly disappointing, but respectable.")
        end

        input:prompt("choose your starter pack:", {"anxiety", "crushing debt", "cool jacket", "free trial of sadness"}, function(starter)
            if starter == "cool jacket" then
                input:write("unfortunately, it's 3 sizes too small and smells like regret.")
            else
                input:write("classic pick.")
            end

            input:prompt("are you ready to face your destiny?", {"yes", "no", "define 'ready'"}, function(destiny)
                if destiny == "no" then
                    input:write("ok coward.")
                    offerRedemption(1)
                elseif destiny == "define 'ready'" then
                    input:write("google it.")
                    offerRedemption(1)
                else
                    input:write("let's roll.")
                end
            end)
        end)
    end)
end)
