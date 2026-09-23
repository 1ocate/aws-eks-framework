# Platform Application bootstrap

이 Kustomize 구성은 이미 설치된 Argo CD가 같은 cluster의 platform manifests를
관리하도록 하는 `Application` 템플릿입니다. base에는 유효한 Git repository나
조직별 경로가 없으므로 직접 적용하지 않습니다. 대상 환경은 overlay에서 다음
세 값을 명시해야 합니다.

- `spec.source.repoURL`: platform Git repository URL
- `spec.source.targetRevision`: promotion 정책에 맞는 immutable tag 또는 검토된 branch
- `spec.source.path`: repository 안의 대상 cluster platform 경로

`overlays/example`은 렌더링 검증용 중립 예시입니다. `example` repository나
cluster를 실제 환경으로 가정하지 않습니다. private repository credential은
Terraform 변수나 이 manifest에 넣지 말고, Argo CD의 external secret 또는
조직의 secret manager 통합으로 별도 관리하세요.

Application은 `syncPolicy.automated`와 resources finalizer를 의도적으로 포함하지
않습니다. 따라서 최초 bootstrap과 이후 sync는 운영자가 diff를 검토하고 수동으로
실행하며, Application 삭제가 관리 대상 resource를 cascade 삭제하지 않습니다.
자동 sync, prune, self-heal 또는 cascade deletion은 대상 platform의 resource 범위와
rollback 절차를 검토한 별도 변경에서만 활성화하세요.

기본 `project: default`는 예시를 렌더링하기 위한 값입니다. 운영 환경에서는 source
repository와 destination cluster·namespace, cluster-scoped resource를 최소 권한으로
제한하는 `AppProject`를 먼저 만들고 Application의 `project`를 그 이름으로
바꾸세요.
