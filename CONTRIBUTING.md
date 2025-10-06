# Contributing to IaC Learning Template

Thank you for your interest in contributing! This guide will help you get started.

## 🎯 Ways to Contribute

- 🐛 Report bugs and issues
- 💡 Suggest new features or improvements
- 📝 Improve documentation
- ✅ Add new examples or exercises
- 🔧 Fix bugs and submit pull requests

## 🛠️ Development Setup

1. **Fork and clone the repository**:
   ```bash
   git clone https://github.com/YOUR_USERNAME/iac-learning-template.git
   cd iac-learning-template
   ```

2. **Bootstrap the development environment**:
   ```bash
   task bootstrap:dev
   ```

3. **Verify everything works**:
   ```bash
   task check
   task up
   ```

## 📝 Pull Request Process

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**:
   - Follow existing code style
   - Add tests if applicable
   - Update documentation

3. **Commit with conventional commits**:
   ```bash
   git commit -m "feat: add new learning module"
   git commit -m "fix: correct SOPS configuration"
   git commit -m "docs: update README with examples"
   ```

4. **Push and create PR**:
   ```bash
   git push origin feature/your-feature-name
   ```

## ✅ Code Quality

Before submitting:

```bash
# Run all checks
task check

# Run pre-commit hooks
pre-commit run --all-files

# Validate Taskfiles
task validate:taskfile

# Test services
task up
task validate:health
```

## 📚 Documentation Guidelines

- Use clear, simple language
- Include practical examples
- Add hands-on exercises
- Follow existing structure
- Test all commands

## 🐛 Reporting Issues

When reporting issues, include:

- **Description**: Clear description of the problem
- **Steps to reproduce**: Exact steps to trigger the issue
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happens
- **Environment**: OS, Docker version, Task version
- **Logs**: Relevant error messages

## ❓ Questions

Have questions? Open an [issue](https://github.com/ShockStruck/iac-learning-template/issues) with the `question` label.

## 📑 License

By contributing, you agree your contributions will be licensed under the MIT License.
