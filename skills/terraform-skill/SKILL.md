---
name: terraform-skill
description: "Terraform and OpenTofu authoring, validation, and security workflow. Writes HCL modules, runs plan/apply cycles, and scans for misconfigurations. Use when the user asks about Terraform modules, HCL files, infrastructure as code, terraform plan/apply, tfvars, state management, or OpenTofu configurations."
---

# Terraform Skill

## Purpose

Guide safe infrastructure-as-code changes using Terraform/OpenTofu best practices with concrete validation at every step.

## Inputs

- IaC module or environment target
- Provider and backend configuration
- Policy/security constraints

## Process

1. **Read current module patterns** and understand state implications:
   ```bash
   # Check existing structure
   ls *.tf terraform.tfstate.d/ .terraform/ 2>/dev/null
   # Review what providers and backends are configured
   grep -r 'provider\|backend' *.tf
   ```
2. **Implement minimal, reviewable changes** following conventions:
   ```hcl
   # Use variables with descriptions and validation
   variable "instance_type" {
     description = "EC2 instance type for the web server"
     type        = string
     default     = "t3.micro"
     validation {
       condition     = can(regex("^t3\\.", var.instance_type))
       error_message = "Only t3 instance types are allowed."
     }
   }
   ```
3. **Run format, validate, and plan checks**:
   ```bash
   terraform fmt -recursive
   terraform validate
   terraform plan -out=tfplan
   # Review plan for unintended changes
   terraform show tfplan
   ```
4. **Add or update tests** when applicable:
   ```bash
   # Native Terraform test (1.6+)
   terraform test
   # Or run Terratest if the project uses it
   cd test/ && go test -v -timeout 30m
   ```
5. **Check for security issues**:
   ```bash
   # If tfsec is available
   tfsec .
   # Or checkov
   checkov -d .
   ```

## Output Format

- Changed modules/resources with rationale
- `terraform plan` summary (resources to add/change/destroy)
- Risk notes and rollout guidance

## Quality Checks

- [ ] `terraform fmt` and `terraform validate` pass
- [ ] Plan output reviewed — no unintended resource destruction
- [ ] Sensitive values use `sensitive = true` and are not exposed in logs
- [ ] State is not modified directly; changes go through plan/apply
