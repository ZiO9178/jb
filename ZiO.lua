local a = "b0bad94c803d506a"
local b = "virtual/file/"
local c = "https://pandadevelopment.net/"

local final = c .. b .. a

local function secure_load(data)
    local success, err = pcall(function()
        loadstring(game:HttpGet(data))()
    end)
    if not success then warn("Execution Error") end
end

secure_load(final)