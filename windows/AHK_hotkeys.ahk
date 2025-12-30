;-----------------------------------------------------------------------------------------
; Это моя надстройка на Windows для удобного набора спецсимволов слепой печатью,
; и тучи всего для повышения удобства / скорости использования различного софта.
;
; Для слепой печати я переназначаю `Caps Lock` на `F24` (с помощью PowerToys)
; и проставляю тут набор сочетаний клавиш `F24 + {что-то ещё}`.
;
; NOTE: Раньше я переназначал `Caps Lock` на `Ctrl`, чтобы vim / tmux
;       было удобнее использовать. Но в итоге пришёл к этому варианту
;       и снова вернулся к использованию vim с `Ctrl`.
;
; Добавленные сочетания клавиш:
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
;   1. Переназначить `Caps Lock` на `F24`.
;      - Установить PowerToys.
;        https://learn.microsoft.com/en-us/windows/powertoys/install
;      - Запустить.
;      - Перейти в `Keyboard Manager`.
;      - `Remap a key`.
;      - `Caps lock` на `F24`.
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

CoordMode, Mouse, Relative
SetKeyDelay, 50, 50
SendMode Input

; NOTE: Функцию перезагрузки скрипта раскомменчиваю, когда активно работаю над ним.
^!+f9::fnReload()

; `Right Ctrl + Right Shift` для кнопки вызова окна контекста,
; т.к. у меня на клавиатуре её нет. Использую редко.
RShift & RControl::send {AppsKey}
RControl & RShift::send {AppsKey}

; `Ctrl + Alt + Shift + F12` убирает / возвращает title bar окон.
; Я ценю вертикальное пространство и не готов его отдавать под пустоту,
; занимаемую title bar-ом.
^!+F12::fnToggleTitleBar()

;-----------------------------------------------------------------------------------------
; Набор спецсимволов в удобных местах клавиатуры при печати в слепую.
; У AHK немного конченное экранирование символов, поэтому выглядит неконсистентно.
;-----------------------------------------------------------------------------------------
F24 & S::send, {TEXT}[
F24 & D::send, {TEXT}{
F24 & F::send, {TEXT}(
F24 & G::&
F24 & H::=
F24 & J::send, {TEXT})
F24 & K::send, {TEXT}}
F24 & L::send, {TEXT}]
F24 & `;::send, :

F24 & W::SendRaw, +
F24 & E::send, -
F24 & T::send, {U+00AB} ; «
F24 & Y::send, {U+00BB} ; »
F24 & U::send, \
F24 & I::send, *
F24 & O::send, /
F24 & P::send, |

F24 & V::SendRaw, % "^"
F24 & M::SendRaw, % "$"
F24 & ,::send, <
F24 & .::send, >

;-----------------------------------------------------------------------------------------
; Эксперименитровал с набором цифр на ряду ниже домашнего.
; Не использую, т.к. я слишком слаб :/
;-----------------------------------------------------------------------------------------
; F24 & Z::send, 1
; F24 & X::send, 2
; F24 & C::send, 3
; F24 & V::send, 4
; F24 & B::send, 5
; F24 & N::send, 6
; F24 & M::send, 7
; F24 & <::send, 8
; F24 & >::send, 9
; F24 & /::send, 0

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
*XButton2::send {alt down}{printscreen}{alt up}

; Эмуляция магнитного колеса мыши.
; Зажатый F24 (Caps) + скролл = бесконечная прокрутка,
; пока не нажмёшь F24 или не крутанёшь колесо мыши.
fnResetMagneticWheeling() {
    global custom_wheeling
    custom_wheeling = 0
}

*$WheelUp::fnOnWheelUp()
*$WheelDown::fnOnWheelDown()
*$F24::
{
    fnResetMagneticWheeling()
    send, {Blind}{F24}
}

custom_wheeling := 0

; F24 & WheelUp::fnMagneticWheelUp()
; F24 & WheelDown::fnMagneticWheelDown()
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
XButton1::sendevent, {F9}
XButton2::sendevent, {F9}

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
; Clip Studio Paint - TODO.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe CLIPStudioPaint.exe
F6::fnClipStudioSaveSingle()
F5::fnClipStudioSaveMultiple()
F4::fnClipStudioCopyPasteTransform()

; *alt up::sendevent, {alt up}{esc}
; *alt up::SendInput, {alt up}

clipStudioCopyPasting := 0

fnClipStudioCopyPasteTransform() {
    global clipStudioCopyPasting
    if (clipStudioCopyPasting) {
        clipStudioCopyPasting = 0
        sendevent, {enter}{ctrl down}e{ctrl up}
    } else {
        clipStudioCopyPasting = 1
        sendevent, {ctrl down}cvt{ctrl up}
    }
}

fnClipStudioSaveSingle() {
    ; Opening save dialog
    sendevent, {ctrl down}s{ctrl up}
    sendevent, {alt}{down}
    loop 9 {
        sendevent, {down}
    }
    sendevent, {right}{down}{down}{enter}
    sleep 800
    ; Windows' save dialog opened. Replacing file
    sendevent, {enter}{left}{enter}
    sleep 800
    ; Skipping clip studio export windows
    sendevent, {enter}{enter}
}

fnClipStudioSaveMultiple() {
    sendevent, {ctrl down}s{ctrl up}
    sendevent, {alt}{down}
    loop 10 {
        sendevent, {down}
    }
    sendevent, {right}{down}{enter}
    sleep 100
    sendevent, {tab}{tab}{tab}{tab}{tab}{tab}{up}{enter}
    sleep 100
    sendevent, {enter}
    sleep 500
    sendevent, {enter}
}

;-----------------------------------------------------------------------------------------
; Audacity - F5 для экспортирования WAV.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe audacity.exe
f5::sendevent, {alt down}f{alt up}e
f6::sendevent, {alt down}f{alt up}er
=::sendevent, {alt down}c{alt up}v{up}{enter}{enter}
-::sendevent, {alt down}c{alt up}f{right}{up}{up}{enter}
; +::sendevent, {alt down}c{alt up}f{right}{down}{down}{down}

;-----------------------------------------------------------------------------------------
; Reaper - F5 для экспортирования.
;-----------------------------------------------------------------------------------------
#IfWinActive, ahk_exe reaper.exe
f5::fnReaperSave()
f4::fnReaperNewSubproject()
f3::fnReaperSetSubprojectPreset()
xbutton1::delete

fnReaperSave() {
    fnReaperSetSubprojectPreset()
    sendevent, {enter}{enter}
}

fnReaperSetSubprojectPreset() {
    ; - opening render dialog
    sendevent, {ctrl down}{alt down}r{alt up}{ctrl up}
    WinWait, Render to File
    click 700 60
    ; - Selecting the first preset in ALL SETTINGS
    sendevent, {space}{up}{right}{enter}
    ; - Activating save settings button
    click 190 800
    ; - Closing dialog
    sendevent, {space}

    sendevent, {ctrl down}s{ctrl up}
    WinWait, Rendering to file...
    WinWaitClose, Rendering to file...
}

fnReaperNewSubproject() {
    ; YOU MUST SELECT CURRENT TRACK'S NAME !!!
    sendevent, {ctrl down}ac{ctrl up}{enter}w{alt down}i{alt up}{down}{down}{down}{down}{down}{enter}
    sleep 200
    sendevent, {ctrl down}v{ctrl up}{enter}
    sleep 3000
    sendevent, {ctrl down}s{shift down}{tab}{shift up}{ctrl up}

    fnReaperSetSubprojectPreset()

    ; Creating tracks
    sendevent, {ctrl down}tttttttttttttt{ctrl up}

    ; Saving
    sendevent, {ctrl down}s{ctrl up}
}

;-----------------------------------------------------------------------------------------
; Aseprite - F5 TODO.
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
    Run, C:\Users\user\dev\home\launcher\.venv\Scripts\python.exe C:\Users\user\dev\home\launcher\main.py,,Max
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
