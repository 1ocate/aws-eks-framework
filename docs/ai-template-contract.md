# AI Template 계약

## 상태

이 문서는 AI 지원 사용 계약을 구현하기 위한 설계 기준이다. 아직 generator나
새 Terraform 실행 디렉터리를 추가하지 않는다. 기존 `examples/`를 template으로
정리하거나 새 template을 만들 때 이 계약을 따른다.

## 생성 위치와 파일 소유자

AI는 framework 저장소를 환경별 값으로 수정하지 않는다. 사용자가 지정한 별도
환경 저장소에만 실행 디렉터리를 생성한다.

| 파일 또는 영역 | 소유자 | 규칙 |
| --- | --- | --- |
| framework `modules/`, `templates/`, 검증 | framework | 환경별 값과 backend를 넣지 않는다. |
| `backend.hcl`, `terraform.tfvars` | 사용자 환경 | 추적하지 않으며 credential을 넣지 않는다. |
| `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf` | AI가 template에서 생성 | 허용된 module과 고정된 provider 제약을 사용한다. |
| `.terraform.lock.hcl` | 사용자 환경 | init 결과를 검토 후 추적한다. |

AI는 사용자가 요청한 범위 밖의 component를 생성하지 않으며, component별 boolean
feature flag를 한 실행 디렉터리에 쌓지 않는다. 필요한 component만 포함한 실행
디렉터리를 만든다.

## 전략별 디렉터리

### 단일 cluster

```text
user-eks-environment/
  network/
  cluster/
  platform/
```

### Blue/green

```text
user-eks-environment/
  network/
  slots/
    blue/
      cluster/
      platform/
    green/
      cluster/
      platform/
```

단일 cluster는 하나의 cluster 실행 디렉터리만 가진다. blue/green은 정확히 두 개의
독립 cluster 실행 디렉터리를 가지며, 활성 slot을 변경하거나 삭제해 새 slot을
만들지 않는다. 세 개 이상 slot은 생성하지 않는다.

`binding`과 `application`은 공개 범위와 최소 계약이 확정되기 전까지 위 구조에
추가하지 않는다.

## 실행 단위와 입력 전달

각 디렉터리는 독립 Terraform state를 가진다. AI는 다른 실행 단위의 state를 이름
규칙이나 data source로 발견하지 않는다. 다음 표의 값만 사용자가 승인한 안전한
구성 전달 방식으로 명시 입력한다.

| 이전 실행 단위 | 다음 실행 단위 | 전달 값 |
| --- | --- | --- |
| `network` | `cluster` | VPC ID, 해당 slot의 private subnet ID |
| `cluster` | `platform` | cluster name, endpoint, CA data, OIDC provider ARN/URL |
| ALB Controller IAM | ALB Controller Helm | IAM role ARN |
| Karpenter node IAM·interruption·controller IAM | Karpenter Helm | node/controller role, interruption queue 이름 또는 ARN |

cluster output은 다음 실행 단위가 Kubernetes·Helm provider에 연결하기 위한 계약이다.
cluster 생성과 Kubernetes·Helm provider를 하나의 실행 디렉터리에 넣지 않는다.

## Platform 선택 규약

platform은 다음처럼 필요한 독립 component의 조합으로 생성한다.

| 사용자 선택 | 필요한 의존 순서 |
| --- | --- |
| Cilium | cluster 준비 후 Cilium Helm 적용; 기본 CNI 전환은 별도 검토 단계 |
| Load Balancer Controller | IAM 역할 생성 후 Helm 설치 |
| EBS CSI | OIDC 입력으로 IAM 역할과 EKS add-on 구성 |
| Pod Identity | agent add-on 후 명시 association 구성 |
| Karpenter | node IAM, interruption 처리, controller IAM, Helm 순서 |

기능을 선택하지 않으면 관련 directory, variable, output을 만들지 않는다.

## AI의 생성 절차

1. 사용자에게 cluster 전략과 필요한 platform component만 확인한다.
2. 해당 전략의 directory tree와 state 경계를 만든다.
3. module에 필요한 입력을 variable로 선언하고, 값은 placeholder 또는 사용자 환경의
   비추적 입력 파일에서 받는다.
4. 이전 단계 output을 다음 단계의 입력 목록으로 문서화한다. 민감한 값은 출력·로그에
   노출하지 않는다.
5. `terraform fmt`, `terraform init`, `terraform validate`를 실행한다.
6. apply 전 전체 plan과 삭제·교체·권한 확대 여부를 사용자에게 제시한다.

AI는 generator script를 먼저 만들지 않는다. 이 계약을 따라 한 개의 가상 사용자
환경을 생성·검증한 뒤, 반복되는 안전한 작업만 automation 후보로 올린다.

## 기존 example의 전환 기준

| 현재 항목 | 목표 역할 | 조치 기준 |
| --- | --- | --- |
| `examples/two-slot/network` | network template 후보 | 두 slot 입력 계약을 유지하되 사용자 직접 조립 지침은 제거한다. |
| `examples/two-slot/cluster` | cluster template 후보 | 단일·blue/green 양쪽에서 사용할 공통 cluster 계약으로 유지한다. |
| 개별 platform example | component template 후보 | 선택한 component만 AI가 조합하도록 입력·provider 계약을 명확히 한다. |
| #21의 blue/green 실행 디렉터리 | 재검토 대상 | 공통 cluster template의 중복을 없애고 AI 환경 생성 규약에 맞을 때만 채택한다. |
