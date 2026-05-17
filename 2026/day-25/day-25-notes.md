# Day 25 Notes: Git Reset vs Revert & Branching Strategies

## Git Reset Modes

| | `--soft` | `--mixed` | `--hard` |
|---|---|---|---|
| **What it does** | Undo commit, keep in staging | Undo commit & staging, keep files | Undo everything, delete changes |
| **Working files** | Unchanged | Updated | Deleted |
| **Staging area** | Has changes | Empty | Empty |
| **Destructive?** | No | No | **YES** |
| **Use when** | Wrong message | Redo commit | Discard all changes |

```bash
git reset --soft HEAD~1    # Keep changes staged
git reset --mixed HEAD~1   # Keep files, unstaged
git reset --hard HEAD~1    # Delete everything
```

## Git Revert vs Reset

| Aspect | Reset | Revert |
|--------|-------|--------|
| **What it does** | Moves branch pointer back | Creates NEW commit undoing changes |
| **History** | Removed | Preserved |
| **Safe for pushed?** | NO (rewrites history) | YES (safe) |
| **When to use** | Local-only mistakes | Shared branches |

```bash
git revert COMMIT_HASH    # Safe, creates undo commit
git reset --hard HASH     # Dangerous on shared code
```

## Branching Strategies

**GitFlow** (large teams, scheduled releases):
- main → release branches
- develop → feature branches
- Hotfix branches for emergency fixes
- Complex but structured

**GitHub Flow** (startups, continuous deployment):
- main only branch
- feature branches off main
- PR review before merge
- Simple, fast

**Trunk-Based Development** (fastest):
- Everyone commits to main
- Short-lived feature branches (hours)
- Continuous integration
- High discipline needed

**Best choice:**
- Startup → GitHub Flow (ship fast)
- Large team → GitFlow (structure)
- High maturity → Trunk-based (speed)
