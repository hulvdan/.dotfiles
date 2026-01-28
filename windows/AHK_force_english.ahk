HKL := DllCall("LoadKeyboardLayout", "Str", "00000409", "UInt", 1)
PostMessage, 0x50, 0, HKL,, A
Run, "c:\Users\user\dev\.dotfiles\windows\AHK_hotkeys.ahk"
