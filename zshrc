# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd extendedglob
unsetopt beep
bindkey -v
zstyle ':completion:*' menu select
#zstyle ':completion:*' format '%BCompleting %d%b'
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/vasko/.zshrc'

autoload -Uz compinit
compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' \
    'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# End of lines added by compinstall

source ~/.bash_aliases

export PS1='%n@%m:%~%% ' 

export GPGKEY="895134C5"
export PATH="$HOME/bin:$HOME/bin/perl6:$PATH"
export PENTADACTYL_RUNTIME="$HOME/.pentadactyl"
export LD_LIBRARY_PATH=/usr/local/lib

