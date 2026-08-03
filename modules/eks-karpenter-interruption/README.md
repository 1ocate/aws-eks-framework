# Karpenter interruption events

이 모듈은 Karpenter가 EC2 interruption을 처리할 수 있도록 SQS queue와
EventBridge rule을 만듭니다. Spot interruption, rebalance recommendation, instance
state change, capacity reservation interruption, AWS Health event를 queue로
전달합니다.

queue는 SQS 소유 키로 암호화하고 TLS가 아닌 요청을 거부합니다. controller IAM
role에는 이 모듈의 queue ARN에 대해 `sqs:DeleteMessage`, `sqs:GetQueueUrl`,
`sqs:ReceiveMessage` 권한을 별도로 부여해야 합니다. Karpenter Helm release에는
`queue_name` output을 interruption queue 설정으로 전달합니다.

이 모듈은 controller IRSA, Karpenter node IAM, Helm release, NodePool,
EC2NodeClass를 관리하지 않습니다. 각각은 권한과 운영 영향 범위를 검토할 수 있도록
별도 모듈에서 구성합니다.
