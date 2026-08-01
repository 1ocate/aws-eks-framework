# Cilium AWS VPC CNI chaining

이 모듈은 기존 AWS VPC CNI 위에 Cilium을 chaining 방식으로 설치합니다. Pod IP
할당과 기본 네트워크 연결은 AWS VPC CNI가 계속 담당하고, Cilium은 eBPF 기반
L3/L4 가시성·network policy·load balancing 기능을 제공합니다.

이 범위는 CNI 교체, kube-proxy replacement, ENI를 직접 관리하는 Cilium 모드,
기존 workload 재시작을 자동화하지 않습니다. 이러한 전환은 네트워크 단절 위험이
있으므로 대상 환경의 별도 마이그레이션 계획과 검증을 거쳐야 합니다.

사전 조건은 다음과 같습니다.

- AWS VPC CNI 버전 1.11.2 이상
- Cilium 요구사항을 충족하는 worker node Linux kernel
- Helm provider가 Kubernetes API에 연결할 수 있는 대상 환경 root 설정

기본 chart version `1.19.6`은 Cilium 안정 문서 기준입니다. OCI chart는 release
업데이트를 자동으로 받지 않으므로 version을 올릴 때에는 chart 변경 사항과 Cilium
upgrade guide를 함께 검토해야 합니다.

Chaining 구성은 기존에 실행 중인 Pod에 즉시 적용되지 않습니다. network policy
적용 범위를 확인한 뒤 대상 환경의 rollout 절차에 따라 workload를 재시작합니다.

설치 후에는 대상 환경에서 `cilium status --wait` 및 connectivity test를 실행해
검증합니다. 이 모듈은 해당 명령이나 Terraform apply를 실행하지 않습니다.
