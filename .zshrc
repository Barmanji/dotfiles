# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export FZF_TMUX=1
# Add in zsh plugins
#zinit light zsh-users/zsh-syntax-highlighting  #I dont like this bullshit

# Lazy load plugins without messages
zinit light zsh-users/zsh-completions

zinit light zsh-users/zsh-autosuggestions

zinit light Aloxaf/fzf-tab

# OMZ plugins with silent loading
zinit ice wait'0' silent
zinit snippet OMZP::git

zinit ice wait'0' silent
zinit snippet OMZP::sudo
# Load completions
autoload -Uz compinit && compinit -C
zinit cdreplay -q #In docs it says its necessary
#Keybinds related to that
bindkey '^y' autosuggest-accept
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
export FZF_DEFAULT_OPTS="--bind 'ctrl-y:accept'"
# Bind Ctrl + Left Arrow to move one word backward
bindkey '^[[1;5D' backward-word
# Bind Ctrl + Right Arrow to move one word forward
bindkey '^[[1;5C' forward-word

#completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
#zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
#Aliases
alias ls='ls --color'
#Shell integrations
#eval "$(fzf --zsh)"
#eval "$(zoxide init --cmd cd zsh)"
# History

HISTSIZE=10000
SAVEHIST=10000

HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups


# Aliases for convenience
alias ll='ls -la'
alias update='sudo apt update && sudo apt upgrade -y' 
alias vimbegood='sudo docker run -it --rm brandoncc/vim-be-good:latest'			
alias update='sudo apt-get update && sudo apt-get upgrade -y' 
alias vim='nvim' #Vim will open Nvim-
 alias power='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage'  #Battery %age Shortcuts
 alias perc='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
 alias %age='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
 alias percentage='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
 alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | grep percentage' #Battery %age Shortcuts
export EDITOR=nvim #Even i dont know wtf is this, GPT asked me to do this.
alias brightness='sudo tee /sys/class/backlight/intel_backlight/brightness <<<' #Brightness control
alias rwallpaper="~/scripts/random_wallpaper.sh" #Wallpaper randomizer script
alias menubar='gsettings set org.gnome.Terminal.Legacy.Settings default-show-menubar' #Set True or False for menubar/Topbar
alias userkey='screenkey'
alias xcopy='xclip -selection clipboard'
alias treenode='tree -I node_modules/'
alias c='clear'


#Git SSH copy and see
function gssh() { gh repo view "$1" --json sshUrl }
gcssh() {
  gh repo view "$1" --json sshUrl | jq -r '.sshUrl' | xclip -selection clipboard
  echo "SSH URL copied to clipboard."
}
#Git input directly ssh
function gitty() {
  if [[ -z "$1" ]]; then
    echo "Please provide a repository name."
  else
    git remote add origin "git@github.com:barmanji/$1.git"
    echo "Remote origin added for repository: $1"
  fi
}

# Customize Zsh prompt to show your name and current directory
# Customize Zsh prompt to show your username and current directory
#PROMPT='%n:%~ %#'



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
