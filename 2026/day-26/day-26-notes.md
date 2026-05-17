# Day 26 Notes: GitHub CLI

## Authentication

**Supported methods:**
- OAuth token (web browser login)
- Personal access token (PAT)
- SSH key

```bash
gh auth login
gh auth status
```

## Repository Management

```bash
gh repo create my-repo --public      # Create repo
gh repo clone owner/repo              # Clone via gh
gh repo view owner/repo               # View details
gh repo list                          # List all repos
gh repo delete owner/repo             # Delete repo
gh browse                             # Open in browser
```

## Issues

```bash
gh issue create --title "Bug" --body "Description" --label "bug"
gh issue list
gh issue view 1
gh issue close 1
# Useful in scripts: Automate issue creation from monitoring alerts
```

## Pull Requests

```bash
gh pr create --title "Feature" --body "Description"
gh pr list
gh pr view 1
gh pr merge 1                         # Merge strategies: merge, squash, rebase
gh pr review                          # Review PR (approve, request changes)
```

**Merge methods:**
- `--merge`: Regular merge commit
- `--squash`: Combine all commits
- `--rebase`: Rebase on main

## GitHub Actions (Preview)

```bash
gh run list                           # Show workflow runs
gh run view RUN_ID                    # View specific run
# Useful in CI/CD: Check build status, trigger workflows
```

## Advanced Commands

```bash
gh api /repos/OWNER/REPO              # Raw API calls
gh gist create file.txt               # Create gist
gh release create v1.0 --notes "Release notes"
gh alias set pr-review "pr view"      # Create shortcuts
gh search repos --language=go         # Search repos
```

## Scripting

Use `--json` flag for machine-readable output:
```bash
gh pr list --json title,author,url
```
