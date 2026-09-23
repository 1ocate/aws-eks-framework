# 중립 sample application

이 예제는 cluster 내부에만 노출되는 NGINX Deployment와 ClusterIP Service를
Kustomize로 렌더링합니다. image version은 `1.30.4-alpine`으로 고정되어 있으며,
production workload나 외부 ingress를 나타내지 않습니다.

`base`는 `sample-app` namespace, Deployment, Service를 함께 만듭니다. 대상
환경에서 사용하려면 별도 overlay를 만들고 image digest, resource request·limit,
replica, namespace, NetworkPolicy, Pod Security 및 ingress를 해당 환경의 정책에
맞게 명시하세요. sample configuration에는 secret, domain, account ID, repository
credential를 넣지 않습니다.
