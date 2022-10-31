-- Tunnel digging program
-- TODO: Add move functions that keep track of fuel and surroundings
-- TODO: Add a menu system to select what to do to avoid having to use arguments

-- Functions

local function turnLeft(rounds)
    rounds = rounds or 1
    for i = 1, rounds do
        turtle.turnLeft()
    end
end

local function turnRight(rounds)
    rounds = rounds or 1
    for i = 1, rounds do
        turtle.turnRight()
    end
end

local function getFuelLevel()
    fuelLevel = turtle.getFuelLevel()
    if fuelLevel <= 10 then
        print("Fuel level is getting low, refueling...")
        for i = 1, 16 do
            turtle.select(i)
            turtle.refuel()
        end
    end
    return turtle.getFuelLevel()
end

local function isInventoryFull()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.getItemCount() == 0 then
            return false
        end
    end
    return true
end

local function dumpInventory()
    loop = true
    while loop do
        for i = 1, 16 do
            local itemName = turtle.getItemDetail(i)["name"]
            if itemName == "enderstorage:ender_storage" then
                slotChest = i
                replacementChest = false
                loop = false
                break
            end
        end
        for i = 1, 16 do
            local itemName = turtle.getItemDetail(i)["name"]
            if string.find(itemName, "chest") then
                slotChest = i
                replacementChest = true
                loop = false
                break
            end
            if i == 16 then
                print("Please place chest in inventory, none were found")
            end
        end
    end

    turtle.select(slotChest)
    turnLeft(2)
    while turtle.inspect() do
        turtle.dig()
    end
    turtle.place()
    for i = 1, 16 do
        turtle.select(i)
        turtle.dropUp()
    end
    if not replacementChest then
        turtle.dig()
    end
    turnRight(2)

end

local function updateCheck()
    getFuelLevel()
    if isInventoryFull() then
        dumpInventory()
    end
end

local function moveForward(distance)
    distance = distance or 1
    for i = 1, distance do
        while not turtle.forward() do
            print("Blocked movement")
            getFuelLevel()
        end
    end
end

local function moveBack(distance)
    distance = distance or 1
    for i = 1, distance do
        while not turtle.back() do
            print("Blocked movement")
            getFuelLevel()
        end
    end
end

local function moveUp(distance)
    distance = distance or 1
    for i = 1, distance do
        while not turtle.up() do
            print("Blocked movement")
            getFuelLevel()
        end
    end
end

local function moveDown(distance)
    distance = distance or 1
    for i = 1, distance do
        while not turtle.down() do
            print("Blocked movement")
            getFuelLevel()
        end
    end
end

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
    moveForward()
    digUp()
    digDown()
    if ret then
        moveBack()
    end
end 

local function dig3x3()
    dig1x3()
    turnLeft()
    dig1x3(true)
    turnRight(2)
    dig1x3(true)
    turnLeft()
    updateCheck()
end

local function dig1x5(ret)
    ret = ret or false
    dig()
    moveForward()
    digUp()
    digDown()
    moveUp()
    digUp()
    moveUp()
    digUp()
    moveDown(2)
    if ret then
        moveBack()
    end
end

local function dig5x5()
    dig1x5()
    turnLeft()
    dig1x5()
    dig1x5(true)
    moveBack()
    turnRight(2)
    dig1x5()
    dig1x5(true)
    moveBack()
    turnLeft()
    updateCheck()
end

-- Main Function Loops

local function stairs(len)
    -- Stair mining loop
    -- TODO: count steps and return to start when done, stuck, or out of fuel
    -- TODO: check for lava and deal with it

    len = len or 0

    for i = 1, len do
        dig1x3()
        updateCheck()
        moveDown()
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

local function strip5x5(len)
    -- 5x5 strip mining loop
    -- TODO: count steps and return to start when done, stuck, or out of fuel
    -- TODO: check for lava and deal with it
    
    len = len or 0

    for i = 1, len do
        dig5x5()
    end
end

local function digvertical3x3(len, dirUp)
    -- Vertical mining loop
    -- TODO: Make nicer
    -- TODO: count steps and return to start when done, stuck, or out of fuel
    -- TODO: check for lava and deal with it

    len = len or 0
    dirUp = dirUp or false

    for i = 1, len do
        if dirUp then
            digUp()
            moveUp()
        else
            digDown()
            moveDown()
        end
        dig()
        turnLeft(2)
        dig()
        turnRight()
        dig()
        moveForward()
        turnRight()
        dig()
        turnLeft(2)
        dig()
        turnRight()
        moveBack(2)
        turnLeft()
        dig()
        turnRight(2)
        dig()
        turnLeft()
        moveForward()
        turnRight()
    end
end


-- Main execution
while true do
    while true do
        term.clear()
        term.setCursorPos(1,1)
        print("Tunnel Digging Program")
        print("0. Terminate program")
        print("1. Stairs")
        print("2. 3x3 Strip tunnel")
        print("3. 5x5 Strip tunnel")
        print("4. 3x3 Vertical tunnel")
        print("Enter the number of the operation you want to perform")
        selection = false
        selection = tonumber(read())
        if (selection == false) or (selection == nil) then
            print("Invalid input, please enter a number")
        else
            if ((-1 < selection) and (selection < 5)) then
                break
            else 
                print("No such program number, please enter one of the previously mentioned programs")
            end
        end
    end
    if selection == 0 then
        break
    elseif selection == 1 then
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("Stairs selected.")
            print("Enter the number of steps you want to dig")
            length = false
            length = tonumber(read())
            if (length == false) or (length == nil) then
                print("Invalid input, please enter a number")
            else
                break
            end
        end
        stairs(length)
        print("Stairs complete")
    elseif selection == 2 then
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("3x3 Strip mine selected.")
            print("Enter the number of length of tunnel you want to dig")
            length = false
            length = tonumber(read())
            if (length == false) or (length == nil) then
                print("Invalid input, please enter a number")
            else
                break
            end
        end
        strip(length)
        print("Strip mine complete")
    elseif selection == 3 then
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("5x5 Strip mine selected.")
            print("Enter the number of length of tunnel you want to dig")
            length = false
            length = tonumber(read())
            if (length == false) or (length == nil) then
                print("Invalid input, please enter a number")
            else
                break
            end
        end
        strip5x5(length)
        print("Strip mine complete")
    elseif selection == 4 then
        while true do
            term.clear()
            term.setCursorPos(1,1)
            print("3x3 vertical mine selected.")
            print("Enter the number of length of tunnel you want to dig")
            length = false
            length = tonumber(read())
            if (length == false) or (length == nil) then
                print("Invalid input, please enter a number")
            else
                break
            end
            print("Are you digging up?")
            print("yes or no")
            dir = false
            dir = read().lower()
            yesValues = {"y", "yes", "true", "t", "1", "correct", "up"}
            for index, value in ipairs(yesValues) do
                if dir == value then
                    dir = true
                    break
                end
            end
            if dir ~= true then
                dir = false
            end
            
        end
        digvertical3x3(length, dir)
        print("Vertical mine complete")
    else 
        print("Invalid selection")
    end
    sleep(5)
    term.clear()
end
term.clear()
term.setCursorPos(1,1)