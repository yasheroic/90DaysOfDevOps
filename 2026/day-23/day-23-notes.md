# Day 23 Notes: Git Branching & GitHub

## Understanding Branches

**Q: What is a branch in Git?**
- Independent line of development pointing to a specific commit
- Allows working on features without affecting main code

**Q: Why use branches instead of committing to main?**
- Isolate work → no breaking main code
- Multiple features in parallel
- Easy code review before merging
- Safe experimentation

**Q: What is HEAD?**
- Pointer to current commit/branch you're on
- Moves when you switch branches or commit

**Q: What happens to files when switching branches?**
- Files update to match that branch's state
- Changes must be committed or stashed first

## Branching Commands

```bash
git branch                    # List branches
git branch feature-1          # Create branch
git checkout feature-1        # Switch to it
git checkout -b feature-2     # Create & switch
git switch feature-x          # Modern way
git branch -d feature-x       # Delete
```

## Remote & Push

**Origin vs Upstream:**
- `origin`: Your fork/remote repo
- `upstream`: Original repo you forked from

```bash
git remote add origin URL
git push -u origin main
git push origin feature-1
```

## Fetch vs Pull

- `git fetch`: Download updates (no merge)
- `git pull`: Fetch + merge in one command

## Clone vs Fork

- **Clone**: Copy any repo locally (read-only unless yours)
- **Fork**: Copy repo to your GitHub account (own copy)
- **Keep fork synced**: Add upstream remote, `git fetch upstream`, `git rebase upstream/main`
