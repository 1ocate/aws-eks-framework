# Architecture

## Scope

The framework provisions an AWS foundation, replaceable Amazon EKS clusters,
cluster platform components, and a GitOps bootstrap. Application workloads are
out of scope except for small, non-production examples.

## Layer model

1. `bootstrap` creates the remote-state prerequisites.
2. `network` creates the VPC and color-specific subnets.
3. `shared` creates resources that survive cluster replacement.
4. `cluster` creates one EKS control plane and its system capacity.
5. `platform` installs networking, autoscaling, ingress, storage drivers, and
   GitOps controllers.
6. `bindings` connects cluster identities and Kubernetes resources to shared
   AWS resources.
7. `gitops-bootstrap` installs the root Argo CD applications.

Each layer has an independent Terraform state so that replacing a cluster does
not couple its lifecycle to shared data resources.

## Blue/green lifecycle

Blue and green are replaceable cluster slots, not permanent environments.
Only one color receives production traffic at a time. A Kubernetes upgrade is
performed by creating the inactive color, synchronizing platform and workloads,
validating it, switching traffic, and retaining the previous color for a defined
rollback window.

## Configuration principles

- Environment roots own backend and provider configuration.
- Reusable modules do not contain account IDs, domains, or backend settings.
- Naming and tagging are derived from a small common context.
- Optional components use explicit feature flags.
- Secrets are referenced from external secret systems and are never committed.
