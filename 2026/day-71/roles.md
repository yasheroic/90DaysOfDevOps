Good — this is the **turning point in Ansible**.
Till now you were writing playbooks. Now you’re moving to **production structure** 👇

---

# 🧠 1. Why Roles exist (problem first)

Your current setup:

```bash
install-nginx.yml
multi-play.yml
nginx-config.yml
```

👉 Works… but imagine:

* 50 servers
* 10 services
* 1000+ lines

👉 Everything becomes:

* messy ❌
* hard to reuse ❌
* hard to maintain ❌

---

# 🔥 Solution → **Roles**

👉 A **role = reusable, organized bundle of automation**

Think:

> Role = “pre-packaged setup for something”

---

## 🧠 Real-world analogy

| Thing    | Meaning                            |
| -------- | ---------------------------------- |
| Playbook | recipe                             |
| Role     | reusable module (like npm package) |

---

## 🧪 Example

Instead of writing nginx logic everywhere:

👉 You create a role:

```bash
webserver role
```

👉 Then just use:

```yaml
roles:
  - webserver
```

---

# ✅ 2. What a Role contains

This is the structure you saw:

```bash
roles/webserver/
```

Let’s simplify 👇

---

## 🔹 `tasks/main.yml`

👉 Main logic (what to do)

```yaml
Install nginx
Copy config
Start service
```

---

## 🔹 `handlers/main.yml`

👉 Restart services when needed

```yaml
Restart nginx
```

---

## 🔹 `templates/`

👉 Dynamic files (`.j2`)

```bash
nginx.conf.j2
```

---

## 🔹 `files/`

👉 Static files

```bash
index.html
```

---

## 🔹 `defaults/main.yml`

👉 Default values (LOW priority)

```yaml
http_port: 80
```

👉 Can be overridden easily

---

## 🔹 `vars/main.yml`

👉 Strong variables (HIGH priority)

```yaml
http_port: 8080
```

👉 Hard to override

---

## 🔥 Difference (VERY IMPORTANT)

| File     | Priority | Use               |
| -------- | -------- | ----------------- |
| defaults | LOW      | user can override |
| vars     | HIGH     | fixed values      |

---

## 🎯 Interview answer

> “defaults are meant for configurable values, while vars are used for fixed values with higher precedence.”

---

# 🚀 3. How to create a role

Run:

```bash
ansible-galaxy init roles/webserver
```

👉 This creates full structure automatically

---

## 📁 Example

```bash
roles/webserver/
  tasks/main.yml
  handlers/main.yml
  templates/
  files/
  vars/main.yml
  defaults/main.yml
```

---

# 🔥 4. How to use a role

Instead of writing tasks:

```yaml
tasks:
  - install nginx
```

👉 You do:

```yaml
- name: Configure web servers
  hosts: web
  roles:
    - webserver
```

👉 Ansible automatically runs:

* tasks/main.yml
* handlers
* templates

---

# 🧠 5. What is Ansible Galaxy?

👉 Think:

> Galaxy = npm / pip for Ansible roles

---

## 🔹 It gives you ready-made roles

Example:

```bash
ansible-galaxy install geerlingguy.docker
```

👉 Now you don’t write Docker setup yourself

---

## 🔹 Use it like:

```yaml
roles:
  - geerlingguy.docker
```

👉 Done. Docker installed.

---

# 🔥 Why Galaxy is powerful

* Saves time
* Industry-standard configs
* Reusable

---

# 🧠 6. requirements.yml (important)

Instead of installing manually:

```yaml
roles:
  - name: geerlingguy.docker
  - name: geerlingguy.nginx
```

Install all:

```bash
ansible-galaxy install -r requirements.yml
```

---

# 🧠 7. Big picture (THIS is key)

Before:

```bash
playbooks → everything inside
```

After:

```bash
playbooks → call roles
roles → contain logic
```

---

# 🎯 Real-world architecture

```bash
ansible-practice/
  roles/
    webserver/
    database/
  playbooks/
    site.yml
```

👉 `site.yml` = orchestrator
👉 roles = actual work

---

# 🧠 Final mental model

👉 Playbook = “what to run”
👉 Role = “how to do it”

---

# 🎯 Interview-level answer

> “Roles are a structured way to organize reusable automation in Ansible, separating tasks, variables, templates, and handlers. Ansible Galaxy is a repository of reusable roles that helps avoid reinventing common configurations.”

---

# ✅ TL;DR

* Role = reusable automation unit
* Galaxy = marketplace for roles
* defaults → low priority
* vars → high priority
* Playbook calls roles

---

If you want next:
👉 I can help you **build your first webserver role step-by-step (with your current setup)** — that’s where it clicks 100%.
