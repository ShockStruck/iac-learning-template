# 🚀 Infrastructure as Code Learning Template

> A comprehensive, hands-on template for learning Infrastructure as Code concepts with Docker Compose, SOPS secrets management, and Task automation.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Task](https://img.shields.io/badge/Task-Taskfile-blue)](https://taskfile.dev)
[![SOPS](https://img.shields.io/badge/SOPS-Encrypted-green)](https://github.com/mozilla/sops)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue)](https://docs.docker.com/compose/)

## 🎯 Overview

This template provides a **production-ready** Infrastructure as Code learning environment that demonstrates:

- **🔐 Secrets Management**: SOPS with Age encryption for secure credential handling
- **🐳 Service Orchestration**: Docker Compose with multi-service architecture
- **⚙️ Task Automation**: Comprehensive workflow automation using Taskfile
- **📈 Monitoring**: Prometheus and Grafana for observability
- **✅ Quality Assurance**: Pre-commit hooks for code quality and security
- **📚 Educational Approach**: Step-by-step learning path with hands-on examples

## ⚡ Quick Start

```bash
# Clone the repository
git clone https://github.com/ShockStruck/iac-learning-template.git
cd iac-learning-template

# Install dependencies (see Installation section below)
brew bundle  # macOS or Linux with Homebrew

# Bootstrap everything (install dependencies, setup environment)
task start

# Begin learning journey
task basics
```

That's it! Your infrastructure is running and you're ready to learn.

## 📚 Learning Path

This template provides a structured 4-module learning path:

### Module 1: IaC Basics 📖
```bash
task basics
```
- Understand Infrastructure as Code fundamentals
- Learn Task automation patterns
- Explore repository structure and organization

### Module 2: Secrets Management 🔐
```bash
task secrets
```
- Master SOPS encryption with Age keys
- Implement secure secrets handling
- Practice GitOps-compatible secret workflows

### Module 3: Docker Compose 🐳
```bash
task compose
```
- Build multi-service architectures
- Configure service dependencies and networking
- Integrate encrypted secrets with containers

### Module 4: Automation Patterns ⚙️
```bash
task automation
```
- Advanced Task automation techniques
- CI/CD integration patterns
- Production deployment strategies

## 🏠 Architecture

```
iac-learning-template/
├── Taskfile.yml           # Main task automation
├── Brewfile               # Homebrew dependencies
├── .sops.yaml             # SOPS encryption config
├── .taskfiles/            # Modular task definitions
│   ├── compose/           # Docker Compose operations
│   ├── sops/              # Secrets management
│   ├── bootstrap/         # Dependency installation
│   ├── validate/          # Health checks
│   ├── examples/          # Demo workflows
│   └── readme/            # Documentation generation
├── examples/              # Docker Compose examples
│   ├── docker-compose.yml # Multi-service definition
│   ├── nginx.conf         # Web server config
│   ├── prometheus.yml     # Monitoring config
│   ├── init/              # Database initialization
│   └── html/              # Static web content
├── secrets/               # Encrypted secrets (SOPS)
│   └── app.sops.env       # Application secrets
├── .secrets/              # Local secrets (gitignored)
│   └── age.key            # Encryption key
├── docs/                  # Educational documentation
└── scripts/               # Utility scripts
```

## 🔧 Installation

### Prerequisites

**Ubuntu/Linux:**
- **Docker** ([install guide](https://docs.docker.com/engine/install/ubuntu/))
- **Homebrew** (optional, for tool management) ([install here](https://brew.sh/))

**macOS:**
- **Homebrew** ([install here](https://brew.sh/))
- **Docker Desktop** (installed via Brewfile)

### Linux Docker Installation (Ubuntu)

```bash
# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker.io docker-compose-v2

# Add your user to docker group (logout/login required)
sudo usermod -aG docker $USER

# Start and enable Docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Automated Setup

The bootstrap process installs all required tools:

```bash
# Option 1: Install via Homebrew Bundle (recommended)
brew bundle

# Option 2: Full bootstrap (includes dependency installation)
task bootstrap:all
```

This installs:
- ✅ Git, direnv, age, sops, Task, pre-commit
- ✅ Docker Engine and Docker Compose (Linux: via apt, macOS: via Homebrew)
- ✅ Python dependencies for automation
- ✅ Project directory structure
- ✅ SOPS encryption keys and configuration

### Manual Setup

If you prefer manual installation:

```bash
# Install Homebrew tools
brew install git direnv age sops go-task/tap/go-task pre-commit

# Setup direnv
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc  # or ~/.zshrc
source ~/.bashrc

# Generate Age encryption key
mkdir -p .secrets
age-keygen -o .secrets/age.key

# Create SOPS configuration
echo "creation_rules:\n  - age: $(age-keygen -y .secrets/age.key)" > .sops.yaml

# Initialize secrets
task sops:init

# Allow direnv
direnv allow
```

## 🚀 Usage

### Starting Services

```bash
# Start all services with encrypted secrets
task up

# Check service status
task status

# View service logs
task logs -- nginx
task logs -- postgres
```

### Secrets Management

```bash
# View encrypted secrets (decrypted)
task sops:view

# Edit secrets securely
task sops:edit

# Check encryption status
task sops:status

# View SOPS tutorial
task sops:tutorial
```

### Service Management

```bash
# Stop all services
task down

# Restart specific service
task compose:restart -- nginx

# Get shell in container
task compose:shell -- postgres

# Pull latest images
task compose:pull
```

### Development Commands

```bash
# Setup development environment
task dev:setup

# Run all validation checks
task check

# View all available commands
task --list

# Get help
task help
```

## 🌐 Service Endpoints

Once running, access these services:

| Service | URL | Credentials |
| --------- | ----- | ------------- |
| **Nginx** | http://localhost:8080 | N/A |
| **Grafana** | http://localhost:3000 | admin / admin |
| **Prometheus** | http://localhost:9090 | N/A |
| **PostgreSQL** | localhost:5432 | See secrets/app.sops.env |
| **Redis** | localhost:6379 | See secrets/app.sops.env |

## 🔒 Security Features

### Secrets Management
- **Age Encryption**: Military-grade encryption for all sensitive data
- **SOPS Integration**: GitOps-compatible encrypted secrets
- **No Plaintext**: Never commit unencrypted credentials
- **Key Rotation**: Easy key rotation support

### Container Security
- **Non-root Users**: All containers run as unprivileged users
- **Read-only Filesystems**: Immutable container runtime
- **Resource Limits**: CPU and memory constraints
- **Network Isolation**: Segmented networks for services

### Code Quality
- **Pre-commit Hooks**: Automated quality checks
- **Secrets Detection**: Prevent accidental credential commits
- **YAML Linting**: Syntax validation
- **Shell Script Checking**: Shellcheck integration

## 📈 Monitoring

### Prometheus Metrics

Access Prometheus at http://localhost:9090 to query:

- Container resource usage
- Service health checks
- Application metrics
- System performance

### Grafana Dashboards

Access Grafana at http://localhost:3000 (admin/admin) for:

- Pre-configured dashboards
- Custom metric visualization
- Alert management
- Data exploration

## 🐛 Troubleshooting

### Services Won't Start

```bash
# Check Docker daemon
docker info

# Validate Docker Compose file
task validate:docker

# Check secrets decryption
task validate:sops
```

### Permission Issues

```bash
# Fix Age key permissions
chmod 600 .secrets/age.key

# Add user to docker group (Linux)
sudo usermod -aG docker $USER
# Log out and back in for group change to take effect
```

### SOPS Decryption Fails

```bash
# Verify Age key
age-keygen -y .secrets/age.key

# Check SOPS config
cat .sops.yaml

# Test decryption
task sops:view
```

### Port Conflicts

If ports are already in use, modify `examples/docker-compose.yml`:

```yaml
services:
  nginx:
    ports:
      - "8080:80"  # Change 8080 to another port
```

## 📚 Documentation

- [Module 1: IaC Basics](docs/01-iac-basics.md)
- [Module 2: Secrets Management](docs/02-secrets-management.md)
- [Module 3: Docker Compose](docs/03-docker-compose.md)
- [Module 4: Automation Patterns](docs/04-automation-patterns.md)

## 🤝 Contributing

Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.

## 📑 License

MIT License - see [LICENSE](LICENSE) for details.

## 👤 Author

Created as an educational template for learning Infrastructure as Code concepts.

## 💬 Support

For questions or issues:

1. Check the [documentation](docs/)
2. Review [troubleshooting](#-troubleshooting)
3. Open an [issue](https://github.com/ShockStruck/iac-learning-template/issues)

## ⭐ Acknowledgments

- [Mozilla SOPS](https://github.com/mozilla/sops) for secrets management
- [Taskfile](https://taskfile.dev) for task automation
- [Age](https://age-encryption.org/) for encryption
- Infrastructure as Code community

---

**Happy Learning! 🎓** Start your IaC journey with `task start`
