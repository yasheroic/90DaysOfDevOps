## Challenge Tasks

### Task 1: Create Environment-Specific 

```
helm install bankapp-dev bankapp/ -f bankapp/values-dev.yaml -n dev --create-namespace
NAME: bankapp-dev
LAST DEPLOYED: Fri May  1 23:46:33 2026
NAMESPACE: dev
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
AI-BankApp has been deployed successfully!

Release: bankapp-dev
Namespace: dev

Components:
  - BankApp (Spring Boot): enabled
  - MySQL:  enabled
  - Ollama: enabled

To access the application, run:
  kubectl port-forward svc/bankapp-dev-service \
    -n dev 8080:8080

Then visit: http://localhost:8080

NOTE: Ollama may take several minutes to pull the 'tinyllama' model.
Watch pod status with:
  kubectl get pods -n dev -w
```

- `helm template bankapp-staging bankapp/ -f bankapp/values-staging.yaml`

```
---
# Source: bankapp/templates/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: bankapp-staging-secret
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: "U3RhZ2luZ1Bhc3NANDU2"
  MYSQL_USER: "cm9vdA=="
  MYSQL_PASSWORD: "U3RhZ2luZ1Bhc3NANDU2"
---
# Source: bankapp/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: bankapp-staging-config
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
data:
  MYSQL_HOST: bankapp-staging-mysql
  MYSQL_PORT: "3306"
  MYSQL_DATABASE: "bankappdb"
  OLLAMA_URL: "http://bankapp-staging-ollama:11434"
  SERVER_FORWARD_HEADERS_STRATEGY: "native"
---
# Source: bankapp/templates/storage.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  fsType: ext4
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
---
# Source: bankapp/templates/storage.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bankapp-staging-mysql-pvc
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  storageClassName: gp3
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 5Gi
---
# Source: bankapp/templates/storage.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bankapp-staging-ollama-pvc
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  storageClassName: gp3
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
# Source: bankapp/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-staging-mysql
  namespace: default
spec:
  selector:
    app: bankapp-staging-mysql
  ports:
    - port: 3306
---
# Source: bankapp/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-staging-ollama
  namespace: default
spec:
  selector:
    app: bankapp-staging-ollama
  ports:
    - port: 11434
---
# Source: bankapp/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-staging-service
  namespace: default
spec:
  type: ClusterIP
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 3600
  selector:
    app: bankapp-staging
  ports:
    - port: 8080
      targetPort: 8080
---
# Source: bankapp/templates/bankapp-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp-staging
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: bankapp-staging
  template:
    metadata:
      labels:
        app: bankapp-staging
    spec:
      initContainers:
        - name: wait-for-mysql
          image: busybox:1.36
          command: ["/bin/sh", "-c", "until nc -z bankapp-staging-mysql 3306; do sleep 2; done"]
          resources:
            requests: { memory: "32Mi", cpu: "50m" }
            limits: { memory: "64Mi", cpu: "100m" }
        - name: wait-for-ollama
          image: busybox:1.36
          command: ["/bin/sh", "-c", "until nc -z bankapp-staging-ollama 11434; do sleep 2; done"]
          resources:
            requests: { memory: "32Mi", cpu: "50m" }
            limits: { memory: "64Mi", cpu: "100m" }
      containers:
        - name: bankapp
          image: "yasheroic/ai-bankapp-eks:v1.2.0"
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8080
          envFrom:
            - configMapRef:
                name: bankapp-staging-config
            - secretRef:
                name: bankapp-staging-secret
          resources:
            limits:
              cpu: 500m
              memory: 512Mi
            requests:
              cpu: 250m
              memory: 256Mi
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 30
            failureThreshold: 15
          livenessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 5
---
# Source: bankapp/templates/mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp-staging-mysql
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: bankapp-staging-mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: bankapp-staging-mysql
    spec:
      containers:
        - name: mysql
          image: "mysql:8.0"
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: bankapp-staging-secret
                  key: MYSQL_ROOT_PASSWORD
            - name: MYSQL_DATABASE
              valueFrom:
                configMapKeyRef:
                  name: bankapp-staging-config
                  key: MYSQL_DATABASE
          resources:
            limits:
              cpu: 500m
              memory: 512Mi
            requests:
              cpu: 250m
              memory: 256Mi
          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql
          readinessProbe:
            exec:
              command: ["mysqladmin", "ping", "-h", "localhost"]
            initialDelaySeconds: 15
            failureThreshold: 10
          livenessProbe:
            exec:
              command: ["mysqladmin", "ping", "-h", "localhost"]
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 5
      volumes:
        - name: mysql-storage
          persistentVolumeClaim:
            claimName: bankapp-staging-mysql-pvc
---
# Source: bankapp/templates/ollama-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp-staging-ollama
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: bankapp-staging-ollama
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: bankapp-staging-ollama
    spec:
      containers:
        - name: ollama
          image: "ollama/ollama:latest"
          ports:
            - containerPort: 11434
          resources:
            limits:
              cpu: 1500m
              memory: 2.5Gi
            requests:
              cpu: 900m
              memory: 2Gi
          volumeMounts:
            - name: ollama-storage
              mountPath: /root/.ollama
          lifecycle:
            postStart:
              exec:
                command:
                  - /bin/sh
                  - -c
                  - |
                    until ollama list > /dev/null 2>&1; do sleep 2; done
                    ollama pull tinyllama
          readinessProbe:
            exec:
              command: ["/bin/sh", "-c", "ollama list | grep -q tinyllama"]
            initialDelaySeconds: 30
            failureThreshold: 30
          livenessProbe:
            httpGet:
              path: /
              port: 11434
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 5
      volumes:
        - name: ollama-storage
          persistentVolumeClaim:
            claimName: bankapp-staging-ollama-pvc
---
# Source: bankapp/templates/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: bankapp-staging-hpa
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: bankapp-staging
  minReplicas: 2
  maxReplicas: 3
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 75
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 30
      policies:
        - type: Pods
          value: 2
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Pods
          value: 1
          periodSeconds: 60
```

- `helm template bankapp-staging bankapp/ -f bankapp/values-prod.yaml`

```


---
# Source: bankapp/templates/secrets.yaml
apiVersion: v1
kind: Secret
metadata:
  name: bankapp-staging-secret
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
type: Opaque
data:
  MYSQL_ROOT_PASSWORD: "UHJvZFNlY3VyZUA3ODk="
  MYSQL_USER: "cm9vdA=="
  MYSQL_PASSWORD: "UHJvZFNlY3VyZUA3ODk="
---
# Source: bankapp/templates/configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: bankapp-staging-config
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
data:
  MYSQL_HOST: bankapp-staging-mysql
  MYSQL_PORT: "3306"
  MYSQL_DATABASE: "bankappdb"
  OLLAMA_URL: "http://bankapp-staging-ollama:11434"
  SERVER_FORWARD_HEADERS_STRATEGY: "native"
---
# Source: bankapp/templates/storage.yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: gp3
provisioner: ebs.csi.aws.com
parameters:
  type: gp3
  fsType: ext4
reclaimPolicy: Delete
volumeBindingMode: WaitForFirstConsumer
allowVolumeExpansion: true
---
# Source: bankapp/templates/storage.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bankapp-staging-mysql-pvc
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  storageClassName: gp3
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 20Gi
---
# Source: bankapp/templates/storage.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: bankapp-staging-ollama-pvc
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  storageClassName: gp3
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
---
# Source: bankapp/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-staging-mysql
  namespace: default
spec:
  selector:
    app: bankapp-staging-mysql
  ports:
    - port: 3306
---
# Source: bankapp/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-staging-ollama
  namespace: default
spec:
  selector:
    app: bankapp-staging-ollama
  ports:
    - port: 11434
---
# Source: bankapp/templates/services.yaml
apiVersion: v1
kind: Service
metadata:
  name: bankapp-staging-service
  namespace: default
spec:
  type: ClusterIP
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 3600
  selector:
    app: bankapp-staging
  ports:
    - port: 8080
      targetPort: 8080
---
# Source: bankapp/templates/bankapp-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp-staging
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: bankapp-staging
  template:
    metadata:
      labels:
        app: bankapp-staging
    spec:
      initContainers:
        - name: wait-for-mysql
          image: busybox:1.36
          command: ["/bin/sh", "-c", "until nc -z bankapp-staging-mysql 3306; do sleep 2; done"]
          resources:
            requests: { memory: "32Mi", cpu: "50m" }
            limits: { memory: "64Mi", cpu: "100m" }
        - name: wait-for-ollama
          image: busybox:1.36
          command: ["/bin/sh", "-c", "until nc -z bankapp-staging-ollama 11434; do sleep 2; done"]
          resources:
            requests: { memory: "32Mi", cpu: "50m" }
            limits: { memory: "64Mi", cpu: "100m" }
      containers:
        - name: bankapp
          image: "yasheroic/ai-bankapp-eks:v1.2.0"
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 8080
          envFrom:
            - configMapRef:
                name: bankapp-staging-config
            - secretRef:
                name: bankapp-staging-secret
          resources:
            limits:
              cpu: 500m
              memory: 512Mi
            requests:
              cpu: 250m
              memory: 256Mi
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 30
            failureThreshold: 15
          livenessProbe:
            httpGet:
              path: /actuator/health
              port: 8080
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 5
---
# Source: bankapp/templates/mysql-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp-staging-mysql
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: bankapp-staging-mysql
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: bankapp-staging-mysql
    spec:
      containers:
        - name: mysql
          image: "mysql:8.0"
          ports:
            - containerPort: 3306
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: bankapp-staging-secret
                  key: MYSQL_ROOT_PASSWORD
            - name: MYSQL_DATABASE
              valueFrom:
                configMapKeyRef:
                  name: bankapp-staging-config
                  key: MYSQL_DATABASE
          resources:
            limits:
              cpu: 1000m
              memory: 1Gi
            requests:
              cpu: 500m
              memory: 512Mi
          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql
          readinessProbe:
            exec:
              command: ["mysqladmin", "ping", "-h", "localhost"]
            initialDelaySeconds: 15
            failureThreshold: 10
          livenessProbe:
            exec:
              command: ["mysqladmin", "ping", "-h", "localhost"]
            initialDelaySeconds: 30
            periodSeconds: 10
            failureThreshold: 5
      volumes:
        - name: mysql-storage
          persistentVolumeClaim:
            claimName: bankapp-staging-mysql-pvc
---
# Source: bankapp/templates/ollama-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bankapp-staging-ollama
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  selector:
    matchLabels:
      app: bankapp-staging-ollama
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: bankapp-staging-ollama
    spec:
      containers:
        - name: ollama
          image: "ollama/ollama:latest"
          ports:
            - containerPort: 11434
          resources:
            limits:
              cpu: 1500m
              memory: 2.5Gi
            requests:
              cpu: 900m
              memory: 2Gi
          volumeMounts:
            - name: ollama-storage
              mountPath: /root/.ollama
          lifecycle:
            postStart:
              exec:
                command:
                  - /bin/sh
                  - -c
                  - |
                    until ollama list > /dev/null 2>&1; do sleep 2; done
                    ollama pull tinyllama
          readinessProbe:
            exec:
              command: ["/bin/sh", "-c", "ollama list | grep -q tinyllama"]
            initialDelaySeconds: 30
            failureThreshold: 30
          livenessProbe:
            httpGet:
              path: /
              port: 11434
            initialDelaySeconds: 60
            periodSeconds: 10
            failureThreshold: 5
      volumes:
        - name: ollama-storage
          persistentVolumeClaim:
            claimName: bankapp-staging-ollama-pvc
---
# Source: bankapp/templates/hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: bankapp-staging-hpa
  namespace: default
  labels:
    helm.sh/chart: bankapp-0.1.0
    app.kubernetes.io/name: bankapp
    app.kubernetes.io/instance: bankapp-staging
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/managed-by: Helm
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: bankapp-staging
  minReplicas: 2
  maxReplicas: 4
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 70
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 30
      policies:
        - type: Pods
          value: 2
          periodSeconds: 60
    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Pods
          value: 1
          periodSeconds: 60
```

---
### Task 2: Add Helm Hooks

- `helm test bankapp-dev -n dev`

```
NAME: bankapp-dev
LAST DEPLOYED: Fri May  1 23:46:33 2026
NAMESPACE: dev
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
```

---

### Task 3: Package and Version the Chart

`helm install my-bankapp bankapp-0.2.0.tgz -f bankapp/values-dev.yaml -n bankapp --create-namespace`

```
yash@Mac helm-chart % helm package bankapp/
helm install my-bankapp bankapp-0.2.0.tgz \
  -f bankapp/values-dev.yaml \
  -n bankapp --create-namespace
Successfully packaged chart and saved it to: /Users/yash/Developer/helm-tws/AI-BankApp-DevOps/helm-chart/bankapp-0.2.0.tgz
NAME: my-bankapp
LAST DEPLOYED: Sat May  2 02:42:49 2026
NAMESPACE: bankapp
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
NOTES:
AI-BankApp has been deployed successfully!

Release: my-bankapp
Namespace: bankapp

Components:
  - BankApp (Spring Boot): enabled
  - MySQL:  enabled
  - Ollama: enabled

To access the application, run:
  kubectl port-forward svc/my-bankapp-service \
    -n bankapp 8080:8080

Then visit: http://localhost:8080

NOTE: Ollama may take several minutes to pull the 'tinyllama' model.
Watch pod status with:
  kubectl get pods -n bankapp -w
yash@Mac helm-chart % 
```


`index.yaml`

```
apiVersion: v1
entries:
  bankapp:
  - apiVersion: v2
    appVersion: 1.1.0
    created: "2026-05-02T02:44:54.795006+05:30"
    description: AI-BankApp -- Spring Boot banking application with MySQL and Ollama
      AI chatbot
    digest: cd1c4d5c5c0d17697aa72aa0aa17839361a507cfd277ee270aaf42ec48d798d8
    keywords:
    - bankapp
    - spring-boot
    - mysql
    - ollama
    - ai
    maintainers:
    - name: TrainWithShubham
      url: https://github.com/TrainWithShubham
    name: bankapp
    type: application
    urls:
    - https://yasheroic.github.io/helm-charts/bankapp-0.2.0.tgz
    version: 0.2.0
  - apiVersion: v2
    appVersion: 1.0.0
    created: "2026-05-02T02:44:54.794766+05:30"
    description: AI-BankApp -- Spring Boot banking application with MySQL and Ollama
      AI chatbot
    digest: 0dba0bab10da22801245c5b292abf03c8a0b1180e00ee79c658c65c5faaa8f34
    keywords:
    - bankapp
    - spring-boot
    - mysql
    - ollama
    - ai
    maintainers:
    - name: TrainWithShubham
      url: https://github.com/TrainWithShubham
    name: bankapp
    type: application
    urls:
    - https://yasheroic.github.io/helm-charts/bankapp-0.1.0.tgz
    version: 0.1.0
generated: "2026-05-02T02:44:54.79425+05:30"

```

### Task 4: Understand Helm in the AI-BankApp GitOps Pipeline

**Document:** What are the advantages of ArgoCD syncing a Helm chart vs raw manifests?

```

---

## 📄 Advantages of ArgoCD Syncing a Helm Chart vs Raw Manifests

Using **Argo CD** with a Helm chart provides several advantages over syncing plain Kubernetes YAML manifests.

---

### 🚀 1. Reusability & DRY (Don’t Repeat Yourself)

* **Helm:** One chart can be reused across dev, staging, and production using different values files.
* **Raw manifests:** Requires duplicating YAML files or maintaining separate folders.

👉 Result: Less duplication, easier maintenance.

---

### ⚙️ 2. Environment-Specific Configuration

* **Helm:** Supports `values-dev.yaml`, `values-staging.yaml`, `values-prod.yaml`
* **Raw manifests:** Requires manual edits or tools like Kustomize

👉 Result: Cleaner multi-environment deployments.

---

### 🔄 3. Easier Updates via CI/CD

* **Helm:** CI pipeline updates only:

  ```yaml
  image:
    tag: <new-version>
  ```
* **Raw manifests:** Must edit full deployment YAML

👉 Result: Faster, safer, and automated updates.

---

### 📦 4. Dependency Management

* **Helm:** Can manage dependencies (e.g., MySQL, Redis) inside the chart
* **Raw manifests:** You must manage each component separately

👉 Result: Entire application stack is deployed together.

---

### 🧠 5. Templating & Dynamic Configuration

* **Helm:** Uses templates (`{{ }}`) to generate dynamic Kubernetes resources
* **Raw manifests:** Static YAML only

👉 Result: More flexibility and less manual work.

---

### 🔁 6. Versioning & Rollbacks

* **Helm:** Each chart version is versioned (`0.1.0`, `0.2.0`)
* **Raw manifests:** No built-in versioning

👉 Result: Easier rollback and release tracking.

---

### 🔍 7. Better GitOps Workflow with ArgoCD

* **Helm + ArgoCD:**

  * ArgoCD tracks the desired state from Helm values
  * Automatically syncs and detects drift
* **Raw manifests:**

  * Harder to manage changes across environments

👉 Result: More scalable and production-ready GitOps pipeline.

---

## 🧠 Summary

| Feature               | Helm + ArgoCD | Raw Manifests |
| --------------------- | ------------- | ------------- |
| Reusability           | ✅ High        | ❌ Low         |
| Multi-env support     | ✅ Native      | ⚠️ Manual     |
| CI/CD integration     | ✅ Easy        | ⚠️ Complex    |
| Dependency management | ✅ Built-in    | ❌ Manual      |
| Flexibility           | ✅ Dynamic     | ❌ Static      |

---

## 🎯 Final Takeaway

> Using Helm with ArgoCD enables scalable, reusable, and automated deployments, while raw manifests are better suited for simple, single-environment setups.

---


### Task 6: Clean Up and Review

- `helm list -A`

NAME            NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
bankapp-dev     dev             1               2026-05-01 23:46:33.666854 +0530 IST    deployed        bankapp-0.1.0   1.0.0      
my-bankapp      bankapp         1               2026-05-02 02:42:49.043983 +0530 IST    deployed        bankapp-0.2.0   1.1.0      

