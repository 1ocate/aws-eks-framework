# Karpenter NodePool과 EC2NodeClass

이 Kustomize base는 Karpenter `v1` API의 중립적인 NodePool 및 EC2NodeClass
예제입니다. Karpenter controller Helm release와 controller IRSA role을 먼저
설치해야 하며, node IAM role, subnet 및 security group discovery tag는 이 구성에서
생성하지 않습니다.

적용 전 환경별 overlay에서 다음 `REPLACE_ME` 값을 실제 값으로 치환합니다.

- `spec.role`: 해당 cluster의 Karpenter node IAM role 이름
- `spec.amiSelectorTerms[].alias`: 사용하는 Karpenter release와 호환되는 고정된
  Amazon Linux 2023 AMI alias 버전
- subnet 및 security group selector의 `karpenter.sh/discovery` tag 값: cluster별
  discovery 값

base는 비용과 disruption 위험을 낮추기 위해 on-demand capacity만 허용하고,
비어 있는 node만 5분 뒤 consolidation합니다. underutilized node 교체나 Spot
capacity는 환경별 workload 가용성·중단 허용 수준을 검토한 overlay에서 명시적으로
추가합니다. NodePool의 `cpu: 1000` limit도 계정 quota와 예산에 맞춰 조정합니다.

private cluster는 IAM API VPC endpoint가 없으므로 `spec.role` 대신 미리 만든
`spec.instanceProfile`을 사용해야 합니다. Karpenter chart 및 CRD와 이 manifest의
API version을 함께 올리고 렌더링을 검증합니다.

```sh
kubectl kustomize gitops/platform/karpenter-nodepool/base
```
