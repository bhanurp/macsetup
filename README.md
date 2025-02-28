![alt text](images/macsetup.png)

# Mac Setup Script

X64 [![x64 Build Status](https://github.com/bhanurp/macsetup/actions/workflows/validate-macsetup.yaml/badge.svg?branch=main&event=push&job=validate-macsetup&matrix.arch=x64)](https://github.com/bhanurp/macsetup/actions/workflows/validate-macsetup.yaml)
------------

ARM [![ARM Build Status](https://github.com/bhanurp/macsetup/actions/workflows/validate-macsetup.yaml/badge.svg?branch=main&event=push&job=validate-macsetup&matrix.arch=arm64)](https://github.com/bhanurp/macsetup/actions/workflows/validate-macsetup.yaml)
------------

Macsetup automates the installation, configuration, and verification of various tools and applications on a macOS system using Homebrew. It leverages a JSON configuration file to define the tools to be installed, their installation commands, verification commands, and additional metadata. This makes it easy to distribute and manage tool installations across multiple systems.

## How It Works

1. **Download Configuration**: The script first tries to download the `config/tools.json` file into the `~/.macsetup` directory if it is not already present.
2. **Read Configuration Files**: If the `tools.json` file is present, the script uses all `*.json` files in the `~/.macsetup` directory to read the configuration and install the software.
3. **Skip Certain Files**: Any file that ends with `*.json.d` will be skipped and not used for installation.
4. **Install and Verify**: For each tool defined in the JSON files, the script runs the installation command and then verifies the installation using the verification command.

## Features

- Installs a list of predefined tools defined in tools.json.
    - Sample json
    ```json
    {
      "name": "go",
      "install_command": "brew install go",
      "verify_command": "go version"
    }
    ```
- Checks the installation status of each tool using the verify_command.
- Displays a formatted table with the status of each tool given in tools.json.
- Prompts the user to install all non-available binaries.
- **New Feature**: A JSON file placed in `$HOME/.macsetup` in the following format can be used to install and verify tools:
  ```json
  {
    "name": "ghostty",
    "install_command": "brew install ghostty",
    "verify_command": "ghostty --version",
    "notes": "Ghostty is a terminal emulator"
  }
  ```
- **Default Tools**:The default tools.json file is located in config/tools.json.
- **Sample Configurations**: Sample JSON configuration files are available in the samples directory and can be added to the ~/.macsetup directory for custom tool installations.

## JSON Object Properties

  - `name`: The name of the tool.
  - `install_command`: The command to install the tool.
  - `verify_command`: The command to verify the installation of the tool.
  - `notes`: A description of what the tool does.
  - `skip`: If set to `true`, skips both installation and verification of the tool.
  - `post_installation`: An optional command to run after installation and before verification.
- **Distribution Based**: The script now supports multiple JSON files, making it more distribution-based. You can use and distribute different JSON files to check and validate installations.

## Installation command example

```sh
curl -sSL https://raw.githubusercontent.com/bhanurp/macsetup/main/macsetup.sh | bash -s -- --status --install
```

## Usage

### Checking Installation Status

To check the installation status of all predefined tools and applications, use the `--status` flag:

```sh
./macsetup.sh --status
```

### Install Homebrew

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Install ZSH and configure shell

```sh
brew install zsh
brew install oh-my-zsh
brew install powerlevel10k
echo "source $(brew --prefix)/share/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc
p10k configure
```

### Install Dev Tools

```sh
brew install git
brew install --cask iterm2
brew install python
brew install go
brew install openjdk@17
brew install --cask visual-studio-code
brew install --cask slack
brew install --cask postman
brew install jq
brew install --cask docker
brew install --cask rancher
brew install gh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
export NVM_DIR="$HOME/.nvm"
nvm install stable
brew install httpie
brew install k9s
brew install aws
brew install --cask sdm
brew install jfrog-cli
brew install kubectl
brew install fzf
brew install tree
brew install git-lfs
```

### Browsers

```sh
brew install --cask arc
brew install --cask brave-browser
```

### Productivity Tools

```sh
brew install rectangle
brew install speedtest-cli
brew install bat
brew install clipper
```

### Configurations

#### Screenshots in separate folder

1. Use ```Shift``` + ```Command``` + ```5``` to open the screenshot tool.
2. Click on "Options". Then click "Other Location...".
3. Select that specific location that you created earlier.

#### Show hidden files

```sh
defaults write com.apple.finder AppleShowAllFiles -bool true
killall Finder
```

#### Speedup Dock Auto-Hide Delay

```sh
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5
killall Dock
```

#### Make VIM default editor

```sh
export EDITOR=vim
export VISUAL=vim
```

#### Show Full Path in Finder Title Bar

```sh
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
killall Finder
```

#### Git global config

```sh
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global core.editor vim
```

### Music

```sh
brew install spotify
```

## Default Tools

The following table lists all the binaries that are installed via the default `tools.json` in 

tools.json

:

 Tool Name | Installation Command | Verification Command | Notes |
|-----------|----------------------|----------------------|-------|
| zsh       | `brew install zsh` | `zsh --version` | zsh is a shell similar to bash |
| omz       | `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && export ZSH=$HOME/.oh-my-zsh` |  | oh my zsh is a zsh framework |
| git       | `brew install git` | `git --version` | git is a version control system |
| iterm2    | `brew install --cask iterm2` | `brew list --cask iterm2` | iTerm2 is a terminal emulator |
| ghostty   | `brew install ghostty` | `ghostty --version` | Ghostty is a terminal emulator |
| python3   | `brew install python` | `python3 --version` | Python is a programming language |
| go        | `brew install go` | `go version` | Go is a programming language |
| java      | `brew install openjdk@17` | `java -version` | Java is a programming language |
| code      | `brew install --cask visual-studio-code` | `code --version` | Visual Studio Code is a code editor |
| slack     | `brew install --cask slack` | `brew list --cask slack` | Slack is a messaging app |
| postman   | `brew install --cask postman` | `brew list --cask postman` | Postman is an API client |
| jq        | `brew install jq` | `jq --version` | jq is a terminal JSON processor |
| docker    | `brew install --cask docker` | `brew list --cask docker` | Docker Desktop is a containerization platform |
| rancher   | `brew install --cask rancher` | `brew list --cask rancher` | Rancher Desktop is an alternative to Docker Desktop |
| gh        | `brew install gh` | `gh --version` | gh is the GitHub CLI |
| http      | `brew install httpie` | `http --version` | httpie is a HTTP client |
| k9s       | `brew install k9s` | `k9s version` | k9s is a Kubernetes TUI application |
| aws       | `brew install awscli` | `aws --version` | awscli is the AWS CLI |
| sdm       | `brew install --cask sdm` | `brew list --cask sdm` | StrongDM is an access management tool |
| jfrog     | `brew install jfrog-cli` | `jfrog --version` | jfrog is a CLI for JFrog products |
| kubectl   | `brew install kubectl` | `kubectl version --client` | kubectl is the Kubernetes CLI |
| arc       | `brew install --cask arc` | `brew list --cask arc` | Arc is a fancy browser |
| brave     | `brew install --cask brave-browser` | `brew list --cask brave-browser` | Brave is a privacy-focused browser |
| rectangle | `brew install rectangle` | `brew list rectangle` | Rectangle is a window manager |
| speedtest | `brew install speedtest-cli` | `speedtest --version` | speedtest-cli is a network speed test tool |
| bat       | `brew install bat` | `bat --version` | bat is a cat clone on steroids |
| clipper   | `brew install clipper` | `clipper --version` | clipper is a clipboard manager |
| spotify   | `brew install spotify` | `brew list spotify` | Spotify is a music streaming service |
| fzf       | `brew install fzf` | `fzf --version` | fzf is a fuzzy finder generally used with other terminal applications |
| tree      | `brew install tree` | `tree` | tree is a directory listing program |
| git-lfs   | `brew install git-lfs` |  | git-lfs is a Git extension for large files |
| lsd       | `brew install lsd` | `lsd` | lsd is a modern ls command |
| whatsapp  | `brew install whatsapp` |  | WhatsApp is a messaging app |
| ffmpeg    | `brew install ffmpeg` | `ffmpeg -version` | ffmpeg is a multimedia framework and tool suite to edit video and audio |
| mpv       | `brew install mpv` | `mpv --version` | mpv is a terminal media player |

## GitHub Actions

The repository includes a GitHub Actions workflow to validate the installation of tools. The workflow checks if `tools.json` exists, installs the necessary tools, and validates their installation.
