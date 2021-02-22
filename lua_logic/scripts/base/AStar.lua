require("scripts/base/Heap")

AStar = Class(...)

function AStar:__init()
    self.heap = Heap.New()
    self.adjacent_points1 = {{-1,0},{0,1},{1,0},{0,-1}}
    self.adjacent_points2 = {
        {
            tile = {-1,-1},
            adja = {{-1,0},{0,-1}}
        },{
            tile = {-1,1},
            adja = {{-1,0},{0,1}}
        },{
            tile = {1,1},
            adja = {{0,1},{1,0}}
        },{
            tile = {1,-1},
            adja = {{1,0},{0,-1}}
        }
    }
end

function AStar:__delete()
    self.heap = nil
    self.map = nil
end

function AStar:SetMap(map)
    self.map = map
    self.width = self.map:GetWidth()
    self.height = self.map:GetHeight()
end

function AStar:Calculate(sx, sy, ex, ey)
    return math.abs(sx - ex) + math.abs(ex - ey)
end

function AStar:IsValid(x , y)
    return x >= 1 and x <= self.width and y >= 1 and y <= self.height
end

function AStar:FindWay(sx, sy, ex, ey)
    local s = self.map:GetTile(sx, sy)
    local way = {}
    local closeMap = {}
    local x , y , tilex , tiley = 0 , 0, 0, 0

    self.heap:Clear()
    self.heap:Add(s, self:Calculate(sx, sy, ex, ey))
    while self.heap:Size() > 0 do
        local top = self.heap:Pop()
        tilex, tiley = top:GetXY()
        if tilex == ex and tiley == ey then
            break
        end

        for i , v in ipairs(self.adjacent_points1) do
            x = tilex + v[1]
            y = tiley + v[2]
            if self:IsValid(x , y) and self.map:IsCanPass(x, y) then
                local tile = self.map:GetTile(x, y)
                if not closeMap[tile] then
                    self.heap:Add(tile, self:Calculate(x, y, ex, ey))
                    way[tile] = top
                    closeMap[tile] = true
                end
            end
        end

        for i , v in ipairs(self.adjacent_points2) do
            x = tilex + v.tile[1]
            y = tiley + v.tile[2]
            local x1 , y1 = tilex + v.adja[1][1] , tiley + v.adja[1][2]
            local x2 , y2 = tilex + v.adja[2][1], tiley + v.adja[2][2]
            if self:IsValid(x, y) and self:IsValid(x1,y1) and self:IsValid(x2,y2) then
                if self.map:IsCanPass(x,y) and self.map:IsCanPass(x1,y1) and self.map:IsCanPass(x2,y2) then
                    local tile = self.map:GetTile(x, y)
                    if not closeMap[tile] then
                        self.heap:Add(tile, self:Calculate(x, y, ex, ey))
                        way[tile] = top
                        closeMap[tile] = true
                    end
                end
            end
        end
    end

    local e = self.map:GetTile(ex, ey)
    if not way[e] then
        return 
    end

    local result = {}
    while e do
        table.insert( result, e.tile, 1)
        e = way[e]
    end

    return result
end