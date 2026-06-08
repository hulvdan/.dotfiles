;-----------------------------------------------------------------------------------------
; Это моя надстройка на Windows для удобного набора спецсимволов слепой печатью,
; и тучи всего для повышения удобства / скорости использования различного софта.
;
; Для слепой печати я переназначаю `Caps Lock` на `f24` (с помощью PowerToys)
; и проставляю тут набор сочетаний клавиш `f24 + {что-то ещё}`.
;
; NOTE: Раньше я переназначал `Caps Lock` на `Ctrl`, чтобы vim / tmux
;       было удобнее использовать. Но в итоге пришёл к этому варианту
;       и снова вернулся к использованию vim с `Ctrl`.
;
; Добавленные сочетания клавиш:
;
;   (верхний ряд, левая рука)
;     CAPS + W -> +
;     CAPS + E -> -
;     CAPS + T -> «
;
;   (верхний ряд, правая рука)
;     CAPS + Y -> »
;     CAPS + U -> \
;     CAPS + I -> *
;     CAPS + O -> /
;     CAPS + P -> |
;
;   (основной ряд, левая рука)
;     CAPS + S -> [
;     CAPS + D -> {
;     CAPS + F -> (
;     CAPS + G -> &
;
;   (основной ряд, правая рука)
;     CAPS + H -> =
;     CAPS + J -> )
;     CAPS + K -> }
;     CAPS + L -> ]
;     CAPS + ; -> :
;
;   (нижний ряд, левая рука)
;     CAPS + V -> ^
;
;   (нижний ряд, правая рука)
;     CAPS + M -> $
;     CAPS + , -> <
;     CAPS + . -> >
;
;   NOTE: Небольшая особенность в отзеркаливании некоторых клавиш:
;         - Безымянные набирают   []
;         - Средние набирают      {}
;         - Указательные набирают (), ^$ (перейти в начало, в конец в vim)
;
; Изменённые клавиши для быстрого набора snake_case / CONSTANT_CASE.
; Сделал так, чтобы работало только на английском,
; чтобы не переназначать русскую букву `х`.
;
;     Клавиша `[` всегда набирает `_`
;
;     Клавиша `{` (т.е. `shift + [`) всегда набирает `_`.
;
; Как использовать (на момент 2024-07-27):
;   1. Переназначить `Caps Lock` на `f24`.
;      - Установить PowerToys.
;        https://learn.microsoft.com/en-us/windows/powertoys/install
;      - Запустить.
;      - Перейти в `Keyboard Manager`.
;      - `Remap a key`.
;      - `Caps lock` на `f24`.
;   2. Установить AutoHotkey v2. https://www.autohotkey.com/
;   3. Убедиться, что сейчас активна английская раскладка.
;   4. Запустить этот скрипт от имени админа.
;      - Для этого нужно создать shortcut (ПКМ по файлу скрипта -> Create Shortcut).
;      - В его настройках, в advanced поставить галку `Run As Administrator`.
;      - Запустить этот shortcut.
;   5. Готово.
;
; Как я научился использовать новые сочетания клавиш:
;   1. Отрубил работу спецсимволов в местах по-умолчанию
;      (ниже можно специально для этого раскомментить кусок кода).
;
;   2. Кодил.
;
;   3. Иногда устраивал себе тренировки:
;      - Заходил на https://monkeytype.com/
;      - Выбирал режим `custom`.
;      - Нажимал `change`.
;      - И указывал группы подряд идущих символов. Например:
;
;            +]^\ =$$\^ $-[- [}\]$ /&{}- -)[\ /(\/= \&}+ *+[* +-}$\ $}] **\ []) $$(]*
;            +^/ -)/{ =/) ^*{ ]\&&- {$^) ]/( ]\^ -$/)] ))]- {}}\( [/][} =}-/ (/&{$ -=-}
;            =+)[ ++}+ (([]- &)- ](/) ^*^ $*}+ {^*}) \^)\] +^([^ ^(^-^ $&\* ^=(^( [=]=
;            /\= &\)/\ +)- *-)& **[* ^\/} ])\$ *\( ${&$/ &{) \-/&+ (]- [)]/ &&+&^ ^/={+
;            )\\( +{[( +}}-[ $ ][*& =(/ (=={+ /+* ]$(== $*^ -[-+) $]* +{\( [{)( \=^+$
;            *)[ &(]- */\{ +(} *-^/& )])\[ ))) {=+/$ $]^} \$}}[ *^*& *[$$- &{$/ (^]=\
;            {}= ^=]{ })\^) )({/ &]})& }(( } [&-{ }/\$ ]++-$ ={}) /=*& ^=( $*^ -}/+[
;
;        NOTE: Сгенерировано с помощью python:
;
;              ```
;              from random import randint, choices
;
;              symbols = "[{()}]&=+-*/\^$"
;              groups = []
;              for i in range(100):
;                  k = randint(3, 5)
;                  groups.append("".join(choices(symbols, k=k)))
;
;              print(" ".join(groups))
;              ```
;-----------------------------------------------------------------------------------------
#SingleInstance force
#NoEnv

; WinActivate, ahk_exe CLIPStudioPaint.exe

CoordMode, Mouse, Relative
SetKeyDelay, 50, 50
SendMode Input

; Auto-reload on file change
lastModTime := 0
FileGetTime, lastModTime, %A_ScriptFullPath%

fnCheckFileChange() {
    global lastModTime
    FileGetTime, currModTime, %A_ScriptFullPath%
    if (lastModTime != currModTime) {
        lastModTime := currModTime
        fnReload()
    }
}

SetTimer, fnCheckFileChange, 2000

; NOTE: Функцию перезагрузки скрипта раскомменчиваю, когда активно работаю над ним.
^!+f9::fnReload()

; `Right Ctrl + Right Shift` для кнопки вызова окна контекста,
; т.к. у меня на клавиатуре её нет. Использую редко.
RShift & RControl::send {AppsKey}
RControl & RShift::send {AppsKey}

; `Ctrl + Alt + Shift + f12` убирает / возвращает title bar окон.
; Я ценю вертикальное пространство и не готов его отдавать под пустоту,
; занимаемую title bar-ом.
^!+f12::fnToggleTitleBar()

f21::send {U+1F7E2}{space} ; 🟢
f22::send {U+1F7E1}{space} ; 🟡
f23::send {U+1F534}{space} ; 🔴

;-----------------------------------------------------------------------------------------
; Набор спецсимволов в удобных местах клавиатуры при печати в слепую.
; У AHK немного конченное экранирование символов, поэтому выглядит не консистентно.
;-----------------------------------------------------------------------------------------

f24 & 1::send, {blind}{f1}
f24 & 2::send, {blind}{f2}
f24 & 3::send, {blind}{f3}
f24 & 4::send, {blind}{f4}
f24 & 5::send, {blind}{f5}
f24 & 6::send, {blind}{f6}
f24 & 7::send, {blind}{f7}
f24 & 8::send, {blind}{f8}
f24 & 9::send, {blind}{f9}
f24 & 0::send, {blind}{f10}
f24 & backspace::send, {blind}{f11}
f24 & -::send, {blind}{f12}

f24 & tab::send, {blind}``
f24 & w::sendraw, +
f24 & e::send, {blind}-
f24 & t::send, {blind}{U+00AB} ; «
f24 & y::send, {blind}{U+00BB} ; »
f24 & u::send, {blind}\
f24 & i::send, {blind}*
f24 & o::send, {blind}/
f24 & p::send, {blind}|

f24 & s::send, {blind}{TEXT}[
f24 & d::send, {blind}{TEXT}{
f24 & f::send, {blind}{TEXT}(
f24 & g::&
f24 & h::=
f24 & j::send, {blind}{TEXT})
f24 & k::send, {blind}{TEXT}}
f24 & l::send, {blind}{TEXT}]
f24 & `;::send, {blind}:

f24 & v::sendraw, % "^"
f24 & m::sendraw, % "$"
f24 & ,::send, {blind}<
f24 & .::send, {blind}>

;-----------------------------------------------------------------------------------------
; Экспериментировал с набором цифр на ряду ниже домашнего.
; Не использую, т.к. я слишком слаб :/
;-----------------------------------------------------------------------------------------
; f24 & Z::send, 1
; f24 & X::send, 2
; f24 & C::send, 3
; f24 & V::send, 4
; f24 & B::send, 5
; f24 & N::send, 6
; f24 & M::send, 7
; f24 & <::send, 8
; f24 & >::send, 9
; f24 & /::send, 0

;-----------------------------------------------------------------------------------------
; Раскомментить, чтобы отключить работу спецсимволов по-умолчанию.
; Помогает привыкнуть к новому расположению спецсимволов.
;-----------------------------------------------------------------------------------------
; *(::fnDoNothing()
; *)::fnDoNothing()
; *{::fnDoNothing()
; *}::fnDoNothing()
; *[::fnDoNothing()
; *]::fnDoNothing()
; *-::fnDoNothing()
; *+::fnDoNothing()
; *=::fnDoNothing()
; *^::fnDoNothing()
; *$::fnDoNothing()

; Alt + ` (tilda button) - Open launcher
!`::fnLauncher()

*XButton1::Shift
; *XButton1::send {alt down}{printscreen}{alt up}
*XButton2::sendevent, {alt down}{printscreen}{alt up}

; Эмуляция магнитного колеса мыши.
; Зажатый f24 (Caps) + скролл = бесконечная прокрутка,
; пока не нажмёшь f24 или не крутанёшь колесо мыши.
fnResetMagneticWheeling() {
    global custom_wheeling
    custom_wheeling = 0
}

*$WheelUp::fnOnWheelUp()
*$WheelDown::fnOnWheelDown()

fnOnCaps() {
    fnResetMagneticWheeling()
    send, {blind}{f24}
}

*$f24::fnOnCaps()

custom_wheeling := 0

; f24 & WheelUp::fnMagneticWheelUp()
; f24 & WheelDown::fnMagneticWheelDown()
fnMagneticWheelUp() {
    global custom_wheeling
    custom_wheeling := 1
    SetTimer, fnSendWheelWhileMagneticWheeling, -1
}

fnMagneticWheelDown() {
    global custom_wheeling
    custom_wheeling := -1
    SetTimer, fnSendWheelWhileMagneticWheeling, -1
}

fnOnWheelUp() {
    if GetKeyState("CapsLock", "P")
        fnMagneticWheelUp()
    else
        fnResetMagneticWheeling()
    send, {Blind}{WheelUp}
}

fnOnWheelDown() {
    if GetKeyState("CapsLock", "P")
        fnMagneticWheelDown()
    else
        fnResetMagneticWheeling()
    send, {Blind}{WheelDown}
}

fnSendWheelWhileMagneticWheeling() {
    global custom_wheeling

    if (custom_wheeling == 1)
        send, {Blind}{WheelUp}
    else if (custom_wheeling == -1)
        send, {Blind}{WheelDown}

    if (custom_wheeling != 0)
        SetTimer, fnSendWheelWhileMagneticWheeling, -16
}


;-----------------------------------------------------------------------------------------
; Установление breakpoint-а в Visual Studio с помощью дополнительных кнопок на мышке.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe devenv.exe
XButton1::sendevent, {f9}
XButton2::sendevent, {f9}

;-----------------------------------------------------------------------------------------
; Замена `[` и `{` на `_` при использовании английского языка.
;-----------------------------------------------------------------------------------------
#if fnIsEnglishLayoutActive()
{::send, {TEXT}_
[::send, {TEXT}_

;-----------------------------------------------------------------------------------------
; Adobe Illustrator - TODO.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe illustrator.exe
^+S::sendevent, {alt down}f{alt up}e{left}{down}{enter}{space}

;-----------------------------------------------------------------------------------------
; Clip Studio Paint.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe CLIPStudioPaint.exe

SendMode Event

; f1::
; f24 & 1::

; f2::
; f24 & 2::

*f3::fnClipStudioSavePsd()
f24 & 3::fnClipStudioSavePsd()

f4::fnClipStudioCopyPasteTransform()
f24 & 4::fnClipStudioCopyPasteTransform()

f5::fnClipStudioSaveMultiple()
f24 & 5::fnClipStudioSaveMultiple()

f6::fnClipStudioSaveSingle()
f24 & 6::fnClipStudioSaveSingle()

; f7::
; f24 & 7::

; f8::
; f24 & 8::

; f9::
; f24 & 9::

; f10::
; f24 & 0::

; f11::
; f24 & backspace::

; f12::
; f24 & -::

fnClipStudioSavePsd() {
    MouseMove, 0, 0
    Run, uv.exe run python cli/bf_cli.py process_psd --wait-for-change, c:/Users/user/dev/home2/game4
    sleep 300
    WinActivate, ahk_exe CLIPStudioPaint.exe
    ; Pressing CTRL SHIFT S
    send {ctrl down}{shift down}s{shift up}{ctrl up}
    ; Switching to changing "save as" format
    while not WinActive("Save as")
        sleep 250
    send {tab}
    ; Selecting psd
    send {right}{end}
    send {enter}
    ; Saving
    sleep 1000
    send {enter}
    ; If it's replace confirmation -> replace
    sleep 1000
    if WinActive("Confirm Save As") {
        send {left}
        sleep 200
        send {enter}
    }
    ; Export
    sleep 1000
    send {enter}
    WinActivate, ahk_exe uv.exe
}

clipStudioCopyPasting := 0

fnClipStudioCopyPasteTransform() {
    global clipStudioCopyPasting
    if (clipStudioCopyPasting) {
        clipStudioCopyPasting = 0
        send, {enter}{ctrl down}e{ctrl up}
    } else {
        clipStudioCopyPasting = 1
        send, {ctrl down}cvt{ctrl up}
    }
}

fnClipStudioSaveSingle() {
    ; Opening save dialog
    send, {ctrl down}s{ctrl up}
    send, {alt}{down}
    loop 9
        send, {down}
    send, {right}{down}{down}{enter}
    sleep 800
    ; Windows' save dialog opened. Replacing file
    send, {enter}{left}{enter}
    sleep 800
    ; Skipping clip studio export windows
    send, {enter}{enter}
}

fnClipStudioSaveMultiple() {
    send, {ctrl down}s{ctrl up}
    send, {alt}{down}
    loop 10
        send, {down}
    send, {right}{down}{enter}
    sleep 100
    send, {tab}{tab}{tab}{tab}{tab}{tab}{up}{enter}
    sleep 100
    send, {enter}
    sleep 500
    send, {enter}
}

;-----------------------------------------------------------------------------------------
; Audacity - f5 для экспортирования WAV.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe audacity.exe

sendmode event

f5::send, {alt down}f{alt up}e
f6::send, {alt down}f{alt up}er
=::send, {alt down}c{alt up}v{up}{enter}{enter}
-::send, {alt down}c{alt up}f{right}{up}{up}{enter}
; +::send, {alt down}c{alt up}f{right}{down}{down}{down}

;-----------------------------------------------------------------------------------------
; Reaper.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe reaper.exe

sendmode event

xbutton1::delete

*f5::fnReaperSave()
fnReaperSave() {
    fnReaperSetSubprojectPreset()
    send, {enter}{enter}
}

*f3::fnReaperSetSubprojectPreset()
fnReaperSetSubprojectPreset() {
    ; - opening render dialog
    send, {ctrl down}{alt down}r{alt up}{ctrl up}
    WinWait, Render to File
    click 700 60
    ; - Selecting the first preset in ALL SETTINGS
    send, {space}{up}{right}{enter}
    ; - Activating save settings button
    click 190 800
    ; - Closing dialog
    send, {space}

    send, {ctrl down}s{ctrl up}
    WinWait, Rendering to file...
    WinWaitClose, Rendering to file...
}

*f4::fnReaperNewSubproject()
fnReaperNewSubproject() {
    ; YOU MUST SELECT CURRENT TRACK'S NAME !!!
    send, {ctrl down}ac{ctrl up}{enter}w{alt down}i{alt up}{down}{down}{down}{down}{down}{enter}
    sleep 200
    send, {ctrl down}v{ctrl up}{enter}
    sleep 3000
    send, {ctrl down}s{shift down}{tab}{shift up}{ctrl up}

    fnReaperSetSubprojectPreset()

    ; Creating tracks
    send, {ctrl down}tttttttttttttt{ctrl up}

    ; Saving
    send, {ctrl down}s{ctrl up}
}

;-----------------------------------------------------------------------------------------
; Aseprite - f5 TODO.
;-----------------------------------------------------------------------------------------
#ifWinActive, ahk_exe aseprite.exe
f5::sendevent, {ctrl down}cn{ctrl up}{enter}{ctrl down}v{ctrl up}{alt down}s{alt up}t{ctrl down}d{tab}{ctrl up}
f6::fnAseFastSaving()

fnAseFastSaving() {
    sendevent, {enter}{enter}
    sleep 300
    sendevent, {ctrl down}wsv{ctrl up}{left}{left}{left}{left}
}

fnIsEnglishLayoutActive() {
    return DllCall("GetKeyboardLayout", "UInt"
        , DllCall("GetWindowThreadProcessId", "UInt", WinExist("A"), "UInt", 0)) == 67699721
}

fnReload() {
    SoundPlay, *-1
    reload
}

fnDoNothing() {
}

fnToggleTitleBar() {
    WinSet, Style, ^0xC00000, A
}

fnLauncher() {
    Run, C:\Users\user\dev\home2\launcher\.venv\Scripts\python.exe C:\Users\user\dev\home2\launcher\main.py,,Max
}

;-----------------------------------------------------------------------------------------
; Davinci Resolve.
;-----------------------------------------------------------------------------------------
#ifWinActive, ahk_exe Resolve.exe
x::fnResolveRippleDelete()

fnResolveRippleDelete() {
    send, b{click}a
    MouseMove -20, 0, 0, R
    send, {click}{del}
}

;-----------------------------------------------------------------------------------------
; Pencil
;-----------------------------------------------------------------------------------------
#ifWinActive, ahk_exe Pencil.exe
MButton::delete

;-----------------------------------------------------------------------------------------
; Minecraft
;-----------------------------------------------------------------------------------------
#ifWinActive, Minecraft
xbutton1::send, {rbutton down}
xbutton2::send, {lbutton down}

minecraft_clicking_r := 0
minecraft_clicking_l := 0

LControl & xbutton1::fnStartClickingR()

fnStartClickingR() {
    minecraft_clicking_r = 1
    fnClickingR()
}

fnClickingR() {
    send, {rbutton}
    SetTimer, fnClickingR, -100
}

; ctrl + shift + alt + space = hold space
^+!space::send, {space down}

; ctrl + shift + alt + w = hold w
^+!w::send, {w down}

;-----------------------------------------------------------------------------------------
; Aquaria
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe Aquaria.exe

*xbutton1::aquariaStartRightClicking()
*xbutton1 up::aquariaStopRightClicking()
; *xbutton1::Send {LButton down}
*xbutton2::aquariaHoldAttack()
+lbutton::send {lbutton down}

aquariaHoldAttack() {
    send {RButton down}
    sleep 1580
    send {RButton up}
}

aquariaRightClicking = 0
aquariaStartRightClicking() {
    global aquariaRightClicking

    aquariaRightClicking = 1
    aquariaRightClick()
}

aquariaRightClick() {
    global aquariaRightClicking
    if (aquariaRightClicking) {
        sendevent, {RButton}
        SetTimer, aquariaRightClick, -20
    }
}

aquariaStopRightClicking() {
    global aquariaRightClicking
    aquariaRightClicking = 0
}

;-----------------------------------------------------------------------------------------
; Find Matt's Cats
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe Find Matt's Cats.exe

*xbutton1::mattStartRightClicking()
*xbutton1 up::mattStopRightClicking()

mattRightClicking = 0
mattStartRightClicking() {
    global mattRightClicking

    mattRightClicking = 1
    mattRightClick()
}

mattRightClick() {
    global mattRightClicking
    if (mattRightClicking) {
        sendevent, {LButton}
        SetTimer, mattRightClick, -40
    }
}

mattStopRightClicking() {
    global mattRightClicking
    mattRightClicking = 0
}

;-----------------------------------------------------------------------------------------
; Hollow Knight
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe Hollow Knight.exe

*space::k
*j::hkStartAttack()
*j up::hkStopAttack()
*shift::hkStartDash()
*shift up::hkStopDash()

hkAttack = 0
hkStartAttack() {
    global hkAttack

    hkAttack = 1
    hkAttack()
}

hkAttack() {
    global hkAttack
    if (hkAttack) {
        sendevent, j
        SetTimer, hkAttack, -40
    }
}

hkStopAttack() {
    global hkAttack
    hkAttack = 0
}

hkDash = 0
hkStartDash() {
    global hkDash

    hkDash = 1
    hkDash()
}

hkDash() {
    global hkDash
    if (hkDash) {
        sendevent, {shift}
        SetTimer, hkDash, -40
    }
}

hkStopDash() {
    global hkDash
    hkDash = 0
}

;-----------------------------------------------------------------------------------------
; SilkSong
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe Hollow Knight Silksong.exe

*space::k
*j::hksStartAttack()
*j up::hksStopAttack()
; *shift::hksStartDash()
; *shift up::hksStopDash()

hksAttack = 0
hksStartAttack() {
    global hksAttack

    hksAttack = 1
    hksAttack()
}

hksAttack() {
    global hksAttack
    if (hksAttack) {
        sendevent, j
        SetTimer, hksAttack, -40
    }
}

hksStopAttack() {
    global hksAttack
    hksAttack = 0
}

hksDash = 0
hksStartDash() {
    global hksDash

    hksDash = 1
    hksDash()
}

hksDash() {
    global hksDash
    if (hksDash) {
        sendevent, {shift}
        SetTimer, hksDash, -40
    }
}

hksStopDash() {
    global hksDash
    hksDash = 0
}

