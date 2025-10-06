# Module 2: Secrets Management with SOPS

## 🎯 Learning Objectives

By the end of this module, you will:

- ✅ Understand why secrets management is critical
- ✅ Master SOPS encryption with Age keys
- ✅ Safely store and version encrypted secrets
- ✅ Integrate secrets with Docker Compose
- ✅ Follow security best practices

## 🔐 Why Secrets Management?

### The Problem

**Never do this**:
```bash
# BAD - Plaintext secrets in git
DB_PASSWORD=super_secret_123
API_KEY=sk_live_abc123
```

Once committed to Git, secrets are:
- ❌ Visible to anyone with repo access
- ❌ Permanently in Git history
- ❌ Leaked if repo becomes public
- ❌ Hard to rotate securely

### The Solution: SOPS + Age

**SOPS** (Secrets OPerationS) encrypts files using:
- **Age**: Modern, secure encryption
- **Git-friendly**: Encrypted files safe to commit
- **Selective**: Encrypt only sensitive fields
- **Auditable**: Track changes in version control

## 🔑 Age Encryption

### What is Age?

Age is a modern encryption tool:

```bash
# Generate a key pair
age-keygen -o .secrets/age.key

# Public key: age1abc... (share this)
# Private key: AGE-SECRET-KEY-1xyz... (KEEP SECRET)
```

### Key Management

**Your private key** (`.secrets/age.key`):
- 🚫 **NEVER commit to Git**
- 🔒 Store in password manager
- 💾 Backup securely
- 🔄 Rotate periodically

**Public key** (in `.sops.yaml`):
- ✅ Safe to commit
- ✅ Used for encryption only
- ✅ Share with team members

## 📦 SOPS Configuration

### .sops.yaml

```yaml
creation_rules:
  - path_regex: .*\.sops\.(yaml|yml|json|env)$
    age: age1abc123...  # Your public key
```

This tells SOPS:
- Encrypt files matching `*.sops.*`
- Use the specified Age public key

### File Naming Convention

```
app.sops.env       # Encrypted (✅ commit)
app.env            # Plaintext (❌ DON'T commit)
database.sops.yml  # Encrypted (✅ commit)
database.yml       # Plaintext (❌ DON'T commit)
```

The `.sops.` in the filename triggers encryption.

## 📝 Working with Encrypted Secrets

### Creating Encrypted Secrets

```bash
# Initialize SOPS (creates age.key and .sops.yaml)
task sops:init

# View what was created
task sops:tutorial
```

### Editing Secrets

```bash
# Edit encrypted file (decrypts temporarily)
task sops:edit

# Or specify a file
task sops:edit -- secrets/app.sops.env
```

SOPS will:
1. Decrypt the file
2. Open in your `$EDITOR`
3. Re-encrypt when you save and quit

### Viewing Secrets

```bash
# View decrypted contents
task sops:view

# Or specify a file
task sops:view -- secrets/app.sops.env
```

### Checking Encryption Status

```bash
# See which files are encrypted
task sops:status

# Run comprehensive health check
task sops:health
```

## 🐳 Docker Compose Integration

### How It Works

```yaml
# examples/docker-compose.yml
services:
  postgres:
    environment:
      POSTGRES_PASSWORD: "${DB_PASSWORD}"  # From secrets
```

```bash
# Task decrypts and injects secrets
task up
```

The process:
1. SOPS decrypts `secrets/app.sops.env`
2. Variables exported to environment
3. Docker Compose substitutes `${VAR}` with values
4. Containers start with secrets (not stored in images)

### Example Secrets File

```bash
# secrets/app.sops.env (encrypted)
DB_HOST=postgres
DB_PORT=5432
DB_NAME=appdb
DB_USER=appuser
DB_PASSWORD=sops[ENC,AES256_GCM,data...]
```

After decryption:
```bash
DB_PASSWORD=super_secure_password_123
```

## 🔒 Security Best Practices

### DO ✅

1. **Use SOPS for all secrets**
   ```bash
   # Good
   echo "API_KEY=secret" | sops -e --input-type dotenv --output-type dotenv /dev/stdin > api.sops.env
   ```

2. **Keep private keys secure**
   ```bash
   chmod 600 .secrets/age.key  # Owner read/write only
   ```

3. **Version control encrypted files**
   ```bash
   git add secrets/*.sops.env  # Safe
   ```

4. **Rotate keys periodically**
   ```bash
   task sops:rotate
   ```

### DON'T ❌

1. **Never commit plaintext secrets**
   ```bash
   # Bad
   git add secrets/app.env  # NO!
   ```

2. **Never commit private keys**
   ```bash
   # Bad
   git add .secrets/age.key  # NO!
   ```

3. **Never share keys insecurely**
   ```bash
   # Bad
   slack send age.key  # NO!
   email age.key       # NO!
   ```

4. **Never hardcode secrets**
   ```python
   # Bad
   password = "secret123"  # NO!
   ```

## ✍️ Hands-On Exercises

### Exercise 1: Initialize SOPS

```bash
# Create encryption key and config
task sops:init

# Verify setup
task sops:status

# View your public key
age-keygen -y .secrets/age.key
```

### Exercise 2: Work with Secrets

1. **View existing secrets**:
   ```bash
   # See encrypted version
   cat secrets/app.sops.env
   
   # See decrypted version
   task sops:view
   ```

2. **Edit secrets safely**:
   ```bash
   task sops:edit
   # Add: NEW_SECRET=my_value
   # Save and quit
   ```

3. **Verify encryption**:
   ```bash
   # Check file is encrypted
   grep "sops" secrets/app.sops.env
   
   # Verify you can decrypt
   task sops:view
   ```

### Exercise 3: Use Secrets in Compose

1. **Start services with secrets**:
   ```bash
   task up
   ```

2. **Verify secret injection**:
   ```bash
   # Check PostgreSQL received password
   docker compose exec postgres env | grep POSTGRES_PASSWORD
   ```

3. **View container environment**:
   ```bash
   task compose:shell -- postgres
   # Inside container:
   env | grep DB_
   exit
   ```

### Exercise 4: Secret Rotation

1. **Edit a secret value**:
   ```bash
   task sops:edit
   # Change DB_PASSWORD to new value
   ```

2. **Restart services**:
   ```bash
   task down
   task up
   ```

3. **Verify new secret**:
   ```bash
   task compose:logs -- postgres
   # Should show successful connection with new password
   ```

## 🔍 Common Issues

### "Failed to decrypt" Error

**Cause**: Wrong age key or missing key

**Fix**:
```bash
# Verify age key exists
ls -la .secrets/age.key

# Check public key in .sops.yaml matches
age-keygen -y .secrets/age.key
cat .sops.yaml
```

### "sops: command not found"

**Cause**: SOPS not installed

**Fix**:
```bash
brew install sops
```

### Accidental Plaintext Commit

**Fix** (before pushing):
```bash
# Remove from staging
git reset HEAD secrets/app.env

# Delete plaintext file
rm secrets/app.env

# Use encrypted version only
git add secrets/app.sops.env
```

## 📊 Progress Check

You've completed Module 2 when you can:

- [ ] Generate and manage Age encryption keys
- [ ] Create and edit SOPS-encrypted files
- [ ] Integrate encrypted secrets with Docker Compose
- [ ] Follow security best practices
- [ ] Troubleshoot common SOPS issues

## ➡️ Next Steps

Ready for Docker Compose orchestration?

```bash
task learn:compose
```

Or read [Module 3: Docker Compose](03-docker-compose.md)

## 📚 Additional Resources

- [SOPS Documentation](https://github.com/mozilla/sops)
- [Age Encryption](https://age-encryption.org/)
- [Secrets Management Best Practices](https://cloud.google.com/secret-manager/docs/best-practices)
- [OWASP Secrets Management](https://cheatsheetseries.owasp.org/cheatsheets/Secrets_Management_Cheat_Sheet.html)
