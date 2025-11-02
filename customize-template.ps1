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

Write-Host ""
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host "   Java 21 TDD Template Customization" -ForegroundColor Cyan
Write-Host "=================================================================" -ForegroundColor Cyan
Write-Host ""

# Validate we're in a git repository (likely cloned from GitHub)
if (-not (Test-Path ".git")) {
    Write-Host "WARNING: No .git directory found. This script should run in a cloned repository." -ForegroundColor Yellow
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
    Write-Host "ERROR: Invalid package name format: $PackageName" -ForegroundColor Red
    Write-Host ""
    Write-Host "Package name should:" -ForegroundColor Yellow
    Write-Host "  - Start with a lowercase letter" -ForegroundColor Yellow
    Write-Host "  - Contain only lowercase letters, numbers, and dots" -ForegroundColor Yellow
    Write-Host "  - Have no consecutive dots" -ForegroundColor Yellow
    Write-Host "  - Each segment should start with a lowercase letter" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Examples:" -ForegroundColor Yellow
    Write-Host "  GOOD: com.mycompany.app" -ForegroundColor Green
    Write-Host "  GOOD: org.example.project" -ForegroundColor Green
    Write-Host "  BAD:  Com.Example.App (uppercase)" -ForegroundColor Red
    Write-Host "  BAD:  com..example (double dot)" -ForegroundColor Red
    Write-Host ""
    exit 1
}

# Extract group ID from package name (e.g., com.mycompany.app -> com.mycompany)
$GroupId = ($PackageName -split '\.')[0..($PackageName.Split('.').Length - 2)] -join '.'
if ([string]::IsNullOrEmpty($GroupId)) {
    $GroupId = $PackageName  # Single-segment package
}

# Display configuration
Write-Host "Configuration:" -ForegroundColor White
Write-Host "  Project Name:    $ProjectName" -ForegroundColor White
Write-Host "  Package Name:    $PackageName" -ForegroundColor White
Write-Host "  Group ID:        $GroupId" -ForegroundColor White
if ($GitHubUsername) {
    Write-Host "  GitHub Username: $GitHubUsername" -ForegroundColor White
} else {
    Write-Host "  GitHub Username: (not provided - badges will have placeholders)" -ForegroundColor White
}
Write-Host "  Remove Examples:  $RemoveExamples" -ForegroundColor White
Write-Host ""

if (-not $Force) {
    $confirm = Read-Host "Proceed with customization? (Y/n)"
    if ($confirm -eq "n") {
        Write-Host "Aborted." -ForegroundColor Red
        exit 0
    }
}

Write-Host ""
Write-Host "Customizing template..." -ForegroundColor Cyan

# Step 1: Update package structure
Write-Host ""
Write-Host "[1/6] Updating package structure..." -ForegroundColor Yellow

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
        $oldPkgWin = "com\example\app"
        $oldPkgUnix = "com/example/app"
        
        Get-ChildItem -Path $baseDir -Recurse -File -Filter "*.java" | ForEach-Object {
            $content = Get-Content $_.FullName -Raw
            $content = $content.Replace("package com.example.app", "package $PackageName")
            $content = $content.Replace("import com.example.app", "import $PackageName")
            $content = $content.Replace('packages = "com.example.app"', "packages = `"$PackageName`"")
            Set-Content $_.FullName $content -NoNewline
            
            # Move file to new package directory
            if ($_.Directory.FullName.Contains($oldPkgWin) -or $_.Directory.FullName.Contains($oldPkgUnix)) {
                $fileName = $_.Name
                $newFilePath = Join-Path $newDir $fileName
                Move-Item -Path $_.FullName -Destination $newFilePath -Force
                Write-Host "  > Moved $fileName to $newPackagePath" -ForegroundColor Gray
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

Write-Host "  [DONE] Package structure updated" -ForegroundColor Green

# Step 2: Update build.gradle
Write-Host ""
Write-Host "[2/6] Updating build.gradle..." -ForegroundColor Yellow

$buildGradle = "build.gradle"
$content = Get-Content $buildGradle -Raw
$content = $content.Replace("group = 'com.example'", "group = '$GroupId'")
$content = $content.Replace("targetClasses = ['com.example.app.*']", "targetClasses = ['$PackageName.*']")
$content = $content.Replace("targetTests = ['com.example.app.*']", "targetTests = ['$PackageName.*']")
Set-Content $buildGradle $content -NoNewline

Write-Host "  [DONE] build.gradle updated" -ForegroundColor Green

# Step 3: Update settings.gradle
Write-Host ""
Write-Host "[3/6] Updating settings.gradle..." -ForegroundColor Yellow

$settingsGradle = "settings.gradle"
$content = Get-Content $settingsGradle -Raw
$content = $content.Replace("rootProject.name = 'java'", "rootProject.name = '$ProjectName'")
Set-Content $settingsGradle $content -NoNewline

Write-Host "  [DONE] settings.gradle updated" -ForegroundColor Green

# Step 4: Update README.md
Write-Host ""
Write-Host "[4/6] Updating README.md..." -ForegroundColor Yellow

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
    Write-Host "  > Updated GitHub badges" -ForegroundColor Gray
} else {
    Write-Host "  > GitHub username not provided - badges still have placeholders" -ForegroundColor Yellow
}

Set-Content $readme $content -NoNewline
Write-Host "  [DONE] README.md updated" -ForegroundColor Green

# Step 5: Update other documentation
Write-Host ""
Write-Host "[5/6] Updating documentation..." -ForegroundColor Yellow

$docFiles = @(
    "SETUP.md",
    "docs/ARCHITECTURE.md",
    ".github/dependabot.yml"
)

foreach ($docFile in $docFiles) {
    if (Test-Path $docFile) {
        $content = Get-Content $docFile -Raw
        $content = $content.Replace("com.example.app", $PackageName)
        $content = $content.Replace("com/example/app", $newPackagePath)
        if ($GitHubUsername -and $docFile -eq ".github/dependabot.yml") {
            $content = $content.Replace("{username}/{repo}", "$GitHubUsername/$ProjectName")
            $content = $content.Replace("{username}", $GitHubUsername)
            Write-Host "  > Updated dependabot.yml with GitHub username" -ForegroundColor Gray
        }
        Set-Content $docFile $content -NoNewline
        Write-Host "  > Updated $docFile" -ForegroundColor Gray
    }
}

Write-Host "  [DONE] Documentation updated" -ForegroundColor Green

# Step 6: Remove example code (optional)
if ($RemoveExamples) {
    Write-Host ""
    Write-Host "[6/6] Removing example code..." -ForegroundColor Yellow
    
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
            Write-Host "  > Removed $(Split-Path -Leaf $file)" -ForegroundColor Gray
        }
    }
    
    Write-Host "  [DONE] Example code removed" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "[6/6] Keeping example code (use -RemoveExamples to delete)" -ForegroundColor Yellow
}

# Clean up template-specific files
Write-Host ""
Write-Host "Cleaning up template files..." -ForegroundColor Cyan

$templateFiles = @(
    "docs/TEMPLATE_ENHANCEMENTS.md",
    "init-java-template.ps1"
)

foreach ($file in $templateFiles) {
    if (Test-Path $file) {
        Remove-Item $file -Force
        Write-Host "  > Removed $file" -ForegroundColor Gray
    }
}

# Success message
Write-Host ""
Write-Host "=================================================================" -ForegroundColor Green
Write-Host "   Template Customization Complete!" -ForegroundColor Green
Write-Host "=================================================================" -ForegroundColor Green
Write-Host ""

Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Update JDK path in gradle.properties:" -ForegroundColor White
Write-Host "   org.gradle.java.home=C:/Program Files/Java/jdk-21" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Verify the build works:" -ForegroundColor White
Write-Host "   .\gradlew.bat clean build" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Open in VS Code:" -ForegroundColor White
Write-Host "   code ." -ForegroundColor Gray
Write-Host ""
Write-Host "4. Start coding with TDD:" -ForegroundColor White
Write-Host "   - Write tests in src/test/java/$newPackagePath/" -ForegroundColor Gray
Write-Host "   - Implement code in src/main/java/$newPackagePath/" -ForegroundColor Gray
Write-Host ""

if (-not $GitHubUsername) {
    Write-Host "WARNING: Don't forget to update GitHub badges in README.md with your username!" -ForegroundColor Yellow
    Write-Host ""
}

Write-Host "For detailed setup, see: SETUP.md" -ForegroundColor Cyan
Write-Host ""

# Ask if user wants to delete this script
Write-Host "Delete this customization script? It is no longer needed. (Y/n): " -ForegroundColor Yellow -NoNewline
$deleteScript = Read-Host
Write-Host ""
if ($deleteScript -ne "n") {
    Remove-Item $PSCommandPath -Force
    Write-Host "Deleted customize-template.ps1" -ForegroundColor Green
} else {
    Write-Host "Kept customize-template.ps1 (you can delete it manually)" -ForegroundColor Gray
}
Write-Host ""
