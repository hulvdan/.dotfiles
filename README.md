# os

```bash
git config --global core.symlinks true
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
git config --global url.ssh://git@bitbucket.org/.insteadOf https://bitbucket.org/
git config --global core.excludesFile "%USERPROFILE%\dev\.dotfiles\git\gitignore_global"
git config --global submodule.recurse true
git config --global core.autocrlf false
git config --global core.eol lf

# НАХОДЯСЬ В ПАПКЕ ПРОЕКТА

# --- TMUX --------------------
# заранее нужно установить tmux
tmux/install.sh

# При запуске tmux:
# [C-a]+I
# [C-a]+U

# --- ZSH --------------------
echo DEFAULT_USER=$(whoami) >> zsh/zshrc.local.zsh

# заранее нужно установить zsh
zsh/install.sh

# --- NVIM --------------------

# заранее нужно установить nvim

# запустить nvim, и прописать `:Lazy`

# --- КОНФИГИ --------------------
# UNIX
ln -s $(pwd)/nvim ~/.config/nvim

# WINDOWS:
mklink C:\Users\user\.vimrc C:\Users\user\dev\.dotfiles\idea\.vimrc
mklink C:\Users\user\.ideavimrc C:\Users\user\dev\.dotfiles\idea\.ideavimrc
mklink C:\Users\user\.wezterm.lua C:\Users\user\dev\.dotfiles\wezterm\.wezterm.lua
mklink /D C:\Users\user\AppData\Local\nvim C:\Users\user\dev\.dotfiles\nvim

mklink c:\Users\user\AppData\Roaming\Code\User\settings.json c:\Users\user\dev\.dotfiles\vscode\settings.json
mklink c:\Users\user\AppData\Roaming\Code\User\keybindings.json c:\Users\user\dev\.dotfiles\vscode\keybindings.json

mklink /D "e:\Media\SFX\Wildfunk - Video Game Sounds" "e:\Downloads\_torrent\Wildfunk - Video Game Sounds"
mklink /D "e:\Media\SFX\Advanced Game Sounds" "e:\Downloads\_torrent\Advanced Game Sounds"
mklink /D "e:\Media\SFX\" "e:\Downloads\_torrent\"
```

## Windows Setup

1. Отключение автообновления Visual Studio

Tools -> Options -> Environment -> Product Updates убрать всё

2. Отключение обновления Windows 11

https://www.solveyourtech.com/how-to-disable-automatic-updates-windows-11-a-step-by-step-guide/

3. Отключение game bar

Powershell от админа

```
Get-AppxPackage -AllUsers *Microsoft.XboxGameOverlay* | Remove-AppxPackage
Get-AppxPackage -AllUsers *Microsoft.XboxGamingOverlay* | Remove-AppxPackage
```

## FAQ

Конвертнуть PuTTY ppk в openssh
https://superuser.com/questions/232362/how-to-convert-ppk-key-to-openssh-key-under-linux

    puttygen id_dsa.ppk -O public-openssh -o id_dsa.pub

Сменить авторство git

```
uv add git filter-repo
uv run git filter-repo --commit-callback '
commit.author_name = b"user"
commit.author_email = b"email"
commit.committer_name = b"user"
commit.committer_email = b"email"
' --force
git remote add origin git@github2:user/repo.git
git push --set-upstream origin BRANCH --force
uv remove git filter-repo
```
