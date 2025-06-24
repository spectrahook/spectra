
local games = {
    [126244816328678] = "https://raw.githubusercontent.com/spectrahook/spectra/refs/heads/main/Games/126244816328678.lua",
    [116793284465110] = "https://raw.githubusercontent.com/spectrahook/spectra/refs/heads/main/Games/116793284465110.lua"
}

local place_id = game.PlaceId

if games[place_id] then
    loadstring(game:HttpGet(games[place_id]))()
else
    print("not supported vro : " .. place_id)
end
