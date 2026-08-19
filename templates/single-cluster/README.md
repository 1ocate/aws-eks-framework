# 단일 Cluster AI Template

AI는 이 template을 사용자 환경 저장소의 `network/`, `cluster/`, 선택한
`platform/` 실행 디렉터리로 렌더링한다. 이 디렉터리 자체를 환경별 값으로 수정하거나
그대로 apply하지 않는다.

렌더링 전 다음 placeholder를 고정된 값으로 치환한다.

| Placeholder | 값 |
| --- | --- |
| `{framework_repository}` | framework의 Git clone URL |
| `{framework_ref}` | 검증한 release tag가 가리키는 전체 commit SHA |

AI는 network output의 VPC ID와 `primary` slot private subnet ID를 cluster 입력으로,
cluster output의 OIDC provider ARN/URL을 선택한 platform 입력으로 전달한다. 이 값은
다른 state를 추측해서 찾지 않고 사용자 승인 구성으로 명시 전달한다.

`terraform.tfvars`와 backend 설정은 사용자 환경에만 만들며 추적하지 않는다.
