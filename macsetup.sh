#!/bin/bash

# Define color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# check and log the status
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

# install and log the status
install_and_log() {
  tool_name=$1
  install_command=$2
  verify_command=$3

  echo "Installing $tool_name..."
  eval "$install_command"
  
  if [ $? -eq 0 ]; then
    echo -e "${GREEN}$tool_name installed successfully.${NC}"
    if [ -n "$verify_command" ]; then
      echo "Verifying $tool_name installation..."
      eval "$verify_command"
      if [ $? -eq 0 ]; then
        echo -e "${GREEN}$tool_name verification successful.${NC}"
      else
        echo -e "${RED}$tool_name verification failed.${NC}"
      fi
    else
      echo "Verification skipped for $tool_name since verification command is not provided."
    fi
  else
    echo -e "${RED}$tool_name installation failed.${NC}"
  fi
}

debug_echo() {
  if [ "$DEBUG" = true ]; then
    echo "$1"
  fi
}

# Function to setup alias
setup_alias() {
  read -p "Do you want to set up the following aliases? (y/n): 
  alias ls=lsd
  alias ll='ls -latrh'
  alias cat=bat
  " response

  if [[ "$response" =~ ^[Yy]$ ]]; then
    alias ls=lsd
    alias ll='ls -latrh'
    alias cat=bat

    write_to_shell_profile "alias ls=lsd"
    write_to_shell_profile "alias ll='ls -latrh'"
    write_to_shell_profile "alias cat=bat"
    echo "Aliases have been added to your shell profile."
  else
    echo "Aliases setup skipped."
  fi
}

# Function to detect shell and write content to the appropriate profile
write_to_shell_profile() {
  content=$1

  if [ "$SHELL" = "/bin/bash" ]; then
    profile_file="$HOME/.bashrc"
  elif [ "$SHELL" = "/bin/zsh" ]; then
    profile_file="$HOME/.zshrc"
  else
    echo "Unsupported shell: $SHELL"
    return 1
  fi

  echo "Writing to $profile_file..."
  echo "$content" >> "$profile_file"
  echo "Content written to $profile_file. Please restart your shell or run 'source $profile_file' to apply the changes."
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
            echo -e "${GREEN}Homebrew installed successfully.${NC}"
        else
            echo -e "${RED}Failed to install Homebrew. Please check your internet connection or permissions.${NC}"
            exit 1
        fi
    fi
}

# Function to check and install jq
check_and_install_jq() {
    if command -v jq >/dev/null 2>&1; then
        echo "jq is already installed."
    else
        echo "jq is not installed. Installing now..."
        brew install jq
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}jq installed successfully.${NC}"
        else
            echo -e "${RED}Failed to install jq. Please check your internet connection or permissions.${NC}"
            exit 1
        fi
    fi
}

# Read tools from JSON file and install them
install_tools_from_json() {
  json_file=$1
  if [ ! -f "$json_file" ]; then
    echo -e "${RED}Error: JSON file $json_file not found.${NC}"
    exit 1
  fi

  tools=$(jq -c '.[]' "$json_file")
  if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to parse JSON file $json_file.${NC}"
    exit 1
  fi

  echo "$tools" | while IFS= read -r tool; do
    skip=$(echo "$tool" | jq -r '.skip // false')
    if [ "$skip" = true ]; then
      echo "Skipping $(echo "$tool" | jq -r '.name')"
      continue
    fi

    name=$(echo "$tool" | jq -r '.name')
    install_command=$(echo "$tool" | jq -r '.install_command')
    verify_command=$(echo "$tool" | jq -r '.verify_command')

    if [ -z "$name" ] || [ -z "$install_command" ]; then
      echo -e "${RED}Error: Missing required fields in JSON file.${NC}"
      exit 1
    fi

    install_and_log "$name" "$install_command" "$verify_command"
  done
}

# Function to check non-available tools
check_non_available_tools() {
  non_available_tools=()
  for tool in "${tools[@]}"; do
    IFS=":" read -r tool_name install_command check_command <<< "$tool"
    eval "$check_command" &> /dev/null
    if [ $? -ne 0 ] && ! command -v $tool_name &> /dev/null; then
      printf "%-20s\n" "$tool_name"
      non_available_tools+=("$tool")
    fi
  done
}

display_help() {
  echo "Usage: $0 [--skip] [--install] [--debug] [--status] [--help]"
  echo "  --skip    Skip downloading tools.json from URL and use existing file in ~/.macsetup"
  echo "  --install Automatically proceed with the installation of all non-available binaries"
  echo "  --debug   Enable debug mode to print additional information"
  echo "  --status  Check the status of tools and install non-available binaries"
  echo "  --help    Display this help message"
  exit 0
}

# Check and install Homebrew
check_and_install_brew

# Check and install jq
check_and_install_jq

# Check if ~/.macsetup directory exists and create it if necessary
macsetup_dir="$HOME/.macsetup"
if [ ! -d "$macsetup_dir" ]; then
  echo "Directory $macsetup_dir does not exist. Creating now..."
  mkdir -p "$macsetup_dir"
fi

# Parse command-line arguments
skip_download=false
auto_install=false
DEBUG=false
while [[ "$1" != "" ]]; do
  case $1 in
    --help)
      display_help
      ;;
    --skip)
      skip_download=true
      ;;
    --install)
      auto_install=true
      ;;
    --debug)
      DEBUG=true
      ;;
    --status)
      # Ensure tools.json is downloaded before checking status
      if [ "$skip_download" = false ] && [ ! -f "$macsetup_dir/tools.json" ]; then
        echo "Downloading tools.json..."
        curl -L -o "$macsetup_dir/tools.json" "https://raw.githubusercontent.com/bhanurp/macsetup/main/config/tools.json"
      fi

      # Check for eligible JSON files in ~/.macsetup directory
      json_files=("$macsetup_dir"/*.json)
      eligible_files=()
      for json_file in "${json_files[@]}"; do
        if [[ "$json_file" != *.json.d ]]; then
          eligible_files+=("$json_file")
        fi
      done

      # Download the default tools.json into ~/.macsetup if no eligible files are found
      if [ ${#eligible_files[@]} -eq 0 ]; then
        echo "No eligible JSON files found. Downloading tools.json..."
        curl -L -o "$macsetup_dir/tools.json" "https://raw.githubusercontent.com/bhanurp/macsetup/main/config/tools.json"
        eligible_files+=("$macsetup_dir/tools.json")
      else
        echo "Using existing JSON files in ~/.macsetup"
      fi

      # Load tools from tools.json
      tools=$(jq -c '.[]' "$macsetup_dir/tools.json")
      if [ $? -ne 0 ]; then
        echo -e "${RED}Error: Failed to parse JSON file $macsetup_dir/tools.json.${NC}"
        exit 1
      fi

      check_and_install_brew
      printf "%-20s %s\n" "--------------------" "--------------------"
      printf "%-20s %s\n" "Tool" "Status"
      printf "%-20s %s\n" "--------------------" "--------------------"
      echo "$tools" | while IFS= read -r tool; do
        skip=$(echo "$tool" | jq -r '.skip // false')
        if [ "$skip" = true ]; then
          echo "Skipping $(echo "$tool" | jq -r '.name')"
          continue
        fi

        tool_name=$(echo "$tool" | jq -r '.name')
        debug_echo "Checking tool name [$tool_name]..."
        check_command=$(echo "$tool" | jq -r '.verify_command')
        debug_echo "Checking [${tool_name}]...[${check_command}]"
        check_and_log "${tool_name}" "${check_command}"
      done
      printf "%-20s %s\n" "--------------------" "--------------------"

      # Display non-available binaries
      echo -e "\nNon-Available Binaries on Mac:"
      check_non_available_tools

      # Ask user if they want to proceed with installation
      if [ "$auto_install" = true ]; then
        response="y"
      else
        read -p "Would you like to proceed with the installation of all non-available binaries? [Y/n] " response
      fi
      response=$(echo "$response" | tr '[:upper:]' '[:lower:]') # Convert to lowercase
      if [[ "$response" =~ ^(yes|y| ) ]] || [[ -z "$response" ]]; then
        for tool in "${non_available_tools[@]}"; do
          tool_name=$(echo "$tool" | jq -r '.name')
          install_command=$(echo "$tool" | jq -r '.install_command')
          check_command=$(echo "$tool" | jq -r '.verify_command')
          install_and_log "$tool_name" "$install_command" "$check_command"
        done

        # Re-run the check for non-available tools after installation
        echo -e "\nRe-checking non-available binaries on Mac:"
        check_non_available_tools
      else
        echo "Installation aborted."
      fi
      exit 0
      ;;
    *)
      echo "Usage: $0 [--skip] [--install] [--status]"
      echo "  --skip    Skip downloading tools.json from URL and use existing file in ~/.macsetup"
      echo "  --install Automatically proceed with the installation of all non-available binaries"
      echo "  --status  Check the status of tools and install non-available binaries"
      exit 1
      ;;
  esac
  shift
done

# Check for eligible JSON files in ~/.macsetup directory
json_files=("$macsetup_dir"/*.json)
eligible_files=()
for json_file in "${json_files[@]}"; do
  if [[ "$json_file" != *.json.d ]]; then
    eligible_files+=("$json_file")
  fi
done

# Download the default tools.json into ~/.macsetup if not skipping and no eligible files are found
if [ "$skip_download" = false ] && [ ${#eligible_files[@]} -eq 0 ]; then
  echo "No eligible JSON files found. Downloading tools.json..."
  curl -L -o "$macsetup_dir/tools.json" "https://raw.githubusercontent.com/bhanurp/macsetup/main/config/tools.json"
  eligible_files+=("$macsetup_dir/tools.json")
else
  echo "Skipping download of tools.json and using existing file in ~/.macsetup"
fi

# Process JSON files in ~/.macsetup directory
for json_file in "${eligible_files[@]}"; do
  install_tools_from_json "$json_file"
done

# Call setup_alias function
setup_alias