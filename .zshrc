# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="${HOME}/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
export UPDATE_ZSH_DAYS=30

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# General settings
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

export GOPATH=~/dev/go

# Set up PATH
export PATH="$PATH:$HOME/bin"
export PATH="$PATH:$HOME/.local/bin/"
export PATH="$PATH:$HOME/.emacs.d/bin"
export PATH="$PATH:$HOME/bin/miniconda/bin"
export PATH="$PATH:$HOME/bin/jdk-13.0.1/bin"
export PATH="$PATH:$HOME/bin/node-v12.16.3-linux-x64/bin"
export PATH="$PATH:$HOME/bin/Postman"
export PATH="$PATH:$HOME/dev/go/bin"
export PATH="$PATH:$HOME/bin/intellij/bin"
export PATH="$PATH:$HOME/bin/goland/bin"
export PATH="$PATH:$HOME/bin/pycharm/bin"
export PATH="$PATH:$HOME/bin/idea/bin"

# Colored man pages
export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# Fix keybindings
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[H' beginning-of-line
bindkey '^[[1~' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[3;5~' kill-word
bindkey '^[[5~' beginning-of-buffer-or-history
bindkey '^[[6~' end-of-buffer-or-history

# Aliases
alias l="exa --long --classify --icons --group-directories-first --header --git"
alias ll="exa --long --classify --icons --all --group-directories-first --header --git"
alias tree="exa --tree"
alias lt="lsd -hF --tree"
alias lta="lsd -ahF --tree"
alias fd="fd --hidden --no-ignore --exclude '.git' --exclude '*venv*'"
alias b="bat --theme=OneHalfDark"
alias g="git"
alias gs="git status"
alias gl="git --no-pager log --oneline --decorate -n 10"
alias lg="lazygit"
alias rg="rg --smart-case --hidden --glob '!.git'"
alias cd="c"
alias cdi="ci"
alias vim="nvim"
alias updagre="sudo apt update && sudo apt upgrade -y"
alias awsc="aws --cli-auto-prompt"
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias cdtemp="cd $(mktemp -d)"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias em="emacsclient --create-frame --no-wait"
alias emw="emacsclient --create-frame"
alias lg="lazygit"
alias nv="nvim.appimage"
alias docker="podman"
alias dog="~/scripts/dog_util.sh"

# data-tools aliases
alias ipy="docker run -it --rm ghcr.io/mikkoskela/data-tools:main ipython"
alias lab="docker run -it --rm --publish 8888:8888 ghcr.io/mikkoskela/data-tools:main jupyter lab --no-browser --ip='0.0.0.0'"
alias retro="docker run -it --rm --publish 8888:8888 ghcr.io/mikkoskela/data-tools:main jupyter retro --no-browser --ip='0.0.0.0'"

# custom functions

function hitail {
    local lines=${1:-10}
    history | tail -n ${lines}
}

function mkcd {
    mkdir ${1} && cd ${1}
}

# Show top X most edited files in a git repository
# x = 10 by default, first argument is the number of files
# second argument, if provided, is grep search string
pop() {
    num=${1:-10}
    if [ -z "$2" ]; then
        git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -"$num"
    else
        git log --pretty=format: --name-only | sort | uniq -c | sort -rg | head -"$num" | grep "$2"
    fi
}

# Enable Zoxide
eval "$(zoxide init zsh)"

# Enable direnv
eval "$(direnv hook zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("${HOME}/bin/miniconda3/bin/conda" "shell.zsh" "hook" 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "${HOME}/bin/miniconda3/etc/profile.d/conda.sh" ]; then
        . "${HOME}/bin/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="${HOME}/bin/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Sourcing
test -f ~/.shell_completions && source ~/.shell_completions
