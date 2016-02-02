/*
*   Metal Miner
*   Author: adabo
*   Date: 02/01/2016
*   version: 0.0.3.3
*
*   To do:
*       • Add animation and visuals for tools
*       • Balance progression
*       • Add TNT (Big damage for one weapon)
*       • Add Auto-click
*       • Add Award for beating new metal
*       • 
*/
; Variables
    ;                           (attack_dmg, weapon, click_count, money)
    global player1 := new Player(1, "", 0, 0)
    ; global click_count   := 0
    ; global money         := 0
    ; global tool_dmg      := 1

    global rand          := 0
    global log           := ""
    global current_metal := ""
    global metal_health  := 0
    global attack        := player1.attack_dmg
    global metals        := ["aluminium", "bismuth", "cobalt", "copper", "nickel", "silver", "gold", "platinum"]
    global tools         := ["stone_pickaxe", "iron_pickaxe", "steel_pickaxe", "auger"]
    ;                                (prob, count, rate, hardness)
    global aluminium     := new Metal(0.98,   0, 1,    40)
    global bismuth       := new Metal(0.0200, 0, 5,    140)
    global cobalt        := new Metal(0.0100, 0, 10,   300)
    global copper        := new Metal(0.0050, 0, 30,   800)
    global nickel        := new Metal(0.0028, 0, 100,  1800)
    global silver        := new Metal(0.0016, 0, 350,  6000)
    global gold          := new Metal(0.0007, 0, 1000, 20000)
    global platinum      := new Metal(0.0001, 0, 8000, 100000)
    ;                               (Price, Damage)
    global stone_pickaxe := new Tool(10,    1)
    global iron_pickaxe  := new Tool(100,   50)
    global steel_pickaxe := new Tool(1000,  600)
    global auger         := new Tool(12000, 10000)
    ; m(stone_pickaxe)

; Gui
    ; Add Status bar
    Gui, Add, StatusBar
    SB_SetParts(60, 60)

    ; Game Tab
    Gui, Add, Tab2, w210 h168 gTab_Switch, Game|Shop
    Gui, Tab, 1
    Gui, Add, Button, x25 y35 w40 h40 gClick, Click
    Gui, Add, Button, x160 y35 w40 h40 gNext_Metal, Next
    Gui, Font, s14
    Gui, Add, Text, x25 y80 w140 vt_current_metal
    Gui, Font, s8
    Gui, Add, Text, w80 vt_metal_metal_health
    Gui, Add, Progress, w180 0x800000 c58dd58 vprogress_metal_metal_health, 100
    Gui, Add, Text

    ; Shop Tab
    Gui, Tab, 2
    Gui, Add, Text,   x20  y45    w42, % "$" stone_pickaxe.price
    Gui, Add, Text,   x20  y71    w42, % "$" iron_pickaxe.price
    Gui, Add, Text,   x20  y97    w42, % "$" steel_pickaxe.price
    Gui, Add, Text,   x20  y123   w42, % "$" auger.price
    Gui, Add, Text,   x140 y45    w75 vt_no_money_stone_pickaxe
    Gui, Add, Text,   x140 y71    w75 vt_no_money_iron_pickaxe
    Gui, Add, Text,   x140 y97    w75 vt_no_money_steel_pickaxe
    Gui, Add, Text,   x140 y123   w75 vt_no_money_auger
    Gui, Add, Button, x60  y40    w76 Left vbutton_buy_stone_pickaxe gShop, % "  Click + 1"
    Gui, Add, Button, x60  y66    w76 Left vbutton_buy_iron_pickaxe gShop,  % "  Click + 50"
    Gui, Add, Button, x60  y92    w76 Left vbutton_buy_steel_pickaxe gShop, % "  Click + 600"
    Gui, Add, Button, x60  y118   w76 Left vbutton_buy_auger gShop,         % "  Click + 1000"
    Gui, Show, w230 h200

; Game Start
    Random,, %A_TickCount%
    Gosub, Next_Metal
return

GuiClose:
ExitApp

Tab_Switch:
    Gui_Set_Text()
return

Next_Metal:
    rand := Calculate_Probability()
    metal_health := Get_Next_Metal(rand)
    Gui_Set_Text()
    Gui_Set_Progress()
return

Shop:
    if (A_GuiControl == "button_buy_stone_pickaxe")
        Shop("stone_pickaxe")
    if (A_GuiControl == "button_buy_iron_pickaxe")
        Shop("iron_pickaxe")
    if (A_GuiControl == "button_buy_steel_pickaxe")
        Shop("steel_pickaxe")
    if (A_GuiControl == "button_buy_auger")
        Shop("auger")
return

Shop(tool){
    Gui_Set_Text()
    if (player1.money - %tool%.price < 0)
        GuiControl,, t_no_money_%tool%, Can't afford.
    else
    {
        player1.money -= %tool%.price
        if (tool == "stone_pickaxe")
            player1.attack_dmg += 1
        if (tool == "iron_pickaxe")
            player1.attack_dmg += 50
        if (tool == "steel_pickaxe")
            player1.attack_dmg += 600
        if (tool == "auger")
            player1.attack_dmg += 10000
        Gui_Set_Text()
    }
}

Gui_Set_Text(){
    GuiControl,, t_metal_metal_health, %metal_health%
    GuiControl,, t_current_metal, %current_metal%
    SB_SetText("$ " floor(player1.money), 1)
    SB_SetText("C " player1.attack_dmg, 2)
    SB_SetText("# " player1.click_count, 3)
    for index, tool in tools
        GuiControl,, t_no_money_%tool%
}

Click:
    ++player1.click_count
    Do_Attack()
    Gui_Set_Text()
return

Calculate_Probability(){
    Random, rand, 0
    return rand / 2147483647
}

Get_Next_Metal(rand){
    ; m(rand)
    if      (rand < platinum.prob)
        current_metal := "platinum",  hardness := platinum.hardness
    else if (rand < gold.prob)
        current_metal := "gold",      hardness := gold.hardness
    else if (rand < silver.prob)
        current_metal := "silver",    hardness := silver.hardness
    else if (rand < nickel.prob)
        current_metal := "nickel",    hardness := nickel.hardness
    else if (rand < copper.prob)
        current_metal := "copper",    hardness := copper.hardness
    else if (rand < cobalt.prob)
        current_metal := "cobalt",    hardness := cobalt.hardness
    else if (rand < bismuth.prob)
        current_metal := "bismuth",   hardness := bismuth.hardness
    else                  ; aluminium
        current_metal := "aluminium", hardness := aluminium.hardness
    ; m(%current_metal%.hardness)
    return %current_metal%.hardness
}

Gui_Set_Progress(){
    GuiControl, +Range0-%metal_health%, progress_metal_metal_health
    GuiControl,, progress_metal_metal_health, %metal_health%
}

Do_Attack(){
    while (attack > 0)
    {
        ; sleep 100
        temp := attack
        attack -= metal_health
        metal_health -= temp
        GuiControl,, progress_metal_metal_health, %metal_health%
        if (metal_health < 1)
        {
            player1.money += %current_metal%.Get_Money()
            ++%current_metal%.count
            rand := Calculate_Probability()
            metal_health := Get_Next_Metal(rand)
            ; m(metal_health,rand)
            Gui_Set_Text()
            Gui_Set_Progress()
            SB_SetText("$ " floor(player1.money), 1)
            ; m("Broke")
        }
    }
    attack := player1.attack_dmg
    ; if (log)
    ;     m(RTrim(log, "`n"))
}

Class Metal{
    __New(prob, count, rate, hardness, broken = 0){
        this.prob          := prob
        this.count         := count
        this.exchange_rate := rate
        this.hardness      := hardness
        this.is_broken     := broken
    }

    Set_Money(){
        exchanged_money := floor(this.count * this.exchange_rate)
        this.count := 0
        return exchanged_money
    }

    Get_Money(){
        exchanged_money := this.exchange_rate
        return exchanged_money
    }
}

Class Tool{
    __New(price,damage){
        this.price  := price
        this.damage := damage
    }
}

Class Player{
    __New(attack_dmg, weapon, click_count, money){
        this.attack_dmg  := attack_dmg
        this.weapon      := weapon
        this.click_count := click_count
        this.money       := money
    }
}
