local function wget(option, url, filename)
  if type(url) ~= "string" and type(filename) ~= "string" then
    return
  elseif type(option) == "string" and option ~= "-f" and type(url) == "string" then
    filename = url
    url = option
  end
  if http.checkURL(url) then
    if fs.exists(filename) and option ~= "-f" then
      printError("<Error> Target exists already")
      return
    else
      term.write("Downloading ... ")
      local timer = os.startTimer(60)
      http.request(url)
      while true do
        local event, id, data = os.pullEvent()
        if event == "http_success" then
          print("success")
          local f = io.open(filename, "w")
          f:write(data.readAll())
          f:close()
          data:close()
          print("Saved as " .. filename)
          return true
        elseif event == "timer" and timer == id then
          printError("<Error> Timeout")
          return
        elseif event == "http_failure" then
          printError("<Error> Download")
          os.cancelAlarm(timer)
          return
        end
      end
    end
  else
    printError("<Error> URL")
    return
  end
end

-- Update current file
wget("-f", "https://raw.githubusercontent.com/Ridderrasmus/ComputerCraft/master/startup.lua", "startup")
wget("-f", "https://raw.githubusercontent.com/Ridderrasmus/ComputerCraft/master/Turtle/mine.lua", "mine")

local tArgs = {...}
local url = tArgs[1]
local filename = tArgs[2]
local option = tArgs[3]

if url == nil or filename == nil then
  print("Usage: wget <url> <filename> [-f]")
  return
end
wget(option, url, filename)