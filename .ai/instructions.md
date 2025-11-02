# AI Agent Instructions

> **For AI Coding Assistants**: Read this before making code changes.

## Project Type

**Java 21 TDD Template** - Test-Driven Development with strict quality gates.

## Your Role

You implement code to satisfy tests written by humans. You do NOT write tests (unless explicitly asked).

## TDD Protocol

```
1. User writes test → 2. You implement → 3. You verify build → 4. You commit
```

**If no test exists**: Ask user to write one first. Do not proceed.

## Quick Commands

```powershell
# Verify all quality gates pass
.\gradlew clean build

# Run tests only
.\gradlew test

# Check coverage
.\gradlew jacocoTestReport
```

## Code Style Rules

```java
// ✓ Use final always
final String name = "Alice";

// ✓ Use immutable collections
final List<String> list = List.of("a", "b", "c");

// ✓ Use AssertJ in tests
assertThat(result).isEqualTo(expected);

// ✓ Early returns (not nested ifs)
if (input == null) return "";
return input.trim();

// ✗ Never use {} in lambdas
list.stream().filter(item -> {  // WRONG
    return item != null;
});

// ✓ Extract to method instead
list.stream().filter(this::isNotNull);
```

## Quality Gates (All Must Pass)

9 automated checks run on every build:

1. **Error Prone** - Compile-time bug detection (<1s)
2. **Checkstyle** - Code style validation (1-2s)
3. **PMD** - Bug pattern detection (2-3s)
4. **SpotBugs** - Static analysis (3-5s)
5. **ArchUnit** - Architecture rules (5-7s)
6. **JUnit** - All tests must pass (5-10s)
7. **JaCoCo** - 80% line coverage minimum (10s)
8. **Pitest** - 80% mutation coverage minimum (10-15s)
9. **OWASP** - Dependency vulnerabilities (CI only)

## Commit Format

```
<type>(<scope>): <description>

[optional body]

[auto] - Agent: <your_name>
```

**Types:** feat, fix, refactor, test, docs, build, chore

**Example:**
```
feat(calculator): add divide method to satisfy tests

Implements integer division with zero-check.
All tests pass, build verified.

[auto] - Agent: GitHub Copilot
```

## Escalation (Require Human Review)

Stop and ask for approval if:
- Changes ≥ 100 lines
- Public API modification
- New dependency
- Security-sensitive code
- Test modification (without permission)
- Unclear requirements

## Complete Documentation

📖 **Full standards with decision trees and examples:**
[docs/AI_AGENT_CODING_STANDARDS.md](../docs/AI_AGENT_CODING_STANDARDS.md)

📚 **Human-readable project overview:**
[README.md](../README.md)

## Success Criteria

✅ User's test passes
✅ `.\gradlew clean build` succeeds
✅ All 9 quality gates pass
✅ Code follows style rules (final, immutable, AssertJ)
✅ Commit message formatted correctly
