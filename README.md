# os

```bash
git config --global core.symlinks true
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
git config --global url.ssh://git@bitbucket.org/.insteadOf https://bitbucket.org/
git config --global core.excludesFile "%USERPROFILE%\dev\.dotfiles\git\gitignore_global"

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

# WINDOWS. Powershell с правами админа:
ni C:\Users\user\.vimrc -i SymbolicLink -ta "C:\Users\user\dev\.dotfiles\idea\.vimrc"
ni C:\Users\user\.ideavimrc -i SymbolicLink -ta "C:\Users\user\dev\.dotfiles\idea\.ideavimrc"
ni C:\Users\user\.wezterm.lua -i SymbolicLink -ta "C:\Users\user\dev\.dotfiles\wezterm\.wezterm.lua"
ni C:\Users\user\AppData\Local\nvim -i SymbolicLink -ta "C:\Users\user\dev\.dotfiles\nvim"
```

## FAQ

Конвертнуть PuTTY ppk в openssh
https://superuser.com/questions/232362/how-to-convert-ppk-key-to-openssh-key-under-linux

    puttygen id_dsa.ppk -O public-openssh -o id_dsa.pub
