# Day 79 — Creating a Custom Helm Chart for AI-BankApp

## Task
Convert the 12 raw YAML files from the `k8s/` directory into a templated, configurable, reusable Helm chart for the AI-BankApp (Spring Boot + MySQL + Ollama AI chatbot). Deploy the entire stack with a single `helm install` command.

---

## Challenge Tasks

### Task 1: Scaffold the Chart and Study the Raw Manifests

Cloned the repo and studied the raw manifests:

```bash
cd AI-BankApp-DevOps
ls k8s/
```

| File | Purpose |
|------|---------|
| `namespace.yml` | Creates `bankapp` namespace |
| `configmap.yml` | MySQL host, port, database, Ollama URL |
| `secrets.yml` | MySQL credentials (base64 encoded) |
| `pv.yml` | StorageClass (gp3 via EBS CSI) |
| `pvc.yml` | PVCs for MySQL (5Gi) and Ollama (10Gi) |
| `bankapp-deployment.yml` | BankApp with init containers, probes, envFrom |
| `mysql-deployment.yml` | MySQL with EBS volume mount, probes |
| `ollama-deployment.yml` | Ollama with postStart model pull, probes |
| `service.yml` | ClusterIP services for all 3 components |
| `hpa.yml` | HPA for BankApp (2-4 replicas, 70% CPU) |
| `gateway.yml` | Envoy Gateway + HTTPRoute + TLS |
| `cert-manager.yml` | Let's Encrypt ClusterIssuer |

Scaffolded the Helm chart:

```bash
mkdir helm-chart && cd helm-chart
helm create bankapp
rm -rf bankapp/templates/*.yaml bankapp/templates/tests/
```

Kept `_helpers.tpl` and replaced the generated `NOTES.txt` with a bankapp-specific one (the default `NOTES.txt` referenced `.Values.httpRoute` and `.Values.ingress` keys that don't exist in our `values.yaml`, causing `helm lint` to fail).

---

### Task 2: Define Chart.yaml and values.yaml

**`bankapp/Chart.yaml`:**
```yaml
apiVersion: v2
name: bankapp
description: AI-BankApp -- Spring Boot banking application with MySQL and Ollama AI chatbot
type: application
version: 0.1.0
appVersion: "1.0.0"
maintainers:
  - name: TrainWithShubham
    url: https://github.com/TrainWithShubham
keywords:
  - bankapp
  - spring-boot
  - mysql
  - ollama
  - ai
```

**`bankapp/values.yaml`** extracts every hardcoded value from the raw manifests into configurable values:

```yaml
bankapp:
  replicaCount: 4
  image:
    repository: yasheroic/ai-bankapp-eks
    tag: "latest"
    pullPolicy: Always
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  service:
    type: ClusterIP
    port: 8080
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 4
    targetCPUUtilization: 70

mysql:
  enabled: true
  image:
    repository: mysql
    tag: "8.0"
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  persistence:
    size: 5Gi
    storageClass: gp3

ollama:
  enabled: true
  image:
    repository: ollama/ollama
    tag: "latest"
  model: tinyllama
  resources:
    requests:
      memory: "2Gi"
      cpu: "900m"
    limits:
      memory: "2.5Gi"
      cpu: "1500m"
  persistence:
    size: 10Gi
    storageClass: gp3

config:
  mysqlDatabase: bankappdb
  ollamaUrl: ""

secrets:
  mysqlRootPassword: Test@123
  mysqlUser: root
  mysqlPassword: Test@123

storageClass:
  create: true
  name: gp3
  provisioner: ebs.csi.aws.com

gateway:
  enabled: false
  hostname: ""
  tls:
    enabled: false
```

**Key improvement over raw YAML — Secrets handling:**

| Feature | Raw YAML | Helm |
|---------|----------|------|
| Base64 encoding | Manual (`echo -n "pass" \| base64`) | Automatic (`b64enc`) |
| Change values | Edit file | CLI / values.yaml |
| Reusability | Low | High |
| Environments | Multiple files | One chart |

Raw `k8s/secrets.yml` had hardcoded base64:
```yaml
data:
  MYSQL_PASSWORD: VGVzdEAxMjM=   # manually encoded, hardcoded
```

Helm template auto-encodes:
```yaml
data:
  MYSQL_PASSWORD: {{ .Values.secrets.mysqlPassword | b64enc | quote }}
```

One chart → multiple environments:
```bash
# Dev
helm install app ./bankapp --set secrets.mysqlPassword=Test@123

# Prod
helm install app ./bankapp --set secrets.mysqlPassword=UltraSecure@987
```

---

### Task 3: Write the Core Templates

**`bankapp/templates/configmap.yaml`:**
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "bankapp.fullname" . }}-config
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "bankapp.labels" . | nindent 4 }}
data:
  MYSQL_HOST: {{ include "bankapp.fullname" . }}-mysql
  MYSQL_PORT: "3306"
  MYSQL_DATABASE: {{ .Values.config.mysqlDatabase | quote }}
  OLLAMA_URL: {{ default (printf "http://%s-ollama:11434" (include "bankapp.fullname" .)) .Values.config.ollamaUrl | quote }}
  SERVER_FORWARD_HEADERS_STRATEGY: "native"
```

**`bankapp/templates/secrets.yaml`:**
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "bankapp.fullname" . }}-secret
  namespace: {{ .Release.Namespace }}
  labels:
    {{- include "bankapp.labels" . | nindent 4 }}
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: {{ .Values.secrets.mysqlRootPassword | b64enc | quote }}
  MYSQL_USER: {{ .Values.secrets.mysqlUser | b64enc | quote }}
  MYSQL_PASSWORD: {{ .Values.secrets.mysqlPassword | b64enc | quote }}
```

**`bankapp/templates/storage.yaml`** combines StorageClass + both PVCs, with conditional blocks so MySQL/Ollama storage is only created when enabled.

---

### Task 4: Write the Deployment Templates

Three deployment templates converted from raw manifests:

**Key template decisions in `bankapp-deployment.yaml`:**
- Init containers dynamically reference service names via `{{ include "bankapp.fullname" . }}`
- Ollama init container is conditional: `{{- if .Values.ollama.enabled }}`
- `replicas` field omitted when HPA is enabled (HPA manages the count)
- Health probes use Spring Boot's `/actuator/health` endpoint

**Key decisions in `ollama-deployment.yaml`:**
- Model name is now a value: `{{ .Values.ollama.model }}` — switch from `tinyllama` to any model without editing YAML
- `postStart` lifecycle hook pulls the model after container starts
- Readiness probe: `ollama list | grep -q tinyllama` — pod only becomes Ready after model is downloaded

---

### Task 5: Write the Services and HPA Templates

**`helm template` output (rendered manifests):**

```yaml
# Source: bankapp/templates/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: my-bankapp-secret
  namespace: default
data:
  MYSQL_ROOT_PASSWORD: "VGVzdEAxMjM="
  MYSQL_USER: "cm9vdA=="
  MYSQL_PASSWORD: "VGVzdEAxMjM="
---
# Source: bankapp/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: my-bankapp-config
data:
  MYSQL_HOST: my-bankapp-mysql
  MYSQL_PORT: "3306"
  MYSQL_DATABASE: "bankappdb"
  OLLAMA_URL: "http://my-bankapp-ollama:11434"
  SERVER_FORWARD_HEADERS_STRATEGY: "native"
---
# Source: bankapp/templates/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: my-bankapp-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: my-bankapp
  minReplicas: 2
  maxReplicas: 4
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
```

---

### Task 6: Validate and Deploy

**Lint:**
```bash
helm lint bankapp/
# ==> Linting bankapp/
# [INFO] Chart.yaml: icon is recommended
# 1 chart(s) linted, 0 chart(s) failed
```

> **Note:** The default generated `NOTES.txt` caused a lint error: `nil pointer evaluating interface {}.enabled` because it referenced `.Values.httpRoute.enabled` which doesn't exist in our `values.yaml`. Fixed by replacing it with a bankapp-specific `NOTES.txt`.

**Initial install:**
```bash
helm install my-bankapp bankapp/ \
  -n bankapp --create-namespace \
  --set storageClass.create=false \
  --set mysql.persistence.storageClass=standard \
  --set ollama.persistence.storageClass=standard
```

```
NAME: my-bankapp
LAST DEPLOYED: Thu Apr 30 01:19:39 2026
NAMESPACE: bankapp
STATUS: deployed
REVISION: 1
NOTES:
AI-BankApp has been deployed successfully!
  - BankApp (Spring Boot): enabled
  - MySQL:  enabled
  - Ollama: enabled
```

**Troubleshooting encountered:**

#### Issue 1 — Image platform mismatch
The original image `trainwithshubham/ai-bankapp-eks:latest` was built only for `linux/amd64` (AWS EKS). Running on Apple Silicon (arm64) caused:
```
no match for platform in manifest: not found
```

**Fix:** Built the image locally targeting `linux/amd64`, then pushed to own Docker Hub account:
```bash
# In the AI-BankApp-DevOps repo
docker buildx build \
  --platform linux/amd64 \
  --provenance=false \
  --sbom=false \
  -t yasheroic/ai-bankapp-eks:latest \
  --push \
  .
```

> **Why `--provenance=false --sbom=false`?** Without these flags, `buildx` creates a manifest list with an extra `unknown/unknown` attestation blob. Kind's containerd sees this blob and fails to match any platform. These flags produce a clean single-platform manifest that Kind can pull without issues.

Verify the manifest is clean (should show only one entry, no `unknown/unknown`):
```bash
docker manifest inspect yasheroic/ai-bankapp-eks:latest
```

Then upgrade the release to use the new image:
```bash
helm upgrade my-bankapp bankapp/ \
  -n bankapp \
  --set bankapp.image.repository=yasheroic/ai-bankapp-eks \
  --set bankapp.image.tag=latest \
  --set storageClass.create=false \
  --set mysql.persistence.storageClass=standard \
  --set ollama.persistence.storageClass=standard
```

#### Issue 2 — Ollama takes time
Ollama pod stayed in `ContainerCreating` for ~12 minutes — it was pulling the 3.2GB `ollama/ollama:latest` image. Then after the container started, the `postStart` hook pulled `tinyllama` (~637MB). BankApp pods stayed at `Init:1/2` the entire time — this is expected. The second init container (`wait-for-ollama`) loops until port 11434 is reachable.

Monitor progress:
```bash
kubectl exec -n bankapp <ollama-pod> -- ollama list
# Empty = still downloading. Shows tinyllama = ready.
```

**Final pod status:**
```
NAME                                 READY   STATUS    RESTARTS   AGE
my-bankapp-7cf98f5bf9-shj47          1/1     Running   0          -
my-bankapp-7cf98f5bf9-th9zm          1/1     Running   0          -
my-bankapp-mysql-6788576b64-dhbwg    1/1     Running   0          -
my-bankapp-ollama-55bb44df54-tdwxg   1/1     Running   0          -
```

**Port-forward and access:**
```bash
kubectl port-forward svc/my-bankapp-service -n bankapp 8080:8080
# Visit http://localhost:8080
```

**Clean up:**
```bash
helm uninstall my-bankapp -n bankapp
kubectl delete namespace bankapp
```

---

## Go Template Syntax Cheat Sheet

| Syntax | What it does | Example |
|--------|-------------|---------|
| `{{ .Values.key }}` | Read from values.yaml | `{{ .Values.bankapp.replicaCount }}` |
| `{{ .Release.Name }}` | Helm release name | `my-bankapp` |
| `{{ .Release.Namespace }}` | Namespace being deployed to | `bankapp` |
| `{{- if .Values.x }}` | Conditional block (leading `-` trims whitespace) | `{{- if .Values.mysql.enabled }}` |
| `{{- end }}` | Close an if/with/range block | |
| `{{ include "name" . }}` | Call a helper function (pipeable) | `{{ include "bankapp.fullname" . }}` |
| `{{ toYaml . \| nindent 4 }}` | Convert object to YAML, indent 4 spaces | Used for `resources:` blocks |
| `{{ .Values.x \| b64enc }}` | Base64 encode a string | `{{ .Values.secrets.mysqlPassword \| b64enc }}` |
| `{{ .Values.x \| quote }}` | Wrap value in quotes | `{{ .Values.config.mysqlDatabase \| quote }}` |
| `{{ default "fallback" .Values.x }}` | Use fallback if value is empty | Used for `ollamaUrl` |
| `{{ printf "http://%s:11434" .name }}` | String formatting | Dynamic service URLs |

---

## How Disabling Ollama Removes All Related Resources

Setting `ollama.enabled=false` removes everything Ollama-related with a single flag:

```bash
helm template my-bankapp bankapp/ --set ollama.enabled=false
```

| Resource | With Ollama | Without Ollama |
|----------|-------------|----------------|
| Ollama Deployment | ✅ Created | ❌ Skipped |
| Ollama Service | ✅ Created | ❌ Skipped |
| Ollama PVC (10Gi) | ✅ Created | ❌ Skipped |
| `wait-for-ollama` init container | ✅ In BankApp pod | ❌ Removed |

This works because every Ollama resource is wrapped in `{{- if .Values.ollama.enabled }}` blocks. One boolean controls an entire component.

---

## Key Takeaways

**12 raw YAML files → 1 Helm chart.** Same Kubernetes resources, but now:
- **Configurable** — every hardcoded value is a `{{ .Values }}` reference
- **Reusable** — one chart deploys to dev, staging, and prod with different values files
- **Rollback-safe** — `helm rollback my-bankapp 1` instantly reverts to any previous revision
- **Self-documenting** — `helm template` renders exactly what will be applied

```
Without Helm: 12 files × 3 environments = 36 YAML files
With Helm:    1 chart  + 3 values files = clean, maintainable setup
```