# Mac Setup Script

This script automates the installation and configuration of various tools and applications on a macOS system using Homebrew.

## Features

- Installs a list of predefined tools and applications.
- Checks the installation status of each tool.
- Displays a formatted table with the status of each tool.
- Prompts the user to install all non-available binaries.

## Usage

### Checking Installation Status

To check the installation status of all predefined tools and applications, use the `--status` flag:

```sh
./macsetup.sh --status
```

### Install Homebrew

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install ZSH and configure shell
```
brew install zsh
```

```
brew install oh-my-zsh
```

```
brew install powerlevel10k\necho "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
```

Configure shell using below
```
p10k configure
```

### Install Dev Tools

```
brew install git
```

```
brew install --cask iterm2
```

```
brew install python
```

```
brew install go
```

```
brew install openjdk@17
```

```
brew install --cask visual-studio-code
```

```
brew install --cask slack
```

```
brew install --cask postman
```

```
brew install jq
```

```
brew install --cask docker
```

```
brew install --cask rancher
```

```
brew install gh
```

```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
```
```
export NVM_DIR="$HOME/.nvm"
```
```
nvm install stable
```

```
brew install httpie
```

```
brew install k9s
```

```
brew install aws
```

```
brew install --cask sdm
```

```
brew install jfrog-cli
```

```
brew install kubectl
```
### Browsers

```
brew install --cask arc
```

```
brew install --cask brave-browser
```

### Productivity Tools

```
brew install rectangle
```

```
brew install speedtest-cli
```

```
brew install bat
```

```
brew install clipper
```

### Configurations

#### Screenshots in separate folder

1. Use ```Shift``` + ```Command``` + ```5``` to open the screenshot tool.
2. Click on "Options". Then click "Other Location...".
3. Select that specific location that you created earlier.

#### Show hidden files

```
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

#### Speedup Dock Auto-Hide Delay

```
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
killall Dock
```

#### Make VIM default editor

```
export EDITOR=vim
export VISUAL=vim
```

#### Show Full Path in Finder Title Bar

```
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
killall Finder
```

#### Git global config

```
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor vim
```

### Music

```
brew install spotify
```