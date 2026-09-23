# Argo CD bootstrap 예제

이 root는 cluster state와 독립적으로 Argo CD를 bootstrap합니다. `blue-cluster`
또는 `green-cluster` root의 `cluster_name`, `cluster_endpoint`,
`cluster_certificate_authority_data` output을 안전한 CI 변수 또는 구성 저장소로
전달합니다. 전체 remote state를 직접 읽는 방식은 state에 포함될 수 있는 다른
정보에 대한 접근 권한까지 줄 수 있으므로 피합니다.

이 예제는 AWS CLI의 `eks get-token` exec plugin을 사용합니다. private EKS API
endpoint를 사용하는 기본 cluster 예제에서는 Terraform 실행 환경이 cluster VPC
DNS와 API endpoint에 도달할 수 있어야 합니다. `terraform init -backend=false`와
`terraform validate`는 cluster에 연결하지 않지만, apply는 연결과 적절한 AWS·Kubernetes
권한을 요구합니다.

Argo CD control plane의 ingress는 열지 않습니다. repository 연결, SSO/RBAC,
TLS ingress, platform Application은 별도 GitOps state와 secret 관리 절차에서
추가합니다.
