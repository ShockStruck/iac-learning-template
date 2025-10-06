# Contributing to IaC Learning Template

Thank you for your interest in contributing to the Infrastructure as Code Learning Template! This document provides guidelines and information for contributors.

## 🎯 Project Goals

This project aims to:
- Provide a comprehensive learning environment for IaC concepts
- Demonstrate modern infrastructure patterns and best practices
- Offer hands-on experience with Docker Compose, SOPS, and Task automation
- Maintain security-first approach to infrastructure management

## 🤝 How to Contribute

### Types of Contributions

We welcome:
- 🐛 Bug reports and fixes
- 📚 Documentation improvements
- ✨ New learning examples and scenarios
- 🔧 Task automation enhancements
- 🔐 Security improvements
- 📊 Monitoring and observability features

### Getting Started

1. **Fork the repository**
   ```bash
   # Click "Fork" on GitHub, then clone your fork
   git clone https://github.com/YOUR_USERNAME/iac-learning-template.git
   cd iac-learning-template
   ```

2. **Set up development environment**
   ```bash
   # Bootstrap the environment
   task bootstrap
   
   # Verify setup
   task health
   ```

3. **Create a feature branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. **Make your changes**
   - Follow existing patterns and conventions
   - Add documentation for new features
   - Include examples where appropriate

5. **Test your changes**
   ```bash
   # Test basic functionality
   task examples:basic
   
   # Test advanced features
   task examples:advanced
   
   # Verify all examples work
   task examples:list
   ```

6. **Commit and push**
   ```bash
   git add .
   git commit -m "feat: add new learning example for X"
   git push origin feature/your-feature-name
   ```

7. **Create a Pull Request**
   - Use the GitHub interface to create a PR
   - Provide a clear description of your changes
   - Reference any related issues

---

Thank you for helping make Infrastructure as Code learning more accessible! 🚀
