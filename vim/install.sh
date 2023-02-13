if ! [ -x "$(command -v vim)" ]; then
  echo 'Error: VIM не установлен!' >&2
  exit 1
fi

ln -s -f $(pwd)/vim/.vimrc.symlink ~/.vimrc
curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh

