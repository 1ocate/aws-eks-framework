# EKS Pod Identity

이 모듈은 EKS Pod Identity Agent add-on과 서비스 계정별 IAM role association을
관리합니다. AWS workload 권한은 대상 환경의 IAM role과 Kubernetes service account를
명시적으로 연결해 관리합니다.

## 전제 조건

- 대상 cluster는 Linux EC2 worker node를 사용해야 합니다. Fargate, Windows node,
  EKS Anywhere, Outposts 환경에서는 EKS Pod Identity를 사용할 수 없습니다.
- node는 EKS Auth API에 접근할 수 있어야 합니다. internet egress가 없는 private
  subnet은 EKS Auth API PrivateLink interface endpoint가 필요합니다.
- association에 전달하는 IAM role은 `pods.eks.amazonaws.com` service principal에
  `sts:AssumeRole`과 `sts:TagSession`을 허용해야 합니다.
- service account와 workload manifest는 이 모듈이 아닌 대상 환경의 platform 또는
  workload 배포에서 관리합니다.

## 버전 선택

`agent_addon_version`은 대상 EKS Kubernetes version과 호환되는 정확한 버전으로
고정해야 합니다. 적용 전 아래 명령으로 호환 버전을 확인합니다.

```sh
aws eks describe-addon-versions \
  --kubernetes-version <eks-version> \
  --addon-name eks-pod-identity-agent
```

EKS Auto Mode에는 Pod Identity Agent가 기본 제공되므로 이 모듈을 사용하지
않습니다.
