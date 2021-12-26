CoordMode "Mouse", "Screen"

ScreenWidth := SysGet(78)
ScreenHeight := SysGet(79)
BlockWidth := ScreenWidth / 9
BlockHeight := ScreenHeight / 9

Leader := "["
LClick := "Space"
RClick := "/"

Absolute := "\"
ChordNull := "g"
ChordX1 := "f"
ChordX2 := "r"
ChordX3 := "d"
ChordX4 := "e"
ChordY1 := "s"
ChordY2 := "w"
ChordY3 := "a"
ChordY4 := "q"

Movement := "]"
MoveDown := "d"
MoveUp := "e"
MoveLeft := "s"
MoveRight := "f"
MoveLeftAlt := "z"
MoveDownAlt := "x"
MoveUpAlt := "c"
MoveRightAlt := "v"

Hotkey "*" Leader, HandleChord

HandleChord(*) {
    SetSecondaryHotkeys("On")
    DidSomething := False
    InAbs := false

    Loop {
        if (IsActive(Absolute)) {
            DidSomething := True
            if (not InAbs) {
                InAbs := True
                DrawAbsTips(True)
            }
            HandleAbsolute()
        } else {
            if (InAbs) {
                InAbs := false
                DrawAbsTips(False)
            }
        }

        if (IsActive(Movement)) {
            DidSomething := True
        }

        if (not IsActive(Leader)) {
            SetSecondaryHotkeys("Off")
            if (not DidSomething) {
                Send Leader
            }
            break
        }
    }
}

HandleAbsolute() {
    xKeys := [ChordX1, ChordX2, ChordX3, ChordX4]
    xBlock := CheckDimension(xKeys)

    yKeys := [ChordY1, ChordY2, ChordY3, ChordY4]
    yBlock := CheckDimension(yKeys)
    
    GoToBlock(xBlock, yBlock)
}

DrawAbsTips(isOn) {
    for n in [1, 2, 3, 4, 5, 6, 7, 8, 9] {
        label := (isOn = True) ? n : ""
        xPos := ((n - 1) * BlockWidth) + (BlockWidth / 2)
        yPos := BlockHeight / 2
        ToolTip label, xPos, yPos, n
    }

    for n in [2, 3, 4, 5, 6, 7, 8, 9] {
        label := (isOn = True) ? n : ""
        xPos := BlockWidth / 2
        yPos := ((n - 1) * BlockHeight) + (BlockHeight / 2)
        ToolTip label, xPos, yPos, 9+n-1
    }

    centerLabel := (isOn = true) ? "c" : ""
    ToolTip centerLabel, ScreenWidth/2, ScreenHeight/2, 18
}

CheckDimension(keys) {
    if (IsActive(ChordNull))
        return 1
    ; if (MatchMask(keys, [0, 0, 0, 0]))
    ;     return 0
    if (MatchMask(keys, [1, 0, 0, 0]))
        return 2
    if (MatchMask(keys, [0, 1, 0, 0]))
        return 3
    if (MatchMask(keys, [0, 0, 1, 0]))
        return 4
    if (MatchMask(keys, [1, 0, 1, 0]))
        return 5
    if (MatchMask(keys, [0, 1, 1, 0]))
        return 6
    if (MatchMask(keys, [0, 0, 0, 1]))
        return 7
    if (MatchMask(keys, [1, 0, 0, 1]))
        return 8
    if (MatchMask(keys, [0, 1, 0, 1]))
        return 9
    return 0
}

MatchMask(keys, masks) {
    return IsActive(keys[1]) = masks[1] and IsActive(keys[2]) = masks[2] and IsActive(keys[3]) = masks[3] and IsActive(keys[4]) = masks[4]
}

DoMoveDown(*) {
    DoMove(0, 1)
}
DoMoveUp(*) {
    DoMove(0, -1) 
}
DoMoveLeft(*) {
    DoMove(-1, 0)
}
DoMoveRight(*) {
    DoMove(1, 0) 
}

DoMove(x, y) {
    MouseMove (x * (BlockWidth / 4)), (y * (BlockHeight / 4)), , "Relative"
}

Nada := (*) => ""

IsActive(key) {
    return GetKeyState(key, "P")
}

SetSecondaryHotkeys(state) {
    Hotkey "*" LClick, DoLeftClick, state
    Hotkey "*" RClick, DoRightClick, state

    for key in [Absolute, ChordNull, ChordX1, ChordX2, ChordX3, ChordX4, ChordY1, ChordY2, ChordY3, ChordY4] {
        Hotkey "*" key, Nada, state
    }

    Hotkey Movement " & " MoveDown, DoMoveDown, state
    Hotkey Movement " & " MoveUp, DoMoveUp, state
    Hotkey Movement " & " MoveLeft, DoMoveLeft, state
    Hotkey Movement " & " MoveRight, DoMoveRight, state
    Hotkey "*" MoveDownAlt, DoMoveDown, state
    Hotkey "*" MoveUpAlt, DoMoveUp, state
    Hotkey "*" MoveLeftAlt, DoMoveLeft, state
    Hotkey "*" MoveRightAlt, DoMoveRight, state
}

DoLeftClick(*) {
    Click "Left"
}

DoRightClick(*) {
    Click "Right"
}

GoToBlock(blockX, blockY) {
    MouseGetPos &currentX, &currentY

    x := (blockX != 0) ? ((blockX - 1) * BlockWidth) + (BlockWidth / 2) : currentX
    y := (blockY != 0) ? ((blockY - 1) * BlockHeight) + (BlockHeight / 2) : currentY
    MouseMove x, y
}
