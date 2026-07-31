# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export WLR_NO_HARDWARE_CURSORS=1

alias ls='ls --color=auto'
alias ll='ls -al'
PS1='[\u@\h \W]\$ '
