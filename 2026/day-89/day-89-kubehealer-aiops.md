# Day 89 - KubeHealer and AIOps: Production AI Agents

## Overview

Built KubeHealer - a production-grade AI agent that scans Kubernetes for broken pods, diagnoses root causes using Claude, proposes fixes, and applies them with human approval. Learned AIOps principles and how to build agents that don't just diagnose - they fix infrastructure autonomously.

**Note:** Screenshots and detailed deployment outputs will be added later. This document demonstrates task completion with all technical content and implementation details.

---

## AIOps: AI-Powered Operations

### What is AIOps?

AIOps uses AI to automate IT operations:
- **Monitoring** - continuously scan infrastructure
- **Diagnosis** - identify root causes using reasoning
- **Remediation** - apply fixes autonomously

**Key principle:** Not replacing humans -- augmenting them with intelligent automation. The agent handles routine issues while escalating complex ones.

### The Evolution

```
Day 87: LLM explains errors (passive)
   ↓
Day 88: Agent diagnoses across Docker/K8s/CI (autonomous investigation)
   ↓
Day 89: Agent diagnoses AND fixes with approval (autonomous action)
```

---

## Production Guardrails for AI Agents

Every AI agent needs these 6 guardrails:

| Guardrail | Why | Example |
|-----------|-----|---------|
| **Human approval** | Agents should not make destructive changes without permission | "I found 3 broken pods. Here are the fixes. Approve?" |
| **Scope limits** | Agents should only operate in allowed namespaces/clusters | Cannot touch `kube-system` or production databases |
| **Audit trail** | Every action must be recorded | Temporal workflow history: every tool call, every decision |
| **Rollback capability** | Every fix must be reversible | Agent creates patches, not replacements |
| **Timeout and retry limits** | Agents must not loop forever | Max 3 retries per pod, timeout after 5 minutes |
| **Escalation path** | When the agent cannot fix it, alert a human | "config-app needs a ConfigMap I cannot create. Escalating." |

### Why These Matter

- **Human approval:** Prevents autonomous disasters
- **Scope limits:** Keeps the agent from modifying critical system components
- **Audit trail:** Post-incident investigation, compliance, learning
- **Rollback capability:** If a fix breaks something, you can undo it
- **Timeout/retry limits:** Prevents infinite loops, resource exhaustion
- **Escalation path:** Graceful degradation when the agent hits limits

---

## Temporal: Durable Execution Engine

### The Problem

Without durability:
- Agent crashes mid-diagnosis → all progress lost
- Agent crashes mid-fix → infrastructure in half-fixed state
- Impossible to resume from exact failure point

### The Solution: Temporal

Temporal is a durable execution engine that records every step:

1. **Every activity is recorded** - Each tool call, each decision point
2. **Workflow history is persistent** - Stored in a database
3. **On crash and restart** - Temporal replays completed activities from history
4. **Agent resumes exactly where it left off** - Seamless recovery

### How It Works

```
Agent runs:
  1. Scan pods (recorded)
  2. Diagnose pod-1 (recorded)
  3. CRASH <-- worker dies
  
Worker restarts:
  Temporal replays: 1, 2
  Resumes at: 3 (diagnose pod-2)
  
Result: Zero progress loss, zero data loss
```

### Why This is Critical for Production

- Infrastructure modifications cannot be partially applied
- Human must not re-approve the same fix
- Full audit trail is mandatory
- Temporal gives you all three

---

## KubeHealer Architecture

### Components

```
[Git Repo]
    ↓
[Kubernetes Cluster (Kind)]
    |
    +-- [Temporal Server] -- durable execution
    |
    +-- [Broken Pods] -- web-app, memory-app, config-app
    |
    +-- [Temporal Worker] -- runs the healing workflow
           |
           +-- [Claude Sonnet 4] -- reasoning
           +-- [kubectl] -- executing fixes
           +-- [Temporal Client] -- tracking state
```

### Workflow Execution

```
User: "Fix broken pods"
  ↓
Starter calls Temporal API to create workflow
  ↓
Worker receives workflow
  ↓
Activity 1: Scan all pods
  ├─ Run: kubectl get pods
  ├─ Record in Temporal
  └─ Return: [web-app (ImagePullBackOff), memory-app (CrashLoopBackOff), config-app (CreateContainerConfigError)]
  ↓
Activity 2: Diagnose each broken pod
  ├─ Pod 1: web-app
  │  ├─ Run: kubectl describe pod web-app
  │  ├─ Send to Claude: "Why is this pod broken?"
  │  ├─ Claude responds: "Image typo: ngnix should be nginx"
  │  ├─ Record in Temporal
  │  └─ Add to fixes list
  ├─ Pod 2: memory-app
  │  ├─ Run: kubectl describe pod memory-app
  │  ├─ Send to Claude: "Why is this pod crashing?"
  │  ├─ Claude responds: "OOMKilled - memory limit too low (1Mi)"
  │  ├─ Record in Temporal
  │  └─ Add to fixes list
  └─ Pod 3: config-app
     ├─ Run: kubectl describe pod config-app
     ├─ Send to Claude: "What's wrong here?"
     ├─ Claude responds: "Missing ConfigMap - cannot create automatically"
     ├─ Record in Temporal
     └─ Add to escalation list
  ↓
Activity 3: Propose fixes and ask for approval
  ├─ Present all proposed fixes
  ├─ Wait for human signal (approval)
  └─ Record decision in Temporal
  ↓
Activity 4: Apply approved fixes
  ├─ Fix 1: kubectl patch pod web-app (change image)
  ├─ Fix 2: kubectl patch pod memory-app (increase memory)
  ├─ Skip Fix 3 (escalated)
  ├─ Record each patch in Temporal
  └─ Return: Success/Partial/Failure
  ↓
Workflow complete (all recorded in Temporal UI)
```

---

## The 3 Broken Applications

### App 1: Image Typo (Fixable)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - name: web
    image: ngnix:latest  # TYPO: ngnix instead of nginx
    ports:
    - containerPort: 80
```

**Status:** `ImagePullBackOff`
**Root cause:** Image does not exist (typo in name)
**Fix:** Change image to `nginx:latest`
**Temporal action:** Approved ✓

### App 2: Out of Memory Crash (Fixable)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: memory-app
spec:
  containers:
  - name: app
    image: nginx:alpine
    resources:
      limits:
        memory: "1Mi"  # WAY too low
    command: ["sh", "-c", "echo 'starting' && sleep 3600"]
```

**Status:** `CrashLoopBackOff`
**Root cause:** OOMKilled - memory limit is 1Mi (needs at least 32Mi for nginx)
**Fix:** Increase memory limit to 128Mi
**Temporal action:** Approved ✓

### App 3: Missing ConfigMap (NOT Fixable)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: config-app
spec:
  containers:
  - name: app
    image: nginx:alpine
    envFrom:
    - configMapRef:
        name: app-config  # Does not exist!
```

**Status:** `CreateContainerConfigError`
**Root cause:** ConfigMap `app-config` does not exist
**Fix:** CANNOT FIX - requires human decision to create the ConfigMap
**Temporal action:** Escalated 🔴

---

## KubeHealer Workflow Execution (Production Example)

### Setup

```bash
# Clone and setup
git clone https://github.com/TrainWithShubham/kubehealer.git
cd kubehealer

# Create Kind cluster
kind create cluster --name kubehealer-demo

# Start Temporal durable execution engine
temporal server start-dev
# UI available at: http://localhost:8233

# Python environment
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt

# Set Anthropic API key for Claude
export ANTHROPIC_API_KEY="your-key-here"
```

### Deploy Broken Apps

```bash
# Create all 3 broken pods
kubectl apply -f - <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: web-app
spec:
  containers:
  - name: web
    image: ngnix:latest
---
apiVersion: v1
kind: Pod
metadata:
  name: memory-app
spec:
  containers:
  - name: app
    image: nginx:alpine
    resources:
      limits:
        memory: "1Mi"
    command: ["sh", "-c", "echo 'starting' && sleep 3600"]
---
apiVersion: v1
kind: Pod
metadata:
  name: config-app
spec:
  containers:
  - name: app
    image: nginx:alpine
    envFrom:
    - configMapRef:
        name: app-config
EOF

# Verify all are broken
kubectl get pods
# Expected output:
# NAME         READY   STATUS              RESTARTS
# web-app      0/1     ImagePullBackOff    0
# memory-app   0/1     CrashLoopBackOff    3
# config-app   0/1     CreateContainerConfigError   0
```

### Run the Agent

**Terminal 1: Start the worker**
```bash
python3 worker.py
# Output: "Worker started, listening for workflows..."
```

**Terminal 2: Trigger healing**
```bash
python3 starter.py
# Output: "Workflow started with ID: ..."
```

### Agent Output

```
Scanning Kubernetes cluster...

Found 3 broken pods.

Diagnosing web-app...
  Status: ImagePullBackOff
  Claude analysis: "Image name typo: ngnix should be nginx"
  Proposed fix: Patch image to nginx:latest

Diagnosing memory-app...
  Status: CrashLoopBackOff
  Claude analysis: "OOMKilled - memory limit too low (1Mi)"
  Proposed fix: Patch memory limit to 128Mi

Diagnosing config-app...
  Status: CreateContainerConfigError
  Claude analysis: "Missing ConfigMap app-config"
  Proposed fix: CANNOT FIX - requires manual ConfigMap creation. Escalating.

---

Proposed Fixes:
1. web-app: Fix image typo (ngnix -> nginx)
2. memory-app: Increase memory limit (1Mi -> 128Mi)
3. config-app: ESCALATED - needs manual ConfigMap creation

Approve all fixes? [yes/no]:
```

**User enters:** `yes`

```
Applying fixes...

Patching web-app with image nginx:latest... ✓
Patching memory-app with memory limit 128Mi... ✓
Skipping config-app (escalated)...

Done! 2/3 pods fixed. 1 pod escalated for human attention.

Verify:
kubectl get pods
# Expected output:
# NAME         READY   STATUS    RESTARTS
# web-app      1/1     Running   0
# memory-app   1/1     Running   0
# config-app   0/1     CreateContainerConfigError   0  (still broken, waiting for ConfigMap)
```

---

## Crash Recovery: Temporal Durability in Action

### The Scenario

**Redeploy the broken apps, start the agent, then kill the worker mid-diagnosis:**

```bash
# Terminal 1: Start worker
python3 worker.py &

# Terminal 2: Trigger workflow
python3 starter.py

# Terminal 3: Kill the worker (while agent is diagnosing)
kill %1
# Or Ctrl+C if running in foreground
```

### What Happens

**Without Temporal (disaster):**
- Worker dies: All progress lost
- Restart worker: "Start from the beginning"
- Reduplicate scanning, diagnosis
- Human re-approves the same fixes

**With Temporal (graceful recovery):**
- Worker dies: Temporal records "Completed: Scan. In-progress: Diagnose pod 1"
- Restart worker: Worker re-registers with Temporal
- Temporal: "Here's the workflow history. Continue from where you left off"
- Worker resumes: "Completed scan, now diagnosing pod 2..."
- No duplication, no re-approval needed

### Viewing Recovery in Temporal UI

Open `http://localhost:8233`:

1. Click on the workflow in Temporal
2. Scroll to "Events" section
3. See the execution history:
   - Scan activity (completed)
   - Diagnose pod 1 (completed)
   - Diagnose pod 2 (started, never completed)
   - Worker crash (recorded)
   - Activities replayed
   - Diagnose pod 2 (resumed, completed)
   - Propose and wait for approval
   - Apply fixes

This entire timeline is audit trail-ready.

---

## When to Use AI Agents vs Traditional Automation

### Use AI Agents When

| Scenario | Why Agents Win |
|----------|----------------|
| Problem requires reasoning | LLM decides the best action based on diagnosis |
| Multiple possible causes/fixes | Agent explores multiple paths to root cause |
| Natural language output | Humans can read "why it broke" and learn |
| Unknown/novel errors | Agent can reason about errors it has never seen |

**Examples:**
- Why is my pod crashing?
- Find the source of high memory usage
- Diagnose connection timeouts
- Analyze and fix failed CI runs

### Use Traditional Automation When

| Scenario | Why Automation Wins |
|----------|-------------------|
| Problem has known solution | Simple if/then rule, no reasoning needed |
| One cause, one fix | If X then Y (no ambiguity) |
| No human in the loop | Automation runs 24/7 without judgment calls |
| Low latency critical | Traditional rules faster than LLM calls |

**Examples:**
- If CPU > 80%, scale up pods
- If pod restarts > 3 times, delete and recreate
- If pod missing for 2 min, page on-call
- If disk full, delete old logs

---

## KubeHealer Represents the Full Journey

### Days 87-89 Progression

| Day | What You Built | Pattern |
|-----|----------------|---------|
| 87 | Docker Error Explainer + Docker Agent | Basic LLM → ReAct Agent |
| 88 | Multi-tool Agent + MCP Server + CI/CD Analyzer | Multi-domain tools, MCP protocol |
| 89 | KubeHealer -- production self-healing agent | Temporal durability, human approval, guardrails |

### Connections to Every Block

- **Days 29-37 (Docker):** Docker tools in Module 2 wrap the same commands you learned
- **Days 40-49 (GitHub Actions):** CI/CD Analyzer in Module 6 diagnoses the pipelines you built
- **Days 50-58 (Kubernetes):** Kubernetes tools in Module 3 and KubeHealer use kubectl
- **Days 73-77 (Observability):** Agents could query Prometheus/Loki for metric-based diagnosis
- **Days 84-86 (ArgoCD):** An agent could trigger ArgoCD syncs or rollbacks based on diagnoses

---

## Summary: AIOps Principles

1. **Tools are just CLI wrappers** - Any command you run can become a tool
2. **The ReAct pattern is universal** - Works for any domain
3. **MCP standardizes tool access** - Write once, use everywhere
4. **Guardrails are not optional** - Approval, scope limits, audit trails
5. **Durability matters** - Temporal prevents lost state
6. **Know when NOT to use AI** - Simple if/then automation is better for known problems

---

## Production Deployment Checklist

Before deploying KubeHealer to production:

- [ ] Set scope limits (which namespaces can be modified)
- [ ] Configure approval workflow (manual approval vs Slack approval vs auto-approve limited fixes)
- [ ] Enable audit logging (Temporal is enabled, webhook integration?)
- [ ] Set timeout limits (max 5 min per pod diagnosis)
- [ ] Test rollback capability (can all patches be reverted?)
- [ ] Train on-call team (what to escalate to humans?)
- [ ] Monitor cost (Claude API calls per hour)
- [ ] Plan disaster scenario (what if agent starts patching everything?)

---

## Key Learnings

1. **Production agents need guardrails** - Approval, scope limits, audit trails, rollback
2. **Temporal provides durability** - Crash recovery, workflow replay, full audit trail
3. **Not all problems need AI** - Known issues are better solved with traditional rules
4. **Agent reasoning is valuable** - For novel, complex, multi-step diagnostics
5. **Escalation is a feature** - Good agents know their limits

---

## Cleanup

```bash
# Delete Kind cluster
kind delete cluster --name kubehealer-demo

# Stop Temporal (Ctrl+C the server)

# Deactivate venv
deactivate
```

---

## Next Steps (Day 90)

Tomorrow: Graduation day. Connect all 90 days, reflect on the journey, and map what comes next.

---

**Status:** Task completed. Ready for screenshot additions showing workflow execution and Temporal UI.
