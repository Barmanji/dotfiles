# My dotfiles :cherries:

My never ending update of this hell, I welcome you here!

## Manual Installalation -

### Step 1: Install Yay

```bash
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
```

### Step 2: Install the Packages

```bash
cd dotfiles/InstalledArchPackages
bash combined_oneliner_pkg.txt
```

> [!NOTE]
> Have a look at [Packages]("https://github.com/Barmanji/dotfiles/tree/master/InstalledArchPackages")
> If any package installation failed, manual look would be required, go through the files in [Packages]("https://github.com/Barmanji/dotfiles/tree/master/InstalledArchPackages") and either delete them, or check their name if its a typo.

- At this point all of essential files should have been installed.

### Step 3: Stow, Git Setup

### Git

- Check this by running `git --version` in the shell to see if the command is available
- it will most likely prompt you to install it with Xcode Command Line tools.
  - (Skip this step if command line tools already installed)

### GNU Stow

- Refer the docs : [Read More](https://www.gnu.org/software/stow/)

```bash
# If not installed
yay -S stow
```

### Installation of this repo using stow

First, check out dotfiles repo in your $HOME directory using git

```bash
git clone git@github.com:Barmanji/dotfiles.git
cd Godfiles
```

> [!NOTE]
> Dont Stow hyprland, read hyprland & manual copy paste!

#### Before Running any stow commands

- At least for this config structure
- **make sure home directories is set to have the same structure first**
- for instances ( Watch for Sub-directories )
  - if any subdirectory eg: `~/.config` dont exist in $HOME then `mkdir .config`
  - other config files that don't exist in $HOME atm, should not have any problems
    for stow symlinks

then use GNU stow to create symlinks

> [!IMPORTANT]
> make sure you are in your dotfiles directory

- `cd dotfiles`
- as long as you have the structure setup in $HOME correctly
- running `stow .` should be enough

##### However, for assurance

- run stow commands like below for each directory in dotfiles
- re-check if the symlinks are correct for each sub-directories and files

````bash
# or run them separately

stow -vt ~ picom wofi cava scripts bash ghostty p10k  feh neofetch InstalledArchPackages tmux swaync rofi xinitrc wlogout waybar wal yazi kitty waypaper nvim zsh alacritty swww

# read hyprland before stowing it, i prefer manual copy
````


### Step 4: Tmux + Nvim

#### Tmux

- Considering Tmux is installed, check:

```bash
tmux -V
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Use the Prefix + I and Prefix + U, to install and update the plugins then restart
# Prefer Tmux-Sessionizer (just type `ts` in bash/zsh)
```

#### Nvim

- Considering Nvim is installed and `stow -t ~ nvim` has been done.
- Just start nvim and enjoy.

##### Misc

- Flameshot-git is more advanced than hyprshot
- fstrim is important for SSD hygeine, have discard enabled while installing
- SWAP is must, atleast have some I prefer equal to or half of RAM for >64GB Ram, else no need.
- Zen-Browser + Tmux + Nvim + Yt_Music + Docker and moltbot(maybe) is my current Go to VIBE.
