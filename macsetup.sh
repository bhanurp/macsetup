#!/bin/bash

# ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to check and log the status
check_and_log() {
  tool_name=$1
  check_command=$2

  # Check if installed via Homebrew
  eval "$check_command" &> /dev/null
  if [ $? -eq 0 ]; then
    printf "%-20s ${GREEN}%s${NC}\n" "$tool_name" "Already Installed (via brew)"
  else
    # Check if installed directly
    if command -v $tool_name &> /dev/null; then
      printf "%-20s ${GREEN}%s${NC}\n" "$tool_name" "Already Installed (not via brew)"
    else
      printf "%-20s ${RED}%s${NC}\n" "$tool_name" "Not Installed"
    fi
  fi
}

# Function to install and log the status
install_and_log() {
  tool_name=$1
  install_command=$2

  echo "Installing $tool_name..."
  eval "$install_command"
  
  if [ $? -eq 0 ]; then
    echo "$tool_name installed successfully."
  else
    echo "$tool_name installation failed."
  fi
}

# Function to setup alias
setup_alias() {
  alias ls=lsd
  alias ll='ls -latrh'
  alias cat=bat
}

# Function to check and install Homebrew
check_and_install_brew() {
    # Check if brew is installed
    if command -v brew >/dev/null 2>&1; then
        echo "Homebrew is already installed."
    else
        echo "Homebrew is not installed. Installing now..."
        # Install Homebrew
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then
            echo "Homebrew installed successfully."
        else
            echo "Failed to install Homebrew. Please check your internet connection or permissions."
            exit 1
        fi
    fi
}


# Tools list
tools=(
  "brew:/bin/bash -c \"$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\":brew --version"
  "zsh:brew install zsh:zsh --version"
  "omz:brew install oh-my-zsh:omz --version"
  "powerlevel10k:brew install powerlevel10k && echo \"source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme\" >>~/.zshrc:brew list powerlevel10k"
  "git:brew install git:git --version"
  "iterm2:brew install --cask iterm2:brew list --cask iterm2"
  "python3:brew install python:python3 --version"
  "go:brew install go:go version"
  "java:brew install openjdk@17:java -version"
  "code:brew install --cask visual-studio-code:brew list --cask visual-studio-code"
  "slack:brew install --cask slack:brew list --cask slack"
  "postman:brew install --cask postman:brew list --cask postman"
  "jq:brew install jq:jq --version"
  "docker:brew install --cask docker:brew list --cask docker"
  "rancher:brew install --cask rancher:brew list --cask rancher"
  "gh:brew install gh:gh --version"
  "nvm:curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash && export NVM_DIR=\"$HOME/.nvm\" && nvm install stable:nvm --version"
  "http:brew install httpie:http --version"
  "k9s:brew install k9s:k9s version"
  "aws:brew install aws:aws --version"
  "sdm:brew install --cask sdm:brew list --cask sdm"
  "jfrog:brew install jfrog-cli:jfrog --version"
  "kubectl:brew install kubectl:kubectl version --client"
  "arc:brew install --cask arc:brew list --cask arc"
  "brave:brew install --cask brave-browser:brew list --cask brave-browser"
  "rectangle:brew install rectangle:brew list rectangle"
  "speedtest:brew install speedtest-cli:speedtest --version"
  "bat:brew install bat:bat --version"
  "clipper:brew install clipper:clipper --version"
  "spotify:brew install spotify:brew list spotify"
  "fzf:brew install fzf"
  "tree:brew install tree"
  "git-lfs:brew install git-lfs"
  "lsd:brew install lsd"
  "whatsapp: brew install whatsapp"
  "ffmpeg: brew install ffmpeg"
)

# Check if the --status flag is provided
if [[ "$1" == "--status" ]]; then
  check_and_install_brew
  printf "%-20s %s\n" "--------------------" "--------------------"
  printf "%-20s %s\n" "Tool" "Status"
  printf "%-20s %s\n" "--------------------" "--------------------"
  for tool in "${tools[@]}"; do
    IFS=":" read -r tool_name install_command check_command <<< "$tool"
    check_and_log "$tool_name" "$check_command"
  done
  printf "%-20s %s\n" "--------------------" "--------------------"

  # Display non-available binaries
  echo -e "\nNon-Available Binaries on Mac:"
  non_available_tools=()
  for tool in "${tools[@]}"; do
    IFS=":" read -r tool_name install_command check_command <<< "$tool"
    eval "$check_command" &> /dev/null
    if [ $? -ne 0 ] && ! command -v $tool_name &> /dev/null; then
      printf "%-20s\n" "$tool_name"
      non_available_tools+=("$tool")
    fi
  done

  # Ask user if they want to proceed with installation
  read -p "Would you like to proceed with the installation of all non-available binaries? [Y/n] " response
  response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
  if [[ "$response" =~ ^(yes|y| ) ]] || [[ -z "$response" ]]; then
    for tool in "${non_available_tools[@]}"; do
      IFS=":" read -r tool_name install_command check_command <<< "$tool"
      install_and_log "$tool_name" "$install_command"
    done
  else
    echo "Installation aborted."
  fi
  exit 0
fi

# If no flag is provided, just print a message
echo "Please provide the --status flag to check the installation status of binaries."