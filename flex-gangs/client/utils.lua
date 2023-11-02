function CreateZoneBlip(color, opacity, x1, y1, x2, y2, w)
    local cX = (x1 + x2) / 2
    local cY = (y1 + y2) / 2
    local width = math.abs(x1 - x2)
    local height = math.abs(y1 - y2)
    local blip = AddBlipForArea(cX, cY, w*1.0, width, height)
    SetBlipColour(blip, color)
    SetBlipAlpha(blip, opacity)
    SetBlipAsShortRange(blip, true)
    SetBlipDisplay(blip, 3)
    return blip
end