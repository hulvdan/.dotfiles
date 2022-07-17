local REPO_ZSH_DIR=$(readlink -f ~/.zshrc | sed 's|\(.*\)/.*|\1|')

# Theme
source $REPO_ZSH_DIR/theme.zsh

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000

# Loading Plugins
plugins=(
	'colored-man-pages'
	'wd'
	'zsh-autosuggestions'
	'zsh-syntax-highlighting'
)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source $REPO_ZSH_DIR/plugins/load.zsh

# Loading Application Configs
for f in $(
	ls -A $REPO_ZSH_DIR/app_configs |
		xargs -I{} echo $REPO_ZSH_DIR/app_configs/{}
); do
	source $f
done

# Improved keys
source $REPO_ZSH_DIR/keys.zsh

# Replaced commands
function ls {
	/bin/ls -G $*
}

# Aliases
alias ll="ls -l"
alias la="ls -A"
alias lla="ls -lA"
alias gss="git status -s"
alias szsh="source ~/.zshrc"

# Local configuration that is not included in git
[ -f "$REPO_ZSH_DIR/zshrc.local.zsh" ] && source "$REPO_ZSH_DIR/zshrc.local.zsh"
