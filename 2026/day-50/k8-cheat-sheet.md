Here is a **clean Kubernetes Commands Cheat Sheet** you can keep as a `.md` file for quick reference.

---

````md
# Kubernetes Command Cheat Sheet

A quick reference for commonly used `kubectl` commands.

---

# 1. Cluster Information

Check cluster info:

```bash
kubectl cluster-info
````

Check nodes in the cluster:

```bash
kubectl get nodes
```

Check Kubernetes version:

```bash
kubectl version
```

---

# 2. Namespaces

List namespaces:

```bash
kubectl get namespaces
```

Create namespace:

```bash
kubectl create namespace my-namespace
```

Delete namespace:

```bash
kubectl delete namespace my-namespace
```

Run command in a namespace:

```bash
kubectl get pods -n my-namespace
```

---

# 3. Pods

List pods:

```bash
kubectl get pods
```

List pods with more details:

```bash
kubectl get pods -o wide
```

List pods from all namespaces:

```bash
kubectl get pods -A
```

Describe a pod:

```bash
kubectl describe pod pod-name
```

Delete a pod:

```bash
kubectl delete pod pod-name
```

Get pod logs:

```bash
kubectl logs pod-name
```

Stream pod logs:

```bash
kubectl logs -f pod-name
```

Execute command inside a pod:

```bash
kubectl exec -it pod-name -- /bin/bash
```

---

# 4. Deployments

List deployments:

```bash
kubectl get deployments
```

Create deployment:

```bash
kubectl create deployment nginx --image=nginx
```

Describe deployment:

```bash
kubectl describe deployment nginx
```

Scale deployment:

```bash
kubectl scale deployment nginx --replicas=3
```

Delete deployment:

```bash
kubectl delete deployment nginx
```

---

# 5. Services

List services:

```bash
kubectl get services
```

Expose deployment as a service:

```bash
kubectl expose deployment nginx --type=NodePort --port=80
```

Describe service:

```bash
kubectl describe service nginx
```

Delete service:

```bash
kubectl delete service nginx
```

---

# 6. Apply & Manage YAML Resources

Create resource from YAML:

```bash
kubectl apply -f file.yaml
```

Delete resource from YAML:

```bash
kubectl delete -f file.yaml
```

View YAML of a resource:

```bash
kubectl get pod pod-name -o yaml
```

Edit resource live:

```bash
kubectl edit deployment nginx
```

---

# 7. Debugging Commands

Check pod events:

```bash
kubectl describe pod pod-name
```

Check logs:

```bash
kubectl logs pod-name
```

Check node status:

```bash
kubectl describe node node-name
```

Check system components:

```bash
kubectl get pods -n kube-system
```

---

# 8. Config & Context Management

Show current context:

```bash
kubectl config current-context
```

List contexts:

```bash
kubectl config get-contexts
```

Switch context:

```bash
kubectl config use-context context-name
```

View kubeconfig:

```bash
kubectl config view
```

---

# 9. Resource Monitoring

Check resource usage (if metrics-server installed):

```bash
kubectl top nodes
```

```bash
kubectl top pods
```

---

# 10. Helpful Output Options

Wide output:

```bash
kubectl get pods -o wide
```

YAML output:

```bash
kubectl get pod pod-name -o yaml
```

JSON output:

```bash
kubectl get pod pod-name -o json
```

---

# 11. Useful Shortcuts

Get everything in namespace:

```bash
kubectl get all
```

Watch resource changes live:

```bash
kubectl get pods -w
```

Sort resources:

```bash
kubectl get pods --sort-by=.metadata.name
```

---

# 12. KIND Cluster Commands

List KIND clusters:

```bash
kind get clusters
```

Create cluster:

```bash
kind create cluster --name cluster-name
```

Delete cluster:

```bash
kind delete cluster --name cluster-name
```

---

# Quick Mental Model

```
kubectl
   ↓
API Server
   ↓
Kubernetes Cluster
```

All kubectl commands interact with the **API Server**.

```

---
