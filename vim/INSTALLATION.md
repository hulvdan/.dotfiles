# vim

Using `vim`.

## Installation

1. Check vim is installed and install it if it's not

    ```bash
    which vim
    ```

2. `cd` into `os` repository and make symlink for tmux configuration

    ```bash
    ln -s -f $(pwd)/vim/.vimrc.linux ~/.vimrc
    ```

3. Install NeoBundle

    ```bash
    curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh
    ```
