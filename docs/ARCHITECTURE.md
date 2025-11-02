# Architecture Documentation

## Overview

This is a Java 21 LTS template project demonstrating modern Java development practices with a focus on code quality, testing, and maintainability.

## Design Principles

### 1. Functional Programming Style
- **Immutability by Default**: All classes use `final` fields where possible
- **Pure Functions**: Methods avoid side effects and return new objects rather than modifying state
- **Single-Expression Lambdas**: Lambdas are kept simple and extracted to methods when complex

### 2. Test-Driven Development (TDD)
- Tests are written first to define expected behavior
- Production code implements minimal functionality to pass tests
- Refactoring occurs only after tests pass

### 3. Code Quality
- **Checkstyle**: Enforces style guidelines (4-space indent, 120-char lines, max 40 lines/method)
- **SpotBugs**: Static analysis for bug detection (now compatible with Java 21)
- **Pitest**: Mutation testing with 80% coverage threshold **enforced on every build**
- **JaCoCo**: Code coverage reporting (for visibility, not enforcement)
- **OWASP Dependency-Check**: Security vulnerability scanning

**Philosophy**: This template uses **mutation testing** as the primary quality gate instead of naive line coverage. Mutation testing verifies that tests actually detect bugs by mutating the code and checking if tests fail. This is a much stronger guarantee of test quality than simple line coverage metrics.

## Project Structure

```
├── src/
│   ├── main/
│   │   ├── java/com/example/app/     # Production code
│   │   └── resources/                # Configuration files
│   └── test/
│       ├── java/com/example/app/     # Test code
│       └── resources/                # Test configuration
├── config/
│   ├── checkstyle/                   # Code style rules
│   ├── spotbugs/                     # Bug detection rules
│   └── owasp/                        # Security scan config
├── .github/
│   ├── workflows/                    # CI/CD pipelines
│   ├── ISSUE_TEMPLATE/               # Issue templates
│   └── dependabot.yml                # Dependency updates
└── docs/                             # Additional documentation
```

## Component Design

### Calculator
Simple demonstration of business logic with pure functions.

### Person (Builder Pattern)
Immutable data class using the Builder pattern for flexible construction:
- Validation in constructor
- Proper equals/hashCode/toString
- Type-safe builder

### StringUtils (Utility Class)
Static utility methods following the utility class pattern:
- Private constructor to prevent instantiation
- All methods are static and pure
- Null-safe implementations

### ApplicationException
Base exception for application-specific errors, allowing for:
- Consistent exception hierarchy
- Better error handling and logging
- Type-safe exception catching

## Testing Strategy

### Unit Tests
- **JUnit 5**: Test framework with modern annotations
- **AssertJ**: Fluent assertions for readability
- **Mockito**: Mocking framework for dependencies
- **Coverage**: Minimum 80% code coverage enforced

### Test Organization
- Tests mirror production package structure
- Clear test naming: `shouldDoSomethingWhenCondition`
- Given-When-Then comments for clarity

## Build & CI/CD

### Gradle
- Java toolchain targeting Java 21 LTS
- Dependency management via Maven Central
- Multi-report generation (coverage, checkstyle, spotbugs, pitest)

### GitHub Actions
- Build on every push/PR to main
- Run all quality checks (tests, coverage, checkstyle, spotbugs)
- Upload reports as artifacts
- Automated dependency updates via Dependabot

## Security

### Dependency Management
- OWASP Dependency-Check scans for CVEs
- Dependabot creates PRs for security updates
- Fails build on CVSS score ≥ 7

### Code Analysis
- SpotBugs detects potential security issues
- Checkstyle enforces secure coding practices

## Logging

### Framework
- **SLF4J 2.0.9**: Logging facade (MIT license)
- **Logback 1.4.11**: Logging implementation (EPL/LGPL dual-license)
- **Lombok @Slf4j**: Automatic logger field injection

### Structured Logging Best Practices

**Use key=value format** for all log messages to enable searchability in modern log viewers (Elasticsearch, Splunk, Datadog) and SIEM tools:

```java
// ✅ Good: Structured logging with key=value format
log.info("user_action userId={} action={}", userId, action);
log.error("processing_failed orderId={} reason={}", orderId, reason, exception);
log.debug("test_data userId={} status={}", userId, status);

// ❌ Bad: Prose format - harder to search and parse
log.info("User {} performed action {}", userId, action);
log.info("User: {} action: {}", userId, action);

// ❌ Bad: String concatenation - inefficient and loses parameterization
log.info("User " + userId + " performed " + action);
```

### Log Event Naming

Use **snake_case** for log event names (first parameter) to create consistent, searchable event identifiers:

```java
log.info("user_login userId={} timestamp={}", userId, timestamp);
log.warn("rate_limit_exceeded userId={} requestCount={}", userId, count);
log.error("database_connection_failed host={} port={} error={}", host, port, error);
```

### Configuration

**Production** (`src/main/resources/logback.xml`):
- Console and File appenders
- Daily log rotation with 30-day retention
- INFO level for root logger
- Logs stored in `logs/application.log`

**Test** (`src/test/resources/logback-test.xml`):
- Console appender only
- WARN level to reduce test noise
- Override to DEBUG for specific packages when debugging

### Examples

See `ExampleService.java` for comprehensive logging examples demonstrating:
- Structured logging patterns
- Log level usage (TRACE, DEBUG, INFO, WARN, ERROR)
- Exception logging with context
- Conditional logging for expensive operations

## Future Enhancements

Potential additions for production projects:
- Integration tests with separate source set
- Performance benchmarks (JMH)
- Docker containerization
- Database integration examples
- REST API examples

## References

- [Java 21 Documentation](https://docs.oracle.com/en/java/javase/21/)
- [Gradle User Guide](https://docs.gradle.org/)
- [JUnit 5 User Guide](https://junit.org/junit5/docs/current/user-guide/)
- [AssertJ Documentation](https://assertj.github.io/doc/)
