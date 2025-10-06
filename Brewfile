# IaC Learning Template - Homebrew Dependencies
# Install all required tools with: brew bundle
#
# NOTE: This Brewfile works on macOS and Linux (via Homebrew on Linux)
# For Ubuntu/Linux: Docker should be installed via apt, not Homebrew

# === Core Tools ===
brew "git"                    # Version control
brew "direnv"                 # Environment management
brew "jq"                     # JSON processor
brew "yq"                     # YAML processor

# === Infrastructure as Code ===
brew "go-task/tap/go-task"    # Task automation (Taskfile.yml)

# === Secrets Management ===
brew "age"                    # Modern encryption tool
brew "sops"                   # Secrets OPerationS

# === Container Runtime ===
# LINUX USERS: Install Docker via your package manager (apt, yum, etc.)
#   Ubuntu: sudo apt-get install docker.io docker-compose-v2
#   Or see: https://docs.docker.com/engine/install/ubuntu/
#
# MACOS USERS: Install Docker Desktop
cask "docker" if OS.mac?

# === Code Quality ===
brew "pre-commit"             # Git pre-commit hooks
brew "yamllint"               # YAML linting
brew "shellcheck"             # Shell script analysis

# === Development Tools (optional) ===
brew "htop"                   # System monitor
brew "tree"                   # Directory visualization
brew "watch"                  # Execute commands periodically
brew "curl"                   # URL transfers
brew "wget"                   # Web file retrieval
brew "httpie"                 # HTTP client

# === Python (if not already installed) ===
brew "python@3"               # Python 3 runtime
