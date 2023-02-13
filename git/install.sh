if ! [ -x "$(command -v git)" ]; then
	echo 'Error: GIT is not installed!' >&2
	exit 1
fi

echo "Linking '~/.gitignore_global'"
ln -s -f $(pwd)/git/gitignore_global ~/.gitignore_global
git config --global core.excludesfile ~/.gitignore_global

git config --global url.ssh://git@github.com/.insteadOf https://github.com/
git config --global url.ssh://git@bitbucket.org/.insteadOf https://bitbucket.org/

echo "git was configured!"
