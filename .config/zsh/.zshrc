# -------------------
# Config file for zsh
# @RKBethke
# -------------------

# Enable colors
autoload -U colors && colors	# Load colors

# Set up the prompt (with git branch name)
# Reference: https://scriptingosx.com/2019/07/moving-to-zsh-06-customizing-the-zsh-prompt/
# Load version control information
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
zstyle ':vcs_info:git:*' formats '%F{240}(%b)%f'
zstyle ':vcs_info:*' enable git
RPROMPT=\$vcs_info_msg_0_
PROMPT='%(?..%F{red}%? )%f%F{magenta}%~%f $ '
# PROMPT="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "

setopt autocd		# Automatically cd into typed directory.
stty stop undef		# Disable ctrl-s to freeze terminal.
setopt interactive_comments

# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.cache/zsh/history

# Initialize zoxide, a smarter cd command.
# Aliases "z"
eval "$(zoxide init zsh)"

# Basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

# Better vi mode plugin
function zvm_config() {
  ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
  ZVM_VI_INSERT_ESCAPE_BINDKEY=^[ # <Esc>
}
source /usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Function to cd (zoxide) into directory via lf
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                z "$dir"
            fi
        fi
    fi
}

bindkey -s '^o' 'lfcd\n'
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey '^z' push-line-or-edit

# Aliases
alias config='/usr/bin/git --git-dir=/home/ryanb/.dotfiles/ --work-tree=/home/ryanb'
alias nv='/usr/bin/nvim'
alias gs='git status'
alias gb='git branch'
alias gap='git add -p'
alias gc='git commit'
alias gd='git diff'

# Load syntax highlighting. Should be last.
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null
