# 아키텍처

## 범위

이 프레임워크는 AWS 기반 환경, 교체 가능한 Amazon EKS 클러스터, 클러스터
플랫폼 구성요소와 GitOps bootstrap을 프로비저닝합니다. 소규모 비운영 예제를
제외한 애플리케이션 workload는 범위에 포함하지 않습니다.

## 계층 모델

1. `bootstrap`은 원격 state에 필요한 리소스를 생성합니다.
2. `network`는 VPC와 색상별 subnet을 생성합니다.
3. `shared`는 클러스터 교체 후에도 유지되는 리소스를 생성합니다.
4. `cluster`는 하나의 EKS control plane과 system capacity를 생성합니다.
5. `platform`은 networking, autoscaling, ingress, storage driver와 GitOps
   controller를 설치합니다.
6. `bindings`는 클러스터 identity와 Kubernetes 리소스를 공유 AWS 리소스에
   연결합니다.
7. `gitops-bootstrap`은 최상위 Argo CD application을 설치합니다.

각 계층은 독립적인 Terraform state를 사용하므로 클러스터를 교체해도 공유
데이터 리소스의 수명 주기와 결합되지 않습니다.

## Blue/green 수명 주기

Blue와 green은 영구 환경이 아니라 교체 가능한 클러스터 slot입니다. 한 번에
하나의 색상만 운영 트래픽을 받습니다. Kubernetes 업그레이드는 비활성 색상을
생성하고 플랫폼과 workload를 동기화한 뒤 검증, 트래픽 전환을 수행하고, 정의된
rollback 기간 동안 이전 색상을 유지하는 방식으로 진행합니다.

## 구성 원칙

- 환경 root가 backend와 provider 설정을 소유합니다.
- 재사용 가능한 모듈에는 계정 ID, 도메인 또는 backend 설정을 포함하지
  않습니다.
- 이름과 tag는 작은 공통 context에서 파생합니다.
- 선택적 구성요소는 명시적인 feature flag를 사용합니다.
- 비밀정보는 외부 secret system에서 참조하며 저장소에 커밋하지 않습니다.
