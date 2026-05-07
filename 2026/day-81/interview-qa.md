Great. Let me give you every question they can ask with answers in your own voice — the way you should actually speak in an interview.

---

## Category 1 — Project Overview Questions

**Q: Tell me about your project.**

> "I worked on deploying a production-grade AI-powered banking application called AI-BankApp on AWS EKS. The app has three main components — a Spring Boot backend, a MySQL database, and an Ollama AI service that powers a chatbot. I handled the complete infrastructure and deployment side — provisioned the EKS cluster using Terraform, set up GitOps-based deployments using ArgoCD, built CI pipelines with GitHub Actions, and packaged everything using Helm charts. The infrastructure is fully reproducible — one terraform apply brings up the entire stack."

---

**Q: What does the application actually do?**

> "It's a banking application where users can register, log in, and manage their accounts. The interesting part is it has an AI chatbot powered by Ollama running TinyLlama model — users can ask banking-related questions and get AI responses. From a DevOps perspective what made it interesting was the storage requirements — MySQL needs persistent storage for user data, Ollama needs persistent storage for the AI model which is several GBs. Both use EBS volumes backed by PVCs on EKS."

---

**Q: What is your role in this project?**

> "Entirely infrastructure and DevOps. I didn't write the application code — my focus was provisioning the cloud infrastructure, containerizing and deploying the services, setting up the CI/CD pipeline, and making the deployment fully automated through GitOps. Everything from VPC creation to the final app running on EKS was my responsibility."

---

## Category 2 — Infrastructure and Terraform Questions

**Q: How did you provision the infrastructure?**

> "Using Terraform with a modular approach. The infrastructure is split into separate files — vpc.tf for networking, eks.tf for the cluster, argocd.tf for installing ArgoCD via Helm. I used the official terraform-aws-modules for VPC and EKS which are community-maintained battle-tested modules. State is stored remotely in S3 so it's shared and versioned."

---

**Q: Walk me through your VPC architecture.**

> "The VPC has 9 subnets across 3 availability zones for high availability. Public subnets host the load balancers — anything that needs to be internet-facing. Private subnets host the worker nodes — they're not directly reachable from internet which is a security best practice. There are also intra subnets for the EKS control plane ENIs. A NAT gateway sits in the public subnet so the private subnet worker nodes can reach internet to pull Docker images — but without being exposed to internet themselves."

---

**Q: Why private subnets for worker nodes?**

> "Security. If worker nodes were in public subnets they'd have public IPs and be directly reachable from internet — that's an attack surface. In private subnets they're isolated. The only way traffic reaches them is through the load balancer which we control. NAT gateway handles their outbound internet access for things like pulling images."

---

**Q: What is IRSA and why did you use it?**

> "IRSA stands for IAM Roles for Service Accounts. In Kubernetes pods need to interact with AWS services — in our case the EBS CSI driver needs permission to create and attach EBS volumes. IRSA allows you to attach an IAM role directly to a Kubernetes service account, so only that specific pod gets those AWS permissions. It's more secure than giving the entire EC2 node broad AWS permissions."

---

**Q: What EKS addons did you install and why?**

> "Six addons. CoreDNS for DNS resolution inside the cluster so pods can find each other by name. Kube-proxy for service networking. VPC CNI which is AWS specific — it gives each pod its own VPC IP address so pods are directly routable within the VPC. EBS CSI driver so our PVCs can provision actual EBS volumes on AWS. Metrics server so kubectl top works and HPA can function. And eks-pod-identity-agent which enables IRSA."

---

**Q: What does terraform destroy do to your cluster?**

> "It tears down everything in reverse order of creation — ArgoCD first, then the EKS cluster, node groups, addons, then VPC and all networking. Everything is deleted cleanly. This is why IaC is powerful — you can spin up a full production environment and tear it down completely with one command. We did this to save costs since EKS costs around $7 per day for this setup."

---

## Category 3 — Kubernetes Questions

**Q: How many nodes did your cluster have and why that size?**

> "3 t3.medium nodes across 3 availability zones — one per AZ. t3.medium gives 2 vCPU and 4GB RAM. We needed at least 3 nodes for high availability — if one AZ goes down the other nodes keep running. The Ollama pod alone needs 2-2.5GB RAM so we needed nodes with enough memory. t3.medium can run approximately 17 pods per node based on ENI and IP limitations on AWS."

---

**Q: What is a managed node group?**

> "In EKS you have three options for worker nodes. Managed node groups where AWS handles provisioning, scaling, and updates of the EC2 instances — that's what we used. Self-managed nodes where you handle the EC2 instances yourself. And Fargate which is fully serverless with no nodes to manage at all. We chose managed node groups because it's the balance between control and convenience — AWS handles the node lifecycle but we still control the instance type and scaling config."

---

**Q: How did you handle persistent storage?**

> "Using PersistentVolumes and PersistentVolumeClaims backed by EBS volumes. MySQL needs 5Gi for database storage, Ollama needs 10Gi for the AI model. When a PVC is created on EKS with the EBS CSI driver installed, AWS automatically provisions an EBS volume in the same availability zone as the pod. The data persists even if the pod restarts — it just reattaches to the same EBS volume."

---

**Q: What startup order do your pods follow and why?**

> "MySQL starts first and becomes healthy. Then Ollama starts and pulls the TinyLlama model which takes 2-5 minutes. The BankApp has init containers that wait for both MySQL and Ollama to be ready before the main container starts. This is important because if BankApp starts before MySQL is ready it will crash trying to connect to the database. Init containers solve this dependency ordering problem."

---

**Q: What is HPA and did you use it?**

> "HPA is Horizontal Pod Autoscaler. It automatically scales the number of pod replicas based on metrics — usually CPU or memory. Yes we had HPA configured for the BankApp. It requires the metrics-server addon to be running which we installed. So if traffic increases and CPU goes high HPA automatically adds more BankApp pods. It scales down when load reduces."

---

## Category 4 — ArgoCD and GitOps Questions

**Q: What is GitOps and why did you use it?**

> "GitOps means Git is the single source of truth for your infrastructure and deployments. Instead of someone manually running kubectl apply, ArgoCD watches your Git repository and automatically applies any changes to the cluster. If someone pushes a new Helm chart value or manifest to Git — ArgoCD detects it and syncs the cluster to match. The benefit is every deployment is auditable through Git history, you can rollback by reverting a commit, and no one needs direct kubectl access to deploy."

---

**Q: How does ArgoCD know when to deploy?**

> "ArgoCD continuously polls the Git repository — by default every 3 minutes. When it detects a difference between what's in Git and what's running in the cluster it marks the app as OutOfSync. With auto-sync enabled it automatically applies the changes. In our CI pipeline GitHub Actions updates the image tag in the Helm values file and pushes to Git — ArgoCD picks that up and deploys the new version automatically."

---

**Q: How did you install ArgoCD?**

> "Via Terraform using a Helm chart — it's defined in argocd.tf. So it gets installed automatically as part of terraform apply when the cluster is created. It runs as pods inside the argocd namespace on EKS. It's exposed via a LoadBalancer service so we can access the ArgoCD UI from a browser using the AWS LoadBalancer URL."

---

**Q: What is an ArgoCD Application manifest?**

> "It's a Kubernetes custom resource that tells ArgoCD what to deploy and where. It specifies the Git repo URL, the path inside the repo where the Helm chart or manifests are, and the destination cluster and namespace. ArgoCD reads this manifest and starts watching that repo path. Any change to that path in Git triggers a sync."

---

**Q: How do you rollback with ArgoCD?**

> "Two ways. Through the ArgoCD UI you can see the deployment history and click rollback to any previous version — it reverts the cluster to that state. Or through CLI using argocd app rollback. Under the hood it's just reverting to a previous Git commit state. This is the power of GitOps — rollback is just going back in Git history."

---

## Category 5 — CI/CD Questions

**Q: Walk me through your complete CI/CD pipeline.**

> "When a developer pushes code to the main branch, GitHub Actions triggers. First job runs the tests. If tests pass the second job builds the Docker image, tags it with the Git commit SHA for traceability, and pushes to AWS ECR. Then it updates the image tag in the Helm values.yaml file in the Git repo and commits that change. ArgoCD detects the new commit, sees the image tag changed, and automatically deploys the new version to EKS. So the full flow is — code push to GitHub Actions to ECR to Git update to ArgoCD to EKS."

---

**Q: Why did you tag images with Git commit SHA?**

> "For traceability. If something breaks in production you can immediately see which commit caused it — the image tag tells you exactly. Using latest tag is a bad practice because you lose that traceability — you can't tell which code version is running. Commit SHA tags are immutable and unique."

---

**Q: What is the difference between CI and CD in your pipeline?**

> "CI is the automated build and test part — GitHub Actions runs tests, builds the Docker image, pushes to ECR. That's continuous integration — every code change is automatically built and validated. CD is the deployment part — ArgoCD watches Git and automatically deploys to EKS when it detects changes. That's continuous delivery — every validated change automatically goes to the target environment."

---

## Category 6 — Scenario and Troubleshooting Questions

**Q: A pod is in CrashLoopBackOff — how do you debug?**

> "First check the logs — kubectl logs podname --previous to see logs from the crashed container. That usually tells you why it crashed — missing environment variable, can't connect to database, out of memory. Then kubectl describe pod podname to see events — it shows things like image pull failures, volume mount issues, liveness probe failures. In our project if BankApp is in CrashLoopBackOff it's usually because MySQL isn't ready yet or an environment variable for DB connection is wrong."

---

**Q: A pod is Pending — what are the possible reasons?**

> "Few common reasons. Insufficient resources — no node has enough CPU or memory to schedule the pod. In our case Ollama needs 2.5GB RAM so if nodes are full it stays Pending. Node selector or affinity rules that don't match any node. PVC not bound — if the EBS volume couldn't be provisioned the pod waits. You debug with kubectl describe pod and look at the Events section — it tells you exactly why it's not scheduling."

---

**Q: How would you handle a situation where terraform apply fails midway?**

> "Terraform is idempotent so you just run terraform apply again. It reads the current state from the S3 remote backend, compares with desired state, and only creates what's missing. It won't recreate things that already exist. We had this happen once during EKS provisioning — it failed on an addon, we ran apply again and it picked up from where it stopped."

---

**Q: EKS cluster is up but kubectl can't connect — what do you do?**

> "First thing is run aws eks update-kubeconfig command again with the cluster name and region. This updates your local kubeconfig file with the cluster endpoint and credentials. Then check aws sts get-caller-identity to make sure your AWS credentials are valid and you're using the right profile. If still failing check if the EKS API endpoint is public or private — if private you need to be inside the VPC or use a VPN to reach it."

---

## Category 7 — Cost and Production Thinking Questions

**Q: What does this setup cost and how would you optimize it?**

> "For our setup it's around $7 per day — $0.10/hour for EKS control plane, about $0.13/hour for 3 t3.medium nodes, $0.045/hour for NAT gateway, plus EBS and LoadBalancer costs. For a real production setup I'd optimize by using Spot instances for non-critical workloads which can save 60-70% on node costs. Use a single NAT gateway only in dev, multiple for prod HA. Right-size nodes based on actual resource usage from metrics."

---

**Q: What would you improve if this went to real production?**

> "Several things. Add cluster autoscaler so nodes scale up and down based on actual load instead of fixed 3 nodes. Add pod disruption budgets to ensure zero downtime during node updates. Set up proper monitoring with Prometheus and Grafana with alerts on pod restarts and node memory pressure. Use AWS Secrets Manager instead of Kubernetes secrets for sensitive data like DB passwords. Add network policies to restrict pod-to-pod communication. And set up multiple environments — dev, staging, prod — with separate clusters or namespaces."

---

## How to Use These in Interviews

Three rules:

**Don't memorize word for word.** Read each answer, understand the point, then close this and say it in your own words out loud. Your natural speaking voice is better than a rehearsed answer.

**Always connect to something specific you did.** Don't say "EBS is used for persistent storage." Say "In our project MySQL needed 5Gi and Ollama needed 10Gi — both backed by EBS volumes through PVCs."

