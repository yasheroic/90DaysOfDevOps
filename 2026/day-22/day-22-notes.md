# Day 22 Notes: Git Basics

## Understanding Git Workflow

**Q: What is the difference between `git add` and `git commit`?**
- `git add`: Moves changes to staging area (tells Git what to include)
- `git commit`: Records staged changes to repo history permanently

**Q: What does the staging area do? Why not commit directly?**
- Staging area lets you control exactly which changes go in each commit
- Allows splitting logical changes across multiple commits
- Gives you time to review before committing

**Q: What information does `git log` show?**
- Commit hash (SHA-1)
- Author name and email
- Date and time
- Commit message
- Shows all commits in current branch

**Q: What is the .git/ folder?**
- Hidden directory containing entire repository data
- Contains objects, refs, commits, branches history
- Deleting it destroys all version control (but files remain)

**Q: Difference between working directory, staging area, repository?**
- **Working directory**: Your actual files on disk (modified state)
- **Staging area** (Index): Temporary holding area for next commit
- **Repository**: Actual stored commits (.git/)

## Basic Commands Used

```bash
git config --global user.name "Your Name"
git config --global user.email "email@example.com"
git init
git status
git add filename
git commit -m "message"
git log --oneline
git diff
```
