############################### INITIALIZATION ###############################

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


############################### Package MANGER ################################


ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [ ! -d "$ZINIT_HOME" ]; then
	mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Powerlevel10k prompt with turbo loading
zinit ice depth=1;
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
export FZF_TMUX=1

zinit ice wait lucid atinit'zicompinit; zicdreplay'
zinit light zsh-users/zsh-completions

# Syntax highlighting loaded AFTER completions to avoid errors
zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting
#
# Autosuggestions lazy load with trigger on plugin load
zinit ice wait lucid atload'!_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# fzf-tab lazy load turbo mode
zinit ice wait lucid
zinit light Aloxaf/fzf-tab

# OMZ plugins loaded silently and after prompt
zinit ice wait lucid silent
zinit snippet OMZP::git

zinit ice wait lucid silent
zinit snippet OMZP::sudo

# Load completions
autoload -Uz compinit && compinit -C
zinit cdreplay -q #In docs it says its necessary

#Keybinds related to that
bindkey -e
bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
export FZF_DEFAULT_OPTS="--bind 'ctrl-y:accept'"
bindkey '^[[1;5D' backward-word # Bind Ctrl + Left Arrow to move one word backward
bindkey '^[[1;5C' forward-word # Bind Ctrl + Right Arrow to move one word forward

#completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

#Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=$HOME/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

######################################## ALIAS ##########################################

#---- Basic Utilities -----#
alias ls='ls --color'
alias ll='ls -la'
alias c='clear'

#---- Laptop functions -----#
alias power='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage'  #Battery %age Shortcuts
alias perc='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
alias %age='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
alias percentage='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
alias userkey='screenkey'
alias touchpad='hyprctl keyword "device[elan06fa:00-04f3:31be-touchpad]:enabled"'
alias treenode='tree -I node_modules/'
alias update='$HOME/scripts/system_update_and_maintainance.sh'

#---- My special Shortcuts -----#
alias rwallpaper="$HOME/.config/swww/swww.sh"
alias menubar='gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar' #Set True or False for menubar/Topbar
alias gapsDisable='$HOME/scripts/gaps_and_rounding_switch.sh'
alias gapsEnable='$HOME/scripts/gaps_and_rounding_switch.sh'
alias currentWallpaper='$HOME/scripts/current_wallpaper.sh'
alias deleteCurrentWallpaper='$HOME/scripts/delete_current_wallpaper.sh'
alias copy='wl-copy'
alias clock='tty-clock -t -C'
alias pipe='pipes.sh -t'
alias pipes='pipes.sh -t'
alias so='source $HOME/.zshrc'

#---- Vim related ----#
alias vimbegood='sudo docker run -it --rm brandoncc/vim-be-good:latest'
alias vp='nvim $HOME/Documents/projects/'
alias vim='nvim' #Vim will open Nvim-
alias v='nvim'
alias vi='nvim .'
alias sv='sudo -E nvim'
alias snvim='sudo -E nvim .'
alias svim='sudo -E nvim .'
alias sudonvim='sudo -E nvim'
alias sn='sudo -E nvim'
alias pd='pnpm run dev'
alias pi='pnpm install'
alias pa='pnpm add'
alias nd='npm run dev'
alias ni='npm install'
alias gs='git status'
alias ts='$HOME/scripts/tmux_sessionizer'
alias tss='$HOME/scripts/tmux_sessionizer "$(pwd)"'
alias fman='print -l ${(ok)commands} | fzf | xargs man'
alias top='btop'
alias tsync="tmux_env_sync && source $HOME/.zshrc"
alias hi="echo bye"
alias nightlight="~/scripts/nightlight_brightness.sh"
alias play="ncmpcpp"

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^V' edit-command-line

############################## FUNCTIONAL SHORTCUTS ##################################
#Git SSH copy and see
function gssh() { gh repo view "$1" --json sshUrl }
gcssh() {
  gh repo view "$1" --json sshUrl | jq -r '.sshUrl' | wl-copy
  echo "SSH URL copied to clipboard."
}
#Git input directly ssh
function gitty() {
  if [[ -z "$1" ]]; then
    echo "Please provide a repository name."
  else
    git remote add origin "git@github.com:Barmanji/$1.git"
    echo "Remote origin added for repository: $1"
  fi
}

tmux_env_sync() {
  if [ -z "$TMUX" ]; then
    echo 'Not inside tmux.'
    return 1
  fi

  # 1. Get the environment from tmux
  # 2. Filter out removed variables (starting with -)
  # 3. Use 'eval' to properly handle the quoted strings tmux provides
  while read -r line; do
    if [[ "$line" == *=* ]]; then
      eval "export $line"
    fi
  done < <(tmux show-environment | grep -v '^-')

  echo '[tmux] Environment reloaded from tmux server!'
}

#### DEFAULT EXPORTS #####
export EDITOR=nvim
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
source /usr/share/nvm/init-nvm.sh

# pnpm
export PNPM_HOME="/home/barmanji/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
### CONDA ###
[ -f /opt/anaconda/etc/profile.d/conda.sh ] && source /opt/anaconda/etc/profile.d/conda.sh
export CRYPTOGRAPHY_OPENSSL_NO_LEGACY=1

# Added by LM Studio CLI (lms)
export PATH="$PATH:/home/barmanji/.lmstudio/bin"
# End of LM Studio CLI section
export CPATH=$(g++ -v -E -x c++ /dev/null 2>&1 | sed -n '/^#include <...> search starts here:/,$p' | tail -n +2 | sed -e '/^End of search list./q' -e 's/^ //')
export LIBRARY_PATH=$(g++ -print-search-dirs | grep libraries | cut -d '=' -f2)

# NOTE: OLD CONF
# Add in Powerlevel10k
# zinit ice depth=1; zinit light romkatv/powerlevel10k
#
# # To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
# [[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh
# export FZF_TMUX=1
#
# zinit light zsh-users/zsh-syntax-highlighting #Highliter
#
# # Lazy load plugins without messages
# zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
#
# # OMZ plugins with silent loading
# zinit ice wait'0' silent
# zinit snippet OMZP::git
# zinit ice wait'0' silent
# zinit snippet OMZP::sudo
#
# # Load completions
# autoload -Uz compinit && compinit -C
# zinit cdreplay -q #In docs it says its necessary

export PATH="$HOME/.npm-global/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
