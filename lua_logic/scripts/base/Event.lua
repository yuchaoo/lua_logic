EV = {
    PANEL_OPEN = 101,
    PANEL_CLOSE = 102,
    ROLE_ATTR_CHANGE = 201,
    ENTER_GAME = 401,
    
    BATTLEOBJ_DEAD = 501,
    ENTER_BATTLE_READY = 505,
    
    START_BATTLE = 601,
    END_BATTLE = 602,
    RELEASE_SKILL = 603,
    OBJ_HP_CHANGED = 604,
    NEXT_BATTLE = 605
}

EV_VK = {}

for k , v in pairs(EV) do
    EV_VK[v] = k
end