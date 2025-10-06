# Module 3: Docker Compose Orchestration

## 🎯 Learning Objectives

By the end of this module, you will:

- ✅ Understand Docker Compose fundamentals
- ✅ Build multi-service architectures
- ✅ Configure service dependencies and networking
- ✅ Integrate volumes and persistent data
- ✅ Implement health checks and monitoring
- ✅ Apply production-ready patterns

## 🐳 What is Docker Compose?

Docker Compose is a tool for defining and running multi-container applications.

### Single Container vs Multi-Service

**Single Container** (docker run):
```bash
docker run -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres
```

**Multi-Service** (docker-compose.yml):
```yaml
services:
  postgres:
    image: postgres:15
    environment:
      POSTGRES_PASSWORD: ${DB_PASSWORD}
  redis:
    image: redis:7
  nginx:
    image: nginx:alpine
    depends_on:
      - postgres
```

## 🏠 Compose File Anatomy

### Basic Structure

```yaml
version: '3.8'

# Reusable configuration
x-common: &common
  restart: unless-stopped
  
networks:
  app:
    driver: bridge

volumes:
  db-data:

services:
  app:
    <<: *common
    image: myapp:latest
    ports:
      - "8080:80"
    networks:
      - app
    volumes:
      - db-data:/data
```

### Key Concepts

**Services**: Containers in your application
**Networks**: How containers communicate
**Volumes**: Persistent data storage
**Extensions** (`x-*`): Reusable YAML anchors

## 🔗 Service Configuration

### Image Selection

```yaml
services:
  # Use official image
  postgres:
    image: postgres:15-alpine  # Specific version + variant
    
  # Build from Dockerfile
  app:
    build:
      context: ./app
      dockerfile: Dockerfile
```

**Best Practices**:
- ✅ Use specific versions (`postgres:15` not `postgres:latest`)
- ✅ Prefer Alpine variants (smaller size)
- ✅ Pin to digest for production (`image@sha256:...`)

### Environment Variables

```yaml
services:
  app:
    environment:
      # Direct values
      APP_ENV: production
      
      # From host environment
      DB_PASSWORD: "${DB_PASSWORD}"
      
      # From .env file (automatically loaded)
      API_KEY: "${API_KEY}"
```

### Port Mapping

```yaml
services:
  nginx:
    ports:
      - "8080:80"       # host:container
      - "127.0.0.1:443:443"  # bind to localhost only
      
  postgres:
    expose:
      - "5432"          # Accessible to other services only
```

## 🔄 Dependencies and Startup Order

### Service Dependencies

```yaml
services:
  app:
    depends_on:
      postgres:
        condition: service_healthy  # Wait for health check
      redis:
        condition: service_started  # Wait for container start
        
  postgres:
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
      interval: 10s
      timeout: 5s
      retries: 5
```

### Startup Sequence

```yaml
# This ensures:
# 1. postgres starts
# 2. postgres becomes healthy
# 3. redis starts
# 4. app starts after both are ready

services:
  postgres:
    # Starts first
    healthcheck:
      test: ["CMD", "pg_isready"]
      
  redis:
    # Starts second
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      
  app:
    # Starts last
    depends_on:
      postgres:
        condition: service_healthy
      redis:
        condition: service_healthy
```

## 🌐 Networking

### Network Types

```yaml
networks:
  # Bridge network (default)
  frontend:
    driver: bridge
    
  # Internal network (no external access)
  backend:
    internal: true

services:
  nginx:
    networks:
      - frontend  # Internet-facing
      
  app:
    networks:
      - frontend  # Talk to nginx
      - backend   # Talk to database
      
  postgres:
    networks:
      - backend   # Isolated from internet
```

### Service Discovery

Containers can reach each other by service name:

```yaml
services:
  app:
    environment:
      DB_HOST: postgres  # Service name as hostname
      REDIS_HOST: redis
      
  postgres:
    # Accessible at 'postgres' hostname
    
  redis:
    # Accessible at 'redis' hostname
```

## 💾 Volumes and Persistence

### Named Volumes

```yaml
volumes:
  postgres-data:
  redis-data:

services:
  postgres:
    volumes:
      - postgres-data:/var/lib/postgresql/data
      
  redis:
    volumes:
      - redis-data:/data
```

### Bind Mounts

```yaml
services:
  nginx:
    volumes:
      # Read-only config
      - ./nginx.conf:/etc/nginx/nginx.conf:ro
      
      # Read-write content
      - ./html:/usr/share/nginx/html
```

## ❤️ Health Checks

### Database Health Check

```yaml
services:
  postgres:
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 10s
```

### Web Service Health Check

```yaml
services:
  nginx:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost/health"]
      interval: 30s
      timeout: 5s
      retries: 3
```

### Why Health Checks?

- ✅ Dependency management (wait for services to be ready)
- ✅ Automatic restarts (if service becomes unhealthy)
- ✅ Load balancer integration
- ✅ Monitoring and alerting

## 🔒 Security Patterns

### Non-Root Containers

```yaml
services:
  app:
    user: "1000:1000"  # Run as non-root user
    
    security_opt:
      - no-new-privileges:true  # Prevent privilege escalation
```

### Read-Only Filesystems

```yaml
services:
  app:
    read_only: true  # Immutable container
    
    tmpfs:
      - /tmp  # Writable tmpfs for temporary files
```

### Resource Limits

```yaml
services:
  app:
    deploy:
      resources:
        limits:
          cpus: '0.5'     # Max 50% of 1 CPU
          memory: 512M    # Max 512MB RAM
        reservations:
          cpus: '0.25'
          memory: 256M
```

## ✍️ Hands-On Exercises

### Exercise 1: Explore the Stack

```bash
# Start all services
task up

# View running services
task status
docker compose ps

# Check service logs
task logs -- postgres
task logs -- nginx

# Inspect networks
docker network ls
docker network inspect iac-learning_app-network

# Inspect volumes
docker volume ls
```

### Exercise 2: Service Communication

```bash
# Get shell in app container
task compose:shell -- app

# Inside container, test connectivity:
ping postgres
curl postgres:5432
ping redis
redis-cli -h redis ping

exit
```

### Exercise 3: Health Checks

```bash
# View health status
docker compose ps

# Watch health checks in real-time
watch -n 1 'docker compose ps'

# View health check logs
docker inspect iac-postgres | grep -A 10 Health
```

### Exercise 4: Scaling Services

```bash
# Scale nginx to 3 instances
docker compose up -d --scale nginx=3

# View scaled services
docker compose ps nginx

# Scale back to 1
docker compose up -d --scale nginx=1
```

### Exercise 5: Data Persistence

```bash
# Create data in database
task compose:shell -- postgres
psql -U appuser -d appdb
CREATE TABLE test (id serial, value text);
INSERT INTO test (value) VALUES ('persistent data');
\q
exit

# Stop and remove containers
task down

# Restart (data persists in volume)
task up

# Verify data still exists
task compose:shell -- postgres
psql -U appuser -d appdb
SELECT * FROM test;
\q
exit
```

## 🔍 Production Patterns

### 1. Environment-Specific Configs

```yaml
# docker-compose.yml (base)
services:
  app:
    image: myapp:latest

# docker-compose.prod.yml (overrides)
services:
  app:
    deploy:
      replicas: 3
      restart_policy:
        condition: on-failure
```

Use:
```bash
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
```

### 2. Logging Configuration

```yaml
services:
  app:
    logging:
      driver: "json-file"
      options:
        max-size: "10m"
        max-file: "3"
```

### 3. Restart Policies

```yaml
services:
  app:
    restart: unless-stopped  # Always restart except when explicitly stopped
    
  worker:
    restart: on-failure      # Only restart on failure
```

## 📊 Progress Check

You've completed Module 3 when you can:

- [ ] Create multi-service Compose files
- [ ] Configure service dependencies and health checks
- [ ] Set up networks and volumes
- [ ] Implement security best practices
- [ ] Scale services dynamically
- [ ] Troubleshoot service communication

## ➡️ Next Steps

Ready for advanced automation?

```bash
task learn:automation
```

Or read [Module 4: Automation Patterns](04-automation-patterns.md)

## 📚 Additional Resources

- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Compose File Specification](https://docs.docker.com/compose/compose-file/)
- [Best Practices Guide](https://docs.docker.com/develop/dev-best-practices/)
- [Production Deployment](https://docs.docker.com/compose/production/)
