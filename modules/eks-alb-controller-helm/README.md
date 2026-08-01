# AWS Load Balancer Controller Helm release

이 모듈은 AWS Load Balancer Controller Helm chart를 설치합니다. IRSA role은
별도의 `eks-alb-controller-irsa` 모듈에서 먼저 만들고, 그 ARN을
`iam_role_arn`으로 전달합니다. 모듈에는 provider 설정이나 backend를 포함하지
않으므로 대상 환경의 root module에서 Helm provider 연결을 구성해야 합니다.

기본 chart version `1.14.0`은 AWS EKS Helm 설치 문서의 예시 버전입니다. chart를
올릴 때에는 controller release와 IRSA role에 연결한 customer-managed IAM policy를
같은 upstream release 기준으로 함께 검토해야 합니다.

`enable_service_mutator_webhook`의 기본값은 `false`입니다. 이를 `true`로 설정하면
새 `LoadBalancer` Service에 controller-managed NLB class가 자동으로 지정됩니다.
기존 환경의 Service 생성 동작을 바꿀 수 있으므로 대상 환경에서 명시적으로
선택합니다.

Helm chart는 최초 설치 때 CRD를 설치하지만 Helm upgrade는 CRD를 자동으로
업데이트하지 않습니다. chart upgrade 전에 해당 release의 CRD 변경 사항을 검토하고
필요한 CRD를 별도 절차로 적용해야 합니다.

EKS Auto Mode는 자체 load balancing 기능을 제공하므로 이 모듈을 설치하지
않습니다.
