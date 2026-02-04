#
# ~/.bashrc
#

# If not running interactively,don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
export EDITOR=nvim

. "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/barmanji/.lmstudio/bin"
# End of LM Studio CLI section

export PATH="$HOME/.npm-global/bin:$PATH"
