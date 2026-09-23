# GitOps 환경 승격과 rollback

이 절차는 이 저장소의 Argo CD `Application` template처럼 자동 sync, prune,
self-heal과 resources finalizer를 기본으로 사용하지 않는 환경을 대상으로 합니다.
승격의 단위는 Git revision이며, 각 환경의 repository URL·path·revision은
환경별 overlay에서 명시합니다. 조직별 repository URL, domain, credential와
운영 환경 식별자는 이 문서에 기록하지 않습니다.

## 전제 조건

- Argo CD control plane과 대상 `Application`이 정상이고, Application이 최소 권한
  `AppProject`에 속합니다.
- 대상 revision의 Kustomize 또는 Helm rendering, 정책 검사, image 취약점 검사와
  필요한 integration test를 CI에서 통과했습니다.
- 변경 범위의 resource, namespace, CRD, migration, NetworkPolicy와 dependency를
  검토했습니다. cluster-scoped resource·CRD·data migration은 일반 workload와
  별도 변경으로 다룹니다.
- 배포 전 관측 지표, 성공 기준, 중단 기준, 담당자와 rollback 책임자를 정했습니다.
- promotion에 사용할 Git commit SHA 또는 immutable tag를 확인했습니다. 이동하는
  branch 이름만으로 production revision을 지정하지 않습니다.

## 승격 절차

1. 다음 환경 overlay에서 `spec.source.targetRevision`을 검토된 commit SHA 또는
   immutable tag로 바꾸는 PR을 만듭니다. repository URL과 path가 의도한
   environment를 가리키는지 함께 확인합니다.
2. PR에서 rendered manifest와 Argo CD diff를 검토합니다. 삭제·교체, 권한 확대,
   CRD 변경, immutable field 변경, data migration이 있으면 동기화를 중단하고
   별도 운영 계획을 검토합니다.
3. PR 병합 후 Argo CD에서 대상 Application의 revision과 diff를 다시 확인합니다.
   운영자가 수동 sync를 실행하고, sync operation 및 resource health가 완료될
   때까지 관찰합니다.
4. readiness·liveness, application error rate·latency, queue backlog, dependency
   health와 보안·비용 지표를 사전에 정한 관찰 시간 동안 확인합니다. 성공 기준을
   충족하면 다음 환경에서 같은 절차를 반복합니다.

자동 sync를 별도 정책으로 활성화한 standalone Application은 rollback 전에
`spec.syncPolicy.automated.enabled`를 `false`로 설정합니다. ApplicationSet이
생성한 Application은 child를 직접 고치지 않고 ApplicationSet template에서
설정합니다. Argo CD는 automated sync가 활성화된 Application에 rollback을 수행할
수 없습니다. [Argo CD automated sync 문서](https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/)를
변경 전 확인하세요.

## 중단 기준

다음 중 하나라도 발생하면 다음 환경으로 승격하거나 prune을 진행하지 않습니다.

- Argo CD sync가 실패하거나 resource가 `Degraded`, `Unknown` 상태가 됨
- error rate·latency·saturation·data integrity가 합의한 임계값을 넘음
- 권한, NetworkPolicy, ingress, certificate, external dependency의 예상하지 못한
  변경이 발생함
- CRD·database·queue·schema migration의 rollback 가능 여부가 검증되지 않음
- 적용 대상 revision과 rendered manifest가 PR에서 검토한 결과와 다름

## Rollback

1. 즉시 진행 중인 sync와 다음 환경 promotion을 멈추고, incident 담당자와 영향
   범위를 기록합니다. data corruption이나 credential 노출이 의심되면 workload
   rollback보다 해당 incident 절차를 우선합니다.
2. 문제가 없는 마지막 revision을 확인해, environment overlay의
   `spec.source.targetRevision`을 그 immutable revision으로 되돌리는 새 PR을
   만듭니다. 이미 병합된 Git history를 force-push 또는 수정하지 않습니다.
3. rollback PR의 diff를 검토하고 수동 sync를 실행합니다. 필요하다면 prune을
   선택하지 않고 resource health와 traffic을 먼저 안정화합니다.
4. health와 관측 지표가 정상인지 확인한 뒤 incident, 실제 적용 revision,
   관찰 결과와 후속 조치를 기록합니다. 원인과 재발 방지 변경이 검증되기 전에는
   다시 승격하지 않습니다.

Argo CD sync option, prune, CRD replacement 같은 동작은 resource 종류에 따라
위험도가 다릅니다. 기본 Application template의 수동 sync·prune 비활성 상태를
유지하고, 예외는 별도 PR에서 운영 근거와 rollback 방법을 함께 검토하세요.
