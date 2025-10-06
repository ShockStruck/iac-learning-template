# 🏗️ Infrastructure as Code Learning Template

[![Task](https://img.shields.io/badge/Task-Enabled-brightgreen?logo=task)](https://taskfile.dev)
[![SOPS](https://img.shields.io/badge/SOPS-Encrypted-blue?logo=mozilla)](https://github.com/mozilla/sops)
[![Docker](https://img.shields.io/badge/Docker-Compose-blue?logo=docker)](https://docs.docker.com/compose/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

A comprehensive learning template for Infrastructure as Code (IaC) concepts using Docker Compose, SOPS secret management, and Task automation. Perfect for learning modern infrastructure patterns and best practices.

## 🎆 Features

- **🔐 Secret Management**: SOPS encryption with Age keys
- **🚀 Task Automation**: Comprehensive task runner configuration
- **🐳 Multi-Service Stack**: Web, API, Database, Cache, Monitoring
- **📊 Monitoring**: Prometheus metrics + Grafana dashboards
- **🌐 Load Balancing**: Traefik reverse proxy (advanced profile)
- **📦 Package Management**: Homebrew automation for macOS
- **📁 Volume Persistence**: Data persistence across container restarts
- **🔗 Service Discovery**: Internal networking and communication

## 🚀 Quick Start

### Prerequisites

- **macOS**: Run `task brew:install` (installs all required tools)
- **Other platforms**: Install manually:
  - [Docker](https://docs.docker.com/get-docker/)
  - [Docker Compose](https://docs.docker.com/compose/install/)
  - [Task](https://taskfile.dev/installation/)
  - [SOPS](https://github.com/mozilla/sops)
  - [Age](https://github.com/FiloSottile/age)
  - [direnv](https://direnv.net/docs/installation.html)

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/ShockStruck/iac-learning-template.git
cd iac-learning-template

# 2. Bootstrap the environment (macOS)
task bootstrap

# 3. Edit secrets (will create and encrypt)
task sops:edit -- secrets/secret.sops.env

# 4. Start the basic stack
task examples:basic

# 5. Open in browser
open http://localhost:8080
```

## 📊 Service Stack

| Service | Port | Description | Health Check |
|---------|------|-------------|-------------|
| **Web** | 8080 | Nginx static content | ✅ HTTP |
| **API** | 3000 | Node.js REST API | ✅ HTTP |
| **Database** | 5432 | PostgreSQL 15 | ✅ pg_isready |
| **Cache** | 6379 | Redis 7 | ✅ ping |
| **Prometheus** | 9090 | Metrics collection | ✅ HTTP |
| **Grafana** | 3001 | Dashboards | ✅ HTTP |
| **Traefik** | 80/8081 | Load balancer (advanced) | ✅ HTTP |

## 🔐 Secret Management

This template uses **SOPS** (Secrets OPerationS) with **Age** encryption for secure secret management.

### Key Commands

```bash
# Generate Age encryption key
task sops:keygen

# Edit encrypted secrets file
task sops:edit -- secrets/secret.sops.env

# View decrypted secrets (for debugging)
task sops:decrypt -- secrets/secret.sops.env

# Check SOPS health
task sops:health

# Encrypt any unencrypted .sops.* files
task sops:encrypt
```

### Secret Integration

Secrets are automatically decrypted and injected into Docker Compose:

```yaml
# docker-compose.yml
environment:
  - POSTGRES_PASSWORD=${DATABASE_PASSWORD}  # From SOPS
  - APP_SECRET_KEY=${APP_SECRET_KEY}        # From SOPS
```

## 🚀 Learning Examples

### Basic Examples

```bash
# Start simple web + database stack
task examples:basic

# Explore secret management
task examples:secrets

# Add monitoring (Prometheus + Grafana)
task examples:monitoring
```

### Intermediate Examples

```bash
# Learn Docker networking
task examples:networking

# Explore data persistence
task examples:persistence

# Practice horizontal scaling
task examples:scaling
```

### Advanced Examples

```bash
# Full stack with load balancer
task examples:advanced

# Backup and recovery strategies
task examples:backup

# Security hardening patterns
task examples:security
```

## 🚀 Task Automation

This project uses [Task](https://taskfile.dev) for automation. View all available tasks:

```bash
# List all tasks
task --list

# Core operations
task bootstrap          # Full setup
task health            # System health check
task clean             # Clean up resources

# Docker Compose operations
task compose:up        # Start stack
task compose:down      # Stop stack
task compose:ps        # List services
task compose:logs      # View logs
task compose:restart   # Restart service

# Secret management
task sops:keygen       # Generate Age key
task sops:edit         # Edit secrets
task sops:health       # Check SOPS status

# Learning examples
task examples:list     # List all examples
task examples:basic    # Basic stack
task examples:advanced # Advanced features

# macOS tool installation
task brew:install      # Install CLI tools
task brew:check        # Check tool status
```

---

**🎉 Happy learning!** This template provides a solid foundation for understanding Infrastructure as Code concepts. Start with the basic examples and gradually work your way up to advanced patterns.
