if ! [ -x "$(command -v zsh)" ]; then
	echo 'Error: ZSH is not installed!' >&2
	exit 1
fi

echo "Linking '~/.zshrc'"
ln -s -f $(pwd)/zsh/zshrc.zsh ~/.zshrc

echo "Zsh was configured!"
