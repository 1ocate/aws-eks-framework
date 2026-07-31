# 저장소 지침

이 저장소는 외부에 공개하여 재사용할 수 있도록 관리합니다.

## 안전

- 자격 증명, Terraform state, kubeconfig, 개인 키 또는 조직별 식별자를
  커밋하지 않습니다.
- 계정 ID, 도메인, 저장소 URL, CIDR 범위와 리소스 이름에는 플레이스홀더와
  문서화된 입력 변수를 사용합니다.
- 명시적인 사용자 승인 없이 `terraform apply`를 실행하지 않습니다.
- apply 전에 전체 Terraform plan을 검토합니다. 예상하지 못한 교체 또는
  삭제가 있으면 중단합니다.
- 예제나 테스트에 실제 운영 환경을 사용하지 않습니다.

## GitHub 인증

- `gh auth status` 실패만으로 토큰이 만료되었거나 무효라고 단정하지 않습니다.
  샌드박스 네트워크 제약이나 전역 GitHub CLI 자격 증명이 원인일 수 있습니다.
- GitHub CLI 작업 전, 무시된 `.local/gh-token` 파일이 있으면 토큰을 출력하지
  말고 해당 명령에만 `GH_TOKEN`으로 전달해 `gh api user`로 인증을 확인합니다.
- 로컬 토큰 인증이 성공하면 전역 `gh` 자격 증명 오류와 구분해 보고합니다.
  토큰 값은 로그·명령 출력·커밋·PR 본문에 포함하지 않으며, 전역 인증 설정을
  변경하지 않습니다.

## 설계

- 공유 리소스는 교체 가능한 EKS 클러스터와 독립적으로 유지합니다.
- 재사용 가능한 Terraform 모듈에는 환경별 backend와 provider 설정을
  포함하지 않습니다.
- 계층 간 암묵적인 의존성보다 명시적인 입력과 출력을 우선합니다.
- provider, module, Helm chart와 Kubernetes 구성요소 버전을 고정합니다.
- 모든 공개 모듈에 검증 규칙과 안전한 예제를 포함합니다.

## 모델 선택

- 일반적인 Terraform, Kubernetes, 문서화, 검증 및 유지보수 작업에는 저장소
  기본값인 GPT-5.6 Terra와 medium reasoning을 사용합니다.
- 아키텍처 결정, 어려운 디버깅, 계층 간 의존성 분석, 보안 검토와
  마이그레이션 계획은 GPT-5.6 Sol과 high reasoning으로 새 세션을 시작합니다.
- 파괴적인 Terraform plan이나 운영 마이그레이션 계획처럼 위험도가 가장
  높은 검토에만 GPT-5.6 Sol과 xhigh reasoning을 사용합니다.
- 모델 선택은 세션 단위이며 작업 복잡도에 따라 자동으로 전환되지 않습니다.
- 선택 기준, 명령과 토큰 효율화 방법은
  `docs/codex-model-guidelines.md`를 따릅니다.

## 검증

- `terraform fmt -check -recursive`를 실행합니다.
- 초기화 후 모든 root module에서 `terraform validate`를 실행합니다.
- 변경한 모든 Kustomize overlay를 렌더링하고 검증합니다.
- 릴리스 전에 추적 파일에서 비밀정보와 조직별 값을 검사합니다.
