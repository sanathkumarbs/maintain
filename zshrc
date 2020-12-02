# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/bagursreenivasamurth/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"

POWERLEVEL9K_VCS_SHORTEN_LENGTH=8
POWERLEVEL9K_VCS_SHORTEN_STRATEGY=truncate_middle

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

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
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

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
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git colored-man-pages colorize pip python brew osx zsh-syntax-highlighting zsh-autosuggestions golang kubectl z)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Sanath Custom Config

# [[ $TMUX = "" ]] && export TERM="xterm-256color"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
 eval "$(pyenv init -)"
fi

# Go Settings
export GOPRIVATE="*.f5net.com"
export GO111MODULE="on"
export GOPATH=$HOME/go
export PATH=$PATH:$HOME/go/bin
#export PATH=$PATH:/usr/local/go/bin

# SSH Cluster Config
export SSH_CFG=~/Documents/OneDrive\ -\ F5\ Networks/indigo-dev/configfiles/testenv-ssh-config

# Login to cluster
# scp -F $SSH_CFG -i ~/.ssh/id_rsa_testenv build/waf-log-processor-linux-amd64 data-1:/home/centos/waf-log-processor

tssh(){
  ssh -F $SSH_CFG -i ~/.ssh/id_rsa_testenv $1
}

tscp(){
 scp -F $SSH_CFG -i ~/.ssh/id_rsa_testenv $2 $1:
}

mk(){
  p=$(pwd | sed 's/Documents\/OneDrive[[:space:]]-[[:space:]]F5[[:space:]]Networks/Desktop\/OneDrive/g')
  cd $p
}

setup_dataplanes(){
  cd /Users/bagursreenivasamurth/Desktop/OneDrive/indigo-dev/repo/shield-deployer
  scp -F $SSH_CFG -i ~/.ssh/id_rsa_testenv ./app-protect.repo data-1:/home/centos/app-protect.repo
  scp -F $SSH_CFG -i ~/.ssh/id_rsa_testenv ./bootstrap.sh data-1:/home/centos/bootstrap.sh
  ssh -F $SSH_CFG -i ~/.ssh/id_rsa_testenv data-1 "chmod +x /home/centos/bootstrap.sh; ./bootstrap.sh"

  for ((i = 1; i <= 4; i++)); do
    echo "ssh -F $SSH_CFG -i ~/.ssh/id_rsa_testenv workload-$i \"docker run -d -p 8001:5678 hashicorp/http-echo -text=\"hello world from upstream $i\""
    ssh -F $SSH_CFG -i ~/.ssh/id_rsa_testenv workload-$i "docker run -d -p 8001:5678 hashicorp/http-echo -text=\"hello world from upstream $i\""
  done

  cd /Users/bagursreenivasamurth/Desktop/OneDrive/indigo-dev/repo/controller-security/waf-log-processor
  tscp data-1 build/waf-log-processor-linux-amd64
}

clip(){
  cat $1 | pbcopy
}

maintain(){
  sh /Users/bagursreenivasamurth/Desktop/OneDrive/indigo-dev/maintain.sh
}
