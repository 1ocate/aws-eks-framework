# 아키텍처

## 범위

이 프레임워크는 AWS VPC와 교체 가능한 Amazon EKS 클러스터의 기반을
프로비저닝합니다. 애플리케이션 workload, 조직별 namespace, S3/RDS/CloudFront,
DNS/ACM, state backend, GitOps 저장소와 비밀정보는 범위에 포함하지 않습니다.

## 계층 모델

1. 소비자가 소유한 `backend`는 각 root state를 격리합니다.
2. `network`는 VPC와 cluster slot별 public/private subnet, NAT를 생성합니다.
3. `cluster`는 하나의 EKS control plane, system capacity, OIDC provider를
   생성합니다.
4. 선택적 platform, workload identity binding, GitOps는 cluster output을
   입력으로 받아 소비자 측 별도 state에서 관리합니다.

각 계층은 독립적인 Terraform state를 사용합니다. 특히 shared data service는
이 저장소가 관리하지 않으며, cluster 교체와 수명 주기가 결합되지 않습니다.

## Blue/green 수명 주기

Blue와 green은 영구 환경이 아니라 교체 가능한 클러스터 slot입니다. 한 번에
하나의 색상만 운영 트래픽을 받습니다. Kubernetes 업그레이드는 비활성 색상을
생성하고 플랫폼과 workload를 동기화한 뒤 검증, 트래픽 전환을 수행하고, 정의된
rollback 기간 동안 이전 색상을 유지하는 방식으로 진행합니다.

## 구성 원칙

- 환경 root가 backend와 provider 설정을 소유합니다. 예제는 backend를
  선언하지 않아 검증 시 외부 state를 만들지 않습니다.
- 재사용 가능한 모듈에는 계정 ID, 도메인 또는 backend 설정을 포함하지
  않습니다.
- 이름과 tag는 작은 공통 context에서 파생합니다.
- 선택적 구성요소는 명시적인 feature flag를 사용합니다.
- 비밀정보는 외부 secret system에서 참조하며 저장소에 커밋하지 않습니다.
