# AWS EKS 프레임워크

Amazon EKS 클러스터의 in-place 업그레이드와 blue/green 교체 수명 주기를 모두
지원하는 공개 및 재사용 가능한 Terraform·GitOps 프레임워크입니다.

운영 경험을 바탕으로 프로젝트를 추출하고 있지만 조직별 workload, 계정
식별자, 도메인, 자격 증명 또는 Terraform state는 포함하지 않습니다.

## 목표

- 조합 가능한 Terraform 계층으로 반복 가능한 EKS 환경을 구축합니다.
- 공유 AWS 리소스를 교체 가능한 EKS 클러스터와 독립적으로 유지합니다.
- 서비스 위험과 운영 비용에 맞춰 in-place 또는 blue/green 업그레이드를
  선택합니다.
- 클러스터 플랫폼 구성요소와 Argo CD를 일관되게 bootstrap합니다.
- 운영 환경을 가정하지 않는 안전한 예제를 제공합니다.

## 제공 범위

- VPC와 blue/green 등 교체 가능한 cluster slot별 public/private subnet
- slot별 NAT topology와 EKS cluster, managed node group, OIDC provider
- 별도 state를 사용하는 network 및 cluster root 예제

다음 항목은 의도적으로 제공하지 않습니다. 조직별 애플리케이션과 namespace,
S3·RDS·CloudFront 같은 공유 데이터 서비스, DNS/ACM, 원격 state 저장소,
Git repository URL 및 비밀정보입니다. 이들은 대상 환경에서 별도 state와
명시적 입력·출력으로 연결해야 합니다.

## 디렉터리 구조

```text
modules
  ├── network
  └── eks

examples/two-slot
  ├── network       # shared network state
  └── cluster       # one independently replaceable EKS slot
```

## 시작하기

예제는 실제 리소스를 만들지 않는 검증용 구성입니다. 각 root의 state backend는
대상 환경이 소유하며, `terraform init` 시 backend 설정을 별도로 전달합니다.

```sh
cd examples/two-slot/network
cp terraform.example.tfvars terraform.tfvars
terraform init -backend=false
terraform validate
```

network apply 후 `private_subnet_ids_by_slot["blue"]`와 `vpc_id`를 안전한
원격 state 또는 CI 변수로 cluster root에 전달합니다. `terraform.tfvars`는
추적하지 않습니다. `cluster_version`은 대상 계정에서 지원되는 EKS Kubernetes
minor version으로 명시하고, 적용 전에는 전체 plan을 검토해야 합니다.

클러스터 수명 주기 전략과 slot 구성 방법은 [아키텍처 문서](docs/architecture.md#클러스터-수명-주기-전략)에서 확인할 수 있습니다.

## 상태

현재 VPC/EKS 기반 모듈과 안전한 two-slot 예제를 제공합니다. 플랫폼 add-on,
IRSA binding, GitOps와 shared service 연결은 별도 모듈로 추가될 예정입니다.
`addons`를 사용할 경우에는 대상 EKS 버전과 호환되는 정확한 add-on 버전을
대상 환경의 root module에서 명시해야 합니다.

## 기여자 안내

- [Codex 모델 가이드라인](docs/codex-model-guidelines.md)

## 라이선스

첫 공개 릴리스 전에 결정할 예정입니다.
