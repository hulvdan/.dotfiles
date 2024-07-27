#singleinstance force
#NoTrayIcon
#NoEnv

SendMode Input

!`::fnLauncher()

fnLauncher() {
    Run, C:\Users\user\dev\home\launcher\.venv\Scripts\python.exe C:\Users\user\dev\home\launcher\main.py,,Max
}
