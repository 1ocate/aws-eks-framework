# 아키텍처

## 범위

이 프레임워크는 AWS VPC와 교체 가능한 Amazon EKS 클러스터의 기반을
프로비저닝합니다. 애플리케이션 workload, 조직별 namespace, S3/RDS/CloudFront,
DNS/ACM, state backend, GitOps 저장소와 비밀정보는 범위에 포함하지 않습니다.

## 계층 모델

1. 각 사용 환경이 소유한 `backend`는 root별 state를 격리합니다.
2. `network`는 VPC와 cluster slot별 public/private subnet, NAT를 생성합니다.
3. `cluster`는 하나의 EKS control plane, system capacity, OIDC provider를
   생성합니다.
4. 선택적 platform, workload identity binding, GitOps는 cluster output을
   입력으로 받아 사용 환경의 별도 state에서 관리합니다.

각 계층은 독립적인 Terraform state를 사용합니다. 특히 shared data service는
이 저장소가 관리하지 않으며, cluster 교체와 수명 주기가 결합되지 않습니다.

## 클러스터 수명 주기 전략

EKS의 Kubernetes minor version은 출시 후 표준 지원 기간이 제한되어 있으므로
업그레이드 계획이 필요합니다. Amazon EKS의 현재 정책은 표준 지원 14개월과 그
뒤의 extended support 12개월입니다. 지원 기간만으로 blue/green을 강제하지
않으며, 서비스의 허용 중단 시간·트래픽 전환 능력·비용을 기준으로 전략을
선택합니다. [EKS Kubernetes version lifecycle](https://docs.aws.amazon.com/eks/latest/userguide/kubernetes-versions.html)을 배포 전 다시 확인합니다.

| 전략 | 적합한 경우 | 장점 | 고려 사항 |
| --- | --- | --- | --- |
| In-place | 짧은 유지보수 창을 허용하고, 워크로드·add-on 호환성을 사전 검증할 수 있는 서비스 | 비용과 운영 구성이 작고, 기존 endpoint와 노드를 유지할 수 있음 | 단계적 minor 업그레이드, 호환성 검증, rollback·복구 절차가 필요함 |
| Blue/green replacement | 무중단에 가까운 전환, 새 platform 검증, 빠른 이전 cluster 복귀가 중요한 서비스 | 새 cluster를 독립적으로 검증한 뒤 트래픽을 전환할 수 있음 | 전환 기간의 이중 capacity·NAT 비용, DNS/load balancer와 데이터 호환성 계획이 필요함 |

이 선택은 provider가 안전하게 전환할 수 있는 단순 feature flag가 아니라 환경
토폴로지 결정입니다. `network.subnet_cidrs`에 한 slot만 전달하면 in-place
전략용 subnet을, 두 개 이상의 slot을 전달하면 replacement 전략용 독립 subnet을
생성합니다. 각 slot은 별도 cluster root와 state로 관리합니다. 기존 단일 slot을
blue/green으로 바꿀 때는 활성 slot을 변경하거나 삭제하지 않고 새 slot과 cluster를
추가한 뒤 검증·트래픽 전환·보존 기간을 거쳐 제거합니다.

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
