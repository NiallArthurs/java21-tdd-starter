# Dependency Management Guide

## Current Status

✅ **This template has ZERO runtime dependencies**, which means:
- You can choose **any license** for your project (MIT, Apache, GPL, proprietary, etc.)
- No third-party code is bundled in your compiled JAR
- Complete freedom to add dependencies as needed

## Understanding Dependency Scopes

### Compile-Only Dependencies
```gradle
compileOnly 'org.projectlombok:lombok:1.18.30'
```
- Used only during compilation
- **NOT** included in final JAR
- **Does not affect your license choice**
- Example: Lombok annotations, SpotBugs annotations

### Test Dependencies
```gradle
testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
```
- Used only for running tests
- **NOT** shipped with production code
- **Does not affect your license choice**
- Examples: JUnit, AssertJ, Mockito

### Runtime Dependencies
```gradle
implementation 'org.apache.commons:commons-lang3:3.14.0'
```
- **Bundled with your application**
- **Their licenses DO affect your options**
- Require careful license review

## License Categories

### ✅ Permissive Licenses (Safe for Most Uses)

#### Apache License 2.0
- **Popular libraries**: Spring Framework, Spring Boot, Google Guava, Apache Commons, Jackson, Log4j2
- **Permissions**: Commercial use, modification, distribution, patent grant
- **Requirements**: Include license notice and attribution
- **Compatible with**: Any license (MIT, GPL, proprietary)
- **Best for**: Production applications, commercial products

```gradle
// Examples of Apache 2.0 dependencies:
implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'
implementation 'com.google.guava:guava:33.0.0-jre'
implementation 'org.apache.commons:commons-lang3:3.14.0'
```

#### MIT License
- **Popular libraries**: Lombok (compile-only), Mockito, SLF4J
- **Permissions**: Almost no restrictions
- **Requirements**: Include copyright notice
- **Compatible with**: Any license
- **Best for**: Maximum flexibility

```gradle
// Examples of MIT dependencies:
implementation 'org.slf4j:slf4j-api:2.0.9'
testImplementation 'org.mockito:mockito-core:5.10.0'
```

#### BSD Licenses (2-Clause, 3-Clause)
- **Popular libraries**: Various utility libraries
- **Permissions**: Similar to MIT
- **Requirements**: Include copyright notice, no trademark use (3-Clause)
- **Compatible with**: Any license
- **Best for**: Maximum flexibility

### ⚠️ Copyleft Licenses (Require Review)

#### GNU Lesser General Public License (LGPL)
- **Popular libraries**: Some older Java libraries, Hibernate (dual-licensed)
- **Permissions**: Can be used in commercial/proprietary software
- **Requirements**: 
  - Dynamic linking is usually acceptable
  - Modifications to LGPL library must be released
  - Provide source of LGPL components
- **Compatible with**: Commercial software (with proper linking)
- **Best for**: Use as-is without modification
- **⚠️ Warning**: Linking requirements can be complex

```gradle
// If using LGPL library:
implementation 'org.example:lgpl-library:1.0.0'
// ⚠️ Consider: Can you dynamically link? Will you modify the library?
```

#### GNU General Public License (GPL v2/v3)
- **Popular libraries**: Some Linux utilities, MySQL Connector/J (GPL with FOSS exception)
- **Permissions**: Free use for GPL-compatible projects
- **Requirements**: 
  - **Derivative works must be GPL**
  - Must provide source code
  - Cannot be combined with proprietary code
- **Compatible with**: Other GPL projects only
- **❌ Avoid for**: Commercial/proprietary applications

```gradle
// ❌ Avoid GPL dependencies unless your project is also GPL:
// implementation 'com.example:gpl-library:1.0.0'  // Don't do this!
```

#### GNU Affero General Public License (AGPL)
- **Popular libraries**: Some server-side libraries
- **Permissions**: Like GPL but applies to network use
- **Requirements**: 
  - Must provide source to **all network users**
  - Triggers even for SaaS applications
- **Compatible with**: Other AGPL projects only
- **❌ Avoid for**: Nearly all commercial uses

### 🔒 Proprietary/Commercial Licenses

Some libraries require paid licenses or have usage restrictions:
- Oracle JDBC drivers (free for development, check production terms)
- Commercial database drivers
- Enterprise features of open-source products

**Always read the license terms before adding these dependencies.**

## Recommended Practices

### 1. Automatic License Validation

This template includes a **build-time license check** that automatically fails the build if GPL/AGPL dependencies are detected:

```bash
# Runs automatically during build:
./gradlew build

# Or run manually:
./gradlew checkLicenses
```

**What it checks:**
- ✅ Scans all `runtimeClasspath` dependencies (what gets bundled)
- ✅ Detects GPL, GPLv2, GPLv3, AGPL, AGPLv3 licenses
- ✅ Excludes LGPL (which is acceptable with proper linking)
- ❌ Fails build if restricted licenses are found

**If a GPL/AGPL dependency is detected:**
```
❌ BUILD FAILED: Restricted licenses detected!

The following dependencies have GPL/AGPL licenses:
  • com.example:gpl-library:1.0.0
    License: GPL
    
Solutions:
  1. Find an alternative library with Apache/MIT/BSD license
  2. If dual-licensed, add the non-GPL version
  3. If false positive, update the check logic
  4. If your project is GPL-compatible, disable the check
```

**To disable the check** (only if your project is GPL-compatible):
```gradle
// In build.gradle, remove this line:
tasks.named('check').configure {
    dependsOn 'checkLicenses'  // ← Remove this dependency
}
```

### 2. Check Licenses Before Adding Dependencies

```bash
# View all dependencies and their details:
./gradlew dependencies

# Check only runtime (bundled) dependencies:
./gradlew dependencies --configuration runtimeClasspath

# Generate license report (requires plugin):
# Add: id 'com.github.jk1.dependency-license-report' version '2.5'
./gradlew generateLicenseReport
```

### 2. Prefer Apache 2.0 and MIT Libraries

These licenses are:
- ✅ Compatible with commercial use
- ✅ Allow modification
- ✅ Do not require source disclosure
- ✅ Include patent grants (Apache 2.0)

### 3. Avoid GPL/AGPL for Business Applications

Unless your project is open source and GPL-compatible:
- ❌ GPL requires derivative works to be GPL
- ❌ AGPL requires source disclosure for network services
- ❌ Can contaminate your entire codebase

### 4. Document Your Dependencies

Create a `NOTICE` or `THIRD_PARTY_LICENSES` file listing:
- Library name and version
- License type
- Copyright holder
- Where to find the full license text

### 5. Use OWASP Dependency-Check

This template includes automatic vulnerability scanning:

```bash
# Run security scan:
./gradlew dependencyCheckAnalyze

# View report:
# build/reports/dependency-check-report.html
```

The build will **fail** if vulnerabilities with CVSS ≥ 7 are found.

## Common Dependencies and Their Licenses

| Library | License | Safe for Commercial? | Notes |
|---------|---------|---------------------|-------|
| Spring Boot | Apache 2.0 | ✅ Yes | Very permissive |
| Spring Framework | Apache 2.0 | ✅ Yes | Very permissive |
| Hibernate | LGPL + Apache 2.0 | ✅ Yes | Dual-licensed |
| Jackson | Apache 2.0 | ✅ Yes | JSON processing |
| Google Guava | Apache 2.0 | ✅ Yes | Utilities |
| Apache Commons | Apache 2.0 | ✅ Yes | Utilities |
| SLF4J | MIT | ✅ Yes | Logging API |
| Logback | EPL 1.0 / LGPL 2.1 | ✅ Yes | Dual-licensed |
| Log4j2 | Apache 2.0 | ✅ Yes | Logging |
| JUnit 5 | EPL 2.0 | ✅ Yes | Test only (no impact) |
| AssertJ | Apache 2.0 | ✅ Yes | Test only (no impact) |
| Mockito | MIT | ✅ Yes | Test only (no impact) |
| Lombok | MIT | ✅ Yes | Compile-only (no impact) |
| PostgreSQL JDBC | BSD 2-Clause | ✅ Yes | Database driver |
| MySQL Connector/J | GPL + FOSS Exception | ⚠️ Review | May require GPL or Oracle license |
| H2 Database | EPL 1.0 / MPL 2.0 | ✅ Yes | Dual-licensed |

## License Compatibility Matrix

| Your License | Can Use Apache/MIT? | Can Use LGPL? | Can Use GPL? |
|--------------|---------------------|---------------|--------------|
| MIT | ✅ Yes | ✅ Yes (with care) | ❌ No |
| Apache 2.0 | ✅ Yes | ✅ Yes (with care) | ❌ No |
| BSD | ✅ Yes | ✅ Yes (with care) | ❌ No |
| LGPL | ✅ Yes | ✅ Yes | ⚠️ Maybe |
| GPL | ✅ Yes | ✅ Yes | ✅ Yes |
| Proprietary | ✅ Yes | ⚠️ Review | ❌ No |

## When You Add a New Dependency

### Checklist

1. **Check the license**:
   ```bash
   # Look at the library's GitHub/website
   # Check Maven Central for license info
   ```

2. **Verify it's in runtimeClasspath**:
   ```bash
   ./gradlew dependencies --configuration runtimeClasspath
   ```

3. **Scan for vulnerabilities**:
   ```bash
   ./gradlew dependencyCheckAnalyze
   ```

4. **Ensure license compatibility**:
   - Apache/MIT/BSD → ✅ Safe
   - LGPL → ⚠️ Review linking requirements
   - GPL/AGPL → ❌ Likely incompatible with commercial use

5. **Update documentation**:
   - Add to README if it's a major dependency
   - Include in NOTICE file if required by license

## Example: Adding Spring Boot

Spring Boot is Apache 2.0, so it's safe to add:

```gradle
dependencies {
    implementation 'org.springframework.boot:spring-boot-starter-web:3.2.0'
    implementation 'org.springframework.boot:spring-boot-starter-data-jpa:3.2.0'
    
    // All Spring dependencies are Apache 2.0
    // Compatible with: MIT, Apache, BSD, proprietary licenses
}
```

After adding:
```bash
# Verify it appears in runtime:
./gradlew dependencies --configuration runtimeClasspath | Select-String "spring-boot"

# Check for vulnerabilities:
./gradlew dependencyCheckAnalyze
```

## Resources

- [ChooseALicense.com](https://choosealicense.com/) - License comparison
- [TLDRLegal](https://tldrlegal.com/) - License summaries
- [SPDX License List](https://spdx.org/licenses/) - Standardized license identifiers
- [Apache License FAQ](https://www.apache.org/foundation/license-faq.html)
- [GNU License List](https://www.gnu.org/licenses/license-list.html)

## Questions?

**Q: Can I use this template for commercial projects?**  
A: Yes! The template has no runtime dependencies, so you're free to use any license.

**Q: What if I add a dependency with GPL license by mistake?**  
A: Remove it immediately and find an alternative with Apache/MIT license. Most popular libraries have permissive alternatives.

**Q: Do test dependencies affect my license?**  
A: No. Test dependencies (JUnit, Mockito, etc.) are not distributed with your application.

**Q: What about transitive dependencies?**  
A: All dependencies of your dependencies also apply. Use `./gradlew dependencies` to see the full tree.

**Q: Can I change a library's license?**  
A: No. You must comply with the license chosen by the library author.

## Summary

- ✅ **This template**: Zero runtime dependencies = total freedom
- ✅ **Apache 2.0 / MIT / BSD**: Safe for any use, including commercial
- ⚠️ **LGPL**: Usually okay but review carefully
- ❌ **GPL / AGPL**: Avoid unless your project is also GPL
- 🔍 **Always check**: Use `gradle dependencies --configuration runtimeClasspath`
- 🛡️ **Security**: OWASP Dependency-Check runs on every build
