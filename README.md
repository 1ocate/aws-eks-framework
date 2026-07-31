# AWS EKS Framework

An open-source-ready Terraform and GitOps framework for operating Amazon EKS
clusters with a blue/green lifecycle.

The project is being extracted from production experience, but contains no
organization-specific workloads, account identifiers, domains, credentials, or
Terraform state.

## Goals

- Build repeatable EKS environments from composable Terraform layers.
- Keep shared AWS resources independent from replaceable EKS clusters.
- Support blue/green cluster replacement for Kubernetes upgrades.
- Bootstrap cluster platform components and Argo CD consistently.
- Provide safe examples without embedding production assumptions.

## Planned architecture

```text
bootstrap
  └── remote Terraform state and locking

environments/<name>
  ├── network
  ├── shared
  └── clusters
      ├── blue
      │   ├── cluster
      │   ├── platform
      │   ├── bindings
      │   └── gitops-bootstrap
      └── green

modules
  ├── network
  ├── eks
  ├── karpenter
  ├── cilium
  ├── irsa
  ├── storage
  └── gitops-bootstrap

gitops
  ├── platform
  └── examples
```

## Status

Early development. Interfaces and directory structure may change.

## License

To be determined before the first public release.
