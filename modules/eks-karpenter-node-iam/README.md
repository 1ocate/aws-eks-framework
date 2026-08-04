# Karpenter node IAM

이 모듈은 Karpenter가 생성하는 Linux node의 IAM role과 EKS `EC2_LINUX` access
entry를 만듭니다. access entry를 사용하므로 대상 EKS cluster의 authentication
mode는 `API` 또는 `API_AND_CONFIG_MAP`이어야 합니다. 이 저장소의 EKS module은
`API` mode를 사용합니다.

기본으로 EKS worker, ECR image pull, SSM managed instance 정책을 연결합니다.
`attach_vpc_cni_policy`는 AWS VPC CNI에 별도 Pod Identity 또는 IRSA role이 없는
환경을 위한 안전한 기본값입니다. CNI 권한을 별도 role로 관리한다면 `false`로
설정합니다.

Karpenter controller는 이후 `EC2NodeClass`에서 이 role name을 참조합니다.
instance profile은 controller가 관리하므로 이 모듈에서 만들지 않습니다.

role을 삭제하고 같은 ARN으로 다시 만들면 EKS access entry가 기존 role ID를
보관해 동작하지 않을 수 있습니다. 해당 경우 access entry를 별도로 다시 만들어야
합니다.
