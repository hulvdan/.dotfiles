# os

OS configuration essentials

## TMUX

### Быстрая конфигурация TMUX

Заранее установите **tmux**.

Находясь в папке проекта, выполните скрипт `tmux/install.sh`.

При запуске tmux

[C-a]+I
[C-a]+U

## VIM

### Быстрая конфигурация VIM

Заранее установите **vim**.

Находясь в папке проекта, выполните скрипт `vim/install.sh`.

## ZSH

Рекомендуется создать файл `zsh/zshrc.local.zsh`

```bash
echo DEFAULT_USER=$(whoami) >> zsh/zshrc.local.zsh
```

Это файл локальной конфигурации. Необходим для того, чтобы для
конкретного ПК запускать разный набор скриптов.

Также, при указании переменной `DEFAULT_USER` равной вашему пользователю,
у вас строка shell-а будет короче благодаря тому, что сегмент
с пользователем/пк не будет отображаться.

### Быстрая конфигурация ZSH

Установите заранее **zsh**.

Находясь в папке проекта,  выполните скрипт `zsh/install.sh`.

Создастся symlink на конфигурацию `~/.zshrc`.

## GIT

```bash
git config --global url.ssh://git@github.com/.insteadOf https://github.com/
```

```bash
git config --global url.ssh://git@bitbucket.org/.insteadOf https://bitbucket.org/
```

## SSH

Конвертнуть PuTTY ppk в openssh https://superuser.com/questions/232362/how-to-convert-ppk-key-to-openssh-key-under-linux

```bash
puttygen id_dsa.ppk -O public-openssh -o id_dsa.pub
```

## Idea

### Windows

We need to create 2 hard links inside the **home** directory.
One for `.ideavimrc` and another for `.vimrc`

```
mklink /H .vimrc C:\Users\User\dev\.dotfiles\idea\.vimrc
mklink /H .ideavimrc C:\Users\User\dev\.dotfiles\idea\.ideavimrc
```
