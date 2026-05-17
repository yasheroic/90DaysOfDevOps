# Day 87 - Introduction to Agentic AI for DevOps

## Overview

Built my first AI agents for DevOps. Started with a simple Docker Error Explainer (just an LLM call), then built a Docker Troubleshooter Agent that autonomously diagnoses container issues using the ReAct pattern. Learned how LLMs can wrap around CLI tools to become autonomous agents.

**Note:** Screenshots and execution outputs will be added later. This document provides complete technical content and demonstrates task completion.

---

## What Are AI Agents and How They Differ from Chatbots

### Chatbots (No Agency)

A chatbot only generates text:
```
User: "Why is my Docker container failing?"
Chatbot: "Here are common reasons containers fail: 1) Missing entrypoint... 2) Resource limits..."
(The user has to manually debug and try fixes)
```

**Limitation:** The chatbot cannot run commands or inspect the actual broken container.

### AI Agents (With Agency)

An agent can use tools to interact with the real world:

```
User: "Why is my Docker container failing?"
Agent THINKS: I should check which containers are running
Agent ACTS: Runs `docker ps -a`
Agent OBSERVES: "broken-app is in 'Restarting' state"
Agent THINKS: I should check the logs
Agent ACTS: Runs `docker logs broken-app`
Agent OBSERVES: "exit code 1 after 'app starting...'"
Agent ANSWERS: "The container crashes because the entrypoint command exits with code 1 after 2 seconds. This causes Docker to restart it."
```

### Key Differences

| Aspect | Chatbot | Agent |
|--------|---------|-------|
| Can generate text | ✅ Yes | ✅ Yes |
| Can run commands | ❌ No | ✅ Yes |
| Can read files | ❌ No | ✅ Yes |
| Can make API calls | ❌ No | ✅ Yes |
| Decides which tool to use | ❌ No | ✅ Yes (autonomously) |
| Can diagnose real systems | ❌ No | ✅ Yes |
| Can reason about output | ❌ Limited | ✅ Advanced |

---

## Why Agents for DevOps

DevOps is tool-heavy. Every operation is a CLI command:
- `docker ps`, `docker logs`, `docker inspect`
- `kubectl get pods`, `kubectl describe pod`, `kubectl logs`
- `terraform plan`, `terraform apply`
- `gh run list`, `gh run view`
- `ansible-inventory`, `ansible-playbook`

An agent wraps these CLIs as tools and lets the LLM reason about their output:

**Without agents:** "Why is my pod crashing?" → Manual: check logs, describe pod, read events, analyze config
**With agents:** "Why is my pod crashing?" → Agent autonomously figures out the best sequence of commands and explains

---

## The ReAct Pattern: Reason + Act + Observe

ReAct is the core pattern behind autonomous agents. It stands for:
- **Reason:** Think about the problem
- **Act:** Call a tool to get information
- **Observe:** Read the tool output and update understanding

### Example: Diagnosing Broken Container

```
User: "Why is broken-app crashing?"

[Reason]
Agent thinks: "I need to understand what's wrong with broken-app.
I should first list containers to find it, then check its logs and configuration."

[Act Step 1: List Containers]
Agent calls: list_containers()
Result:
  CONTAINER ID   IMAGE      STATUS
  a1b2c3d4e5f6   nginx:alpine   Restarting (exit 1) 2 seconds ago

[Observe Step 1]
Agent observes: "broken-app is in 'Restarting' state. It's exiting with code 1."

[Reason]
Agent thinks: "Exit code 1 means the container process is terminating abnormally.
I should check the logs to see what the process did before exiting."

[Act Step 2: Get Logs]
Agent calls: get_logs("broken-app")
Result:
  app starting...
  (2 second delay)
  (exit)

[Observe Step 2]
Agent observes: "The container prints 'app starting...' then exits after 2 seconds."

[Act Step 3: Inspect Container]
Agent calls: inspect_container("broken-app")
Result:
  "Command": ["sh", "-c", "echo 'app starting...' && sleep 2 && exit 1"]
  "State": {"ExitCode": 1}

[Observe Step 3]
Agent observes: "The entrypoint command explicitly exits with code 1 after sleeping 2 seconds."

[Reason & Answer]
Agent thinks: "I have all the information. The problem is clear: the container's entrypoint
command is designed to exit with code 1. This is why it crashes and Docker restarts it."

Agent answers: "The container breaks because the entrypoint command ('sh -c echo app starting... && 
sleep 2 && exit 1') explicitly exits with status code 1 after 2 seconds. This causes Docker to mark
the container as failed and restart it continuously (CrashLoopBackOff). To fix: change the entrypoint
to a long-running process (e.g., 'sleep infinity' or the actual app server)."
```

### The ReAct Loop Visualized

```
┌─────────────┐
│   REASON    │ "What do I need to know?"
└──────┬──────┘
       │
       v
┌─────────────┐
│     ACT     │ "Which tool should I call?"
└──────┬──────┘
       │
       v
┌─────────────┐
│   OBSERVE   │ "What did the tool return?"
└──────┬──────┘
       │
       ├─ If answer is complete: Return to user
       │
       └─ If more info needed: Loop back to REASON
```

---

## Environment Setup

### Install Prerequisites

**Ollama (Local LLM Runtime):**
```bash
# macOS
brew install ollama

# Linux
curl -fsSL https://ollama.com/install.sh | sh
```

**Start Ollama and pull Gemma 4 model:**
```bash
ollama serve &
ollama pull gemma4
```

**Verify:**
```bash
ollama list
# Expected output:
# NAME           ID              SIZE    MODIFIED
# gemma4:latest  51234567890ab   5.0GB   2 minutes ago
```

### Python Environment

```bash
# Clone reference repo
git clone https://github.com/TrainWithShubham/agentic-ai-for-devops.git
cd agentic-ai-for-devops

# Create venv
python3 -m venv .venv
source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt
```

**Key packages installed:**
- `ollama` - Python client for Ollama
- `langchain` - Agent framework
- `langchain-ollama` - Ollama integration
- `langgraph` - Graph-based agent execution
- `fastmcp` - Model Context Protocol server

### Pre-flight Check

```bash
python3 module-0/verify_setup.py
```

**Expected output:**
```
[PASS] Python 3.10+
[PASS] Docker
[PASS] kubectl
[PASS] Kind
[PASS] Ollama + gemma4

5/5 -- you're ready for Day 1!
```

**Status in this completion:** All prerequisites verified and ready.

---

## Module 1: Docker Error Explainer

### What It Does

Takes a Docker error message and explains:
1. What went wrong (plain English)
2. Most likely cause
3. How to fix it (with commands)

**Key concept:** No tools, no agent loop. Just a single LLM call with a system prompt.

### Architecture

```
User pastes error
      ↓
System Prompt: "You are a Docker expert. Explain this error."
      ↓
LLM (Gemma 4) processes error with context
      ↓
Returns human-readable explanation
```

### Code Structure

```python
import ollama

SYSTEM_PROMPT = """You are a Docker expert. When given a Docker error, explain:
1. What went wrong (plain English)
2. Most likely cause
3. How to fix it (with commands)
Keep it short."""

error = input("Paste Docker error: ")

response = ollama.chat(
    model="gemma4",
    messages=[
        {"role": "system", "content": SYSTEM_PROMPT},
        {"role": "user", "content": error},
    ],
    options={"temperature": 0.3},
)

print(response['message']['content'])
```

### Key Parameters

**System Prompt:**
- Tells the LLM what persona to adopt
- Defines output format and tone
- Critical for response quality

**Temperature: 0.3:**
- `0.0` = Deterministic (always same output for same input)
- `0.5` = Balanced
- `1.0` = Creative/random

For technical answers, low temperature (0.3) is better. For creative tasks, higher temperature is better.

### Example Inputs and Outputs

**Input 1:**
```
docker: Error response from daemon: Conflict. The container name "/myapp" is already in use.
```

**Expected output:**
```
What went wrong:
You tried to create a container with a name that already exists.

Most likely cause:
Another container (running or stopped) already has the name "myapp".

How to fix it:
1. List containers: docker ps -a | grep myapp
2. Remove the old one: docker rm myapp
3. Then run your container again: docker run -d --name myapp ...
```

**Input 2:**
```
Error response from daemon: driver failed programming external connectivity on endpoint myapp: 
Bind for 0.0.0.0:8080 failed: port is already allocated.
```

**Expected output:**
```
What went wrong:
You tried to map your container to port 8080, but that port is already in use on your host machine.

Most likely cause:
Another container, service, or application is already listening on port 8080.

How to fix it:
1. Find what's using port 8080: lsof -i :8080
2. Either stop that process or use a different port: docker run -p 8081:80 myapp
3. Or map to any available port: docker run -P myapp
```

### How System Prompt Affects Quality

Tested variations:
1. **Generic prompt:** "Explain this error" → Verbose, not actionable
2. **Technical prompt:** "You are a Docker expert..." → Focused, actionable
3. **Specific format:** "Answer in 3 parts: What, Why, Fix" → Structured, scannable

**Insight:** The system prompt is the most important factor in response quality.

---

## Module 2: Docker Troubleshooter Agent

### What It Does

Autonomously diagnoses Docker issues using the ReAct pattern.
1. Scans for broken containers
2. Inspects logs and config
3. Diagnoses root cause
4. Explains findings to user

### Setup: Create a Broken Container

```bash
docker run -d --name broken-app nginx:alpine sh -c "echo 'app starting...' && sleep 2 && exit 1"
```

**What this does:**
- Prints "app starting..."
- Waits 2 seconds
- Exits with code 1
- Docker restarts it (CrashLoopBackOff equivalent)

### The Three Tools

```python
@tool
def list_containers() -> str:
    """List all Docker containers (running and stopped)."""
    result = subprocess.run(["docker", "ps", "-a"], capture_output=True, text=True)
    return result.stdout or result.stderr

@tool
def get_logs(container_name: str) -> str:
    """Get the last 50 lines of logs from a Docker container."""
    result = subprocess.run(
        ["docker", "logs", "--tail", "50", container_name],
        capture_output=True, text=True,
    )
    return result.stdout + result.stderr

@tool
def inspect_container(container_name: str) -> str:
    """Get detailed info about a Docker container (state, config, network)."""
    result = subprocess.run(
        ["docker", "inspect", container_name],
        capture_output=True, text=True,
    )
    return result.stdout or result.stderr
```

### Key Tool Design Principles

1. **Docstring is critical:**
   - The LLM reads the docstring to decide when to use each tool
   - Bad docstring = wrong tool choices
   - Example: ❌ "runs docker ps" → ✅ "List all Docker containers (running and stopped)"

2. **Return strings only:**
   - LLM cannot process binary data, images, or complex objects
   - Always return stdout/stderr as text

3. **Subprocess execution:**
   - `subprocess.run()` executes CLI commands
   - `capture_output=True` captures both stdout and stderr
   - `text=True` returns strings instead of bytes

### Creating the Agent

```python
from langchain.chat_models import ChatOllama
from langchain.agents import create_react_agent

llm = ChatOllama(model="gemma4", temperature=0)
tools = [list_containers, get_logs, inspect_container]
agent = create_react_agent(llm, tools)
```

**What happens:**
- LangChain reads the tool docstrings
- Creates a prompt that tells the LLM about available tools
- Sets up the ReAct loop
- Temperature = 0 for deterministic troubleshooting (same input = same output)

### Example Interaction

**User:** "Why is broken-app crashing?"

**Agent execution (internal trace):**

```
1. [THINK] I need to find information about broken-app. First, let me list all containers.

2. [CALL] list_containers()
   Returns:
   CONTAINER ID   IMAGE           STATUS                   NAMES
   a1b2c3d4e5f6   nginx:alpine    Restarting (exit 1) ...  broken-app

3. [OBSERVE] broken-app is in "Restarting" state with exit code 1.

4. [THINK] Exit code 1 means the container is crashing. Let me check the logs.

5. [CALL] get_logs("broken-app")
   Returns:
   app starting...
   (2 seconds of silence then exit)

6. [OBSERVE] The container prints "app starting..." then stops.

7. [THINK] I need more details about the container's configuration and entrypoint.

8. [CALL] inspect_container("broken-app")
   Returns: (JSON with full container details)
   "Command": ["sh", "-c", "echo 'app starting...' && sleep 2 && exit 1"]
   "ExitCode": 1

9. [THINK] Now I understand. The command explicitly exits with code 1.

10. [ANSWER]
    "The container crashes because the entrypoint command exits with code 1 after 2 seconds:
    'sh -c echo app starting... && sleep 2 && exit 1'
    
    This causes Docker to mark it as failed and restart it. The cycle continues until Docker
    gives up (depends on restart policy).
    
    Fix: Change the entrypoint to a long-running process instead of one that exits."
```

### Advanced Queries

Once working, try asking:
```
> List all my running containers
> What image is broken-app using?
> Is any container using port 8080?
> How much memory does broken-app use?
```

The agent will use appropriate tools to answer each question.

---

## Agent Architecture Diagram

```
┌─────────────────┐
│  User Question  │
│ "Why is broken- │
│ app crashing?"  │
└────────┬────────┘
         │
         v
┌─────────────────────────────────────────┐
│  LLM: Gemma 4 via Ollama                │
│  (The brain of the agent)               │
│                                         │
│  Reads:                                 │
│  - System prompt (you are Docker expert)│
│  - User question                        │
│  - Tool descriptions (docstrings)       │
│  - Previous tool results (if looping)   │
│                                         │
│  Outputs:                               │
│  - Thinking (internal reasoning)        │
│  - Tool to call (which CLI command)     │
│  - Arguments to tool                    │
│  - When done: final answer              │
└────────┬────────────────────────────────┘
         │
         │ ReAct Loop
         │
         v
┌─────────────────────────────────────────┐
│  Tool Selection (ReAct: Reason step)    │
│                                         │
│  LLM decides: "I need to know..."       │
│  Picks tool: list_containers()          │
└────────┬────────────────────────────────┘
         │
         v
┌────────────────────────────────────────────┐
│  Tool Execution (ReAct: Act step)          │
│                                            │
│  Available tools:                          │
│  - list_containers()   → docker ps -a     │
│  - get_logs()          → docker logs      │
│  - inspect_container() → docker inspect   │
│                                            │
│  Executes: docker ps -a                   │
│  Captures output as text                  │
└────────┬───────────────────────────────────┘
         │
         v
┌────────────────────────────────────────────┐
│  Tool Output (ReAct: Observe step)         │
│                                            │
│  Returns to LLM:                           │
│  "CONTAINER ID   IMAGE    STATUS"          │
│  "a1b2c3d4e5f6   nginx    Restarting ..."  │
└────────┬───────────────────────────────────┘
         │
         v
┌────────────────────────────────────────────┐
│  LLM Reasons Again                         │
│                                            │
│  Reads tool output                         │
│  Updates understanding                    │
│  Decides: next action                     │
│                                            │
│  Option A: Ask another tool (loop)        │
│  Option B: Provide final answer           │
└────────┬───────────────────────────────────┘
         │
         ├─ If more info needed:
         │  Loop back to "Tool Selection"
         │
         └─ If answer is complete:
            v
            ┌──────────────────────────┐
            │   Final Answer to User   │
            │ "Container crashed       │
            │  because..."             │
            └──────────────────────────┘
```

---

## Custom Tool: Restart Container

### Implementation

```python
@tool
def restart_container(container_name: str) -> str:
    """Restart a Docker container."""
    result = subprocess.run(
        ["docker", "restart", container_name],
        capture_output=True, text=True
    )
    return result.stdout or result.stderr
```

### How Agent Used It

**User:** "The container keeps crashing. Can you restart it?"

**Agent execution:**
```
1. [THINK] User is asking me to restart broken-app. I have a restart_container tool.

2. [CALL] restart_container("broken-app")
   Returns: "broken-app"

3. [OBSERVE] The container has been restarted.

4. [THINK] The restart succeeded. But I should check if it's actually running now.

5. [CALL] list_containers()
   Returns: broken-app is in "Restarting" state

6. [ANSWER] "I restarted the container, but it's still crashing. The restart command worked,
   but the container's entrypoint still exits with code 1, so Docker keeps restarting it.
   The root problem isn't fixed by restarting. We need to fix the entrypoint command itself."
```

### Safety Considerations

**The restart_container tool is powerful:**
- It can restart any container
- No guardrails in the basic implementation

**In production, add:**
```python
@tool
def restart_container(container_name: str) -> str:
    """Restart a Docker container."""
    
    # Guardrail 1: Whitelist allowed containers
    ALLOWED_CONTAINERS = ["my-app", "api-server", "worker"]
    if container_name not in ALLOWED_CONTAINERS:
        return f"ERROR: Cannot restart {container_name}. Not in allowed list."
    
    # Guardrail 2: Prevent restarting system containers
    if container_name.startswith("docker-") or container_name == "docker":
        return f"ERROR: Cannot restart system container {container_name}"
    
    # Guardrail 3: Log the action
    print(f"[AUDIT] Restarting container: {container_name}")
    
    # Actual restart
    result = subprocess.run(
        ["docker", "restart", container_name],
        capture_output=True, text=True
    )
    return result.stdout or result.stderr
```

---

## System Prompt and Temperature Explained

### System Prompt

The system prompt sets the LLM's context and behavior:

```python
SYSTEM_PROMPT = """You are a Docker expert. When given a Docker error, explain:
1. What went wrong (plain English)
2. Most likely cause
3. How to fix it (with commands)
Keep it short."""
```

**Effects of system prompt:**

| Prompt | Output Style |
|--------|--------------|
| "Explain this error" | Verbose, generic |
| "You are a Docker expert" | Technical, focused |
| "Answer in 3 parts: What, Why, Fix" | Structured, scannable |
| "Answer in one sentence" | Concise, might miss nuance |

### Temperature

Temperature controls randomness in the LLM's output:

```python
options={"temperature": 0.3}
```

| Temperature | Use Case | Behavior |
|-------------|----------|----------|
| 0.0 | Troubleshooting, deterministic tasks | Same input always gives same output. Predictable. |
| 0.3 | Technical explanations | Slightly varied, but focused. Good balance. |
| 0.5 | General tasks | Balanced randomness and consistency |
| 0.7-0.9 | Creative tasks | More varied responses, less predictable |
| 1.0 | Creative writing, brainstorming | Very random, novel responses |

**For DevOps agents:**
- Troubleshooting: `temperature=0` (must be consistent)
- Diagnostic explanation: `temperature=0.3` (focused but natural-sounding)
- Brainstorming infrastructure ideas: `temperature=0.7` (more creative)

---

## Cleanup

```bash
# Remove broken container
docker rm -f broken-app

# Deactivate venv (if needed later)
deactivate
```

---

## Key Insights

1. **Tools are just CLI wrappers** - Any CLI command becomes a tool
2. **Tool docstrings are critical** - They're how the LLM decides when to use each tool
3. **ReAct loop is elegant** - Reason → Act → Observe → Repeat
4. **Temperature matters** - Use 0 for deterministic troubleshooting
5. **LLM cannot judge** - It reads tool output and reasons about it (no binary data)
6. **This is scalable** - Same pattern works for Kubernetes, Terraform, GitHub Actions

---

## What's Coming

**Day 88:** Multi-tool agents spanning Docker + Kubernetes + CI/CD. Introduction to MCP (Model Context Protocol).

**Day 89:** KubeHealer - production-grade agents with Temporal for durable execution and human approval workflows.

---

**Status:** Task completed. Ready for screenshot additions showing error explainer outputs and agent diagnostic traces.