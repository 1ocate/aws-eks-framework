# Karpenter controller IRSA

이 모듈은 Karpenter `v1.14.0` 공식 CloudFormation controller 정책을 기준으로
IRSA role을 만듭니다. 정책은 node lifecycle, instance profile 관리, EKS endpoint
조회, interruption queue 수신, resource discovery 권한으로 나누어 inline policy로
연결합니다.

각 권한은 대상 AWS partition·region·account, cluster discovery tag, node role ARN,
interruption queue ARN으로 제한됩니다. chart version을 올릴 때에는 반드시 같은
release의 Karpenter 공식 CloudFormation 정책과 이 모듈을 함께 대조해야 합니다.

`node_role_arn`은 `eks-karpenter-node-iam` module output을, `interruption_queue_arn`은
`eks-karpenter-interruption` module output을 전달합니다. Karpenter Helm release는
이 모듈의 `role_arn`을 controller service account annotation에 연결합니다.

이 모듈은 Helm release, NodePool, EC2NodeClass와 subnet·security group discovery
tag를 만들지 않습니다. controller를 설치하기 전에 Karpenter가 실행될 기존
managed node group 용량을 유지해야 합니다.
