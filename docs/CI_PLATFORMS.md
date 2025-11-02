# CI Platform Guide

This template includes GitHub Actions CI configuration by default. If you're using **GitLab CI**, **Bitbucket Pipelines**, or **Azure DevOps**, this guide shows how to adapt the configuration.

> **Good news:** All quality gates use Gradle tasks, so they work identically across platforms. Only the CI syntax changes!

## Quick Reference

| Platform | Config File | Status |
|----------|-------------|--------|
| **GitHub Actions** | `.github/workflows/ci.yml` | ✅ Included (default) |
| **GitLab CI** | `.gitlab-ci.yml` | 📖 Guide below |
| **Bitbucket Pipelines** | `bitbucket-pipelines.yml` | 📖 Guide below |
| **Azure DevOps** | `azure-pipelines.yml` | 📖 Guide below |
| **Jenkins** | `Jenkinsfile` | 📖 Guide below |

---

## GitLab CI

### Setup Steps

1. **Delete GitHub-specific files:**
   ```bash
   rm -rf .github/
   ```

2. **Create `.gitlab-ci.yml` in project root:**

```yaml
# GitLab CI configuration for Java 21 TDD Template

image: gradle:8.11-jdk21

variables:
  GRADLE_OPTS: "-Dorg.gradle.daemon=false"
  GRADLE_USER_HOME: "$CI_PROJECT_DIR/.gradle"

cache:
  key: "$CI_COMMIT_REF_SLUG"
  paths:
    - .gradle/wrapper
    - .gradle/caches

stages:
  - validate
  - build
  - test
  - security

# Validate Gradle wrapper
validate:
  stage: validate
  script:
    - gradle wrapper --gradle-version 8.11

# Build and run all quality gates
build:
  stage: build
  script:
    - ./gradlew clean build --no-daemon
  artifacts:
    when: always
    paths:
      - build/reports/
      - build/test-results/
    reports:
      junit: build/test-results/test/TEST-*.xml
    expire_in: 1 week

# Code quality checks (runs in parallel with build)
checkstyle:
  stage: build
  script:
    - ./gradlew checkstyleMain checkstyleTest --no-daemon
  artifacts:
    when: on_failure
    paths:
      - build/reports/checkstyle/

spotbugs:
  stage: build
  script:
    - ./gradlew spotbugsMain spotbugsTest --no-daemon
  artifacts:
    when: on_failure
    paths:
      - build/reports/spotbugs/

# Test coverage
coverage:
  stage: test
  script:
    - ./gradlew jacocoTestReport --no-daemon
  artifacts:
    paths:
      - build/reports/jacoco/
  coverage: '/Total.*?([0-9]{1,3})%/'

# Mutation testing
pitest:
  stage: test
  script:
    - ./gradlew pitest --no-daemon
  artifacts:
    paths:
      - build/reports/pitest/

# OWASP dependency check
security:
  stage: security
  script:
    - ./gradlew dependencyCheckAnalyze --no-daemon
  artifacts:
    when: always
    paths:
      - build/reports/dependency-check-report.html
  allow_failure: false
  only:
    - main
    - merge_requests
```

### GitLab-Specific Features

**Code Coverage Visualization:**
Add to your GitLab project settings (Settings → CI/CD → General pipelines):
```
Coverage regex: Total.*?([0-9]{1,3})%
```

**Merge Request Integration:**
```yaml
build:
  only:
    - merge_requests
    - main
```

**Dependency Scanning (GitLab Ultimate):**
```yaml
include:
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/SAST.gitlab-ci.yml
```

---

## Bitbucket Pipelines

### Setup Steps

1. **Delete GitHub-specific files:**
   ```bash
   rm -rf .github/
   ```

2. **Create `bitbucket-pipelines.yml` in project root:**

```yaml
# Bitbucket Pipelines configuration for Java 21 TDD Template

image: gradle:8.11-jdk21

pipelines:
  default:
    - step:
        name: Build and Test
        caches:
          - gradle
        script:
          - ./gradlew clean build --no-daemon
        artifacts:
          - build/reports/**
          - build/test-results/**

  branches:
    main:
      - step:
          name: Build and Quality Gates
          caches:
            - gradle
          script:
            - ./gradlew clean build --no-daemon
          artifacts:
            - build/reports/**

      - step:
          name: Code Quality
          script:
            - ./gradlew checkstyleMain checkstyleTest --no-daemon
            - ./gradlew spotbugsMain spotbugsTest --no-daemon

      - step:
          name: Coverage and Mutation Testing
          script:
            - ./gradlew jacocoTestReport --no-daemon
            - ./gradlew pitest --no-daemon

      - step:
          name: Security Scan
          script:
            - ./gradlew dependencyCheckAnalyze --no-daemon
          artifacts:
            - build/reports/dependency-check-report.html

  pull-requests:
    '**':
      - step:
          name: PR Build and Test
          caches:
            - gradle
          script:
            - ./gradlew clean build --no-daemon

definitions:
  caches:
    gradle: ~/.gradle/caches
```

### Bitbucket-Specific Features

**Test Reporting:**
Bitbucket automatically detects JUnit XML in `build/test-results/`

**Code Coverage:**
Add Codecov or similar to `script`:
```yaml
- bash <(curl -s https://codecov.io/bash)
```

---

## Azure DevOps

### Setup Steps

1. **Delete GitHub-specific files:**
   ```bash
   rm -rf .github/
   ```

2. **Create `azure-pipelines.yml` in project root:**

```yaml
# Azure Pipelines configuration for Java 21 TDD Template

trigger:
  - main

pr:
  - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  GRADLE_USER_HOME: $(Pipeline.Workspace)/.gradle

steps:
- task: JavaToolInstaller@0
  inputs:
    versionSpec: '21'
    jdkArchitectureOption: 'x64'
    jdkSourceOption: 'PreInstalled'

- task: Cache@2
  inputs:
    key: 'gradle | "$(Agent.OS)" | **/build.gradle, **/gradle/wrapper/gradle-wrapper.properties'
    path: $(GRADLE_USER_HOME)
  displayName: 'Cache Gradle packages'

- script: |
    chmod +x gradlew
    ./gradlew clean build --no-daemon
  displayName: 'Build and run quality gates'

- script: ./gradlew checkstyleMain checkstyleTest --no-daemon
  displayName: 'Run Checkstyle'

- script: ./gradlew spotbugsMain spotbugsTest --no-daemon
  displayName: 'Run SpotBugs'

- script: ./gradlew jacocoTestReport --no-daemon
  displayName: 'Generate coverage report'

- script: ./gradlew pitest --no-daemon
  displayName: 'Run mutation tests'

- script: ./gradlew dependencyCheckAnalyze --no-daemon
  displayName: 'OWASP dependency check'
  condition: eq(variables['Build.SourceBranch'], 'refs/heads/main')

- task: PublishTestResults@2
  condition: succeededOrFailed()
  inputs:
    testResultsFormat: 'JUnit'
    testResultsFiles: '**/TEST-*.xml'
    searchFolder: '$(System.DefaultWorkingDirectory)/build/test-results'

- task: PublishCodeCoverageResults@1
  inputs:
    codeCoverageTool: 'JaCoCo'
    summaryFileLocation: '$(System.DefaultWorkingDirectory)/build/reports/jacoco/test/jacocoTestReport.xml'
    reportDirectory: '$(System.DefaultWorkingDirectory)/build/reports/jacoco/test/html'

- publish: build/reports
  artifact: QualityReports
  condition: always()
```

### Azure DevOps-Specific Features

**Code Coverage Widget:**
Azure DevOps shows coverage automatically from JaCoCo XML.

**Security Scanning:**
Add Microsoft Security DevOps extension for additional scanning.

---

## Jenkins

### Setup Steps

1. **Delete GitHub-specific files:**
   ```bash
   rm -rf .github/
   ```

2. **Create `Jenkinsfile` in project root:**

```groovy
// Jenkinsfile for Java 21 TDD Template

pipeline {
    agent any
    
    tools {
        jdk 'JDK 21'
    }
    
    environment {
        GRADLE_OPTS = '-Dorg.gradle.daemon=false'
    }
    
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        
        stage('Build') {
            steps {
                sh './gradlew clean build --no-daemon'
            }
        }
        
        stage('Quality Gates') {
            parallel {
                stage('Checkstyle') {
                    steps {
                        sh './gradlew checkstyleMain checkstyleTest --no-daemon'
                    }
                }
                
                stage('SpotBugs') {
                    steps {
                        sh './gradlew spotbugsMain spotbugsTest --no-daemon'
                    }
                }
                
                stage('PMD') {
                    steps {
                        sh './gradlew pmdMain pmdTest --no-daemon'
                    }
                }
            }
        }
        
        stage('Coverage') {
            steps {
                sh './gradlew jacocoTestReport --no-daemon'
            }
        }
        
        stage('Mutation Testing') {
            steps {
                sh './gradlew pitest --no-daemon'
            }
        }
        
        stage('Security Scan') {
            when {
                branch 'main'
            }
            steps {
                sh './gradlew dependencyCheckAnalyze --no-daemon'
            }
        }
    }
    
    post {
        always {
            junit '**/build/test-results/test/TEST-*.xml'
            
            publishHTML([
                reportDir: 'build/reports/tests/test',
                reportFiles: 'index.html',
                reportName: 'Test Report'
            ])
            
            publishHTML([
                reportDir: 'build/reports/jacoco/test/html',
                reportFiles: 'index.html',
                reportName: 'Coverage Report'
            ])
            
            publishHTML([
                reportDir: 'build/reports/pitest',
                reportFiles: 'index.html',
                reportName: 'Mutation Test Report'
            ])
        }
        
        success {
            echo 'Build succeeded!'
        }
        
        failure {
            echo 'Build failed!'
        }
    }
}
```

---

## Platform Comparison

| Feature | GitHub Actions | GitLab CI | Bitbucket | Azure DevOps | Jenkins |
|---------|---------------|-----------|-----------|--------------|---------|
| **Config File** | `.github/workflows/ci.yml` | `.gitlab-ci.yml` | `bitbucket-pipelines.yml` | `azure-pipelines.yml` | `Jenkinsfile` |
| **Free Tier** | 2,000 min/month | Unlimited shared | 50 min/month | 1,800 min/month | Self-hosted |
| **Test Reports** | Actions UI | Merge Request UI | Built-in | Test Plans | HTML Publisher |
| **Coverage** | 3rd party | Built-in | 3rd party | Built-in | Plugins |
| **Caching** | actions/cache | Built-in | Built-in | Built-in | Manual |
| **Parallel Jobs** | Matrix strategy | parallel keyword | parallel steps | Multiple jobs | parallel stage |

---

## Common Gradle Commands

All platforms run the same Gradle tasks:

```bash
# Full build with all quality gates
./gradlew clean build

# Individual quality checks
./gradlew checkstyleMain checkstyleTest  # Code style
./gradlew pmdMain pmdTest                # Bug patterns
./gradlew spotbugsMain spotbugsTest      # Static analysis
./gradlew test                           # Run tests
./gradlew jacocoTestReport               # Coverage report
./gradlew pitest                         # Mutation testing
./gradlew dependencyCheckAnalyze         # Security scan

# Check coverage thresholds
./gradlew jacocoTestCoverageVerification

# Architecture tests
./gradlew architectureTest
```

---

## Dependency Management

### GitHub: Dependabot
Included in `.github/dependabot.yml` (already configured)

### GitLab: Renovate Bot
Add `.gitlab/renovate.json`:
```json
{
  "extends": ["config:base"],
  "gradle": {
    "enabled": true
  }
}
```

### Bitbucket/Azure/Jenkins: Renovate Bot
Add `renovate.json` in root:
```json
{
  "extends": ["config:base"],
  "gradle": {
    "enabled": true
  }
}
```

---

## Troubleshooting

### Build Fails with "Permission Denied"
**Solution:** Make gradlew executable:
```yaml
- chmod +x gradlew
- ./gradlew build
```

### Out of Memory Errors
**Solution:** Increase Gradle memory:
```yaml
variables:
  GRADLE_OPTS: "-Xmx2048m -XX:MaxMetaspaceSize=512m"
```

### Slow Builds
**Solution:** Use Gradle daemon and build cache:
```bash
# Local development
./gradlew build --build-cache

# CI (disable daemon, but use cache)
./gradlew build --no-daemon --build-cache
```

### Cache Not Working
**Solution:** Verify cache paths for your platform:
- Gradle cache: `~/.gradle/caches` or `$GRADLE_USER_HOME/caches`
- Wrapper: `~/.gradle/wrapper`

---

## Migration Checklist

When switching from GitHub to another platform:

- [ ] Delete `.github/` directory
- [ ] Create platform-specific CI config file (see above)
- [ ] Update README badges (build status, coverage)
- [ ] Configure dependency management bot (Renovate/Dependabot)
- [ ] Set up branch protection rules
- [ ] Configure code coverage thresholds
- [ ] Enable security scanning
- [ ] Test CI pipeline with a dummy commit
- [ ] Verify all quality gates run successfully

---

## Need Help?

- **Gradle docs:** https://docs.gradle.org/current/userguide/userguide.html
- **GitLab CI:** https://docs.gitlab.com/ee/ci/
- **Bitbucket Pipelines:** https://support.atlassian.com/bitbucket-cloud/docs/get-started-with-bitbucket-pipelines/
- **Azure Pipelines:** https://docs.microsoft.com/en-us/azure/devops/pipelines/
- **Jenkins:** https://www.jenkins.io/doc/

**Questions?** Open an issue in the template repository.
