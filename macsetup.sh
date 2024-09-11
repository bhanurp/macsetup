#!/bin/bash

# Log file to store the installation status
log_file="installation_status.log"
echo -e "Tool\t\tStatus" > $log_file

install_and_log() {
  tool_name=$1
  install_command=$2

  echo "Installing $tool_name..."
  eval "$install_command"
  
  if [ $? -eq 0 ]; then
    echo "$tool_name installed successfully."
    echo -e "$tool_name\t\tSuccess" >> $log_file
  else
    echo "$tool_name installation failed."
    echo -e "$tool_name\t\tFailed" >> $log_file
  fi
}

# Install Homebrew
install_and_log "Homebrew" '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'

# Install ZSH
install_and_log "ZSH" "brew install zsh"

# Install Oh My Zsh
install_and_log "Oh My Zsh" "brew install oh-my-zsh"

# Install Powerlevel10k
install_and_log "Powerlevel10k" "brew install powerlevel10k && echo \"source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme\" >>~/.zshrc"

# Dev Tools Installations
install_and_log "Git" "brew install git"
install_and_log "iTerm2" "brew install --cask iterm2"
install_and_log "Python" "brew install python"
install_and_log "Go" "brew install go"
install_and_log "OpenJDK@17" "brew install openjdk@17"
install_and_log "VS Code" "brew install --cask visual-studio-code"
install_and_log "Slack" "brew install --cask slack"
install_and_log "Postman" "brew install --cask postman"
install_and_log "jq" "brew install jq"
install_and_log "Docker" "brew install --cask docker"
install_and_log "Rancher" "brew install --cask rancher"
install_and_log "GitHub CLI" "brew install gh"
install_and_log "nvm" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && export NVM_DIR=\"$HOME/.nvm\" && nvm install stable"
install_and_log "HTTPie" "brew install httpie"

# Browsers
install_and_log "Arc Browser" "brew install --cask arc"
install_and_log "Brave Browser" "brew install --cask brave-browser"

# Productivity Tools
install_and_log "Rectangle" "brew install rectangle"
install_and_log "Speedtest CLI" "brew install speedtest-cli"
install_and_log "bat" "brew install bat"
install_and_log "Clipper" "brew install clipper"

# Additional Configurations
echo "Setting macOS configurations..."

# Show hidden files
install_and_log "Show Hidden Files" "defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"

# Speed up Dock auto-hide delay
install_and_log "Speedup Dock Auto-Hide" "defaults write com.apple.dock autohide-delay -float 0 && defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall Dock"

# Make Vim the default editor
install_and_log "Set Vim as Default Editor" "export EDITOR=vim && export VISUAL=vim"

# Show full path in Finder title bar
install_and_log "Show Full Path in Finder" "defaults write com.apple.finder _FXShowPosixPathInTitle -bool true && killall Finder"

# Git global config
install_and_log "Git Global Config" "git config --global user.name 'Your Name' && git config --global user.email 'your.email@example.com' && git config --global core.editor vim"

echo "Installation and configuration complete."
echo "Check $log_file for a summary of installation statuses."
"""
