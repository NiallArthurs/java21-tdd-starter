# First-Time Setup Guide

This guide walks you through setting up this Java project template for the first time.

## Prerequisites

- **JDK 21 LTS** installed
- **VS Code** with extensions:
  - [Extension Pack for Java](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-java-pack)
  - [Lombok](https://marketplace.visualstudio.com/items?itemName=vscjava.vscode-lombok)

## Quick Start

### 1. Clone This Template

```bash
git clone https://github.com/{your-repo}/java-tdd-template.git my-project
cd my-project
```

### 2. Customize the Template (Recommended)

Run the customization script to update package names and project settings:

```powershell
.\customize-template.ps1 -ProjectName "my-project" -PackageName "com.mycompany.app" -GitHubUsername "yourusername"
```

**Options:**
- `-ProjectName` - Your project name (e.g., "my-awesome-app")
- `-PackageName` - Your Java package (e.g., "com.mycompany.app")
- `-GitHubUsername` - Your GitHub username (updates README badges)
- `-RemoveExamples` - Remove example code files (Person, Calculator, etc.)
- `-Force` - Skip confirmation prompts

**What it does:**
- ✅ Updates package structure (`com.example.app` → your package)
- ✅ Updates `build.gradle` and `settings.gradle`
- ✅ Updates README badges with your GitHub username
- ✅ Updates all documentation references
- ✅ Optionally removes example code
- ✅ Deletes template-specific files
- ✅ Deletes itself when done

**Or customize manually:**
1. **Rename the package**: Currently `com.example.app` - change in all files + folder structure
2. **Update `build.gradle`**: Change `group = 'com.example'`
3. **Remove example code**: `Person.java`, `Calculator.java`, `StringUtils.java` and their tests

### 3. Configure JDK Path

Edit `.vscode/settings.json` and update the JDK path:

```jsonc
"java.configuration.runtimes": [
    {
        "name": "JavaSE-21",
        "path": "C:\\Program Files\\Java\\jdk-21",  // ⬅️ UPDATE THIS
        "default": true
    }
]
```

**Or** set it globally in VS Code:
- `Ctrl+Shift+P` → "Preferences: Open User Settings (JSON)"
- Add: `"java.jdt.ls.java.home": "C:\\Program Files\\Java\\jdk-21"`

### 3. Update `gradle.properties`

Edit `gradle.properties` and set your JDK path:

```properties
org.gradle.java.home=C:/Program Files/Java/jdk-21
```

### 4. Generate Eclipse Project Files

VS Code's Java Language Server needs Eclipse metadata files due to a bug in the Gradle Build Server.

Run this command:

```powershell
.\gradlew.bat eclipse
```

This creates `.project`, `.classpath`, and `.settings/` files (gitignored - they're local only).

### 5. Open in VS Code

```powershell
code .
```

Wait for:
- VS Code to install recommended extensions (click "Install" when prompted)
- Java Language Server to initialize (watch status bar)

### 6. Verify Setup

Build the project:

```powershell
.\gradlew.bat clean build
```

You should see:
- ✅ BUILD SUCCESSFUL
- ✅ All tests pass
- ✅ 100% mutation coverage (Pitest)
- ✅ No Checkstyle violations
- ✅ No SpotBugs issues

## Optional: Enable Codecov (Coverage Reporting)

The template includes a Codecov badge in the README, but you need to enable it for your repository.

### For Public Repositories (Free)

1. **Sign in to Codecov:**
   - Go to https://codecov.io/
   - Click "Sign in with GitHub"
   - Authorize Codecov to access your repositories

2. **Add Your Repository:**
   - Click "+ Add repository" or go to https://app.codecov.io/gh/{your-username}
   - Select your repository from the list
   - That's it! No token needed for public repos.

3. **Push to GitHub:**
   - The CI workflow is already configured to upload coverage
   - Push any commit and watch the CI run
   - Check your coverage at: `https://codecov.io/gh/{your-username}/{your-repo}`

4. **Badge Updates:**
   - Your README badge will start working automatically
   - Badge URL: `https://codecov.io/gh/{your-username}/{your-repo}/branch/master/graph/badge.svg`

### For Private Repositories

1. **Follow steps 1-2 above** (sign in and add repository)

2. **Get Your Codecov Token:**
   - Go to your repository settings in Codecov
   - Copy the "Upload Token"

3. **Add Token to GitHub Secrets:**
   - Go to your GitHub repository → Settings → Secrets and variables → Actions
   - Click "New repository secret"
   - Name: `CODECOV_TOKEN`
   - Value: (paste your token)
   - Click "Add secret"

4. **Update CI Workflow:**
   
   Edit `.github/workflows/ci.yml` and add the token:
   
   ```yaml
   - name: Upload coverage to Codecov
     uses: codecov/codecov-action@v5
     with:
       files: build/reports/jacoco/test/jacocoTestReport.xml
       token: ${{ secrets.CODECOV_TOKEN }}  # ⬅️ Add this line
       flags: unittests
       name: codecov-umbrella
       fail_ci_if_error: false
   ```

### Verify Coverage Upload

After the CI runs:
1. Check the GitHub Actions log for "Upload coverage to Codecov" step
2. You should see: "Coverage reports upload successfully"
3. Visit your Codecov dashboard: `https://app.codecov.io/gh/{your-username}/{your-repo}`
4. View coverage trends, file-by-file coverage, and pull request comments

### Coverage Badge

The README includes a Codecov badge that shows your current coverage percentage:

```markdown
[![Codecov](https://codecov.io/gh/{your-username}/{your-repo}/branch/master/graph/badge.svg)](https://codecov.io/gh/{your-username}/{your-repo})
```

If you used `customize-template.ps1`, this is already updated with your GitHub username.

### What Gets Uploaded?

The CI workflow uploads the JaCoCo XML report:
- **File**: `build/reports/jacoco/test/jacocoTestReport.xml`
- **Format**: JaCoCo XML (Codecov native format)
- **Coverage**: Line, branch, and method coverage
- **When**: On every push to main/master and pull requests

### Codecov Features

- **Pull Request Comments**: Codecov will comment on PRs with coverage changes
- **Coverage Trends**: Track coverage over time
- **File Browser**: See which files need more tests
- **Diff Coverage**: See coverage for code changed in PRs
- **Status Checks**: Fail PRs if coverage drops (configurable)

### Codecov Configuration (Optional)

Create `codecov.yml` in your project root to customize:

```yaml
coverage:
  precision: 2
  round: down
  range: "70...100"
  status:
    project:
      default:
        target: 80%
        threshold: 1%
    patch:
      default:
        target: 80%

comment:
  layout: "reach, diff, files"
  behavior: default
```

This enforces 80% minimum coverage (matching your JaCoCo threshold).

## Troubleshooting

### "non-project file, only syntax errors are reported"

**Cause**: Eclipse files not generated or VS Code didn't reload.

**Fix**:
1. Run `.\gradlew.bat eclipse`
2. `Ctrl+Shift+P` → "Java: Clean Java Language Server Workspace"
3. Choose "Restart and delete"

### "class file major version 65" error

**Cause**: JDK path mismatch.

**Fix**: Verify both `.vscode/settings.json` and `gradle.properties` point to the same JDK 21 installation.

### Gradle Build Fails

**Cause**: JDK not found or wrong version.

**Fix**:
1. Run `java -version` (should show 21.x.x)
2. Check `gradle.properties` has correct JDK path
3. Run `.\gradlew.bat --stop` then retry build

## Using the Template

Once set up, you can:

1. **Customize package names**: Use `customize-template.ps1` (see step 2 above) or manually update files
2. **Update project metadata**: `build.gradle` (group, version), `README.md`
3. **Remove example code**: Use `-RemoveExamples` flag with script or manually delete files
4. **Start coding with TDD**: Write tests first in `src/test/java/`, implement in `src/main/java/`

## Key Commands

```bash
# Build with all quality checks
.\gradlew.bat build

# Run tests only
.\gradlew.bat test

# Mutation testing
.\gradlew.bat pitest

# Static analysis
.\gradlew.bat spotbugsMain

# Security scan
.\gradlew.bat dependencyCheckAnalyze

# Regenerate Eclipse files (if needed)
.\gradlew.bat cleanEclipse eclipse
```

## Why Eclipse Files?

VS Code's Gradle Build Server has a `ConcurrentModificationException` bug when reading project dependencies. Using Eclipse metadata files (`.project`, `.classpath`) works around this while still using Gradle as the build system.

- ✅ Gradle is still your build tool
- ✅ Eclipse files provide IDE metadata
- ✅ Files are gitignored (generated locally)
- ✅ Run `gradle eclipse` anytime to regenerate

## Next Steps

See:
- [`README.md`](README.md) - Project overview and features
- [`docs/DEPENDENCIES.md`](docs/DEPENDENCIES.md) - **License guidance for adding dependencies**
- [`docs/CONTRIBUTING.md`](docs/CONTRIBUTING.md) - Development guidelines
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) - Design principles
- [`docs/AI_AGENT_CODING_STANDARDS.md`](docs/AI_AGENT_CODING_STANDARDS.md) - AI agent guidelines
- [`docs/README.md`](docs/README.md) - **Full documentation index**
