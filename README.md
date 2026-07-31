# AWS EKS 프레임워크

Amazon EKS 클러스터를 blue/green 수명 주기로 운영하기 위한 공개 및 재사용
가능한 Terraform·GitOps 프레임워크입니다.

운영 경험을 바탕으로 프로젝트를 추출하고 있지만 조직별 workload, 계정
식별자, 도메인, 자격 증명 또는 Terraform state는 포함하지 않습니다.

## 목표

- 조합 가능한 Terraform 계층으로 반복 가능한 EKS 환경을 구축합니다.
- 공유 AWS 리소스를 교체 가능한 EKS 클러스터와 독립적으로 유지합니다.
- Kubernetes 업그레이드를 위한 blue/green 클러스터 교체를 지원합니다.
- 클러스터 플랫폼 구성요소와 Argo CD를 일관되게 bootstrap합니다.
- 운영 환경을 가정하지 않는 안전한 예제를 제공합니다.

## 예정 아키텍처

```text
bootstrap
  └── 원격 Terraform state와 잠금

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

## 상태

초기 개발 단계입니다. 인터페이스와 디렉터리 구조는 변경될 수 있습니다.

## 기여자 안내

- [Codex 모델 가이드라인](docs/codex-model-guidelines.md)

## 라이선스

첫 공개 릴리스 전에 결정할 예정입니다.
