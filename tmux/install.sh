if ! [ -x "$(command -v tmux)" ]; then
  echo 'ERROR: TMUX не установлен!' >&2
  exit 1
fi

ln -s -f $(pwd)/tmux/.tmux.conf.symlink ~/.tmux.conf

# tmux-yank
# https://github.com/tmux-plugins/tmux-yank
tmux set-option -g -s set-clipboard on
