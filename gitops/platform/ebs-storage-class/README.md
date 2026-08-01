# EBS gp3 StorageClass

Amazon EBS CSI Driver가 설치된 EKS cluster에 범용 `gp3` StorageClass를
제공합니다. EBS CSI Driver는 [별도 Terraform 모듈](../../../modules/eks-ebs-csi)로
설치하며, 이 Kustomize 구성은 driver나 IAM 역할을 생성하지 않습니다.

## Base 구성

`base`는 다음의 안전한 기본값을 사용합니다.

- EBS CSI provisioner: `ebs.csi.aws.com`
- 볼륨 유형: `gp3`
- EBS 암호화: 활성화
- volume expansion: 허용
- volume binding: `WaitForFirstConsumer`
- reclaim policy: `Retain`

`Retain`은 PVC 또는 PV를 삭제해도 EBS volume을 자동으로 제거하지 않습니다.
보존된 PV와 volume은 대상 환경의 운영 절차에 따라 확인하고 정리해야 합니다.

```sh
kubectl kustomize gitops/platform/ebs-storage-class/base
```

## 기본 StorageClass 지정

`overlays/set-as-default`는 `ebs-gp3`에
`storageclass.kubernetes.io/is-default-class: "true"` annotation을 추가합니다.

```sh
kubectl kustomize gitops/platform/ebs-storage-class/overlays/set-as-default
```

기존 default StorageClass가 있는 cluster에서는 이 overlay를 적용하기 전에 기존
annotation을 제거할 운영 절차를 마련해야 합니다. Kubernetes는 default annotation을
자동으로 하나만 유지하지 않습니다.

## 대상 환경별 확장

KMS CMK, IOPS, throughput 같은 조직별 요구 사항은 대상 환경 overlay에서
`StorageClass.parameters`를 patch해 설정합니다. 계정 ID, KMS key ARN, workload별
PVC는 base에 포함하지 않습니다.
