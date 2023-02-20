local REPO_ZSH_DIR=$(readlink -f ~/.zshrc | sed 's|\(.*\)/.*|\1|')

# Theme
source $REPO_ZSH_DIR/theme.zsh

autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "$key[Up]" up-line-or-beginning-search
bindkey "$key[Down]" down-line-or-beginning-search

# History
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
setopt inc_append_history
setopt share_history

# Loading Plugins
plugins=(
	'colored-man-pages'
	'wd'
	'zsh-autosuggestions'
	'zsh-syntax-highlighting'
)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source $REPO_ZSH_DIR/plugins/load.zsh
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

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

alias qd='cd ~$(ls -ld1 ~/dev/home/*/ ~/dev/work/*/ | sed "s/\/Users\/user//g" | fzf)'
