-- Tunnel digging program
-- TODO: Add move functions that keep track of fuel and surroundings
-- TODO: Add a menu system to select what to do to avoid having to use arguments

-- Functions
local function dig()
    while turtle.detect() do
        turtle.dig()
        sleep(0.5)
    end
end

local function digUp()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.5)
    end
end

local function digDown()
    while turtle.detectDown() do
        turtle.digDown()
        sleep(0.5)
    end
end

local function dig1x3(ret)
    ret = ret or false
    dig()
    turtle.forward()
    digUp()
    digDown()
    if ret then
        turtle.back()
    end
end 

local function dig3x3()
    dig1x3()
    turtle.turnLeft()
    dig1x3(true)
    turtle.turnRight()
    turtle.turnRight()
    dig1x3(true)
    turtle.turnLeft()
end

-- Main Function Loops

local function stairs(len)
    -- Stair mining loop
    -- TODO: count steps and return to start when done, stuck, or out of fuel
    -- TODO: check for lava and deal with it

    len = len or 0

    for i = 1, len do
        dig1x3()
        turtle.down()
    end
end

local function strip(len)
    -- Strip mining loop
    -- TODO: count steps and return to start when done, stuck, or out of fuel
    -- TODO: check for lava and deal with it

    len = len or 0

    for i = 1, len do
        dig3x3()
    end
end


-- Main execution
while true do
    while true do
        term.clear()
        print("Tunnel Digging Program")
        print("0. Terminate program")
        print("1. Stairs")
        print("2. 3x3 Strip tunnel")
        print("Enter the number of the operation you want to perform")
        local type = false
        type = tonumber(read())
        if type == false then
            print("Invalid input, please enter a number")
        elseif (1 < type and type > 2) then
            print("No such program number, please enter one of the previously mentioned programs")
        else
            break
        end
    end

    if type == 0 then
        break
    elseif type == 1 then
        while true do
            term.clear()
            print("Stairs selected.")
            print("Enter the number of steps you want to dig")
            local length = false
            length = tonumber(read())
            if length == false then
                print("Invalid input, please enter a number")
            else
                break
            end
        end
        stairs(length)
        print("Stairs complete")
    elseif type == 2 then
        while true do
            term.clear()
            print("3x3 Strip mine selected.")
            print("Enter the number of length of tunnel you want to dig")
            local length = false
            length = tonumber(read())
            if length == false then
                print("Invalid input, please enter a number")
            else
                break
            end
        end
        strip(length)
        print("Strip mine complete")
    else 
        print("Invalid type")
    end
    sleep(5)
    term.clear()
end
term.clear()