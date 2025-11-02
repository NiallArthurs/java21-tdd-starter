# GitHub Copilot Instructions

> **Note**: This file is automatically read by GitHub Copilot and similar AI coding assistants.

## Overview

This is a **Java 21 TDD Project Template** with strict coding standards. You are assisting with **Test-Driven Development** where:
- **Human writes tests** (defines requirements)
- **AI implements code** (minimal solution to pass tests)
- **Human reviews and guides refactoring**

## 📋 Quick Reference for AI Agents

### Before Every Code Change

1. ✅ Verify user has written a test first
2. ✅ Run the test to confirm it fails
3. ✅ Implement minimal code to make test pass
4. ✅ Run full build: `.\gradlew clean build`
5. ✅ Commit with format: `<type>(<scope>): <description>`

### Code Style Requirements

```java
// ALWAYS use final
final String result = input.trim();

// ALWAYS use immutable collections
final List<String> names = List.of("Alice", "Bob");

// ALWAYS use AssertJ for tests
assertThat(actual).isEqualTo(expected);

// NEVER use {} in lambdas (extract to method)
list.stream().filter(this::isValid).collect(toList());
```

### Quality Gates

Every commit must pass:
- Error Prone (compile-time bug detection)
- Checkstyle (code style)
- PMD (bug patterns)
- SpotBugs (static analysis)
- ArchUnit (architecture rules)
- JUnit tests (100% must pass)
- JaCoCo (≥80% line coverage)
- Pitest (≥80% mutation coverage)

## 📖 Complete Standards

For detailed rules, decision trees, and code examples:

👉 **[Read the full AI Agent Coding Standards](../docs/AI_AGENT_CODING_STANDARDS.md)**

This includes:
- ✅ Decision trees for "add feature", "fix bug", "refactor"
- ✅ Escalation protocol (when to require human review)
- ✅ Commit message templates
- ✅ Code examples (correct vs wrong)
- ✅ Security rules
- ✅ TDD workflow examples

## ⚠️ Critical Rules

### NEVER Do This
- ❌ Modify tests without explicit permission
- ❌ Add code without tests
- ❌ Commit without running build
- ❌ Use Unicode/emoji in output
- ❌ Commit secrets or credentials
- ❌ Change >100 lines without creating draft PR

### ALWAYS Do This
- ✅ Ask for tests if none exist
- ✅ Run `.\gradlew clean build` before commit
- ✅ Use `final` for all variables
- ✅ Tag commits with `[auto]`
- ✅ Escalate unclear requirements

## 🎯 Success Criteria

**Your job is complete when:**
1. User's test passes
2. `.\gradlew clean build` shows BUILD SUCCESSFUL
3. All quality gates pass (9 checks)
4. Code uses proper style (final, immutable, early returns)
5. Commit message follows format

## Example Session

**User:** "Add a method to reverse a string"

**You:** "I need a test first. Could you add something like:
```java
@Test
void shouldReverseString() {
    assertThat(reverse("hello")).isEqualTo("olleh");
}
```"

**User:** *adds test, test fails*

**You:** *implements minimal solution*
```java
public static String reverse(final String input) {
    return new StringBuilder(input).reverse().toString();
}
```

**You:** *verifies*
```
Running: .\gradlew clean build
BUILD SUCCESSFUL in 2s
All tests pass ✓
```

**You:** *commits*
```
feat(string-utils): add reverse method to satisfy tests

Implemented string reversal using StringBuilder.
All tests pass, build verified.

[auto] - Agent: GitHub Copilot
```

---

**Questions?** See the [full standards document](../docs/AI_AGENT_CODING_STANDARDS.md).
