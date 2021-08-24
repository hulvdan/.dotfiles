if ! [ -x "$(command -v zsh)" ]; then
  echo 'Error: ZSH не установлен!' >&2
  exit 1
fi

if [ ! -f "$HOME/.oh-my-zsh/oh-my-zsh.sh" ]; then
    echo "Скачивание и установка 'oh-my-zsh'"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "Установка '~/.zshrc'"
ln -s -f $(pwd)/zsh/.zshrc.symlink ~/.zshrc

if [ -f "$(pwd)/zsh/.zshrc.local.symlink" ]; then
    echo "Найдена локальная конфигурация ~/.zshrc.local"
    ln -s -f $(pwd)/zsh/.zshrc.local.symlink ~/.zshrc.local
fi

echo "Установка темы 'hulvdan'"
ln -s -f $(pwd)/zsh/themes/hulvdan.zsh-theme.symlink ~/.oh-my-zsh/themes/hulvdan.zsh-theme

# https://github.com/zsh-users/zsh-syntax-highlighting
echo "Установка 'zsh-syntax-highlighting'"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# https://github.com/zsh-users/zsh-autosuggestions
echo "Установка 'zsh-autosuggestions'"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
