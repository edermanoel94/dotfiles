export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="cloud"

plugins=(git docker golang aws zsh-fzf-history-search)

source $ZSH/oh-my-zsh.sh

source $HOME/.zsh_aliases

export EDITOR=vim

#For remove git alias and use go watch
unalias gow
