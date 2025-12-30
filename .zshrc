# export PATH
export PATH=$PATH:/snap/bin

# path to oh-m-zsh
export ZSH="$HOME/.oh-my-zsh"

# add i386 elf ive built
export PATH="$HOME/opt/cross/bin:$PATH"

# ALIASES
alias vim=nvim
alias cls=clear
alias ll="ls -la"


# git
alias gaa="git add -a"
alias gap="git add -p"
alias gc="git commit"
alias gcm="git commit -m"
alias gp="git push"
alias gpu="git pull"
alias gck="git checkout"

if [ -z "$TMUX" ]; then
    tmux -u
fi

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="geoffbluepink"
CASE_SENSITIVE="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

DISABLE_UPDATE_PROMPT="true"
export UPDATE_ZSH_DAYS=1
DISABLE_AUTO_TITLE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  archlinux
)

source $ZSH/oh-my-zsh.sh

# CUSTOM
set +m

# zsh-autosuggest config
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#666666"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)

if type rg &> /dev/null; then
  export FZF_DEFAULT_COMMAND='rg --files'
  export FZF_DEFAULT_OPTS='-m --height 50% --border'
fi
