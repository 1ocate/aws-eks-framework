# Argo CD Helm release

이 모듈은 공식 Argo Helm repository의 Argo CD chart를 설치합니다. cluster,
network, Git repository credential와 provider 설정은 소유하지 않으므로 대상
환경의 별도 root module에서 Helm provider를 연결해야 합니다.

기본 chart version `10.2.1`은 정확히 고정되어 있습니다. chart 또는 Argo CD
version을 올릴 때에는 해당 release의 upgrade 문서, CRD 변화와 Kubernetes 지원
버전을 함께 검토해야 합니다. Argo CD 공식 설치 문서는 production에 HA 구성을
권장하며, chart의 HA topology는 Redis pod anti-affinity 때문에 worker node가
최소 세 개 필요합니다.

server Service는 항상 `ClusterIP`이고 ingress는 비활성화됩니다. 외부 UI/API
접근, SSO, RBAC, repository credential 및 TLS는 조직별 보안 경계에 속하므로 이
모듈에 넣지 않습니다. 그런 설정에는 별도 GitOps manifest와 external secret
system을 사용하고, plain-text credential을 Helm values나 Terraform 변수로 전달하지
마세요.

`high_availability = true`는 chart의 non-autoscaling HA topology를 명시적으로
활성화합니다. 이 옵션은 controller 1개, API server·repo server·ApplicationSet
각 2개와 Redis HA를 설정합니다. 충분한 worker capacity와 pod disruption,
monitoring 정책을 먼저 검토하세요.
