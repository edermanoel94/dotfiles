export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="cloud"

plugins=(git docker golang aws zsh-fzf-history-search)

export EDITOR=vim

source $ZSH/oh-my-zsh.sh

source $HOME/.zsh_aliases

export PATH=$PATH:/usr/local/go/bin
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.local/bin

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
