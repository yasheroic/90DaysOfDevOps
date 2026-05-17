## Challenge Tasks

### Task 1: Self-Assessment Checklist

 #### Linux
- [✅] Navigate the file system, create/move/delete files and directories
- [✅] Manage processes — list, kill, background/foreground
- [✅] Work with systemd — start, stop, enable, check status of services
- [✅] Read and edit text files using vi/vim or nano
- [✅] Troubleshoot CPU, memory, and disk issues using top, free, df, du
- [✅] Explain the Linux file system hierarchy (/, /etc, /var, /home, /tmp, etc.)
- [✅] Create users and groups, manage passwords
- [✅] Set file permissions using chmod (numeric and symbolic)
- [✅] Change file ownership with chown and chgrp
- [✅] Create and manage LVM volumes
- [✅] Check network connectivity — ping, curl, netstat, ss, dig, nslookup
- [✅] Explain DNS resolution, IP addressing, subnets, and common ports

#### Shell Scripting
- [✅] Write a script with variables, arguments, and user input
- [✅] Use if/elif/else and case statements
- [✅] Write for, while, and until loops
- [✅] Define and call functions with arguments and return values
- [✅] Use grep, awk, sed, sort, uniq for text processing
- [✅] Handle errors with set -e, set -u, set -o pipefail, trap
- [✅] Schedule scripts with crontab

#### Git & GitHub
- [✅] Initialize a repo, stage, commit, and view history
- [✅] Create and switch branches
- [✅] Push to and pull from GitHub
- [✅] Explain clone vs fork
- [✅] Merge branches — understand fast-forward vs merge commit
- [✅] Rebase a branch and explain when to use it vs merge
- [✅]Use git stash and git stash pop
- [✅] Cherry-pick a commit from another branch
- [✅] Explain squash merge vs regular merge
- [✅] Use git reset (soft, mixed, hard) and git revert
- [✅] Explain GitFlow, GitHub Flow, and Trunk-Based Development
- [✅] Use GitHub CLI to create repos, PRs, and issues

---

### Task 2: Revisit Your Weak Spots

- Done

### Task 3: Quick-Fire Questions

1. Gives rwx to owner and read and execute(r_x)to user and group
2. every file in linux is a procees
3. lsof -i 8080
4. if a script fails at any step it stops
5. 
6. 
7. while switching to other branches we use git stash
8. cron job
9. it just gets the branches
10. 


Your answers are partially correct, but a few are inaccurate/incomplete. Here’s the corrected version:

---

## 1. What does `chmod 755 script.sh` do?

Your answer:

> Gives rwx to root and read and execute(r_x)to user and group

Correction:

* `755` means:

  * Owner: `rwx` (7)
  * Group: `r-x` (5)
  * Others: `r-x` (5)

So:

```bash
chmod 755 script.sh
```

gives:

* owner full permissions
* everyone else read + execute only

Equivalent:

```bash
rwxr-xr-x
```

Your concept was correct, but:

* “root” should be “owner”
* “user and group” should be “group and others”

Verified. ([SSD Nodes][1])

---

## 2. What is the difference between a process and a service?

Your answer:

> every file in linux is a procees

This is incorrect.

Correct answer:

* **Process** = a running instance of a program
  Example:

  ```bash
  python app.py
  ```
* **Service** = a background process managed by the OS (usually systemd)
  Example:

  * nginx
  * docker
  * sshd

A service usually:

* starts automatically
* runs in background
* can restart automatically

---

## 3. How do you find which process is using port 8080?

Your answer:

```bash
lsof -i 8080
```

Almost correct.

Better:

```bash
lsof -i :8080
```

Or:

```bash
sudo lsof -iTCP:8080 -sTCP:LISTEN
```

Also common:

```bash
netstat -tulpn | grep 8080
```

---

## 4. What does `set -euo pipefail` do in a shell script?

Your answer:

> if a script fails at any step it stops

Partially correct.

Full explanation:

```bash
set -euo pipefail
```

* `-e` → exit immediately if command fails
* `-u` → error on undefined variables
* `-o pipefail` → pipeline fails if any command fails

Example:

```bash
cat file.txt | grep hello | sort
```

Normally only last command matters.
With `pipefail`, failure anywhere fails script.

---

## 5. What is the difference between `git reset --hard` and `git revert`?

You left blank.

Correct answer:

### `git reset --hard`

* moves HEAD backward
* deletes commits locally
* changes history
* dangerous in shared branches

Example:

```bash
git reset --hard HEAD~1
```

### `git revert`

* creates a new commit that undoes previous commit
* safe for shared/public branches
* preserves history

---

## 6. What branching strategy would you recommend for a team of 5 developers shipping weekly?

Blank.

Good interview-style answer:

For a small team shipping weekly:

* use **GitHub Flow** or simplified **Git Flow**
* `main` = production-ready
* create feature branches:

  ```bash
  feature/login-page
  ```
* open PRs
* code review
* merge into main
* CI/CD deploys automatically

For weekly shipping, GitHub Flow is simpler and faster.

---

## 7. What does `git stash` do and when would you use it?

Your answer:

> while switching to other branches we use git stash

Correct idea.

Better wording:

* temporarily saves uncommitted changes
* cleans working directory
* useful when:

  * switching branches
  * pulling changes
  * handling urgent fixes

Commands:

```bash
git stash
git stash pop
```

---

## 8. How do you schedule a script to run every day at 3 AM?

Your answer:

> cron job

Correct but incomplete.

Example:

```bash
crontab -e
```

Add:

```bash
0 3 * * * /path/script.sh
```

---

## 9. What is the difference between `git fetch` and `git pull`?

Your answer:

> it just gets the branches

Partially correct.

Correct answer:

### `git fetch`

* downloads latest changes
* does NOT merge

### `git pull`

* fetch + merge

Equivalent:

```bash
git pull = git fetch + git merge
```

---

## 10. What is LVM and why would you use it instead of regular partitions?

Blank.

Correct answer:

LVM = Logical Volume Manager

It provides flexible disk management.

Advantages over normal partitions:

* resize volumes dynamically
* extend storage without repartitioning
* snapshots
* combine multiple disks into one logical volume

Useful in:

* servers
* cloud VMs
* production systems

---

### Task 4: Organize Your Work

- Done

---

### Task 5: Teach It Back

## Understanding Git Branching

Git branching allows developers to work on different features or fixes without affecting the main project code. Think of it like creating a copy of your notebook before trying new changes. If something breaks, your original notebook is still safe.

The `main` branch usually contains stable production-ready code. Developers create separate branches like `feature-login` or `bugfix-navbar` to work independently. Once the work is completed and tested, the branch is merged back into the main branch.

Branching helps teams collaborate safely, avoid conflicts, and develop multiple features simultaneously. It is one of the most important concepts in Git and modern software development.

---