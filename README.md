
# Java 21 TDD Project Template

[![Build Status](https://github.com/{username}/{repo}/actions/workflows/ci.yml/badge.svg)](https://github.com/{username}/{repo}/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/{username}/{repo}/branch/master/graph/badge.svg)](https://codecov.io/gh/{username}/{repo})
[![Mutation Coverage](https://img.shields.io/badge/mutation%20coverage-100%25-brightgreen)](https://github.com/{username}/{repo})
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A production-ready Java 21 LTS project template designed for **Test-Driven Development (TDD)** with AI-assisted coding. Features 9 automated quality gates, mutation testing, and comprehensive documentation for human-AI collaboration.

## 🎯 Who This Template Is For

- **Solo developers** using AI assistants (GitHub Copilot, ChatGPT, Claude, etc.) for TDD workflows
- **Teams** practicing TDD where developers write tests and AI generates implementation code
- **Projects** requiring strong quality gates and mutation testing (80%+ coverage)
- **Anyone** wanting a modern Java 21 starter with best practices pre-configured

## 🚀 Quick Start (30 seconds)

```powershell
# 1. Clone this template
git clone https://github.com/{username}/{repo}.git my-project
cd my-project

# 2. Customize for your project (optional but recommended)
.\customize-template.ps1 -ProjectName "my-project" -PackageName "com.mycompany.app"

# 3. Verify Java 21 is installed
java -version  # Should show Java 21

# 4. Run the build (all tests pass, 100% mutation coverage)
.\gradlew.bat clean build

# 5. Start coding with TDD!
# - Write your test first in src/test/java/
# - Let AI implement code in src/main/java/
# - Run build to verify quality gates pass
```

**📚 First-time setup? See [SETUP.md](SETUP.md) for detailed instructions.**

## Prerequisites

- **Java**: JDK 21 LTS installed
- **Gradle**: Included via Gradle wrapper (no separate install needed)
- **AI Assistant** (optional but recommended): GitHub Copilot, ChatGPT, Claude, or similar

### IDE Setup

#### VS Code (Recommended for AI-Assisted Development)

This template is optimized for VS Code + AI assistants:

1. **Install Required Extensions:**
   - [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
   - [Lombok Annotations Support](https://marketplace.visualstudio.com/items?itemName=GabrielBB.vscode-lombok)
   - [GitHub Copilot](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot) (optional)

2. **Verify JDK Configuration:**
   - Workspace settings (`.vscode/settings.json`) pre-configured for JDK 21
   - Update JDK path if your installation differs from `C:\Program Files\Java\jdk-21`

3. **First-Time Setup:**
   - Open project folder in VS Code
   - Wait for "Importing Java projects..." to complete
   - If errors appear: `Ctrl+Shift+P` → "Java: Clean Java Language Server Workspace"

#### Other IDEs (IntelliJ IDEA, Eclipse)

- Import as Gradle project
- Configure JDK 21 as project SDK
- Enable Lombok annotation processing
- All quality gates work the same regardless of IDE

## Quick Start

```powershell
# 1. Verify Java installation
java -version  # Should show Java 21

# 2. Build and test (includes mutation testing)
.\gradlew.bat clean build

# 3. View reports
# - Code coverage: build/reports/jacoco/test/html/index.html
# - Mutation testing: build/reports/pitest/index.html
# - Checkstyle: build/reports/checkstyle/
# - SpotBugs: build/reports/spotbugs/
```

## Features

- **Java 21 LTS**: Long-term support version with modern language features
- **Gradle 8.11**: Build automation with Gradle Wrapper
- **Mutation Testing (Pitest 1.15.0)**: Enforced on every build with 80% mutation coverage threshold
- **Error Prone 2.36.0**: Google's compile-time static analysis that catches common Java mistakes
- **ArchUnit 1.3.0**: Architecture testing to enforce structural rules and design patterns
- **PMD 7.7.0**: Static analysis for unused code, complexity, and security issues
- **SpotBugs 6.0.26**: Static analysis for bug detection
- **Checkstyle 10.20.2**: Code style enforcement (custom rules per project standards)
- **JaCoCo**: Code coverage reporting with 80% threshold
- **OWASP Dependency-Check**: Security vulnerability scanning (CVSS ≥7 fails build)
- **JUnit 5 + AssertJ + Mockito**: Complete testing stack
- **Lombok 1.18.36**: Reduces boilerplate with annotations (@Data, @Builder, etc.)
- **SLF4J 2.0.16 + Logback 1.5.12**: Structured logging framework
- **EditorConfig**: Consistent formatting across IDEs
- **GitHub Actions**: CI/CD with CodeQL scanning and Dependabot

> **Using GitLab, Bitbucket, or Azure DevOps?** See the [CI Platform Guide](docs/CI_PLATFORMS.md) for adapting the CI configuration to your platform.

### Why Mutation Testing?

This template uses **mutation testing** as the primary quality gate instead of naive line coverage. Here's why:

**Traditional Coverage (Weak):**
```java
// 100% line coverage but useless test
@Test
void testAdd() {
    calculator.add(2, 2);  // Never checks result!
}
```

**Mutation Testing (Strong):**
- Changes `+` to `-`, `*`, `/` in your code
- If tests still pass, the mutation "survived" (bad - test didn't catch the bug)
- If tests fail, the mutation was "killed" (good - test caught the bug)
- 80% threshold means 80% of code changes break tests (strong quality signal)

**Result**: Tests must actually verify behavior, not just execute code.

## 🎓 TDD Workflow (Human + AI)

This template is designed for Test-Driven Development with AI assistance:

### The Cycle

```
1. HUMAN: Write failing test (describe behavior)
   - Create test in src/test/java/
   - Use AssertJ fluent assertions
   - Run: ./gradlew test (should fail)
         ↓
2. AI: Implement minimal code to pass test
   - Add/modify code in src/main/java/
   - Make test pass with simplest solution
   - Run: ./gradlew build (all quality gates)
         ↓
3. HUMAN: Review and guide refactoring
   - Check mutation coverage (80%+ required)
   - Request improvements if needed
   - Approve or iterate
```

### Example Session

**Human:** "I need a method to capitalize the first letter of a string"

**Human writes test:**
```java
@Test
@DisplayName("should capitalize first letter")
void shouldCapitalizeFirstLetter() {
    assertThat(StringUtils.capitalize("hello"))
        .isEqualTo("Hello");
}
```

**AI implements:**
```java
public static String capitalize(final String str) {
    if (str == null || str.isEmpty()) {
        return str;
    }
    return str.substring(0, 1).toUpperCase(Locale.ROOT) 
         + str.substring(1);
}
```

**Build runs:** All quality gates pass, including mutation testing ✅

### Key Rules

- ✅ **Human writes tests** - They define what "correct" means
- ✅ **AI writes implementation** - Minimal code to satisfy tests
- ✅ **AI suggests refactoring** - But waits for human approval
- ❌ **AI doesn't modify tests** - Unless explicitly requested
- ❌ **AI doesn't add untested code** - Every line must have test coverage

**See [docs/AI_AGENT_CODING_STANDARDS.md](docs/AI_AGENT_CODING_STANDARDS.md) for complete guidelines.**

## Project Structure

```
├── src/
│   ├── main/
│   │   ├── java/com/example/app/     # Production code
│   │   └── resources/                # Configuration files
│   ├── test/
│   │   ├── java/com/example/app/     # Unit tests (business logic)
│   │   └── resources/                # Test configuration
│   └── architecture-test/
│       └── java/com/example/app/     # Architecture tests (ArchUnit)
├── config/
│   ├── checkstyle/                   # Code style rules
│   ├── pmd/                          # PMD ruleset
│   ├── spotbugs/                     # Bug detection exclusions
│   └── owasp/                        # Security scan suppressions
├── .github/
│   ├── workflows/                    # CI/CD pipelines
│   └── dependabot.yml                # Dependency updates
├── docs/                             # Architecture documentation
├── .editorconfig                     # Cross-IDE formatting
├── build.gradle                      # Build configuration
├── gradle.properties                 # Gradle settings (JDK path)
└── gradlew / gradlew.bat             # Gradle wrapper scripts
```

**Note**: Architecture tests are in a separate source set (`architecture-test`) to keep infrastructure/quality tests isolated from business logic tests.

## Development

### Available Commands

```bash
# Build and run all quality checks (includes mutation testing)
./gradlew build

# Run unit tests only (business logic tests)
./gradlew test

# Run architecture tests only (ArchUnit structural validation)
./gradlew architectureTest

# Run all tests (unit + architecture)
./gradlew test architectureTest

# Generate code coverage report
./gradlew jacocoTestReport

# Run mutation testing (included in 'build')
./gradlew pitest

# Run static analysis
./gradlew checkstyleMain checkstyleTest
./gradlew spotbugsMain spotbugsTest
./gradlew pmdMain pmdTest

# Run security vulnerability scan
./gradlew dependencyCheckAnalyze

# Validate no GPL/AGPL dependencies (included in 'build')
./gradlew checkLicenses

# Generate Javadoc
./gradlew javadoc
```

### Quality Gates

The build enforces the following quality standards:

1. **Mutation Coverage ≥ 80%**: Tests must kill at least 80% of code mutations (currently achieving 100%)
2. **JaCoCo Coverage ≥ 80%**: Line coverage threshold enforced (currently at 80.7%)
3. **Error Prone**: Compile-time static analysis catches common Java mistakes (e.g., self-assertion, missing locale)
4. **ArchUnit**: Architecture rules prevent structural violations (exception naming, utility classes, no cyclic dependencies)
5. **PMD**: Zero violations for unused code, complexity >15, security issues
6. **Checkstyle**: Zero violations of style rules
7. **SpotBugs**: No high-priority bugs detected
8. **OWASP**: No vulnerabilities with CVSS ≥ 7
9. **License Check**: No GPL/AGPL dependencies allowed

**Note**: Mutation testing (Pitest) runs automatically during `./gradlew build`. This verifies that tests actually detect bugs when code is mutated, providing a stronger quality guarantee than naive line coverage.

### Reports Location

- Code coverage: `build/reports/jacoco/test/html/index.html`
- Mutation testing: `build/reports/pitest/index.html`
- ArchUnit: See test results (architecture violations fail tests)
- PMD: `build/reports/pmd/`
- Checkstyle: `build/reports/checkstyle/`
- SpotBugs: `build/reports/spotbugs/`

## 📝 Writing Tests (For Humans)

### Test Framework Cheat Sheet

```java
// JUnit 5 - Test structure
@Test
@DisplayName("should return sum of two numbers")
void shouldReturnSumOfTwoNumbers() {
    // Arrange
    Calculator calc = new Calculator();
    
    // Act
    int result = calc.add(2, 3);
    
    // Assert (use AssertJ fluent style)
    assertThat(result).isEqualTo(5);
}

// AssertJ - Common assertions
assertThat(actual).isEqualTo(expected);
assertThat(actual).isNotNull();
assertThat(list).hasSize(3).contains("item");
assertThat(actual).isInstanceOf(String.class);

// Mockito - Mocking dependencies
@Mock
private UserRepository repository;

@Test
void shouldFindUser() {
    when(repository.findById(1L)).thenReturn(Optional.of(user));
    // ... test code
    verify(repository).findById(1L);
}
```

### Test Naming Conventions

Use `should` + `verb` + `context`:
- ✅ `shouldReturnTrueWhenInputIsValid()`
- ✅ `shouldThrowExceptionWhenInputIsNull()`
- ❌ `testAdd()` (too vague)
- ❌ `test1()` (meaningless)

### Tips for Strong Tests

1. **Test one behavior per test** - Makes failures easy to diagnose
2. **Use descriptive names** - `@DisplayName("should ...")` tells the story
3. **Arrange-Act-Assert** - Clear structure helps readability
4. **Test edge cases** - null, empty, negative, boundary values
5. **Verify exceptions** - `assertThatThrownBy(() -> ...).isInstanceOf(...)`

**Remember**: Your tests define what "correct" means. The AI implements code to satisfy them.

---

## 🤖 For AI Agents

**If you're an AI assistant helping with this codebase**, read the strict coding standards here:

👉 **[docs/AI_AGENT_CODING_STANDARDS.md](docs/AI_AGENT_CODING_STANDARDS.md)**

This document contains:
- ✅ Quick reference checklist (verify before every commit)
- ✅ Decision trees for common scenarios (add feature, fix bug, refactor)
- ✅ Code style rules with correct/wrong examples
- ✅ TDD workflow protocol (when to ask for tests, when to implement)
- ✅ Quality gate commands and failure handling
- ✅ Commit message format and escalation triggers

**Key rules:**
- User writes tests first → You implement minimal code to pass tests
- Never modify tests without permission
- Run `.\gradlew clean build` before every commit
- Use `final`, immutable collections, AssertJ assertions
- Escalate if changes > 100 lines or unclear requirements

---

## Configuration

### JDK Setup

Edit `gradle.properties` to set your JDK 21 installation:

```properties
org.gradle.java.home=C:/Program Files/Java/jdk-21
```

Or rely on Gradle's auto-download feature (requires internet connection):

```properties
org.gradle.java.installations.auto-download=true
```

### Customizing Quality Rules

**Before you start coding**, review and adjust these rules for your project:

- **ArchUnit**: Edit `src/architecture-test/java/com/example/app/ArchitectureTest.java`
  - Add layering rules as project grows (controller → service → repository)
  - Enforce package naming conventions
  
- **PMD**: Edit `config/pmd/ruleset.xml`
  - Currently focuses on critical issues only (unused code, complexity >15, security)
  - Add/remove rules based on team preferences
  
- **Checkstyle**: Edit `config/checkstyle/checkstyle.xml`
  - Customize code style (indentation, naming, etc.)
  - Default is Sun Java conventions with modifications
  
- **SpotBugs**: Edit `config/spotbugs/spotbugs-exclude.xml`
  - Add patterns to exclude false positives
  
- **OWASP**: Edit `config/owasp/suppressions.xml`
  - Suppress known false positive vulnerabilities
  
- **Mutation Testing**: Edit `pitest` block in `build.gradle`
  - Adjust mutation threshold (currently 80%)
  - Modify excluded methods if needed
  
- **JaCoCo Coverage**: Edit `jacocoMinimumCoverage` in `build.gradle`
  - Currently 0.8 (80% line coverage)
  - Can increase/decrease based on project needs

## Dependency Management

### Adding Dependencies

⚠️ **License Awareness**: When adding new runtime dependencies (`implementation` scope), be mindful of their licenses:

- **✅ Safe for any use**: Apache 2.0, MIT, BSD (permissive licenses)
- **⚠️ Requires review**: LGPL (may require dynamic linking), GPL (requires derivative works to be GPL)
- **❌ Avoid**: AGPL for server applications, proprietary licenses without permission

**Current Status**: This template has **zero runtime dependencies**, so you can license your project however you want. See [docs/DEPENDENCIES.md](docs/DEPENDENCIES.md) for detailed guidance.

**🛡️ Automatic Protection**: The build includes a `checkLicenses` task that automatically fails if GPL/AGPL dependencies are detected, protecting you from accidentally including restrictive licenses.

```bash
# Verify what dependencies will be bundled in your application:
./gradlew dependencies --configuration runtimeClasspath

# Check for restricted licenses (runs automatically during build):
./gradlew checkLicenses
```

### Dependency Security

- OWASP Dependency-Check runs automatically during `./gradlew build`
- Vulnerabilities with CVSS ≥ 7 will fail the build
- Dependabot automatically creates PRs for dependency updates
- Review `config/owasp/suppressions.xml` for false positive suppressions

## Additional Resources

📚 **[Full Documentation Index](docs/README.md)** - Complete guide to all documentation

### Essential Guides
- **[docs/DEPENDENCIES.md](docs/DEPENDENCIES.md)** - License guidance and dependency management
- **[docs/CONTRIBUTING.md](docs/CONTRIBUTING.md)** - How to contribute to this project
- **[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md)** - System design and architecture principles
- **[docs/SECURITY.md](docs/SECURITY.md)** - Security policy and vulnerability reporting
- **[docs/AI_AGENT_CODING_STANDARDS.md](docs/AI_AGENT_CODING_STANDARDS.md)** - AI-assisted development guidelines
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** - Community guidelines and expectations

### Quick Links
- 🚀 [SETUP.md](SETUP.md) - First-time setup
- 📋 [docs/CHANGELOG.md](docs/CHANGELOG.md) - Version history
- 🎯 [docs/TEMPLATE_ENHANCEMENTS.md](docs/TEMPLATE_ENHANCEMENTS.md) - Template features

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
