echo "Установка ~/.zshrc"
ln -s -f $(pwd)/zsh/.zshrc.symlink ~/.zshrc

if [ -f "$(pwd)/zsh/.zshrc.local.symlink" ]; then
    echo "Найдена локальная конфигурация ~/.zshrc.local"
    ln -s -f $(pwd)/zsh/.zshrc.local.symlink ~/.zshrc.local
fi
