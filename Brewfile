# IaC Template - Homebrew Dependencies
# Install with: brew bundle
#
# NOTE: For Ubuntu/Linux, Docker should be installed via apt
# Only use this for other CLI tools

# === Core Tools ===
brew "git"                    # Version control
brew "direnv"                 # Environment management

# === Infrastructure as Code ===
brew "go-task/tap/go-task"    # Task automation

# === Secrets Management ===
brew "age"                    # Modern encryption
brew "sops"                   # Secrets OPerationS

# === Container Runtime (macOS only) ===
# Ubuntu: Install via apt (docker.io docker-compose-v2)
cask "docker" if OS.mac?

# === Optional Development Tools ===
# Uncomment as needed:
# brew "jq"                   # JSON processor
# brew "yq"                   # YAML processor
# brew "pre-commit"           # Git hooks
# brew "yamllint"             # YAML linting
# brew "shellcheck"           # Shell script analysis
