# PowerShell script to customize this template after cloning from GitHub
# 
# Usage:
#   1. Clone the template: git clone https://github.com/your-repo/java-tdd-template.git my-project
#   2. Navigate to project: cd my-project
#   3. Run this script: .\customize-template.ps1 -ProjectName "my-project" -PackageName "com.mycompany.app"
#
# This script will:
#   - Replace package names (com.example.app -> your package)
#   - Update project name in all files
#   - Update README badges (if GitHub username provided)
#   - Optionally remove example code
#   - Delete itself when complete

param(
    [Parameter(Mandatory=$true, HelpMessage="Your project name (e.g., 'my-awesome-app')")]
    [string]$ProjectName,
    
    [Parameter(Mandatory=$true, HelpMessage="Your Java package name (e.g., 'com.mycompany.app')")]
    [string]$PackageName,
    
    [Parameter(Mandatory=$false, HelpMessage="Your GitHub username for README badges")]
    [string]$GitHubUsername,
    
    [Parameter(Mandatory=$false, HelpMessage="Remove example code files (Person, Calculator, etc.)")]
    [switch]$RemoveExamples,
    
    [Parameter(Mandatory=$false, HelpMessage="Skip confirmation prompts")]
    [switch]$Force
)

Write-Host @"

╔═══════════════════════════════════════════════════════════╗
║   Java 21 TDD Template Customization                     ║
╚═══════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Validate we're in a git repository (likely cloned from GitHub)
if (-not (Test-Path ".git")) {
    Write-Host "⚠️  Warning: No .git directory found. This script should run in a cloned repository." -ForegroundColor Yellow
    if (-not $Force) {
        $continue = Read-Host "Continue anyway? (y/N)"
        if ($continue -ne "y") {
            Write-Host "Aborted." -ForegroundColor Red
            exit 1
        }
    }
}

# Validate package name format
if ($PackageName -notmatch '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$') {
    Write-Host "❌ Invalid package name format: $PackageName" -ForegroundColor Red
    Write-Host @"

Package name should:
  - Start with a lowercase letter
  - Contain only lowercase letters, numbers, and dots
  - Have no consecutive dots
  - Each segment should start with a lowercase letter

Examples:
  ✅ com.mycompany.app
  ✅ org.example.project
  ❌ Com.Example.App (uppercase)
  ❌ com..example (double dot)

"@ -ForegroundColor Yellow
    exit 1
}

}

# Extract group ID from package name (e.g., com.mycompany.app -> com.mycompany)
$GroupId = ($PackageName -split '\.')[0..($PackageName.Split('.').Length - 2)] -join '.'
if ([string]::IsNullOrEmpty($GroupId)) {
    $GroupId = $PackageName  # Single-segment package
}

# Display configuration
Write-Host @"
Configuration:
  📦 Project Name:    $ProjectName
  📁 Package Name:    $PackageName
  🏢 Group ID:        $GroupId
  🐙 GitHub Username: $(if ($GitHubUsername) { $GitHubUsername } else { "(not provided - badges will have placeholders)" })
  🗑️  Remove Examples:  $(if ($RemoveExamples) { "Yes" } else { "No" })

"@ -ForegroundColor White

if (-not $Force) {
    $confirm = Read-Host "Proceed with customization? (Y/n)"
    if ($confirm -eq "n") {
        Write-Host "Aborted." -ForegroundColor Red
        exit 0
    }
}

Write-Host "`n🔧 Customizing template..." -ForegroundColor Cyan

# Step 1: Update package structure
Write-Host "`n[1/6] Updating package structure..." -ForegroundColor Yellow

$oldPackagePath = "com/example/app"
$newPackagePath = $PackageName.Replace(".", "/")

$srcDirs = @(
    "src/main/java",
    "src/test/java",
    "src/architecture-test/java"
)

foreach ($baseDir in $srcDirs) {
    if (Test-Path $baseDir) {
        # Create new package directories
        $newDir = Join-Path $baseDir $newPackagePath
        if (-not (Test-Path $newDir)) {
            New-Item -ItemType Directory -Path $newDir -Force | Out-Null
        }
        
        # Move and update Java files
        Get-ChildItem -Path $baseDir -Recurse -File -Filter "*.java" | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            $content = $content.Replace("package com.example.app", "package $PackageName")
            $content = $content.Replace("import com.example.app", "import $PackageName")
            Set-Content $_.FullName $content -NoNewline
            
            # Move file to new package directory
            if ($_.Directory.FullName.Contains("com\example\app") -or $_.Directory.FullName.Contains("com/example/app")) {
                $fileName = $_.Name
                $newFilePath = Join-Path $newDir $fileName
                Move-Item -Path $_.FullName -Destination $newFilePath -Force
                Write-Host "  ✓ Moved $fileName to $newPackagePath" -ForegroundColor Gray
            }
        }
        
        # Clean up old package directories
        $oldDir = Join-Path $baseDir "com"
        if ((Test-Path $oldDir) -and ($oldPackagePath -ne $newPackagePath)) {
            Get-ChildItem -Path $oldDir -Directory -Recurse |
                Where-Object { (Get-ChildItem $_.FullName -Recurse -File) -eq $null } |
                Sort-Object -Property FullName -Descending |
                Remove-Item -Force -ErrorAction SilentlyContinue
            
            # Remove com/ directory if empty
            if ((Get-ChildItem $oldDir -Recurse -File).Count -eq 0) {
                Remove-Item $oldDir -Recurse -Force -ErrorAction SilentlyContinue
            }
        }
    }
}

Write-Host "  ✅ Package structure updated" -ForegroundColor Green

# Step 2: Update build.gradle
Write-Host "`n[2/6] Updating build.gradle..." -ForegroundColor Yellow

$buildGradle = "build.gradle"
$content = Get-Content $buildGradle -Raw
$content = $content.Replace("group = 'com.example'", "group = '$GroupId'")
$content = $content.Replace("rootProject.name = 'java'", "rootProject.name = '$ProjectName'")
$content = $content.Replace("targetClasses = ['com.example.app.*']", "targetClasses = ['$PackageName.*']")
$content = $content.Replace("targetTests = ['com.example.app.*']", "targetTests = ['$PackageName.*']")
Set-Content $buildGradle $content -NoNewline

Write-Host "  ✅ build.gradle updated" -ForegroundColor Green

# Step 3: Update settings.gradle
Write-Host "`n[3/6] Updating settings.gradle..." -ForegroundColor Yellow

$settingsGradle = "settings.gradle"
$content = Get-Content $settingsGradle -Raw
$content = $content.Replace("rootProject.name = 'java'", "rootProject.name = '$ProjectName'")
Set-Content $settingsGradle $content -NoNewline

Write-Host "  ✅ settings.gradle updated" -ForegroundColor Green

# Step 4: Update README.md
Write-Host "`n[4/6] Updating README.md..." -ForegroundColor Yellow

$readme = "README.md"
$content = Get-Content $readme -Raw

# Update package references
$content = $content.Replace("com/example/app", $newPackagePath)
$content = $content.Replace("com.example.app", $PackageName)

# Update GitHub badges if username provided
if ($GitHubUsername) {
    $content = $content.Replace("{username}/{repo}", "$GitHubUsername/$ProjectName")
    $content = $content.Replace("{your-repo}", "$GitHubUsername")
    $content = $content.Replace("{username}", $GitHubUsername)
    Write-Host "  ✓ Updated GitHub badges" -ForegroundColor Gray
} else {
    Write-Host "  ⚠️  GitHub username not provided - badges still have placeholders" -ForegroundColor Yellow
}

Set-Content $readme $content -NoNewline
Write-Host "  ✅ README.md updated" -ForegroundColor Green

# Step 5: Update other documentation
Write-Host "`n[5/6] Updating documentation..." -ForegroundColor Yellow

$docFiles = @(
    "SETUP.md",
    "docs/ARCHITECTURE.md"
)

foreach ($docFile in $docFiles) {
    if (Test-Path $docFile) {
        $content = Get-Content $docFile -Raw
        $content = $content.Replace("com.example.app", $PackageName)
        $content = $content.Replace("com/example/app", $newPackagePath)
        Set-Content $docFile $content -NoNewline
        Write-Host "  ✓ Updated $docFile" -ForegroundColor Gray
    }
}

Write-Host "  ✅ Documentation updated" -ForegroundColor Green

# Step 6: Remove example code (optional)
if ($RemoveExamples) {
    Write-Host "`n[6/6] Removing example code..." -ForegroundColor Yellow
    
    $exampleFiles = @(
        "src/main/java/$newPackagePath/Person.java",
        "src/main/java/$newPackagePath/Calculator.java",
        "src/main/java/$newPackagePath/StringUtils.java",
        "src/main/java/$newPackagePath/ExampleService.java",
        "src/test/java/$newPackagePath/PersonTest.java",
        "src/test/java/$newPackagePath/CalculatorTest.java",
        "src/test/java/$newPackagePath/StringUtilsTest.java",
        "src/test/java/$newPackagePath/ExampleServiceTest.java"
    )
    
    foreach ($file in $exampleFiles) {
        if (Test-Path $file) {
            Remove-Item $file -Force
            Write-Host "  ✓ Removed $(Split-Path -Leaf $file)" -ForegroundColor Gray
        }
    }
    
    Write-Host "  ✅ Example code removed" -ForegroundColor Green
} else {
    Write-Host "`n[6/6] Keeping example code (use -RemoveExamples to delete)" -ForegroundColor Yellow
}

# Clean up template-specific files
Write-Host "`n🧹 Cleaning up template files..." -ForegroundColor Cyan

$templateFiles = @(
    "docs/TEMPLATE_ENHANCEMENTS.md"
)

foreach ($file in $templateFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "  ✓ Removed $file" -ForegroundColor Gray
    }
}

# Success message
Write-Host @"

╔═══════════════════════════════════════════════════════════╗
║   ✅ Template Customization Complete!                     ║
╚═══════════════════════════════════════════════════════════╝

"@ -ForegroundColor Green

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host @"

1. 📝 Update JDK path in gradle.properties:
   org.gradle.java.home=C:/Program Files/Java/jdk-21

2. 🔨 Verify the build works:
   .\gradlew.bat clean build

3. 💻 Open in VS Code:
   code .

4. 🧪 Start coding with TDD:
   - Write tests in src/test/java/$newPackagePath/
   - Implement code in src/main/java/$newPackagePath/

"@ -ForegroundColor White

if (-not $GitHubUsername) {
    Write-Host "⚠️  Don't forget to update GitHub badges in README.md with your username!" -ForegroundColor Yellow
}

Write-Host "📖 For detailed setup, see: SETUP.md`n" -ForegroundColor Cyan

# Ask if user wants to delete this script
Write-Host "Delete this customization script? It's no longer needed. (Y/n): " -NoNewline -ForegroundColor Yellow
$deleteScript = Read-Host
if ($deleteScript -ne "n") {
    Remove-Item $PSCommandPath -Force
    Write-Host "✓ Deleted customize-template.ps1`n" -ForegroundColor Green
} else {
    Write-Host "✓ Kept customize-template.ps1 (you can delete it manually)`n" -ForegroundColor Gray
}

# Validate package name format
if ($PackageName -notmatch '^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)*$') {
    Write-Host "Error: Invalid package name format. Package name should be in the format 'com.example.project'" -ForegroundColor Red
    Write-Host "Package name should:" -ForegroundColor Yellow
    Write-Host "- Start with a lowercase letter" -ForegroundColor Yellow
    Write-Host "- Contain only lowercase letters, numbers, and dots" -ForegroundColor Yellow
    Write-Host "- Have no consecutive dots" -ForegroundColor Yellow
    Write-Host "- Each segment should start with a lowercase letter" -ForegroundColor Yellow
    exit 1
}

# Create package directories
$srcDirs = @(
    (Join-Path -Path $Destination -ChildPath "src\main\java\$newPackagePath"),
    (Join-Path -Path $Destination -ChildPath "src\test\java\$newPackagePath")
)
foreach ($dir in $srcDirs) {
    New-Item -ItemType Directory -Path $dir -Force | Out-Null
}

# Also handle test files
Get-ChildItem -Path (Join-Path -Path $Destination -ChildPath "src\test") -Recurse -File -Filter "*.java" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content.Replace("com.example.app", $PackageName)
    $content = $content.Replace("com.example", $GroupId)
    Set-Content $_.FullName $content -NoNewline

    if ($_.Directory.FullName.Contains($oldPackagePath)) {
        $relPath = $_.FullName.Substring($_.Directory.FullName.IndexOf($oldPackagePath) + $oldPackagePath.Length)
        $newPath = Join-Path $Destination "src" "test" "java" $newPackagePath $relPath
        Move-FileWithStructure -sourcePath $_.FullName -targetPath $newPath
    }
}

# Function to safely create parent directories and move a file
function Move-FileWithStructure {
    param (
        [string]$sourcePath,
        [string]$targetPath
    )
    
    $targetDir = Split-Path -Parent $targetPath
    if (!(Test-Path $targetDir)) {
        New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    }
    Move-Item -Path $sourcePath -Destination $targetPath -Force
}

# Update and move source files
Get-ChildItem -Path (Join-Path $Destination "src") -Recurse -File -Filter "*.java" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content.Replace("com.example.app", $PackageName)
    $content = $content.Replace("com.example", $GroupId)
    Set-Content $_.FullName $content -NoNewline
    
    if ($_.Directory.FullName.Contains($oldPackagePath)) {
        $relPath = $_.FullName.Substring($_.Directory.FullName.IndexOf($oldPackagePath) + $oldPackagePath.Length)
        $newPath = Join-Path $Destination "src" "main" "java" $newPackagePath $relPath
        Move-FileWithStructure -sourcePath $_.FullName -targetPath $newPath
    }
}

# Clean up empty directories
Get-ChildItem -Path (Join-Path $Destination "src") -Directory -Recurse |
    Where-Object { (Get-ChildItem $_.FullName -Recurse -File) -eq $null } |
    Sort-Object -Property FullName -Descending |
    Remove-Item -Force

# Update Checkstyle configuration with proper XML header
$checkstyleConfig = Join-Path -Path $Destination -ChildPath "config\checkstyle\checkstyle.xml"
$checkstyleContent = Get-Content $checkstyleConfig -Raw
if (!$checkstyleContent.StartsWith("<?xml")) {
    $newContent = @"
<?xml version="1.0"?>
<!DOCTYPE module PUBLIC
          "-//Checkstyle//DTD Checkstyle Configuration 1.3//EN"
          "https://checkstyle.org/dtds/configuration_1_3.dtd">
$checkstyleContent
"@
    Set-Content $checkstyleConfig $newContent -NoNewline
}

# Update build.gradle
Write-Host "Updating build configuration..." -ForegroundColor Cyan
$buildGradle = Join-Path $Destination "build.gradle"
$content = Get-Content $buildGradle -Raw
$content = $content.Replace("com.example", $GroupId)
Set-Content $buildGradle $content

# Update README badges
if ($GitHubUsername) {
    Write-Host "Updating README badges..." -ForegroundColor Cyan
    $readme = Join-Path $Destination "README.md"
    $content = Get-Content $readme -Raw
    $content = $content.Replace("{username}/{repo}", "$GitHubUsername/$ProjectName")
    Set-Content $readme $content
}

# Update license headers in source files
Write-Host "Updating license headers..." -ForegroundColor Cyan
$year = Get-Date -Format yyyy
Get-ChildItem -Path (Join-Path $Destination "src") -Recurse -File -Filter "*.java" | ForEach-Object {
    $content = Get-Content $_.FullName -Raw
    $content = $content.Replace("{Project Name}", $ProjectName)
    $content = $content.Replace("2025", $year)
    Set-Content $_.FullName $content -NoNewline
}

# Update NOTICE file
Write-Host "Updating NOTICE file..." -ForegroundColor Cyan
$noticeFile = Join-Path $Destination "NOTICE"
if (Test-Path $noticeFile) {
    $content = Get-Content $noticeFile -Raw
    if ($content.Contains("## Runtime Dependencies")) {
        $runtimeIndex = $content.IndexOf("## Runtime Dependencies")
        $content = "Third-Party Notices`n====================`n`nThis project ($ProjectName) uses the following third-party libraries and tools:`n`n" + $content.Substring($runtimeIndex)
        Set-Content $noticeFile $content -NoNewline
    }
}

# Update LICENSE
Write-Host "Setting up license..." -ForegroundColor Cyan
$licenseFile = Join-Path $Destination "LICENSE"
if ($License -ne "none") {
    $licenseContent = switch ($License) {
        "MIT" { 
@"
MIT License

Copyright (c) $(Get-Date -Format yyyy) $ProjectName

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"@
        }
        "Apache-2.0" { "[Apache License content...]" }
        "GPL-3.0" { "[GPL License content...]" }
    }
    Set-Content $licenseFile $licenseContent
}

# Initialize git repository if requested
if ($InitGit) {
    Write-Host "Initializing git repository..." -ForegroundColor Cyan
    Push-Location $Destination
    git init
    git add .
    git commit -m "chore: initial commit from Java project template"
    Pop-Location
}

# Cleanup template-specific files
Write-Host "Cleaning up template files..." -ForegroundColor Cyan
$templateFiles = @(
    "init-java-template.ps1",
    "TEMPLATE_ENHANCEMENTS.md"
)
foreach ($file in $templateFiles) {
    Remove-Item (Join-Path $Destination $file) -Force -ErrorAction SilentlyContinue
}

Write-Host "`nProject initialization complete!" -ForegroundColor Green
Write-Host "`nNext steps:"
Write-Host "1. cd $Destination"
Write-Host "2. Update JDK 21 path in:" -ForegroundColor Yellow
Write-Host "   • .vscode/settings.json (line 12)" -ForegroundColor White
Write-Host "   • gradle.properties (line 4)" -ForegroundColor White
Write-Host "3. Generate Eclipse project files (required for VS Code):" -ForegroundColor Yellow
Write-Host "   .\\gradlew.bat eclipse" -ForegroundColor Cyan
Write-Host "   (This works around a Gradle Build Server bug)" -ForegroundColor Gray
Write-Host "4. Open in VS Code and install recommended extensions:" -ForegroundColor Yellow
Write-Host "   • Extension Pack for Java" -ForegroundColor White
Write-Host "   • Lombok (vscjava.vscode-lombok)" -ForegroundColor White
Write-Host "5. Wait for Java Language Server to initialize (30-60 sec)" -ForegroundColor Yellow
Write-Host "6. Verify setup:" -NoNewline
Write-Host " .\\gradlew.bat clean build" -ForegroundColor Cyan
Write-Host "7. Start coding in" -NoNewline
Write-Host " src/main/java/$newPackagePath/" -ForegroundColor Yellow
Write-Host "`n📖 For detailed setup instructions, see SETUP.md" -ForegroundColor Cyan
Write-Host "`nAvailable Gradle tasks:"
Write-Host "  ./gradlew.bat build                    - Build with all checks (includes mutation testing)"
Write-Host "  ./gradlew.bat test                     - Run tests"
Write-Host "  ./gradlew.bat eclipse                  - Generate Eclipse IDE files for VS Code"
Write-Host "  ./gradlew.bat pitest                   - Run mutation testing"
Write-Host "  ./gradlew.bat spotbugsMain             - Run SpotBugs static analysis"
Write-Host "  ./gradlew.bat checkstyleMain           - Run Checkstyle on main code"
Write-Host "  ./gradlew.bat dependencyCheckAnalyze   - Run OWASP security scan"
Write-Host "  ./gradlew.bat jacocoTestReport         - Generate code coverage report"
Write-Host "  ./gradlew.bat javadoc                  - Generate Javadoc"

if ($InitGit) {
    Write-Host "`nGit repository initialized. You may want to:"
    Write-Host "1. Create a remote repository"
    Write-Host "2. Add the remote:" -NoNewline
    Write-Host " git remote add origin <repository-url>" -ForegroundColor Yellow
    Write-Host "3. Push the initial commit:" -NoNewline
    Write-Host " git push -u origin main" -ForegroundColor Yellow
}
