if ! [ -x "$(command -v tmux)" ]; then
  echo 'Error: TMUX не установлен!' >&2
  exit 1
fi

ln -s -f $(pwd)/tmux/.tmux.conf.symlink ~/.tmux.conf
