# 로드맵

## 1단계: 기반 — 완료

- 공개 variable과 output 규칙을 정의했습니다.
- Terraform과 provider 버전 제약을 추가했습니다.
- slot별 network module과 EKS module, 중립 예제를 구현했습니다.
- state backend는 대상 환경에서 관리해 조직별 S3 의존성을 제거했습니다.

## 2단계: EKS 플랫폼

- EKS cluster module을 구현했습니다.
- EBS CSI Driver를 선택 가능한 EKS add-on 모듈로 구현했습니다.
- EBS CSI용 암호화된 gp3 StorageClass Kustomize 구성을 추가했습니다.
- EKS Pod Identity Agent와 service account association 모듈을 구현했습니다.
- Cilium과 Karpenter를 선택 가능한 별도 모듈로 추가합니다.
- load balancer와 storage controller를 추가합니다.
- blue와 green 예제 root를 추가합니다.

## 3단계: GitOps

- Argo CD를 bootstrap합니다.
- 선택 가능한 platform application을 추가합니다.
- 중립적인 sample application을 추가합니다.
- 승격과 rollback 절차를 문서화합니다.

## 4단계: 릴리스 준비

- 자동 검증과 integration test를 추가합니다.
- 보안 및 비용 검토를 완료합니다.
- 라이선스와 기여 정책을 선택합니다.
- 저장소 이력에 비공개 자료가 없는지 확인합니다.
