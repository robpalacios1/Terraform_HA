# Terraform_HA

**Terraform** infrastructure-as-code on AWS: a multi-AZ VPC with public and private subnets, one NAT gateway per availability zone, and four EC2 instances (two public, two private). Terraform state is configured for remote storage in **S3** with locking in **DynamoDB**.

## Repository layout

| Path | Description |
|------|-------------|
| `environments/dev/` | Terraform root for the **dev** environment: invokes the module and defines the backend and AWS provider. |
| `modules/infrastructure/` | Module for networking (VPC, subnets, gateways, routes) and EC2 instances with security groups. |
| `.gitignore` | Ignores `.terraform/`, `*.tfstate*`, `*.tfvars`, local plan files, and override files. |

There are no other environments (for example `prod`) and no CI workflows in this repository in its current state.

## `dev` environment

- **Working directory:** `environments/dev/`
- **Files:**
  - `main.tf` — calls `../../modules/infrastructure` and passes names, CIDRs, AZs (`us-east-1a` / `us-east-1b`), AMI, instance type (`t3.micro`), key pair (`terraform-key`), and `dev-*` tags.
  - `providers.tf` — `terraform` block (**hashicorp/aws** `~> 4.0`), **S3 backend**, and `provider "aws"` using `var.aws_region`.
  - `variables.tf` — `aws_region` variable (default `us-east-1`).
- **Dependency lockfile:** `environments/dev/.terraform.lock.hcl` (alongside the environment you run).

## Remote backend (state)

Defined in `environments/dev/providers.tf` inside `terraform { backend "s3" { ... } }`:

- **Bucket:** `my-project-tf-state-us-east-1`
- **State key:** `terraform.tfstate`
- **Region:** `us-east-1`
- **DynamoDB table (lock):** `terraform-ha-dev-locks`
- **Encryption:** `encrypt = true`

The S3 bucket and DynamoDB table must exist in AWS, and the identity that runs Terraform needs permission on that bucket, that key, and that table.

## `modules/infrastructure` module

Creates, among other resources:

- VPC (`10.0.0.0/16` as configured in dev), Internet Gateway.
- Two public and two private subnets (CIDRs passed from `dev`).
- One public route table with `0.0.0.0/0` via the IGW; associations to the public subnets.
- Two Elastic IPs, two NAT Gateways (one per public AZ), private route tables per AZ with a default route via the matching NAT.
- Security groups for public and private instances (includes SSH rules; review `main.tf` in the module if you change access).
- Four `aws_instance` resources: two in public subnets, two in private subnets.

Module inputs are declared in `modules/infrastructure/variables.tf`; outputs in `modules/infrastructure/outputs.tf` (VPC, IGW, subnet, route table, and NAT IDs).

## Prerequisites

- [Terraform](https://www.terraform.io/downloads) compatible with the environment lockfile.
- An AWS account and configured credentials (CLI, environment variables, or your chosen method).
- In the target region: an EC2 key pair whose name matches `key_name` in `environments/dev/main.tf` (currently `terraform-key`).
- A valid AMI in that region (the AMI set in `main.tf` targets a specific image in `us-east-1`).

## Local usage (from `environments/dev`)

```bash
cd environments/dev
terraform init
terraform validate
terraform plan
terraform apply
```

If you add or change the backend for the first time, Terraform may prompt to migrate existing state; follow the CLI prompts.

## Sensitive values

`*.tfvars` files are listed in `.gitignore`. For extra variables, use `terraform.tfvars` only on your machine or a secrets manager; do not commit secrets to the repository.

## Notes

- NAT Gateways and Elastic IPs incur roughly hourly charges on AWS in addition to data transfer.
- The S3 bucket name and DynamoDB table name in `providers.tf` are what this project uses today; if you rename resources in AWS, update that file so it stays in sync.
