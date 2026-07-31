# 로드맵

## 1단계: 기반

- 공개 variable과 output 규칙을 정의합니다.
- Terraform과 provider 버전 제약을 추가합니다.
- state bootstrap과 network module을 구현합니다.
- 정적 검사와 비밀정보 검사를 추가합니다.

## 2단계: EKS 플랫폼

- EKS cluster module을 구현합니다.
- Cilium과 Karpenter를 추가합니다.
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
