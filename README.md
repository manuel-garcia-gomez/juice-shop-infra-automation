# 🏗️ DevSecOps Infrastructure Automation

## 📖 Project Overview
This repository contains the Infrastructure as Code (IaC) and GitOps pipeline configurations for provisioning and managing the AWS infrastructure supporting the [OWASP Juice Shop DevSecOps Project](https://github.com/manuel-garcia-gomez/juice-shop-devsecops).

All infrastructure is provisioned declaratively using **Terraform** and deployed via an automated **GitLab CI/CD** pipeline featuring built-in IaC security scanning (**Trivy**) and remote state storage (**AWS S3**).

## 🛠️ Versions & Dependencies
* **AWS Provider:** `hashicorp/aws` (~> 5.3)
* **EC2 Module:** `terraform-aws-modules/ec2-instance/aws` (5.2.1)
* **VPC Module:** `terraform-aws-modules/vpc/aws` (5.1.0)

## 🚀 Provisioned AWS Resources
* **IAM Roles & Policies:**
  * `app-server-role`: `AmazonSSMManagedInstanceCore`, `AmazonEC2ContainerRegistryFullAccess`
  * `gitlab-runner-role`: `AmazonSSMFullAccess`, `AmazonEC2ContainerRegistryFullAccess`
* **Networking & Firewall:**
  * VPC: `main`
  * Security Groups: `main`, `app-server`
* **Compute Instances (Ubuntu 22.04 LTS):**
  * `ec2_app_server`: Application host (`app-server-role`, `app-server` SG)
  * `ec2_gitlab_runner`: Self-managed CI runner (`gitlab-runner-role`, `main` SG)

## 🔄 GitOps Pipeline Architecture
The infrastructure lifecycle is managed via a dedicated GitLab CI/CD pipeline:

* [**GitOps Pipeline & Security Implementation**](https://github.com/manuel-garcia-gomez/juice-shop-infra-automation/pull/1)
  * **Remote State:** Centralized state file storage and lock protection using **AWS S3**.
  * **Validation & Security:** Automated `terraform validate`, plan artifact generation, and **Trivy** static security scanning.
  * **Automated Provisioning:** Pipeline-driven `terraform apply` using validated plan artifacts.

## ⚙️ Configuration & Execution

### 1. Variables Setup (`terraform.tfvars`)
Create a local `terraform.tfvars` file for manual testing (never commit this file to Git):

```hcl
aws_access_key_id         = "your-aws-access-key"
aws_secret_access_key     = "your-aws-secret-key"
aws_region                = "us-east-1"
env_prefix                = "dev"
runner_registration_token = "your-gitlab-runner-token"
```

*Note: `variables.tf` declares variables for the codebase, while `terraform.tfvars` assigns local/secret values.*

### 2. Terraform CLI Commands
```bash
# Initialize project and download providers
terraform init

# Preview infrastructure changes
terraform plan -var-file=terraform.tfvars

# Apply changes with confirmation
terraform apply -var-file=terraform.tfvars

# Apply changes without confirmation
terraform apply -var-file=terraform.tfvars -auto-approve

# List managed resources in active state
terraform state list

# Destroy all managed resources
terraform destroy -var-file=terraform.tfvars
```

*CLI Notes:*
* Set `export TF_LOG=DEBUG` for verbose logging output.
* When using an S3 remote state locally, export `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_DEFAULT_REGION` in your terminal session before executing `terraform init`.

## ⚖️ License & Usage
This project is part of a DevSecOps portfolio for educational and security demonstration purposes.