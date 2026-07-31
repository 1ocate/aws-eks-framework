# Codex 모델 가이드라인

이 가이드는 인프라 추론 품질, 토큰 사용량, 지연 시간과 비용의 균형을
유지하면서 이 저장소에서 Codex 모델을 사용하는 기준을 정의합니다.

## 기본값

일반적인 저장소 작업에는 GPT-5.6 Terra와 medium reasoning을 사용합니다.

```bash
codex
```

저장소 기본값은 `.codex/config.toml`에 설정되어 있습니다.

```toml
model = "gpt-5.6-terra"
model_reasoning_effort = "medium"
```

이 설정은 일반적인 Terraform 및 Kubernetes 변경, 문서화, 검증, 테스트
수정과 범위가 명확한 리뷰에 적합합니다.

## 선택 기준

모델 선택은 세션 단위로 이루어집니다. 작업이 복잡해져도 Codex가 모델을
자동으로 전환하지 않습니다. 더 강한 추론이 필요한 작업은 명시적인
override와 함께 새 세션을 시작합니다.

| 작업 유형 | 모델 | Reasoning | 명령 |
| --- | --- | --- | --- |
| 일반 구현 및 유지보수 | GPT-5.6 Terra | `medium` | `codex` |
| 아키텍처, 어려운 디버깅 또는 보안 검토 | GPT-5.6 Sol | `high` | `codex -m gpt-5.6-sol -c 'model_reasoning_effort="high"'` |
| 파괴적 plan 또는 운영 마이그레이션 검토 | GPT-5.6 Sol | `xhigh` | `codex -m gpt-5.6-sol -c 'model_reasoning_effort="xhigh"'` |

다음 조건 중 하나 이상에 해당하면 Sol과 high reasoning을 사용합니다.

- 변경이 여러 Terraform 계층 또는 Kubernetes 제어 영역에 걸쳐 있습니다.
- 정확한 결과가 세밀한 수명 주기 또는 의존성 순서에 좌우됩니다.
- 실패가 보안을 약화하거나 클러스터 중단 또는 데이터 손실을 일으킬 수
  있습니다.
- 디버깅 과정에서 여러 가능성 있는 근본 원인을 함께 검토해야 합니다.
- 복구 방법이 제한적인 마이그레이션 또는 rollback 계획입니다.

문제를 놓쳤을 때 리소스 교체, 삭제, 장시간 중단 또는 안전하지 않은 운영
마이그레이션으로 이어질 수 있는 경우에만 xhigh reasoning을 사용합니다.

## 토큰 효율성

- Terra와 medium reasoning으로 시작하고 작업 위험도나 복잡성이 필요한
  경우에만 상향합니다.
- 하나의 세션은 하나의 결과에 집중하고 목표나 관련 context가 크게 바뀌면
  새 세션을 시작합니다.
- 특별한 이유 없이 전체 저장소를 검사하도록 요청하지 말고 관련 계층, 모듈,
  overlay 또는 plan을 지정합니다.
- 제약 조건과 완료 기준은 한 번만 명시하고 `AGENTS.md`에 있는 저장소 지침을
  반복하지 않습니다.
- 먼저 변경 범위에 집중한 검증을 수행하고 릴리스 전에는 전체 필수 검사를
  실행합니다.
- Sol 검토가 끝난 뒤 일반적인 후속 작업은 Terra로 돌아갑니다.

파괴적인 Terraform plan, 보안 경계 또는 운영 마이그레이션을 검토할 때는
사용량 절감만을 목적으로 reasoning effort를 낮추지 않습니다.

## 인프라 안전

모델 선택과 관계없이 저장소 안전 규칙은 동일하게 적용됩니다.

- 명시적인 사용자 승인 없이 `terraform apply`를 실행하지 않습니다.
- apply 전에 전체 Terraform plan을 검토합니다.
- 예상하지 못한 교체 또는 삭제가 있으면 중단합니다.
- 자격 증명, Terraform state, kubeconfig, 개인 키 또는 조직별 식별자를
  prompt나 커밋 파일에 노출하지 않습니다.
- 예제나 테스트에 실제 운영 환경을 사용하지 않습니다.

모델이나 reasoning 수준과 관계없이 사람의 승인과 `AGENTS.md`의 검증
요구사항이 항상 우선합니다.

## 모델 변경

명시적인 명령줄 옵션은 새 세션에서 저장소 기본값을 override하지만
`.codex/config.toml`을 변경하지는 않습니다.

기존 대화에서 모델을 변경하면 이전 context와 가정이 남을 수 있습니다.
위험도가 높은 작업은 원하는 모델과 reasoning effort로 새 세션을 시작하고,
검토할 정확한 plan, diff 또는 마이그레이션 범위를 제공합니다.
