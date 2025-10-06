# Module 1: Infrastructure as Code Basics

## 🎯 Learning Objectives

By the end of this module, you will:

- ✅ Understand what Infrastructure as Code (IaC) means
- ✅ Learn why IaC is essential for modern infrastructure
- ✅ Explore key IaC principles and practices
- ✅ Master Task automation basics
- ✅ Navigate this template's project structure

## 📚 What is Infrastructure as Code?

Infrastructure as Code is the practice of managing and provisioning infrastructure through **code** rather than manual processes.

### Traditional Approach vs IaC

**Traditional (Manual)**:
```
1. Log into server
2. Run commands manually
3. Document what you did (maybe)
4. Hope you remember next time
5. Struggle to reproduce on another server
```

**IaC Approach**:
```
1. Write code defining desired state
2. Version control the code
3. Apply code automatically
4. Reproduce anywhere, anytime
5. Track all changes in Git
```

## 🎯 Key Principles

### 1. Declarative Configuration

You declare **what** you want, not **how** to get there:

```yaml
# docker-compose.yml
services:
  postgres:
    image: postgres:15-alpine
    environment:
      POSTGRES_DB: appdb
    # Docker handles the "how"
```

### 2. Version Control

All infrastructure code lives in Git:

- Track every change
- Review before applying
- Rollback if needed
- Collaborate effectively

### 3. Idempotency

Running the same code multiple times produces the same result:

```bash
# Safe to run multiple times
task up
task up
task up
# Result: services running (no duplicates)
```

### 4. Automation

Manual steps are automated through code:

```bash
# Instead of 20 manual steps:
task start
# Automatically: install deps, setup secrets, start services
```

## 🔧 Task Automation

This template uses [Task](https://taskfile.dev) for automation.

### Why Task?

- **Simple**: YAML-based, easy to read
- **Powerful**: Dependency management, variables, includes
- **Cross-platform**: Works on macOS, Linux, Windows
- **Fast**: Written in Go, blazing performance

### Task Anatomy

```yaml
tasks:
  deploy:                    # Task name
    desc: "Deploy services"  # Description
    deps: [validate]         # Run 'validate' first
    cmds:                    # Commands to run
      - docker compose up -d
    preconditions:           # Must be true to run
      - docker info
```

### Common Task Patterns

**Running Tasks**:
```bash
task <task-name>           # Run specific task
task --list                # Show all tasks
task help                  # Show help
```

**Task with Arguments**:
```bash
task logs -- nginx         # Pass 'nginx' as argument
task sops:edit -- app.env  # Pass file path
```

**Task Dependencies**:
```yaml
tasks:
  deploy:
    deps: [build, test]      # Run build + test first
    cmds:
      - docker compose up
```

## 🏠 Project Structure

### Root Level

```
├── Taskfile.yml          # Main automation entry point
├── .gitignore            # Git ignore patterns
├── .envrc                # direnv environment
├── .pre-commit-config.yaml  # Code quality hooks
└── README.md             # Project documentation
```

### Task Modules (.taskfiles/)

```
.taskfiles/
├── compose/          # Docker Compose operations
├── sops/             # Secrets management
├── bootstrap/        # Setup automation
├── validate/         # Health checks
└── examples/         # Demo workflows
```

Each module contains a `Taskfile.yml` with related tasks.

### Examples Directory

```
examples/
├── docker-compose.yml    # Service definitions
├── nginx.conf            # Web server config
├── prometheus.yml        # Monitoring config
├── init/                 # Database scripts
└── html/                 # Web content
```

Real, working examples you can learn from.

### Secrets Directory

```
secrets/
└── app.sops.env      # Encrypted secrets (safe to commit)

.secrets/              # (gitignored)
└── age.key           # Encryption key (NEVER commit)
```

## ✍️ Hands-On Exercise

### Exercise 1: Explore Task Automation

1. **List all available tasks**:
   ```bash
   task --list
   ```

2. **Run validation checks**:
   ```bash
   task check
   ```

3. **View task help**:
   ```bash
   task help
   ```

### Exercise 2: Understand Project Structure

1. **Explore the Taskfile**:
   ```bash
   cat Taskfile.yml
   ```
   
   Notice:
   - `includes:` - Modular task organization
   - `vars:` - Reusable variables
   - `env:` - Environment variables

2. **Check task modules**:
   ```bash
   ls -la .taskfiles/
   cat .taskfiles/compose/Taskfile.yml
   ```

3. **Explore examples**:
   ```bash
   ls -la examples/
   cat examples/docker-compose.yml
   ```

### Exercise 3: Run Your First IaC Task

1. **Check system status**:
   ```bash
   task validate:taskfile
   ```

2. **Validate Docker setup**:
   ```bash
   task validate:docker
   ```

3. **Run complete validation**:
   ```bash
   task validate:all
   ```

## 📊 Progress Check

You've completed Module 1 when you can:

- [ ] Explain what IaC is and why it matters
- [ ] List the key IaC principles
- [ ] Run Task commands confidently
- [ ] Navigate the project structure
- [ ] Understand the purpose of each directory

## ➡️ Next Steps

Ready for secrets management?

```bash
task learn:secrets
```

Or read [Module 2: Secrets Management](02-secrets-management.md)

## 📚 Additional Resources

- [Task Documentation](https://taskfile.dev)
- [Infrastructure as Code (Book)](https://www.oreilly.com/library/view/infrastructure-as-code/9781098114664/)
- [The Twelve-Factor App](https://12factor.net/)
- [GitOps Principles](https://opengitops.dev/)
