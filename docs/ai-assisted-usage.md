# AI 지원 사용 계약

## 목적

이 저장소는 사용자가 AI와 함께 AWS EKS 환경을 구성할 때 사용하는 검증 가능한
기반과 가드레일을 제공한다. 단순 Terraform 예제 모음이나 완성된 운영 환경을
제공하는 저장소가 아니다.

AI는 사용자의 요구를 제한된 선택지와 검증 절차 안에서 환경 구성으로 바꾼다.
사용자는 요구사항을 결정하고 Terraform plan을 검토하며, `terraform apply`를
명시적으로 승인한다.

## 저장소 경계

```text
aws-eks-framework/       공개 framework: module, template, 문서, 검증
user-eks-environment/    사용자 환경: backend, 환경 입력, 실행 디렉터리
```

framework에는 계정 식별자, CIDR, domain, repository URL, backend 값, state,
credential, 실제 workload를 넣지 않는다. 사용자 환경도 credential과 state를
추적 파일에 기록하지 않는다.

## 지원하는 선택지

사용자는 다음만 결정한다.

| 결정 | 지원 값 | 의미 |
| --- | --- | --- |
| cluster 전략 | `in-place` | EKS cluster 하나를 같은 실행 단위에서 업그레이드한다. |
| cluster 전략 | `blue-green` | blue와 green 두 cluster를 독립 state로 만들고 검증 후 트래픽을 전환한다. |
| platform 구성요소 | 필요한 항목만 선택 | CNI, Load Balancer Controller, Karpenter, CSI, workload identity 등은 독립 선택 항목이다. |

세 개 이상 cluster slot, framework 내부의 개발·운영 환경 분리, 실제 application
workload 및 조직별 shared service는 현재 범위에 포함하지 않는다.

## 책임 분리

| 주체 | 책임 |
| --- | --- |
| 사용자 | 전략과 필요한 기능 결정, 환경 입력의 안전한 제공, plan 검토, apply 승인, 트래픽 전환 승인 |
| AI | 허용된 template과 module 선택, 사용자 환경 실행 디렉터리 생성·수정, validate·render·plan 실행, 교체·삭제·비밀정보 위험 보고 |
| framework | 고정된 module·provider·chart 제약, 입력 계약, state 경계, 검증과 rollback 기준 제공 |

AI는 module 내부, provider·chart 버전, state 경계를 사용자의 명시 요청과 검토 없이
변경하지 않는다. AI는 `terraform apply`, 운영 트래픽 전환, cluster 제거를 사용자
승인 없이 실행하지 않는다.

## AI 작업 흐름

1. 사용자의 전략과 필요한 platform 구성요소를 확인한다.
2. 별도 사용자 환경 저장소에 선택한 전략의 실행 디렉터리를 생성한다.
3. network, cluster, platform처럼 수명 주기가 다른 구성은 각각 독립 state로 둔다.
4. 앞 단계의 필요한 output만 다음 단계의 명시 입력으로 전달한다. 다른 state나
   이름 규칙으로 리소스를 찾지 않는다.
5. `terraform fmt`, `terraform validate`, Kustomize render를 실행한다.
6. 전체 Terraform plan에서 교체·삭제·권한 확대·예상 밖 비용 영향을 보고한다.
7. 사용자가 승인한 경우에만 apply한다. blue/green은 새 cluster 검증 후에만
   트래픽을 전환하며, 이전 cluster의 보존 기간과 rollback 기준을 먼저 합의한다.

## Template의 역할

`examples/`와 이후 추가될 template은 사용자가 수동으로 복사해 조립하는 설명서가
아니다. AI가 사용자 환경을 생성할 때 참조하는 검증된 원본이다.

현재 `examples/two-slot`은 이 목표로 완전히 정리되지 않았다. 단일 cluster와
blue/green template의 사용자 환경 생성 규약을 설계한 뒤, 기존 example을 유지·변경·
제거할 범위를 결정한다.

## 중단 기준

다음 조건에서는 구현이나 apply를 진행하지 않고 사용자에게 검토를 요청한다.

- 비밀정보 또는 조직 식별자를 framework·추적 파일에 넣어야 하는 경우
- 다른 state를 추측하거나 전체 state 읽기 권한이 필요해지는 경우
- 기존 network, 활성 cluster 또는 shared resource의 예상 밖 교체·삭제가 plan에 있는 경우
- 실제 사용 사례 없이 새로운 전략, slot, feature flag, 호환 계층을 추가하려는 경우
