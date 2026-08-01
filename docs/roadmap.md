# 로드맵

이 문서는 공개 EKS 프레임워크의 현재 상태와 다음 작업의 인수인계를 함께
기록합니다. 각 작업은 독립적으로 검증 가능한 작은 PR로 나누며, 자동 진행
범위에는 `terraform apply`와 PR 병합을 포함하지 않습니다.

## 완료한 기반 구성

- 공개 variable과 output 규칙, 고정된 Terraform·provider 버전 제약을
  정의했습니다.
- 교체 가능한 cluster slot과 독립적인 network module, EKS module 및 중립
  예제를 구현했습니다.
- state backend는 대상 환경에서 관리하도록 하여 조직별 S3 의존성을
  제거했습니다.
- EBS CSI Driver EKS add-on 모듈과 암호화된 gp3 StorageClass Kustomize
  구성을 추가했습니다.
- EKS Pod Identity Agent 및 service account association 모듈을 추가했습니다.
- AWS Load Balancer Controller가 사용할 IRSA role 모듈을 추가했습니다.

## 다음 EKS 플랫폼 작업

완료 순서를 고정하지 않으며, 대상 환경의 요구에 따라 필요한 항목만
선택합니다. 아래 항목은 각각 별도 PR로 진행합니다.

1. AWS Load Balancer Controller Helm release 모듈과 예제를 추가합니다.
   기존 IRSA role의 ARN을 명시적으로 입력받고, chart version과 Service
   mutator webhook 사용 여부를 변수로 노출합니다.
2. Cilium 설치 구성을 별도 모듈 또는 GitOps application으로 추가합니다.
3. Karpenter용 IAM과 Helm release 구성을 분리된 PR로 추가합니다.
4. blue 및 green cluster root 예제를 추가해 교체 전략의 전체 연결 방식을
   보여 줍니다.

## GitOps

- Argo CD bootstrap 구성을 추가합니다.
- 선택 가능한 platform application과 중립적인 sample application을
  추가합니다.
- 환경 승격과 rollback 절차를 문서화합니다.

## 릴리스 준비

- 자동 검증과 integration test를 추가합니다.
- 보안 및 비용 검토를 완료합니다.
- 라이선스와 기여 정책을 선택합니다.
- 저장소 이력에 비공개 자료가 없는지 확인합니다.

## 다음 작업 시작 점검

다음 작업을 시작할 때에는 먼저 최신 `main`을 가져오고, 대상 PR의 변경
범위가 하나의 모듈 또는 하나의 문서 주제인지 확인합니다. 변경 후에는
Terraform format과 해당 root의 validate, 변경된 Kustomize overlay 렌더링,
추적 파일의 비밀정보 검사를 수행합니다. 검증 결과와 남은 전제 조건은 PR
본문에 한국어로 기록합니다.
