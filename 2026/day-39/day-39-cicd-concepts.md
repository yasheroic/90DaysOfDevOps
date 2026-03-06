## Challenge Tasks

### Task 1: The Problem

1. If all push code to same repo manually and deploy to production one thing which can happen is whose code should deploy to production first this becomes an issue

2. it works on my machine mean locally on the local system environment it works but as it reaches the production server it might have different OS or different version or diff dependencies and many other diff things so it might break on production

3. if there are many changes throughout the day then each time manually deploying is very much hectic

----

### Task 2: CI vs CD

1. **Continuous Integration** : What happened before was when a team of devs used to push code to a single repo there used to be conflicts and pushed only once during end of project so with introduction of *Continous Integration* devs push code timely and then the code build there and automated Unit tests runs which saves time and catches bugs before it reaches to the central repo

2. **Continuous Delivery**:
Continuous Integration (CI) focuses on automatically building and testing code changes in a shared repository to ensure stability. 

*Continuous Delivery (CD)* extends this by automatically deploying those tested changes to a staging or production environment, but requires manual approval to release to users. While CI handles integration and testing, CD handles the deployment pipeline. 

*Key Differences:*
Scope: CI focuses on code quality (build/test), whereas Continuous Delivery focuses on the release process (stage/deploy).
Automation: CI automates testing. Continuous Delivery automates testing and deployment to staging, but typically requires a human to trigger the final production push.

*Goal:* CI aims to detect bugs quickly. Continuous Delivery aims to ensure the software is always in a deployable state.
Relationship: CI is a prerequisite for Continuous Delivery. 

3. **Continuous Deployment** : Continous Deployment is different from Continous Delivery because in Delivery there needs to be manual approval before pushing to staging or prod environment but in Continous Deployment the deployment happens by itself no manual approval required

*Continuous Delivery:* Best for companies requiring manual checks or compliance, as it offers a safer, controlled release process.

*Continuous Deployment:* Ideal for agile teams, SaaS, and e-commerce platforms wanting to accelerate feedback loops and eliminate "release days".

---

Here’s a **simple real-life DevOps example** using a web application (like the projects you deploy with GitHub Actions).

---

# 1️⃣ Continuous Integration (CI)

**Goal:** Automatically **build and test code** whenever developers push changes.

### Real-life example

You push code to **GitHub**.

A pipeline using **GitHub Actions** runs automatically:

Steps:

* Install dependencies
* Run unit tests
* Run lint checks
* Build the application
* Create a Docker image

Example flow:

```
Developer pushes code → CI pipeline runs → tests pass/fail
```

If tests fail → merge is blocked.

📌 Example:
You push a new API feature → CI runs tests → bug detected → pipeline fails.

---

# 2️⃣ Continuous Delivery

**Goal:** Code is **automatically prepared for production**, but **deployment requires manual approval**.

### Real-life example

After CI succeeds:

1. Docker image is built
2. Image pushed to **Docker Hub**
3. App deployed automatically to **staging environment**

Production deployment still requires a **manual click**.

Flow:

```
Code push → CI tests → Build Docker image → Deploy to staging → Manual approval → Production
```

📌 Example:

Your website is deployed to:

```
staging.myapp.com
```

You test it → then press **"Deploy to production"**.

---

# 3️⃣ Continuous Deployment

**Goal:** Every successful change is **automatically deployed to production**.

No manual step.

### Real-life example

When CI passes:

```
Code push → tests pass → Docker image built → automatically deployed to production
```

Example stack:

* GitHub
* GitHub Actions
* Docker
* Kubernetes
* Cloud server

📌 Example:

You fix a typo on your website → push code →
Within **2 minutes the live website updates automatically**.

---

# ⚡ Simple Comparison

| Concept                   | What happens                                             |
| ------------------------- | -------------------------------------------------------- |
| **CI**                    | Code is automatically built and tested                   |
| **Continuous Delivery**   | Code is ready for production but needs manual deployment |
| **Continuous Deployment** | Code is automatically deployed to production             |

---

### Task 3: Pipeline Anatomy

| Component | Meaning                         |
| --------- | ------------------------------- |
| Trigger   | Event that starts pipeline      |
| Stage     | Major phase (build/test/deploy) |
| Job       | Work unit inside stage          |
| Step      | Single command                  |
| Runner    | Machine executing jobs          |
| Artifact  | Output produced                 |


### Task 4: Draw a Pipeline

Developer Push
      │
      ▼
Trigger (GitHub push event)
      │
      ▼
Stage 1 — Test
      │
      └── Job: run-tests
              ├─ Step: checkout code
              ├─ Step: install dependencies
              └─ Step: run tests

      ▼
Stage 2 — Build
      │
      └── Job: build-docker
              ├─ Step: checkout code
              ├─ Step: build Docker image
              └─ Step: push image to registry

      ▼
Stage 3 — Deploy
      │
      └── Job: deploy-staging
              ├─ Step: connect to server
              └─ Step: pull Docker image and run container

### Task 5: Explore in the Wild

1. React 
2. react/.github/workflows
/runtime_build_and_test.yml
3. runtime_build_and_test.yml
4. - push,pull req and workflow_dispatch
   -  10+
   - it builds and tests code