local REPO_ZSH_DIR=$(readlink -f ~/.zshrc | sed 's|\(.*\)/.*|\1|')

autoload -U compinit && compinit -u

HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=100000000
# ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"

# Loading Plugins and Application Configs
plugins=(
	'colored-man-pages'
	'wd'
	'zsh-autosuggestions'
	'zsh-syntax-highlighting'
)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
source $REPO_ZSH_DIR/plugins/load.zsh

function list_abs_file_paths_in_dir {
	ls -A $REPO_ZSH_DIR/$1 | xargs -I{} echo $REPO_ZSH_DIR/$1/{}
}
for f in $(list_abs_file_paths_in_dir app_configs); do source $f; done

# Better history searching with arrow keys
autoload -U up-line-or-beginning-search
autoload -U down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# TODO: Mac may vary
# Fixing Home, End, Delete
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

# TODO: Use Alt for Mac
# Ctrl-Left or Ctrl-Right skips word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Ctrl-Backspace and Ctrl-Delete delete respective portions of words
bindkey -M emacs '^[[3;5~' kill-word
bindkey -M emacs '^H' backward-kill-word
bindkey -M viins '^H' backward-kill-word
bindkey -M vicmd '^H' backward-kill-word

# Theme
source $REPO_ZSH_DIR/theme.zsh
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
