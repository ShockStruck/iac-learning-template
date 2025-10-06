# Module 4: Advanced Automation Patterns

## 🎯 Learning Objectives

By the end of this module, you will:

- ✅ Master advanced Task automation techniques
- ✅ Build reusable automation workflows
- ✅ Integrate CI/CD pipelines
- ✅ Implement deployment automation
- ✅ Create production-ready operational procedures

## 🔧 Advanced Task Patterns

### Task Dependencies and DAGs

```yaml
tasks:
  # Parallel execution
  build-all:
    deps:
      - build:frontend
      - build:backend
      # Both run in parallel
      
  # Sequential execution
  deploy:
    cmds:
      - task: validate
      - task: build
      - task: push
      # Run one after another
      
  # Mixed patterns
  release:
    deps: [test, lint]  # Parallel
    cmds:
      - task: build     # Then sequential
      - task: deploy
```

### Dynamic Task Generation

```yaml
tasks:
  # For each service
  build-services:
    vars:
      SERVICES:
        sh: ls services/
    cmds:
      - for:
          var: SERVICES
        cmd: docker build -t {{.ITEM}} services/{{.ITEM}}
```

### Conditional Execution

```yaml
tasks:
  deploy:
    # Only run if tests pass
    preconditions:
      - sh: task test
        msg: "Tests must pass before deployment"
        
    # Skip if already deployed
    status:
      - test -f .deployed
      
    cmds:
      - docker compose up -d
      - touch .deployed
```

## 🔄 CI/CD Integration

### GitHub Actions

```yaml
# .github/workflows/ci.yml
name: CI

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Install Task
        uses: arduino/setup-task@v1
        
      - name: Run tests
        run: task ci:test
        
      - name: Build
        run: task ci:build
        
      - name: Deploy
        if: github.ref == 'refs/heads/main'
        run: task ci:deploy
        env:
          SOPS_AGE_KEY: ${{ secrets.AGE_KEY }}
```

### Taskfile for CI

```yaml
# Taskfile.yml
tasks:
  ci:test:
    desc: "Run tests in CI environment"
    cmds:
      - docker compose -f docker-compose.test.yml up --abort-on-container-exit
      
  ci:build:
    desc: "Build for production"
    cmds:
      - docker compose build --pull
      
  ci:deploy:
    desc: "Deploy to production"
    preconditions:
      - sh: test -n "$SOPS_AGE_KEY"
        msg: "SOPS_AGE_KEY must be set"
    cmds:
      - task: sops:decrypt
      - task: compose:up:prod
```

## 🚀 Deployment Automation

### Zero-Downtime Deployment

```yaml
tasks:
  deploy:zero-downtime:
    desc: "Blue-Green deployment"
    cmds:
      # Start new version (green)
      - docker compose -f docker-compose.green.yml up -d
      
      # Health check
      - task: health:wait
        vars:
          SERVICE: green
          
      # Switch traffic
      - task: lb:switch
        vars:
          TO: green
          
      # Stop old version (blue)
      - docker compose -f docker-compose.blue.yml down
      
      # Rename for next deployment
      - mv docker-compose.green.yml docker-compose.blue.yml
```

### Rollback Procedure

```yaml
tasks:
  deploy:rollback:
    desc: "Rollback to previous version"
    cmds:
      # Get previous image tag
      - task: docker:get-previous-tag
      
      # Update compose file
      - task: compose:set-image
        vars:
          TAG: "{{.PREVIOUS_TAG}}"
          
      # Deploy old version
      - docker compose up -d
      
      # Verify health
      - task: health:check
```

### Database Migrations

```yaml
tasks:
  db:migrate:
    desc: "Run database migrations"
    preconditions:
      - sh: docker compose ps postgres | grep -q healthy
        msg: "Database must be healthy"
    cmds:
      # Backup first
      - task: db:backup
      
      # Run migrations
      - docker compose exec postgres psql -U appuser -d appdb -f /migrations/{{.MIGRATION}}.sql
      
      # Verify
      - task: db:verify
      
  db:backup:
    desc: "Backup database"
    cmds:
      - mkdir -p backups
      - docker compose exec postgres pg_dump -U appuser appdb > backups/$(date +%Y%m%d-%H%M%S).sql
      - echo "Backup created in backups/"
```

## 📊 Monitoring and Observability

### Health Check Automation

```yaml
tasks:
  monitor:health:
    desc: "Continuous health monitoring"
    cmds:
      - |
        while true; do
          clear
          echo "=== Service Health Status ==="
          date
          echo ""
          
          for service in nginx postgres redis prometheus; do
            if docker compose ps $service | grep -q healthy; then
              echo "✅ $service: healthy"
            else
              echo "❌ $service: unhealthy"
            fi
          done
          
          sleep 5
        done
```

### Log Aggregation

```yaml
tasks:
  logs:aggregate:
    desc: "Aggregate logs from all services"
    cmds:
      - |
        mkdir -p logs/$(date +%Y%m%d)
        
        for service in nginx app postgres; do
          docker compose logs --no-color $service > \
            logs/$(date +%Y%m%d)/$service-$(date +%H%M%S).log
        done
        
        echo "Logs saved to logs/$(date +%Y%m%d)/"
```

### Metrics Collection

```yaml
tasks:
  metrics:collect:
    desc: "Collect system metrics"
    cmds:
      - |
        echo "=== System Metrics ==="
        
        # Docker stats
        docker stats --no-stream
        
        # Disk usage
        echo ""
        echo "Volume usage:"
        docker system df -v
        
        # Network traffic
        echo ""
        echo "Network connections:"
        docker network inspect iac-learning_app-network \
          --format '{{range .Containers}}{{.Name}}: {{.IPv4Address}}{{println}}{{end}}'
```

## 🔒 Security Automation

### Secrets Rotation

```yaml
tasks:
  security:rotate-secrets:
    desc: "Rotate all secrets"
    cmds:
      # Generate new secrets
      - task: secrets:generate
      
      # Update SOPS file
      - task: sops:edit
      
      # Rolling restart services
      - task: deploy:rolling-restart
      
      # Verify
      - task: validate:secrets
```

### Vulnerability Scanning

```yaml
tasks:
  security:scan:
    desc: "Scan for vulnerabilities"
    cmds:
      # Scan images
      - docker scout cves --only-package-type os
      
      # Scan dependencies
      - task: security:scan-dependencies
      
      # Check secrets
      - task: security:check-secrets
      
      # Generate report
      - task: security:report
```

## ✍️ Hands-On Exercises

### Exercise 1: Build a Deployment Pipeline

Create `deploy-pipeline.yml`:

```yaml
tasks:
  pipeline:
    desc: "Full deployment pipeline"
    cmds:
      - task: validate
      - task: test
      - task: build
      - task: security:scan
      - task: deploy:staging
      - task: smoke:test
      - task: deploy:production
      
  validate:
    desc: "Validation checks"
    cmds:
      - task: validate:taskfile
      - task: validate:compose
      - task: validate:sops
      
  smoke:test:
    desc: "Smoke tests after deployment"
    cmds:
      - curl -f http://staging.example.com/health
      - task: db:verify
```

Run it:
```bash
task pipeline
```

### Exercise 2: Automated Backup System

Create automated backups:

```yaml
tasks:
  backup:auto:
    desc: "Automated backup system"
    cmds:
      # Database backup
      - task: db:backup
      
      # Volume backup
      - task: volumes:backup
      
      # Config backup
      - task: config:backup
      
      # Upload to cloud
      - task: backup:upload
      
      # Cleanup old backups
      - task: backup:cleanup
        vars:
          KEEP_DAYS: 30
```

### Exercise 3: Monitoring Dashboard

Create real-time monitoring:

```yaml
tasks:
  dashboard:
    desc: "Live monitoring dashboard"
    cmds:
      - |
        while true; do
          clear
          echo "=== Infrastructure Dashboard ==="
          date
          echo ""
          
          # Services
          echo "Services:"
          task status --silent | grep -E '(postgres|nginx|redis)'
          
          # Resources
          echo ""
          echo "Resources:"
          docker stats --no-stream --format \
            "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}"
          
          # Health
          echo ""
          echo "Health Checks:"
          task validate:health --silent
          
          sleep 5
        done
```

## 📊 Production Checklist

Before deploying to production:

### Infrastructure
- [ ] Resource limits configured
- [ ] Health checks implemented
- [ ] Restart policies set
- [ ] Volumes backed up regularly
- [ ] Networks properly segmented

### Security
- [ ] All secrets encrypted with SOPS
- [ ] No plaintext credentials
- [ ] Non-root containers
- [ ] Regular security scans
- [ ] Secrets rotation procedure

### Monitoring
- [ ] Prometheus metrics configured
- [ ] Grafana dashboards created
- [ ] Alerting rules defined
- [ ] Log aggregation setup
- [ ] Health check endpoints

### Operations
- [ ] Deployment automation tested
- [ ] Rollback procedure documented
- [ ] Backup/restore verified
- [ ] Runbook created
- [ ] Team training completed

## 📚 Progress Check

You've completed Module 4 when you can:

- [ ] Build complex automation workflows
- [ ] Implement CI/CD pipelines
- [ ] Create deployment automation
- [ ] Set up monitoring and alerting
- [ ] Follow production best practices
- [ ] Handle operational procedures confidently

## 🎉 Congratulations!

You've completed all 4 modules of the IaC Learning Template!

You now have the skills to:
- ✅ Build infrastructure as code
- ✅ Manage secrets securely
- ✅ Orchestrate multi-service applications
- ✅ Automate operations effectively

## ➡️ Next Steps

### Practice Projects
1. Build a complete web application stack
2. Implement a CI/CD pipeline for your project
3. Set up production monitoring
4. Create disaster recovery procedures

### Advanced Topics
- Kubernetes orchestration
- Terraform infrastructure
- Ansible configuration management
- Service mesh (Istio, Linkerd)

## 📚 Additional Resources

- [12-Factor App](https://12factor.net/)
- [Site Reliability Engineering](https://sre.google/books/)
- [DevOps Handbook](https://itrevolution.com/product/the-devops-handbook/)
- [Kubernetes Patterns](https://www.oreilly.com/library/view/kubernetes-patterns/9781492050278/)
