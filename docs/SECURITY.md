# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Security Vulnerability

We take security seriously. If you discover a security vulnerability, please follow these steps:

1. **Do Not** open a public issue
2. Email [maintainer@example.com] with:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

## Security Measures

This project follows these security practices:

1. Dependencies are regularly updated
2. All code changes go through review
3. CI/CD pipeline includes security checks
4. No secrets in code (use environment variables)

## Third-Party Dependencies

- Dependencies are managed through Gradle
- Regular security audits via GitHub's Dependabot
- CVE monitoring and automated updates

## Code Security

- All inputs are validated
- No sensitive data in logs
- Secure coding practices enforced by Checkstyle
- Regular dependency updates

## Local Development

- Never commit credentials or secrets
- Use environment variables for sensitive data
- Keep your development environment updated