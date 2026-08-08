# Karpenter Helm release

이 모듈은 Karpenter Helm chart를 OCI registry에서 설치합니다. controller의 IRSA
role과 interruption SQS queue는 별도로 만들고 각각 `iam_role_arn`과
`interruption_queue_name`으로 명시적으로 전달합니다. 모듈에는 provider 설정이나
backend가 없으므로 대상 환경 root module에서 Helm provider를 연결해야 합니다.

기본 chart version `1.14.0`은 Karpenter 공식 설치 문서 기준입니다. chart를 올릴
때에는 같은 release의 controller IAM policy 및 CRD 변경 사항을 함께 검토해야
합니다. 첫 설치 전 Karpenter controller가 실행될 기존 managed node group 또는
Fargate 용량을 유지해야 합니다.

`enable_zonal_shift`는 EKS cluster에서 Amazon ARC zonal shift를 이미 활성화한 경우에만
`true`로 설정합니다. `isolated_vpc`를 `true`로 설정하는 private cluster에는 EC2,
ECR API/DKR, S3, STS, SSM, SQS, EKS endpoint 등 Karpenter가 필요한 VPC endpoint와
controller image 접근 경로가 필요합니다.

Helm release는 namespace와 chart CRD를 설치하지만 chart upgrade의 CRD 처리 방식은
release마다 검토해야 합니다. NodePool 및 EC2NodeClass는 이 모듈의 범위 밖이며,
별도의 GitOps 또는 Kubernetes manifest로 관리합니다.
