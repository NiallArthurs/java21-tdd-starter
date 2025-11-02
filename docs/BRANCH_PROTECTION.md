# Branch Protection Setup

This document explains how to configure branch protection while allowing the auto-updating mutation coverage badge to work.

## The Challenge

The CI workflow includes an auto-update step that commits the mutation coverage badge to README.md. With branch protection enabled, this can fail because:

- Branch protection blocks direct pushes to master
- The workflow needs to commit badge updates
- Standard `GITHUB_TOKEN` cannot bypass branch protection rules

## Solution Options

### Option 1: Allow GitHub Actions to Bypass (Recommended)

**Best for:** Production repositories with branch protection

1. **Enable Branch Protection:**
   - Go to: Settings → Branches → Add branch protection rule
   - Branch name pattern: `master`
   - Enable:
     - ✅ Require pull request reviews before merging
     - ✅ Require status checks to pass before merging
     - ✅ Select: "Java CI" as required check
     - ✅ Require branches to be up to date before merging

2. **Allow GitHub Actions to Bypass:**
   - In the same branch protection settings
   - ✅ Enable: "Allow specified actors to bypass required pull requests"
   - Add: `github-actions[bot]` to the list
   
   **OR**
   
   - ✅ Enable: "Allow force pushes" → "Specify who can force push"
   - Add: `github-actions[bot]`

3. **Verify:**
   - Push to master
   - CI should commit badge update successfully
   - Badge updates without creating a PR

**Pros:**
- ✅ Branch protection enabled
- ✅ Badge auto-updates work
- ✅ All PRs still require review
- ✅ No manual intervention needed

**Cons:**
- ⚠️ GitHub Actions can bypass protection (acceptable for badge updates)

---

### Option 2: Disable Auto-Update, Keep Manual

**Best for:** Templates or projects without branch protection needs

1. **Remove the badge update step** from `.github/workflows/ci.yml`:
   - Delete lines 34-57 (the "Update Mutation Coverage Badge" step)

2. **Update badge manually** when mutation coverage changes:
   ```markdown
   <!-- In README.md, change the percentage manually -->
   [![Mutation Coverage](https://img.shields.io/badge/mutation%20coverage-95%25-brightgreen)]
   ```

3. **No branch protection conflicts**

**Pros:**
- ✅ No branch protection conflicts
- ✅ Simple workflow
- ✅ Full control over badge updates

**Cons:**
- ❌ Manual updates required
- ❌ Badge can become stale

---

### Option 3: Create PR for Badge Updates

**Best for:** Strict branch protection requirements

This modifies the workflow to create a pull request instead of direct push:

```yaml
- name: Update Mutation Coverage Badge
  if: github.ref == 'refs/heads/master' && github.event_name == 'push'
  uses: peter-evans/create-pull-request@v6
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    commit-message: 'chore: update mutation coverage badge to ${{ env.MUTATION_PERCENT }}%'
    branch: update-mutation-badge
    delete-branch: true
    title: 'chore: update mutation coverage badge'
    body: |
      Auto-generated PR to update mutation coverage badge.
      
      Mutation Coverage: ${{ env.MUTATION_PERCENT }}%
    labels: |
      automated
      documentation
```

**Implementation:**
1. Replace the current "Update Mutation Coverage Badge" step with the above
2. Badge updates create PRs instead of direct commits
3. Merge PRs manually or auto-merge with GitHub Actions

**Pros:**
- ✅ Respects branch protection fully
- ✅ Audit trail via PRs
- ✅ Can enable auto-merge for these PRs

**Cons:**
- ❌ Requires manual PR merges (unless auto-merge enabled)
- ❌ Badge updates delayed until PR merged
- ❌ More complex workflow

---

## Current Configuration

The template uses **Option 1 approach** with proper token handling:

```yaml
- uses: actions/checkout@v4
  with:
    token: ${{ secrets.GITHUB_TOKEN }}
    fetch-depth: 0

- name: Update Mutation Coverage Badge
  run: |
    # ... extract mutation percentage ...
    git push https://x-access-token:${{ secrets.GITHUB_TOKEN }}@github.com/${{ github.repository }}.git HEAD:master
```

**To enable this with branch protection:**
- Follow Option 1 steps above
- Allow `github-actions[bot]` to bypass required pull requests

---

## Testing Branch Protection

1. **Enable branch protection** (without allowing bypass)
2. **Push a change** to master
3. **Watch CI run** at: https://github.com/{your-username}/{your-repo}/actions

**Expected behavior:**
- ✅ Build passes
- ✅ Tests pass  
- ❌ Badge update fails: "protected branch hook declined"

**Fix:**
- Enable "Allow specified actors to bypass" for `github-actions[bot]`
- Re-run the workflow
- ✅ Badge update succeeds

---

## Recommendation

**For production use:** Choose **Option 1** (Allow GitHub Actions to bypass)

- Balances automation with protection
- Badge always stays current
- PRs still require review
- GitHub Actions is a trusted actor for badge updates

**For template repositories:** Keep **Option 1** (current default)

- Shows users how to configure it
- Template demonstrates working badge
- Users can switch to Option 2 if they prefer manual updates

**For maximum security:** Use **Option 3** (PR-based updates)

- Zero bypass of branch protection
- Full audit trail
- Slightly more complex workflow

---

## Disabling Auto-Update (Option 2)

If you prefer manual badge updates:

1. **Remove the step from CI:**
   ```bash
   # Edit .github/workflows/ci.yml
   # Delete the "Update Mutation Coverage Badge" step (lines 34-57)
   ```

2. **Update permissions:**
   ```yaml
   permissions:
     contents: read  # Change back from 'write'
   ```

3. **Update badge manually** when needed:
   ```markdown
   [![Mutation Coverage](https://img.shields.io/badge/mutation%20coverage-YOUR_PERCENTAGE%25-COLOR)]
   ```

4. **Commit the changes:**
   ```bash
   git add .github/workflows/ci.yml
   git commit -m "chore: disable auto-update of mutation badge"
   git push
   ```

---

## FAQ

### Q: Will this trigger infinite loops?

**A:** No. The commit message includes `[skip ci]` which prevents the workflow from running again on the badge update commit.

### Q: What if multiple commits happen quickly?

**A:** The badge update happens after build, so only the latest mutation coverage is reflected. This is desired behavior.

### Q: Can I change the badge update frequency?

**A:** Yes. Modify the `if:` condition:
```yaml
# Only update on tagged releases
if: github.ref == 'refs/heads/master' && startsWith(github.ref, 'refs/tags/')

# Only update on Mondays
if: github.ref == 'refs/heads/master' && contains(github.event.head_commit.message, '[update-badge]')
```

### Q: Does this work with forks?

**A:** No. Forks don't have write access to upstream repository. This only works on direct pushes to your repository.

---

## Summary

| Option | Branch Protection | Auto-Update | Manual Work | Best For |
|--------|------------------|-------------|-------------|----------|
| **1. Allow Bypass** | ✅ Enabled | ✅ Yes | ⚪ None | Production repos |
| **2. Manual Update** | ✅ Enabled | ❌ No | 🔴 High | Simple setups |
| **3. PR-Based** | ✅ Enabled | ⚪ Via PR | 🟡 Medium | Strict compliance |

**Recommended:** Option 1 for most users.
