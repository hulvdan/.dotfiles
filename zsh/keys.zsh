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
