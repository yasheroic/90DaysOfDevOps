# Git Commands Reference

## Setup & Config
| Command | Purpose |
|---------|---------|
| `git config --global user.name "Name"` | Set user name |
| `git config --global user.email "email@example.com"` | Set email |
| `git config --list` | Show all settings |

## Basic Workflow
| Command | Purpose |
|---------|---------|
| `git init` | Initialize repo |
| `git status` | Show changes |
| `git add file` | Stage file |
| `git add .` | Stage all |
| `git commit -m "message"` | Commit changes |
| `git log` | View history |
| `git log --oneline` | Compact history |
| `git diff` | Show unstaged changes |
| `git diff --staged` | Show staged changes |

## Branching
| Command | Purpose |
|---------|---------|
| `git branch` | List branches |
| `git branch feature-x` | Create branch |
| `git checkout feature-x` | Switch branch |
| `git checkout -b feature-x` | Create & switch |
| `git switch feature-x` | Modern switch |
| `git branch -d feature-x` | Delete branch |

## Remote
| Command | Purpose |
|---------|---------|
| `git remote add origin URL` | Add remote |
| `git push -u origin main` | Push & track |
| `git push origin branch` | Push branch |
| `git pull` | Fetch & merge |
| `git fetch` | Download updates |
| `git clone URL` | Clone repo |

## Merging & Rebasing
| Command | Purpose |
|---------|---------|
| `git merge feature-x` | Merge branch |
| `git merge --squash feature-x` | Squash merge |
| `git rebase main` | Rebase on main |
| `git cherry-pick HASH` | Apply commit |

## Stash & Undo
| Command | Purpose |
|---------|---------|
| `git stash` | Save work |
| `git stash pop` | Apply & remove |
| `git stash apply` | Apply keep |
| `git reset --soft HEAD~1` | Undo commit |
| `git reset --hard HEAD~1` | Discard commit |
| `git revert HASH` | Create undo commit |

## GitHub CLI
| Command | Purpose |
|---------|---------|
| `gh auth login` | Authenticate |
| `gh repo create` | Create repo |
| `gh issue create` | Create issue |
| `gh pr create` | Create PR |
| `gh pr merge` | Merge PR |
| `gh search repos` | Search repos |
