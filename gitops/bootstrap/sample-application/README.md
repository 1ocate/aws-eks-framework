# Sample Application bootstrap

이 template은 `gitops/examples/sample-application/base` 같은 중립 sample
application을 Argo CD가 관리하도록 하는 `Application`입니다. base는 유효한
repository를 가리키지 않으므로 직접 적용하지 않습니다. 환경 overlay에서
`repoURL`, `targetRevision`, `path`를 명시하고, 운영 환경에서는 최소 권한
`AppProject`를 만든 뒤 `spec.project`도 변경하세요.

자동 sync, prune, self-heal과 resources finalizer는 포함하지 않았습니다. 운영자는
최초와 이후 sync 전에 rendered manifest와 Argo CD diff를 검토해야 합니다. private
repository credential은 이 manifest에 넣지 말고 external secret 또는 조직의 secret
manager를 사용하세요.
