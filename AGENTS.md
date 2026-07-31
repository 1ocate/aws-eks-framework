# Repository Guidance

This repository is intended to be publicly reusable.

## Safety

- Never commit credentials, Terraform state, kubeconfig files, private keys, or
  organization-specific identifiers.
- Use placeholders and documented input variables for account IDs, domains,
  repository URLs, CIDR ranges, and resource names.
- Never run `terraform apply` without explicit user approval.
- Review the complete Terraform plan before apply. Stop when a plan contains
  unexpected replacement or destruction.
- Do not use real production environments for examples or tests.

## GitHub authentication

- Do not conclude that a token is expired or invalid only from a failed
  `gh auth status`; sandbox network limits or global GitHub CLI credentials
  may be the cause.
- Before GitHub CLI work, if the ignored `.local/gh-token` file exists, pass
  it only to that command as `GH_TOKEN` and verify authentication with
  `gh api user`, without printing the token.
- If local-token authentication succeeds, report it separately from any global
  `gh` credential error. Never include a token in logs, command output, commits,
  or PR bodies, and do not change global authentication settings.

## Design

- Keep shared resources independent from replaceable EKS clusters.
- Keep reusable Terraform modules free of environment-specific backend and
  provider configuration.
- Prefer explicit inputs and outputs over cross-layer implicit dependencies.
- Pin provider, module, Helm chart, and Kubernetes component versions.
- Include validation and safe examples for every public module.

## Verification

- Run `terraform fmt -check -recursive`.
- Run `terraform validate` in every root module after initialization.
- Render and validate every changed Kustomize overlay.
- Scan tracked files for secrets and organization-specific values before release.
