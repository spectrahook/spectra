local game = {
    [126244816328678] = true,
    [116793284465110] = true
}

local id = game.PlaceId
if game[id] then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/spectrahook/spectra/refs/heads/main/Games/" .. id .. ".lua", true))()
end
