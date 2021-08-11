echo "Установка ~/.zshrc"
ln -s -f $(pwd)/zsh/.zshrc.symlink ~/.zshrc

if [ -f "$(pwd)/zsh/.zshrc.local.symlink" ]; then
    echo "Найдена локальная конфигурация ~/.zshrc.local"
    ln -s -f $(pwd)/zsh/.zshrc.local.symlink ~/.zshrc.local
fi

echo "Установка темы hulvdan"
ln -s -f $(pwd)/zsh/themes/hulvdan.zsh-theme.symlink ~/.oh-my-zsh/themes/hulvdan.zsh-theme
