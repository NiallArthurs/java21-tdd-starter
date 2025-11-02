# AI Agent Coding Standards

Version: 2.0

## Quick Reference Checklist

Before committing ANY code, verify:

- [ ] User wrote the test first (TDD workflow)
- [ ] Implementation is minimal (only makes tests pass)
- [ ] `.\gradlew clean build` passes locally
- [ ] No tests modified without explicit permission
- [ ] Commit message follows format: `<type>(<scope>): <description>`
- [ ] Code uses `final` for all variables unless mutation required
- [ ] No ASCII art, emojis, or Unicode box drawing in output
- [ ] No secrets or credentials added
- [ ] Changes < 100 lines (or draft PR created)

## Purpose

This document provides **imperative rules** for AI agents modifying this codebase. Follow these rules exactly. For human-readable context, see README.md.

## Template Context

This is a starter template for Java 21 TDD projects. Adapt these standards per project needs before production use.

## Core Principles (Imperative Rules)

### ALWAYS Do This

1. **Use `final`** for all variables unless mutation is explicitly required
2. **Use immutable collections** (`List.of()`, `Set.of()`, `Map.of()`)
3. **Use method chaining** for builders and fluent APIs
4. **Use early returns** instead of nested if-else (max 3 levels nesting)
5. **Extract complex lambdas** to named methods (single-expression lambdas only)
6. **Use AssertJ** for all test assertions (`assertThat(x).isEqualTo(y)`)
7. **Run `.\gradlew clean build`** before every commit
8. **Include `[auto]` tag** in commit messages

### NEVER Do This

1. **Never modify user tests** without explicit permission
2. **Never add untested code** (tests must exist first)
3. **Never use Unicode/emoji** in build output (ASCII only)
4. **Never commit secrets** or credentials
5. **Never rewrite > 100 lines** without creating draft PR
6. **Never change public APIs** without issue + migration docs
7. **Never use `{}` in lambdas** (extract to method instead)
8. **Never use JUnit assertions** (`assertEquals`) - use AssertJ

## TDD Workflow (Strict Protocol)

### Decision Tree: "User Asks to Add Feature X"

```
1. Does test for X exist?
   ├─ NO → STOP. Ask user to write test first.
   └─ YES → Continue to step 2

2. Does test pass?
   ├─ YES → STOP. Feature already works.
   └─ NO → Continue to step 3

3. Implement minimal code to make test pass
   
4. Run: .\gradlew clean build
   ├─ FAIL → Fix errors, goto step 4
   └─ PASS → Continue to step 5

5. Commit with message: "feat(scope): add X to satisfy tests"

6. Review code quality
   ├─ Refactor needed? → Suggest to user (don't do it)
   └─ Looks good → Done
```

### Example Session

**User Request:**
> "Add a method to calculate fibonacci numbers"

**Agent Response:**
```
I need a test first to define the expected behavior. 

Could you add a test like this to FibonacciTest.java?

@Test
@DisplayName("Should calculate fibonacci numbers correctly")
void shouldCalculateFibonacci() {
    assertThat(fibonacci(0)).isEqualTo(0);
    assertThat(fibonacci(1)).isEqualTo(1);
    assertThat(fibonacci(5)).isEqualTo(5);
    assertThat(fibonacci(10)).isEqualTo(55);
}
```

**User adds test, test fails**

**Agent implements:**
```java
public static long fibonacci(final int n) {
    if (n <= 1) {
        return n;
    }
    long a = 0;
    long b = 1;
    for (int i = 2; i <= n; i++) {
        final long temp = a + b;
        a = b;
        b = temp;
    }
    return b;
}
```

**Agent verifies:**
```
Running: .\gradlew clean build
BUILD SUCCESSFUL in 2s
All tests pass ✓
```

**Agent commits:**
```
feat(math): add fibonacci method to satisfy tests

- Implemented iterative fibonacci calculation
- All tests pass
- Build verified locally
```

## Code Style Rules (With Examples)

### Rule: Use `final` for all variables

```java
// ✓ CORRECT
public String process(final String input) {
    final String trimmed = input.trim();
    final String upper = trimmed.toUpperCase(Locale.ROOT);
    return upper;
}

// ✗ WRONG
public String process(String input) {
    String trimmed = input.trim();
    String upper = trimmed.toUpperCase(Locale.ROOT);
    return upper;
}
```

### Rule: Use immutable collections

```java
// ✓ CORRECT
final List<String> names = List.of("Alice", "Bob", "Charlie");
final Set<Integer> numbers = Set.of(1, 2, 3);
final Map<String, Integer> scores = Map.of("Alice", 100, "Bob", 95);

// ✗ WRONG
final List<String> names = new ArrayList<>();
names.add("Alice");
names.add("Bob");
```

### Rule: Single-expression lambdas only

```java
// ✓ CORRECT
list.stream()
    .filter(this::isValid)
    .map(String::trim)
    .collect(Collectors.toList());

private boolean isValid(final String item) {
    return item != null && !item.isEmpty() && item.length() > 5;
}

// ✗ WRONG
list.stream()
    .filter(item -> {
        if (item == null) return false;
        if (item.isEmpty()) return false;
        return item.length() > 5;
    })
    .collect(Collectors.toList());
```

### Rule: Early returns (max 3 levels nesting)

```java
// ✓ CORRECT
public String process(final String input) {
    if (input == null) {
        return "";
    }
    if (input.isEmpty()) {
        return input;
    }
    return input.trim().toUpperCase(Locale.ROOT);
}

// ✗ WRONG
public String process(final String input) {
    if (input != null) {
        if (!input.isEmpty()) {
            return input.trim().toUpperCase(Locale.ROOT);
        } else {
            return input;
        }
    } else {
        return "";
    }
}
```

### Rule: AssertJ for all assertions

```java
// ✓ CORRECT
@Test
void shouldReturnEmptyForNull() {
    final String result = process(null);
    assertThat(result).isNotNull().isEmpty();
}

@Test
void shouldProcessValidInput() {
    final String result = process("  hello  ");
    assertThat(result).isEqualTo("HELLO");
}

// ✗ WRONG
@Test
void shouldReturnEmptyForNull() {
    String result = process(null);
    assertNotNull(result);
    assertTrue(result.isEmpty());
}
```

## Quality Gates (Commands to Run)

### Before Every Commit

```powershell
# Full build with all quality checks
.\gradlew clean build

# Expected output on success:
# BUILD SUCCESSFUL in Xs
```

### Quality Gate Details

| Gate | Tool | Failure Time | How to Fix |
|------|------|--------------|------------|
| Compile errors | Error Prone | < 1s | Fix compilation errors shown in console |
| Code style | Checkstyle | 1-2s | Fix style violations in console output |
| Bug patterns | PMD | 2-3s | Fix bug patterns shown in console |
| Bugs | SpotBugs | 3-5s | Fix bugs shown in console (file/line/priority) |
| Architecture | ArchUnit | 5-7s | Fix architecture violations in test output |
| Tests fail | JUnit | 5-10s | Fix failing tests or adjust implementation |
| Coverage | JaCoCo | 10s | Add tests to reach 80% line coverage |
| Mutation | Pitest | 10-15s | Improve tests to kill mutants (80% threshold) |

### If Build Fails

1. Read console output (shows exactly what failed)
2. Fix the specific issue
3. Run `.\gradlew clean build` again
4. Repeat until BUILD SUCCESSFUL

## Commit Message Format (Strict)

### Template

```
<type>(<scope>): <description>

[optional body explaining why, not what]

[auto] - Agent: <agent_name>
```

### Types (Choose One)

- `feat` - New feature (user wrote test, you implemented)
- `fix` - Bug fix (user reported issue, you fixed it)
- `refactor` - Code improvement (no behavior change, user approved)
- `test` - Test changes (user requested test modification)
- `docs` - Documentation only
- `build` - Build system changes
- `chore` - Maintenance tasks

### Examples

```
feat(calculator): add divide method to satisfy tests

Implements integer division with zero-check.
Tests verify behavior for positive, negative, and zero divisor.

[auto] - Agent: GitHub Copilot
```

```
fix(string-utils): handle null input in capitalize

User reported NullPointerException. Added null guard.
Test: StringUtilsTest.shouldReturnEmptyForNull()

[auto] - Agent: GitHub Copilot
```

```
refactor(person): extract validation to helper method

User approved extracting repeated validation logic.
No behavior change. All tests pass.

[auto] - Agent: GitHub Copilot
```

## Decision Trees for Common Scenarios

### Scenario: "Add Feature X"

```
INPUT: User asks "Add feature X"

STEP 1: Check for test
├─ Test exists for X?
│  ├─ YES → Goto STEP 2
│  └─ NO → OUTPUT: "I need a test first. Could you add a test that defines X?"
│          STOP

STEP 2: Run test
├─ Test passes?
│  ├─ YES → OUTPUT: "Feature X already works! Test passes."
│  │        STOP
│  └─ NO → Goto STEP 3

STEP 3: Implement
├─ Write minimal code to make test pass
├─ Run: .\gradlew clean build
│  ├─ PASS → Goto STEP 4
│  └─ FAIL → Fix errors, retry STEP 3

STEP 4: Commit
├─ Create commit: "feat(scope): add X to satisfy tests"
├─ OUTPUT: Show code changes + build result
└─ DONE
```

### Scenario: "Fix Bug Y"

```
INPUT: User reports "Bug Y happens when Z"

STEP 1: Check for test
├─ Test exists that reproduces Y?
│  ├─ YES → Goto STEP 2
│  └─ NO → OUTPUT: "Could you add a test that reproduces bug Y?"
│          STOP

STEP 2: Verify test fails
├─ Test fails as expected?
│  ├─ YES → Goto STEP 3
│  └─ NO → OUTPUT: "Test passes. Can you clarify how to reproduce Y?"
│          STOP

STEP 3: Fix bug
├─ Modify code to fix Y
├─ Run: .\gradlew clean build
│  ├─ PASS → Goto STEP 4
│  └─ FAIL → Fix errors, retry STEP 3

STEP 4: Commit
├─ Create commit: "fix(scope): handle Z to fix Y"
├─ OUTPUT: Show fix + build result
└─ DONE
```

### Scenario: "Refactor Code"

```
INPUT: Code smells detected or user asks "Can we improve X?"

STEP 1: Assess scope
├─ Changes > 100 lines?
│  ├─ YES → OUTPUT: "This is a large refactor. Should I create a draft PR?"
│  │        STOP (wait for approval)
│  └─ NO → Goto STEP 2

STEP 2: Suggest refactor
├─ OUTPUT: "I suggest refactoring X because Y. This would:"
│           "- Benefit 1"
│           "- Benefit 2"
│           "Do you want me to proceed?"
└─ Wait for user approval
    ├─ NO → STOP
    └─ YES → Goto STEP 3

STEP 3: Refactor
├─ Make changes (preserve behavior)
├─ Run: .\gradlew clean build
│  ├─ PASS → Goto STEP 4
│  └─ FAIL → Rollback, OUTPUT: "Refactor breaks tests. Need to investigate."
│          STOP

STEP 4: Commit
├─ Create commit: "refactor(scope): improve X (user approved)"
├─ OUTPUT: Show changes + build result
└─ DONE
```

### Scenario: "Tests Fail"

```
INPUT: .\gradlew clean build shows test failures

STEP 1: Identify failure type
├─ Quality gate failure (Checkstyle, PMD, SpotBugs)?
│  ├─ YES → Goto STEP 2
│  └─ NO → Goto STEP 3

STEP 2: Fix quality issue
├─ Read console output (shows exact issue)
├─ Fix the specific problem
├─ Run: .\gradlew clean build
└─ Goto STEP 1

STEP 3: Test failure
├─ User test failing?
│  ├─ YES → OUTPUT: "Your test X is failing because Y. Should I fix the implementation?"
│  │        STOP (wait for confirmation)
│  └─ NO → Goto STEP 4

STEP 4: Architecture/mutation test failing
├─ Fix implementation to satisfy test
├─ Run: .\gradlew clean build
└─ Goto STEP 1
```

## When to Escalate (Require Human Review)

### Automatic Escalation Triggers

- [ ] Changes ≥ 100 lines
- [ ] Public API modification
- [ ] New dependency addition
- [ ] Security-sensitive code (auth, crypto, input validation)
- [ ] Test modification (unless explicitly requested)
- [ ] Architecture pattern change
- [ ] Ambiguous requirements

### Escalation Protocol

1. **Stop immediately** when trigger detected
2. **Create draft PR** with changes
3. **Output explanation**:
   ```
   This change requires human review because [reason].
   
   I've created a draft PR with my suggested changes:
   - File 1: [description]
   - File 2: [description]
   
   Benefits:
   - [benefit 1]
   - [benefit 2]
   
   Risks:
   - [risk 1]
   - [risk 2]
   
   Please review and approve if this looks good.
   ```
4. **Wait for approval** - do NOT commit

## Security Rules (Non-Negotiable)

### NEVER Do This

1. **Never commit secrets**:
   - API keys, passwords, tokens
   - Private keys, certificates
   - Connection strings with credentials
   - AWS keys, database passwords

2. **Never log sensitive data**:
   - User passwords
   - Credit card numbers
   - Personal identifying information

3. **Never use unsafe practices**:
   - SQL concatenation (use PreparedStatement)
   - Deserialization of untrusted data
   - Direct file path construction from user input

### ALWAYS Do This

1. **Validate all inputs** from external sources
2. **Use parameterized queries** for database access
3. **Use approved secret storage** (environment variables, vaults)
4. **Sanitize user input** before logging or displaying

## Enforcement

### Human Review
- All PRs reviewed by maintainers
- Draft PRs for escalated changes

### Automated Checks
```powershell
.\gradlew clean build  # Runs all quality gates
```

This command enforces:
- ✓ Error Prone (compile-time bug detection)
- ✓ Checkstyle (code style)
- ✓ PMD (bug patterns)
- ✓ SpotBugs (static analysis)
- ✓ ArchUnit (architecture rules)
- ✓ JUnit tests (behavior verification)
- ✓ JaCoCo (80% coverage minimum)
- ✓ Pitest (80% mutation coverage minimum)

**All must pass before commit.**

---

## Summary for AI Agents

**Your job**: Implement minimal code that makes user tests pass.

**Your constraints**:
- Tests come first (user writes them)
- Never modify tests without permission
- Run full build before every commit
- Use `final`, immutable collections, early returns
- Commit format: `<type>(<scope>): <description>`
- Escalate if > 100 lines or unclear requirements

**Success criteria**: `.\gradlew clean build` shows BUILD SUCCESSFUL
