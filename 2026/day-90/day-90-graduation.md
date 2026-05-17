# Day 90 - Graduation: The Complete DevOps Journey

## Overview

90 days. From `ls` to AI-powered self-healing Kubernetes agents. Today I step back, connect every block, reflect on the entire journey, and map what comes next.


---

## The Full 90-Day Timeline

### Week 1-2: Linux Fundamentals (Days 1-13)
- Commands, processes, files, permissions, LVM
- Foundation: Every DevOps tool runs on Linux

### Week 3: Networking (Days 14-15)
- DNS, IP, subnets, ports
- How machines talk to each other

### Week 4: Shell Scripting (Days 16-21)
- Bash basics, functions, projects
- Automating what you'd otherwise type by hand

### Week 5: Git & GitHub (Days 22-28)
- Branching, advanced git, GitHub CLI
- Version control: The backbone of everything that follows

### Week 6-7: Docker (Days 29-37)
- Images, Dockerfile, volumes, networking, Compose, multi-stage builds
- Packaging applications so they run the same everywhere

### Week 8-9: CI/CD & GitHub Actions (Days 38-49)
- YAML, workflows, triggers, runners, secrets, DevSecOps
- Automating build, test, and deploy on every push

### Week 10-12: Kubernetes (Days 50-58)
- Pods, Deployments, Services, Namespaces, RBAC
- Orchestrating containers at scale

### Week 13-15: Terraform (Days 59-67)
- Infrastructure as Code, providers, state, modules, workspaces
- Provisioning cloud resources declaratively

### Week 16: Ansible (Days 68-72)
- Inventory, playbooks, roles, templates, Vault
- Configuration management, keeping servers in desired state

### Week 17: Observability (Days 73-77)
- Prometheus, Grafana, Loki, Promtail, OpenTelemetry, alerting
- The three pillars: metrics, logs, traces

### Week 18-19: Helm (Days 78-80)
- Charts, templates, values, subcharts, multi-env deployment
- Package manager for Kubernetes

### Week 20: Amazon EKS (Days 81-83)
- Terraform for EKS, Gateway API, EBS storage, IRSA, HPA
- Production-grade managed Kubernetes on AWS

### Week 21: ArgoCD & GitOps (Days 84-86)
- GitOps principles, ArgoCD, sync strategies, App of Apps, CI/CD pipeline
- Git is the single source of truth

### Week 22: Agentic AI for DevOps (Days 87-89)
- LLM agents, ReAct pattern, MCP, KubeHealer, Temporal
- AI that diagnoses and fixes infrastructure autonomously

### Week 22: Graduation (Day 90)
- Connecting all blocks
- Reflecting on the journey

---

## The End-to-End Pipeline

### Trace: From Code Commit to Production Monitoring

```
1. Developer writes code on Linux machine (Days 1-13)
   using shell scripts (Days 16-21) and Git (Days 22-28)

2. Developer pushes to GitHub
   ↓

3. GitHub Actions triggered (Days 40-49)
   - Runs tests
   - Builds Docker image (Days 29-37)
   - Pushes to DockerHub
   - Updates Kubernetes manifest with new image tag

4. ArgoCD (Days 84-86) detects the change in Git
   ↓

5. Syncs to EKS cluster (Days 81-83)
   - Cluster provisioned by Terraform (Days 59-67)
   - Configured by Ansible (Days 68-72)

6. Helm (Days 78-80) manages deployment
   - Uses environment-specific values
   - One chart, multiple environments

7. Kubernetes (Days 50-58) orchestrates containers
   - Deploys the new image
   - Manages Services, Ingress, RBAC

8. Prometheus, Grafana, Loki (Days 73-77) monitor
   - Metrics: CPU, memory, requests
   - Logs: Application logs, system logs
   - Traces: Request flow across services

9. If something breaks...
   - AI agent (Days 87-89) diagnoses autonomously
   - Identifies root cause
   - Proposes fix
   - Applies fix with human approval

10. Fix goes through Git
    ↓
    ArgoCD syncs
    ↓
    Cycle repeats
```

**Every single block connects. Nothing learned in isolation.**

---

## The AI-BankApp: Real-World Integration

### Days 78-86: Helm, EKS, GitOps Integration

| Day | Task | What You Did |
|-----|------|-------------|
| 78 | Deploy dependencies | Deployed MySQL via Helm chart |
| 79 | Chart creation | Converted 12 raw K8s manifests into a Helm chart |
| 80 | Multi-environment | Created dev/staging/prod values, hooks, CI/CD integration |
| 81 | Infrastructure | Provisioned EKS using Terraform configs |
| 82 | Storage & Gateway | Set up Gateway API, EBS storage, session persistence |
| 83 | Full production | Deployment with monitoring and auto-scaling |
| 84 | GitOps | Deployed via ArgoCD |
| 85 | Advanced GitOps | Added sync waves, App of Apps, RBAC |
| 86 | End-to-end CI/CD | Wired GitHub Actions pipeline for complete automation |

**One real-world application. Every tool applied to it.**

---

## Skills Self-Assessment

Rate yourself honestly on each skill (1-5 scale):

| Skill | Days | Confidence |
|-------|------|-----------|
| Linux command line | 1-13 | 4/5 |
| Shell scripting | 16-21 | 3/5 |
| Git & GitHub | 22-28 | 4/5 |
| Docker | 29-37 | 4/5 |
| CI/CD (GitHub Actions) | 38-49 | 4/5 |
| Kubernetes | 50-58 | 3.5/5 |
| Terraform | 59-67 | 3.5/5 |
| Ansible | 68-72 | 3.5/5 |
| Observability (Prometheus, Grafana, Loki) | 73-77 | 3/5 |
| Helm | 78-80 | 3/5 |
| Amazon EKS | 81-83 | 3/5 |
| ArgoCD / GitOps | 84-86 | 3/5 |
| Agentic AI for DevOps | 87-89 | 4/5 |

**For anything below 3:** Go back and redo that block. The day folders are still there.

---

## Top 5 Aha Moments

### 1. Containerization Changes Everything (Days 29-37)
**Realization:** Once you Docker-ify an app, infrastructure becomes irrelevant. "It runs on my laptop" becomes literally true everywhere -- staging, production, CI. The entire orchestration problem below disappears.

### 2. Infrastructure as Code Is Liberation (Days 59-67)
**Realization:** Writing Terraform felt slow at first. But then: 1) version control your infrastructure 2) see exact diffs of what will change 3) destroy and recreate entire environments in minutes. Manual clicking in the console becomes visibly primitive.

### 3. Kubernetes Is Just a Database (Days 50-58)
**Realization:** Pods, Services, Deployments are not magical. They're resources with state, stored in etcd, queried and modified via kubectl (the API client). Once you stop seeing it as a black box and understand it's just a declarative database, everything clicks.

### 4. Observability Is Not Optional (Days 73-77)
**Realization:** You cannot operate what you cannot see. Prometheus metrics + Grafana dashboards + Loki logs + traces = the difference between "It's broken" and "here's exactly where it broke and why." This is non-negotiable for production systems.

### 5. AI Doesn't Replace Operators, It Amplifies Them (Days 87-89)
**Realization:** The agent doesn't take your job. It handles routine diagnostics (image typo, OOM, stuck pod) so you can focus on architecture. The guardrails (approval, scope limits, audit trails) mean the agent is your assistant, not your replacement.

---

## The Hardest Day and How I Pushed Through

### Kubernetes (Days 50-58): The Hardest Block

**Why it was hard:**
- Completely new mental model (declarative, state-driven)
- Debugging is opaque (logs in containers, events in cluster)
- One mistake breaks the entire cluster
- YAML is fiddly and error-prone
- Networking is complex (Services, Ingress, DNS)

**How I pushed through:**
1. Started with a single Pod - understood the absolute basics
2. Drew architecture diagrams - visualized what was happening
3. Broke things intentionally - crashed pods, deleted Services, watched what happened
4. Read the output carefully - kubectl describe is your friend
5. Used Kind for safe experimentation - can nuke and recreate cluster in seconds
6. Revisited Day 50 multiple times - repetition builds confidence

**The breakthrough:** Once I understood that Kubernetes is just "declare desired state, let the controller loop make it happen," everything else (Deployments, StatefulSets, Ingress) followed naturally.

---

## Complete Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                         DEVELOPER WORKFLOW                       │
│                                                                  │
│  1. Write code                                                   │
│  2. Commit & Push to GitHub                                     │
│  3. GitHub Actions CI/CD triggered                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      CI/CD PIPELINE                              │
│                   (GitHub Actions - Days 40-49)                 │
│                                                                  │
│  • Run tests                                                    │
│  • Build Docker image (Days 29-37)                             │
│  • Push to DockerHub                                           │
│  • Update manifest with new tag                                │
│  • Commit updated manifest to Git                              │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      GIT REPOSITORY                              │
│               (Git & GitHub - Days 22-28)                       │
│                    Single Source of Truth                        │
│          (Code + Manifests + Helm Values + Terraform)          │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌─────────────────────────────────────────────────────────────────┐
│                      ARGOCD & GITOPS                             │
│                   (ArgoCD - Days 84-86)                         │
│                                                                  │
│  • Watch Git for changes                                       │
│  • Sync to Kubernetes cluster                                  │
│  • App of Apps pattern for multi-env                           │
│  • RBAC for fine-grained control                               │
└─────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                           │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │          AWS (Provisioned by Terraform - Days 59-67)       │ │
│  │                                                             │ │
│  │  ┌──────────────────────────────────────────────────────┐ │ │
│  │  │     EKS Cluster (Days 81-83)                         │ │ │
│  │  │                                                      │ │ │
│  │  │  ┌────────────────────────────────────────────────┐ │ │ │
│  │  │  │   Kubernetes (Days 50-58)                     │ │ │ │
│  │  │  │                                                │ │ │ │
│  │  │  │  ┌──────────────────────────────────────────┐ │ │ │ │
│  │  │  │  │  Pods & Deployments (Docker - Days 29-37)│ │ │ │ │
│  │  │  │  │  - AI-BankApp                            │ │ │ │ │
│  │  │  │  │  - MySQL                                 │ │ │ │ │
│  │  │  │  │  - Redis                                 │ │ │ │ │
│  │  │  │  └──────────────────────────────────────────┘ │ │ │ │
│  │  │  │                                                │ │ │ │
│  │  │  │  Helm Charts (Days 78-80) manage all of it    │ │ │ │
│  │  │  │  - dev/staging/prod values                    │ │ │ │
│  │  │  │  - Template rendering                         │ │ │ │
│  │  │  │  - Multi-environment deployment               │ │ │ │
│  │  │  │                                                │ │ │ │
│  │  │  │  Services & Ingress (Days 50-58)              │ │ │ │
│  │  │  │  - ClusterIP for internal comms               │ │ │ │
│  │  │  │  - Gateway API for external access            │ │ │ │
│  │  │  │                                                │ │ │ │
│  │  │  │  RBAC (Days 50-58)                            │ │ │ │
│  │  │  │  - Role-based access control                  │ │ │ │
│  │  │  │  - ServiceAccounts & ClusterRoles             │ │ │ │
│  │  │  └──────────────────────────────────────────────┘ │ │ │ │
│  │  │                                                      │ │ │
│  │  │  Persistent Storage (EBS - Days 81-83)              │ │ │
│  │  │  - StatefulSets for MySQL                           │ │ │
│  │  │  - PersistentVolumes & PersistentVolumeClaims      │ │ │
│  │  └──────────────────────────────────────────────────┘ │ │ │
│  │                                                        │ │ │
│  │  Networking (EC2, VPC, Security Groups)               │ │ │
│  │  - Configured by Terraform and Ansible               │ │ │
│  └────────────────────────────────────────────────────┘ │ │
│                                                           │ │
│  Configuration Management (Ansible - Days 68-72)         │ │
│  - Keep servers in desired state                          │ │
│  - Secrets management (Vault)                             │ │
│  - Playbooks and roles                                    │ │
└──────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│                    OBSERVABILITY LAYER                            │
│                  (Days 73-77)                                     │
│                                                                   │
│  Metrics (Prometheus)          Logs (Loki)      Traces (OTel)   │
│  - CPU, Memory, Requests       - App logs       - Request flow   │
│  - Pod restarts                - System logs    - Latency        │
│  - Network I/O                 - Error traces   - Dependencies   │
│         ↓                             ↓              ↓            │
│    Grafana Dashboards          Grafana Explore  OpenTelemetry UI │
│    - Visualizations            - Log searches   - Traces UI      │
│    - Alerts & thresholds       - Aggregation    - Spans          │
└──────────────────────────────────────────────────────────────────┘
                              ↓
┌──────────────────────────────────────────────────────────────────┐
│                    AGENTIC AI LAYER                               │
│                   (Days 87-89)                                    │
│                                                                   │
│  ┌────────────────────────────────────────────────────────────┐ │
│  │  AI Agent (KubeHealer with Temporal)                       │ │
│  │                                                             │ │
│  │  1. Monitor: Scan for broken pods                          │ │
│  │  2. Diagnose: Query kubectl describe, read events         │ │
│  │  3. Reason: Send to Claude for root cause analysis        │ │
│  │  4. Propose: Generate fixes                               │ │
│  │  5. Approve: Wait for human signal                         │ │
│  │  6. Fix: Apply patches (kubectl patch)                    │ │
│  │  7. Verify: Confirm pods are now healthy                 │ │
│  │  8. Audit: Log everything in Temporal                     │ │
│  │                                                             │ │
│  │  Tools: list_pods, describe_pod, get_events               │ │
│  │         get_logs, list_containers, patch_pod              │ │
│  │                                                             │ │
│  │  Protocol: MCP (Model Context Protocol)                   │ │
│  │  - Tools accessible via Claude, VS Code, etc.             │ │
│  │  - Durable execution via Temporal                         │ │
│  │  - Crash recovery, audit trail                            │ │
│  └────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────┘
```

---

## What Comes Next

### Deepen What You Learned

**Kubernetes:**
- Multi-cluster Kubernetes (federation, fleet management)
- Service mesh (Istio, Linkerd)
- Operators (custom controllers)
- Admission webhooks

**Infrastructure:**
- Advanced Terraform (custom providers, Terragrunt, drift detection)
- Secrets management (HashiCorp Vault, AWS Secrets Manager, External Secrets Operator)
- Terraform Cloud/Enterprise

**Operations:**
- Database operations (backups, migrations, blue-green deployments)
- Chaos engineering (Litmus, Chaos Monkey)
- FinOps (cloud cost optimization)
- Disaster recovery planning

**AI & Observability:**
- Extend agents to auto-fix based on Prometheus alerts
- Build agents for cost optimization
- Create agents that suggest infrastructure improvements
- Train custom LLMs on your operational runbooks

### Certifications Worth Pursuing

- **AWS Certified Solutions Architect** - validates cloud architecture knowledge
- **Certified Kubernetes Administrator (CKA)** - validates Kubernetes expertise
- **Certified Kubernetes Application Developer (CKAD)** - validates app deployment on K8s
- **HashiCorp Terraform Associate** - validates IaC knowledge
- **GitHub Actions Certification** - validates CI/CD automation

### Build a Portfolio Project

Take everything from days 78-89 and build from scratch for your own application:

```
1. Write an app (any language you choose)
2. Dockerize it (multi-stage build, optimized image)
3. Create a Helm chart (dev/staging/prod values)
4. Provision EKS with Terraform (3 subnets, security groups, etc.)
5. Deploy with ArgoCD (GitOps workflow)
6. Monitor with Prometheus + Grafana (dashboards, alerts)
7. Set up full CI/CD pipeline (GitHub Actions -> Docker -> ArgoCD)
8. Add AI agent for troubleshooting (custom diagnostics)
```

**Put it on GitHub.** Write a blog post. Share on LinkedIn. This becomes your proof.

---

## Personal Journey Reflection

### The Transformation

**90 days ago:**
- Linux commands felt mysterious
- `docker run` was a black box
- Kubernetes seemed impossibly complex
- Infrastructure was manual clicking in AWS console
- No observability = flying blind

**Today:**
- Linux is a comfortable home (pipes, redirection, permissions flow naturally)
- Docker is understood end-to-end (from Dockerfile to multi-stage builds)
- Kubernetes is just a declarative database with a control loop
- Infrastructure is code (reproducible, version-controlled, testable)
- Observability is foundational (I know what's happening)
- AI agents are accessible (not sci-fi, just CLI wrappers + reasoning)

### What This 90-Day Block Taught Me

1. **Patterns matter more than tools.** The specific version of Kubernetes, Terraform, or Prometheus will change. But "declare desired state, let the controller reconcile" is universal.

2. **Composability is power.** Each block (Linux, Docker, Kubernetes) builds on the previous. By Day 90, you're not using 13 separate tools -- you're using one integrated pipeline.

3. **Debugging skills transfer.** Once you understand how to read logs, describe errors, check events in Kubernetes, you can apply that to any system.

4. **Automation scales beyond code.** Infrastructure as Code, GitOps, AI agents -- these all share one principle: humans describe intent, systems execute it.

5. **Production readiness requires discipline.** Observability, audit trails, approval workflows, rollback capability -- these aren't nice-to-haves. They're non-negotiable for infrastructure you care about.

---

## My Advice for Day 1 Practitioners

### Month 1 (Days 1-30): Build Comfort with Basics

- Linux: Don't memorize commands, understand the mental model (files, permissions, processes)
- Shell: Write one useful script per day (even tiny ones)
- Git: Use it for everything, including practice files
- Docker: Build images for everything, understand layers

**Key mindset:** It's okay to feel lost. That's the learning process.

### Month 2 (Days 31-60): Connect the Blocks

- CI/CD: See code flow from commit to production
- Kubernetes: Run apps in containers at scale
- Terraform: Stop clicking consoles manually
- Ansible: Automate configuration

**Key mindset:** Each block doesn't live in isolation -- they reinforce each other.

### Month 3 (Days 61-90): Production Thinking

- Observability: You cannot operate what you cannot see
- Helm: Package and deploy consistently
- EKS: Run real cloud infrastructure
- ArgoCD: Make Git your single source of truth
- AI: Automate the mundane diagnosis work

**Key mindset:** Production isn't about perfection -- it's about visibility, repeatability, and recovery.

### General Advice

1. **Type every command.** Copy-pasting bypasses learning. Muscle memory matters.
2. **Break things intentionally.** Kill pods, delete Services, corrupt configs. See what happens.
3. **Draw architecture diagrams.** Visualizing connections cements understanding.
4. **Blog as you go.** Explaining to others forces clarity.
5. **Join communities.** Reddit's r/kubernetes, the CNCF Slack, Twitter. Other learners matter.
6. **Celebrate small wins.** Your first Helm deployment, your first successful ArgoCD sync, your first working agent -- these deserve recognition.

---

## The End-to-End Insight

**The real learning isn't any single tool. It's this:**

A developer makes a code change. That change flows through Git to GitHub to CI/CD to Docker to Kubernetes to monitoring. If something breaks, an AI agent diagnoses it. If you need to add capacity, Terraform adds it. If you need to roll back, ArgoCD does it. The entire system is declarative, observable, and automated.

This is modern DevOps. This is what you learned in 90 days.

---

## Thank You

To Shubham and TrainWithShubham for creating this challenge. To the community for support and encouragement. To everyone who shared their journey on LinkedIn and helped others learn.

And to you, Day 1 person reading this in 90 days: You did it. Congratulations.

---

**Completed 90 Days of Devops Challenge ✅**
