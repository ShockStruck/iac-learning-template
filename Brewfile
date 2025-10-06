# IaC Learning Template - Homebrew Dependencies
# Install all required tools with: brew bundle

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
# Docker Desktop provides both docker and docker-compose
# Install from: https://docker.com/products/docker-desktop
# Or use: brew install --cask docker
cask "docker" unless system("/usr/local/bin/docker --version")

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
