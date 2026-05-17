# Day 24 Notes: Advanced Git

## Merge Strategies

**Fast-Forward Merge:**
- Happens when feature branch has no divergence from main
- Git simply moves main pointer forward
- Clean, linear history

**Merge Commit:**
- Created when both branches have new commits
- Preserves both branch histories
- Creates explicit merge point

**Merge Conflicts:**
- Occur when same line edited differently on two branches
- Must manually resolve by choosing which version to keep
- Use `git status` to see conflicts, edit files, then commit

```bash
git merge feature-login
git merge feature-signup
```

## Rebase vs Merge

**Rebase:**
- Replays commits from one branch onto another
- Creates linear history (no merge commits)
- Rewrites history (never on shared branches!)

**When to use:**
- Rebase: Local branches before pushing
- Merge: Shared/pushed branches (safe)

```bash
git rebase main
git log --oneline --graph --all  # Visualize
```

## Squash Merge

- Combines all commits into ONE commit
- Cleans up messy feature branch history
- Useful for keeping main clean
- Trade-off: Lose individual commit messages

```bash
git merge --squash feature-profile
```

## Stash

- Temporarily save uncommitted changes
- Switch branches, then apply back

```bash
git stash                          # Save
git stash list                     # View all
git stash pop                      # Apply & remove
git stash apply stash@{0}          # Apply specific
git stash pop vs apply: pop deletes, apply keeps
```

## Cherry Pick

- Apply single commit to current branch
- Useful for backporting fixes

```bash
git cherry-pick COMMIT_HASH
# Risk: Can cause conflicts or duplicate code
```
