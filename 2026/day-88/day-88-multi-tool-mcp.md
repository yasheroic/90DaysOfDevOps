# Day 88 - Multi-Tool Agents, MCP, and CI/CD Analyzer

## Overview

Today I extended the Docker-only agent from Day 87 to handle both Docker and Kubernetes, learned about the Model Context Protocol (MCP) - the emerging standard for connecting AI to tools - and built a CI/CD Failure Analyzer that diagnoses broken GitHub Actions pipelines.

**Note:** Screenshots and detailed outputs will be added later. This document shows the task completion with all technical content and implementation details.

---

## Multi-Tool DevOps Agent Architecture

### The 6-Tool Agent (Module 3)

Created an agent with tools spanning two domains:

**Docker Tools (from Day 87):**
- `list_containers()` - Lists all Docker containers (running and stopped)
- `get_logs(container_name)` - Gets the last 50 lines of logs from a container
- `inspect_container(container_name)` - Gets detailed container info

**Kubernetes Tools (new):**
- `list_pods(namespace="default")` - Lists all pods in a namespace with status
- `describe_pod(pod_name, namespace="default")` - Gets detailed pod info including events and conditions
- `get_events(namespace="default")` - Gets recent Kubernetes events

### How the Agent Decides

The agent uses the ReAct pattern to decide which tools to call:
1. User asks: "What's broken across Docker and Kubernetes?"
2. Agent thinks: "This is asking about both domains"
3. Agent acts: Calls list_containers() and list_pods()
4. Agent observes: Sees broken-container in "Restarting" state, broken-pod in "CrashLoopBackOff"
5. Agent answers: Provides a unified view of all issues

**The key insight:** The LLM reads the question and tool docstrings, then decides which tools are relevant. One agent, many tools, universal reasoning.

---

## Model Context Protocol (MCP) Explained

### What is MCP?

MCP is an open standard (created by Anthropic) for connecting AI models to external tools and data sources, developed to solve a critical problem:

**Without MCP:**
- Tools are locked to one framework (LangChain)
- Every AI client re-implements Docker/K8s tools
- Tool access tied to the agent code

**With MCP:**
- Tools work with any MCP client
- Write once, use everywhere
- Tools exposed as a discoverable service

### MCP Architecture

```
[MCP Server]                    [MCP Clients]
  |                                  |
  |-- list_pods()                    |-- Claude Desktop
  |-- describe_pod()      <--->      |-- VS Code Copilot
  |-- get_events()                   |-- Your Python agent
  |                                  |-- Any MCP client
  |
  (exposes tools via stdio/HTTP)
```

### MCP-Compatible Clients

- Claude Desktop
- VS Code (GitHub Copilot)
- Cursor
- Claude Code (CLI)
- Any LangChain agent via `langchain-mcp-adapters`

---

## MCP Server Implementation (Module 3)

### Key Differences from LangChain Tools

```python
# LangChain approach
@tool
def list_pods(namespace: str = "default") -> str:
    """List all pods in a Kubernetes namespace with their status."""
    # Implementation

# MCP approach
from fastmcp import FastMCP

mcp = FastMCP("Kubernetes Tools")

@mcp.tool
def list_pods(namespace: str = "default") -> str:
    """List all pods in a Kubernetes namespace with their status."""
    # Implementation

if __name__ == "__main__":
    mcp.run()
```

**Differences:**
- `@mcp.tool` instead of `@tool` - Registered with MCP server
- `FastMCP("Kubernetes Tools")` - Creates a named MCP server
- `mcp.run()` - Starts the server (stdio transport by default)
- Any MCP client can discover and call these tools

### MCP Server as a Standalone Service

The MCP server can run independently:
```bash
python3 module-3/mcp_server.py
```

This starts a server that exposes Kubernetes tools via stdio transport. Any MCP-compatible client can connect and use these tools without modifying the server code.

### Configuring Claude Desktop with MCP

Add to `~/Library/Application Support/Claude/claude_desktop_config.json`:
```json
{
  "mcpServers": {
    "kubernetes-tools": {
      "command": "python3",
      "args": ["/full/path/to/agentic-ai-for-devops/module-3/mcp_server.py"]
    }
  }
}
```

Restart Claude Desktop. Now you can ask Claude: "List the pods in my cluster" and it will call your MCP server's `list_pods()` tool.

---

## MCP Client Agent (Module 3)

The agent doesn't define tools locally - it connects to the MCP server and discovers them at runtime:

```python
from langchain_mcp_adapters.client import MultiServerMCPClient

async def main():
    client = MultiServerMCPClient({
        "kubernetes-mcp": {
            "transport": "stdio",
            "command": "python",
            "args": ["mcp_server.py"]
        }
    })

    tools = await client.get_tools()    # Dynamically discovers tools from MCP
    llm = ChatOllama(model="gemma4", temperature=0.8)
    agent = create_agent(llm, tools)    # Same ReAct agent, but tools come from MCP
```

**Same result as before, but tools are served via MCP instead of being hardcoded.**

---

## CI/CD Failure Analyzer (Module 6)

### Architecture

The CI/CD Analyzer uses the `gh` CLI to diagnose GitHub Actions failures with three tools:

```python
@tool
def list_workflow_runs(status: str = "failure") -> str:
    """List recent GitHub Actions workflow runs. Use status='failure' for failed runs."""
    result = subprocess.run(
        ["gh", "run", "list", "--status", status, "--limit", "5"],
        capture_output=True, text=True,
    )
    return result.stdout or result.stderr

@tool
def get_failed_logs(run_id: str) -> str:
    """Get the failed step logs from a GitHub Actions run. Pass the run ID."""
    result = subprocess.run(
        ["gh", "run", "view", run_id, "--log-failed"],
        capture_output=True, text=True,
    )
    output = result.stdout + result.stderr
    if len(output) > 5000:
        output = output[:5000] + "\n\n[...truncated, showing first 5000 chars]"
    return output

@tool
def get_workflow_file(workflow_name: str) -> str:
    """Read a GitHub Actions workflow YAML file. Pass the filename like 'ci.yml'."""
    import pathlib
    path = pathlib.Path(f".github/workflows/{workflow_name}")
    if path.exists():
        return path.read_text()
    return f"File not found: {path}"
```

### Important: Log Truncation

Log truncation to 5000 characters is essential:
- LLMs have token limits
- Cannot send 100KB of build output
- Truncation preserves most important information (the failed step)

### Example Workflow

When asked "What failed in my last CI run?":
1. Agent calls `list_workflow_runs(status="failure")`
2. Sees run ID for failed run
3. Calls `get_failed_logs(run_id)`
4. Reads the workflow file with `get_workflow_file(workflow_name)`
5. Explains the root cause

### Example Questions

```
> What failed in my last CI run?
> Show me the recent workflow runs
> Read the gitops-ci.yml workflow file and explain what it does
```

---

## The Tool Pattern Template

This is the universal pattern that works for any CLI:

```python
@tool
def my_tool(argument: str) -> str:
    """Description the LLM reads to decide when to use this tool."""
    result = subprocess.run(
        ["some-cli", "command", argument], 
        capture_output=True, 
        text=True
    )
    output = result.stdout + result.stderr
    
    # Truncate if needed (for logs, outputs > 5000 chars)
    if len(output) > 5000:
        output = output[:5000] + "\n[...truncated]"
    
    return output
```

**Any CLI command can become an agent tool. Any DevOps workflow can be automated this way.**

---

## Custom Tool Built: Log Searcher

Implemented a tool that searches for keywords across all pod logs in a namespace:

```python
@tool
def search_logs(keyword: str, namespace: str = "default") -> str:
    """Search for a keyword in the logs of all pods in a namespace."""
    pods = subprocess.run(
        ["kubectl", "get", "pods", "-n", namespace, "-o", "name"],
        capture_output=True, text=True,
    )
    results = []
    for pod in pods.stdout.strip().split("\n"):
        if not pod:
            continue
        logs = subprocess.run(
            ["kubectl", "logs", pod, "-n", namespace, "--tail=100"],
            capture_output=True, text=True,
        )
        if keyword.lower() in logs.stdout.lower():
            results.append(f"{pod}: found '{keyword}'")
    return "\n".join(results) if results else f"No pods contain '{keyword}' in their logs"
```

**How the agent used it:** When asked "Are there any error logs across pods?", the agent called this tool with keyword="error" and got back a list of pods containing that keyword.

---

## Summary: What Changed From Day 87

| Aspect | Day 87 | Day 88 |
|--------|--------|--------|
| Tools | 3 Docker tools | 6 tools (Docker + Kubernetes) |
| Domains | Single domain (Docker) | Multi-domain (Docker, K8s, CI/CD) |
| Tool Management | Hardcoded in agent | MCP server + dynamic discovery |
| Clients | Python agent only | Any MCP client (Claude, VS Code, etc.) |
| Scale | Local experimentation | Production-grade tool exposure |

---

## Key Learnings

1. **MCP standardizes tool access** - Write tools once, use with any MCP client
2. **The ReAct pattern scales** - Works for any domain when you have the right tools
3. **Log truncation is critical** - LLMs have token limits
4. **Tool docstrings matter** - The LLM reads them to decide when to use each tool
5. **Domain-agnostic architecture** - Same pattern works for Terraform, AWS, Ansible, etc.

---

## Hints Applied

- MCP servers can expose tools via `stdio` (same-machine) or `HTTP` (remote)
- Tool docstrings are the agent's documentation - be specific about when to use each tool
- `temperature=0` for troubleshooting agents (deterministic)
- `temperature=0.8` for conversational agents (more creative)
- The `gh` CLI must be authenticated (`gh auth login`) before the CI/CD analyzer tools work
- If the agent calls the wrong tool, improve the docstring

---

## Next Steps (Day 89)

Tomorrow: Build KubeHealer - a production-grade AI agent with Temporal for durable execution that doesn't just diagnose but actually fixes broken pods with human approval.

---

**Status:** Task completed. Ready for screenshot additions and final review.
