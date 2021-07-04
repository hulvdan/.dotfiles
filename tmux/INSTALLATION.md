# tmux

Using `tmux` and `tmux-plugins/tpm`.

## Installation

1. Check tmux is installed and install it if it's not

    ```bash
    which tmux
    ```

2. Clone tpm plugin manager for tmux

    ```bash
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
    ```

3. `cd` into `os` repository and make symlink for tmux configuration

    ```bash
    ln -s -f $(pwd)/tmux/.tmux.linux.conf ~/.tmux.conf
    ```

4. Install plugins

    ```bash
    ~/.tmux/plugins/tpm/bin/install_plugins
    ```

5. Reload tmux

    ```bash
    tmux source ~/.tmux.conf
    ```
