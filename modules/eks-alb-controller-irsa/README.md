# AWS Load Balancer Controller IRSA

이 모듈은 AWS Load Balancer Controller Helm 설치에 필요한 IRSA role만 생성합니다.
Controller release에 맞는 upstream IAM policy document를 대상 환경에서 customer-managed
policy로 생성하고, 그 ARN을 `iam_policy_arn`으로 전달해야 합니다.

policy document와 Helm chart는 반드시 같은 controller release 기준으로 검토합니다.
이 모듈은 Helm release, Ingress, Service, DNS, ACM certificate를 관리하지 않습니다.
