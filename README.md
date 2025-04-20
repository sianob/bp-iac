# BP-IAC: Infrastructure as Code for AKS

This repository contains the Terraform code and GitHub Actions workflows to manage Azure Kubernetes Service (AKS) clusters for both **staging** and **production** environments.

In order to contribute you must submit a pull request. This pull request requires at lease one review and for the smoketest status check to pass.

---

## 📁 Folder Structure

```
.
├── BP-IAC/
│   ├── aks-staging/
│   │   ├── main.tf
│   │   ├── output.tf
│   │   ├── providers.tf
│   │   ├── variables.tf
│   │   └── terraform.tfvars
│   └── aks-prod/
│       ├── main.tf
│       ├── output.tf
│       ├── providers.tf
│       ├── variables.tf
│       └── terraform.tfvars
└── .github/
    └── workflows/
        └── deploy.yml
```

---

## 🔀 Staging vs Production Environments

This project uses **two isolated environments**:
- `aks-staging/` – for testing, experimentation, and pre-production validation
- `aks-prod/` – for your live, production-grade infrastructure

Each environment has its own set of Terraform configuration files, including:
- A separate `providers.tf` file that contains the backend configuration
- A unique remote state file in Azure Blob Storage (one for staging, one for prod)

This ensures safe and independent management of environments.

You must **navigate into the correct directory** before running Terraform commands:

```bash
cd BP-IAC/aks-staging
# or
cd BP-IAC/aks-prod
```

---

## 🗂️ Remote State Management

Each environment stores its Terraform state file remotely in an Azure Storage Account using the backend configuration defined in `providers.tf`.

When you run:

```bash
terraform init
```

Terraform reads the `terraform` block in `providers.tf` and configures the backend like this:

```hcl
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "yourstorageaccount"
    container_name       = "tfstate"
    key                  = "staging/terraform.tfstate"  # or prod/terraform.tfstate
  }
}
```

This means:
- State is safely stored in Azure Blob Storage
- Staging and production have **completely separate state files**
- You can collaborate safely with others and avoid overwriting changes

---

## 🚀 Terraform Workflow

### 🔹 1. Initialize Terraform

```bash
terraform init
```

Initializes the working directory, downloads necessary providers, and configures the backend for remote state.

---

### 🔹 2. Validate Configuration

```bash
terraform validate
```

Validates the syntax and configuration of your `.tf` files. Ensures everything is correct before planning or applying changes.

---

### 🔹 3. Preview the Infrastructure Plan

```bash
terraform plan
```

Shows what Terraform *will do* if you apply — including which resources will be created, changed, or destroyed. No changes are made at this stage.

---

### 🔹 4. Apply the Infrastructure

```bash
terraform apply
```

Creates or updates your infrastructure as described in the plan. You'll be prompted to confirm before it proceeds (unless you add `-auto-approve`).

---

### 🔹 5. Destroy the Infrastructure

```bash
terraform destroy
```

Safely tears down all infrastructure managed by Terraform in the current environment. Use with caution!

---

## 🛠 Set up `kubectl` Config After Deployment

Once your AKS cluster is deployed, use the `kubeconfig` output to interact with your cluster:

```bash
terraform output -raw kubeconfig >~/.kube/aks-config 
export KUBECONFIG=~/.kube/aks-config
kubectl config get-contexts
```

---

## ⚙️ GitHub Actions CI/CD

A GitHub Actions workflow is defined in `.github/workflows/deploy.yml` to apply infrastructure changes to **staging** or **production** environments using a manual trigger.

Secrets were created for authenticating to Azure using the GitHub CLI. A GitHub token must be created and then exported `export GH_TOKEN=<your-github-token>`

```
gh secret set ARM_CLIENT_ID --body "$ARM_CLIENT_ID"
gh secret set ARM_CLIENT_SECRET --body "$ARM_CLIENT_SECRET"
gh secret set ARM_TENANT_ID --body "$ARM_TENANT_ID"
gh secret set ARM_SUBSCRIPTION_ID --body "$ARM_SUBSCRIPTION_ID"
```

The workflow:
- Uses a service principal for authentication
- Initializes and applies Terraform
- Targets the correct environment directory based on input

---

## 📚 Resources and References

- [CoachDevOps: Create AKS Cluster using Terraform](https://www.coachdevops.com/2021/09/how-to-create-aks-cluster-using.html)
- [Store Terraform State in Azure Blob Storage (MS Docs)](https://learn.microsoft.com/en-us/azure/developer/terraform/store-state-in-azure-storage?tabs=azure-cli)

---

## ✅ Best Practices Followed

- 🔐 Service Principal auth with `ARM_*` environment variables
- 🗂️ Environment separation via `aks-staging/` and `aks-prod/`
- ☁️ Remote state management in Azure Storage
- 🤖 GitHub Actions for CI/CD pipeline
- 💡 Clean separation of code and secrets

---

Happy shipping! 🚀
