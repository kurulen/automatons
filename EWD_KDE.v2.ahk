; Easy Window Dragging (KDE style) -- by Jonny
;   [Ported to v2 by IroHia!]
; https://www.autohotkey.com
;
; This script makes it much easier to move or resize a window:
;   1) Hold down the ALT key and LEFT-click anywhere inside a window
;      to drag it to a new location
;   2) Hold down ALT and RIGHT-click-drag anywhere inside a window
;      to easily resize it
;
; This script was inspired by and built on many like it
; in the forum. Thanks go out to ck, thinkstorm, Chris,
; and aurelian for a job well done.
;
; Note from IroHia:
;   Double-Alt has been removed;
;   as far as I understand it, KDE doesn't utilize it anymore.
;   Additionally, moving or resizing a maximized window will
;   unmaximize it. Beware!
;
;   Greetz from me go out to mmikeww for the script converter,
;   which helped me quite a lot for some parts of the script.
;   (https://github.com/mmikeww/AHK-v2-script-converter)
;
; The shortcuts:
;  Alt + Left Button  : Drag to move a window.
;  Alt + Right Button : Drag to resize a window.
;
; You can optionally release Alt after the first
; click rather than holding it down the whole time.

SetWinDelay(-1)
CoordMode("Mouse")
return

!LButton::
{
    ; Get the initial mouse position and window id, and
    ; restore the window if it is maximized.
    MouseGetPos(&KDE_X1, &KDE_Y1, &KDE_id)
    If WinGetMinMax("ahk_id " KDE_id)
        WinRestore("ahk_id " KDE_id)

    ; Get the initial window position.
    WinGetPos(&KDE_WinX1, &KDE_WinY1, , , "ahk_id " KDE_id)

    Loop
    {
        If !GetKeyState("LButton","P") ; Break if button has been released.
            break

        MouseGetPos(&KDE_X2, &KDE_Y2) ; Get the current mouse position.
        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1
        KDE_WinX2 := (KDE_WinX1 + KDE_X2) ; Apply this offset to the window position.
        KDE_WinY2 := (KDE_WinY1 + KDE_Y2)

        WinMove(KDE_WinX2, KDE_WinY2, , , "ahk_id " KDE_id) ; Move the window to the new position.
    }
    return
}

!RButton::
{
    ; Get the initial mouse position and window id, and
    ; restore the window if it is maximized.
    MouseGetPos(&KDE_X1, &KDE_Y1, &KDE_id)
    If WinGetMinMax("ahk_id " KDE_id)
        WinRestore("ahk_id " KDE_id)

    ; Get the initial window position and size.
    WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id)

    ; Define the window region the mouse is currently in.
    ; The four regions are (Up and Left, Up and Right) then (Down and Left, Down and Right).
    If (KDE_X1 < KDE_WinX1 + KDE_WinW / 2)
        KDE_WinLeft := true
    Else
        KDE_WinLeft := false

    If (KDE_Y1 < KDE_WinY1 + KDE_WinH / 2)
        KDE_WinUp := true
    Else
        KDE_WinUp := false

    Loop
    {
        If !GetKeyState("RButton","P") ; Break if button has been released.
            break

        MouseGetPos(&KDE_X2, &KDE_Y2) ; Get the current mouse position.
        WinGetPos(&KDE_WinX1, &KDE_WinY1, &KDE_WinW, &KDE_WinH, "ahk_id " KDE_id) ; Get the current window position and size.

        KDE_X2 -= KDE_X1 ; Obtain an offset from the initial mouse position.
        KDE_Y2 -= KDE_Y1

        ; Act according to the defined region, based on the region the mouse is in.
        If KDE_WinLeft
        {
            ; Reverse and apply the offset to the size, and correct for the skewed position.
            KDE_WinX1 += KDE_X2
            KDE_WinW -= KDE_X2
        }
        Else
            KDE_WinW += KDE_X2 ; Apply the offset to the size.

        If KDE_WinUp
        {
            ; Reverse and apply, correct the position.
            KDE_WinY1 += KDE_Y2
            KDE_WinH -= KDE_Y2
        }
        Else
            KDE_WinH += KDE_Y2 ; Apply the offset.

        ; Finally, apply all the changes to the window.
        WinMove(KDE_WinX1, KDE_WinY1, KDE_WinW, KDE_WinH, "ahk_id " KDE_id)

        ; Reset the initial position for the next iteration.
        KDE_X1 := (KDE_X2 + KDE_X1)
        KDE_Y1 := (KDE_Y2 + KDE_Y1)
    }
    return
}
