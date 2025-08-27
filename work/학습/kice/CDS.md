# KICE-CA

## Dockerfile

**도커파일에서는 이미지 레이어 부분이 중요하다고 설명 들었습니다. 따라서 기본적인 도커파일 개념과 이미지 레이어에 대해서 설명합니다.**

Dockerfile은 소스코드를 빌드하기 위한 명령어가 포함된 텍스트 파일입니다.

가장 공통적인 명령어는

| Instruction                                                                    | Description                                                                                           |
| ------------------------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------- |
| [`FROM <image>`](https://docs.docker.com/reference/dockerfile/#from)           | 이미지의 기본 이미지를 지정합니다.                                                                                   |
| [`RUN <command>`](https://docs.docker.com/reference/dockerfile/#run)           | 이미지 위에 새로운 층을 만들고, 거기서 명령을 실행해서 결과를 반영하는 명령어                                                          |
| [`WORKDIR <directory>`](https://docs.docker.com/reference/dockerfile/#workdir) | Dockerfile에서 RUN, CMD, ENTRYPOINT, COPY, ADD 명령들이 실행될 때 사용할 작업 디렉토리를 설정                               |
| [`COPY <src> <dest>`](https://docs.docker.com/reference/dockerfile/#copy)      | <src>에서 새로운 파일이나 디렉터리를 복사해서, 컨테이너 파일 시스템의 <dest> 경로에 추가                                               |
| [`CMD <command>`](https://docs.docker.com/reference/dockerfile/#cmd)           | 이 이미지로부터 컨테이너를 시작할 때 기본적으로 실행되는 프로그램을 정의, Dockerfile에는 CMD를 하나만 가질 수 있으며, 여러 개가 존재할 경우 마지막 CMD만 적용된다. |
다음과 같습니다.

기본 파일명은 Dockerfile이며 특정한 목적을 위해 독립된 도커파일을 지정도 가능합니다. 공통적으로 `<something>.Dockerfile`의 형태를 가지며 명령어 입력시 --file flag를 통해 특정 가능합니다.

아래 예시 Dockerfile을 통해 예상 문제를 설명하자면

```dockerfile
# syntax=docker/dockerfile:1
FROM ubuntu:22.04

# install app dependencies
RUN apt-get update && apt-get install -y python3 python3-pip
RUN pip install flask==3.0.*

# install app
COPY hello.py /

# final configuration
ENV FLASK_APP=hello
EXPOSE 8000
CMD ["flask", "run", "--host", "0.0.0.0", "--port", "8000"]
```

install app dependencies 부분에 RUN apt-get update && apt-get install -y python3 python3-pip 명령어를 확인할 수 있습니다.

### image layer

[docker image layer](https://docs.docker.com/get-started/docker-concepts/building-images/understanding-image-layers/)

도커는 이미지 레이어를 통해 이미지를 생성합니다.

- 레이어는 Docker 이미지가 구성되는 기본 단위로, Dockerfile의 각 명령어(RUN, COPY, FROM 등)가 실행될 때마다 해당 명령이 파일 시스템에 일으킨 변경 사항을 담은 새로운 레이어가 생성됩니다.
- 각 레이어는 불변적(immutable)입니다. 한 번 만들어진 레이어는 다른 Dockerfile에서 수정될 수 없고, 이후 레이어를 덧붙여 새로운 이미지가 만들어집니다.


#### 이미지 레이어의 장점
- 레이어 재사용 가능: 여러 이미지가 동일한 레이어를 공유하며, 동일한 베이스 이미지 및 변경이 있을 경우, 그 레이어를 재활용하여 스토리지와 대역폭을 줄일 수 있습니다.
- 빌드 캐시: Docker는 이전에 만들어진 레이어와 동일한 명령이 있을 경우 캐시를 사용하여, 재빌드 시 시간을 절약할 수 있습니다.

#### 이미지 레이어 작성시 주의할 점
```bash
RUN apt-get update && apt-get install -y openssl
RUN apt-get install -y nginx
```

위의 명령어로 이미지를 작성하면 레이어가 두 개 생기게 됩니다. 따라서 생성된 레이어가 다른 Dockerfile에서 재사용 될 수 있습니다.

```bash
RUN apt-get update && apt-get install -y openssl nginx && rm -rf /var/lib/apt/lists/*
```

위의 명령어로 이미지를 작성하면 레이어가 한 개 생기게 됩니다. 만약 다른 Dockerfile에서 둘 중 하나의 명령어를 사용하고자 할 경우 재사용될 수 없습니다.

## Support VM OS SKU 및 Migration 방법

**OS별로 SKU가 있으며 Migration 과정에서 제약사항이 있는데 해당 부분이 중요하다고 설명 들었습니다.**

VMWare를 Azure로 Migration하게 되면 Agent, Agentless방식 두 가지중에 선택 가능합니다.

- **Agentless (권장/기본, VMware 전용)**
	- vCenter + VMware 스냅샷/CBT로 증분 복제. 게스트 OS에 설치 없음. 대규모(최대 300~500대 동시)까지 스케일아웃 어플라이언스로 확장. 일부 제한(예: VMDK 이름에 비-ASCII 문자가 있으면 미지원)
- **Agent (대안)**
	- 각 서버에 Mobility Service를 설치해 블록 단위로 거의 연속 복제. 온프레미스 VMware는 물론 물리 서버·타 클라우드(AWS/GCP) 이전에도 사용. 포트/구성요소(복제 어플라이언스/프로세스 서버/443·9443 등) 요건이 있음.

[마이그레이션 옵션 선택 방법](https://learn.microsoft.com/ko-kr/azure/migrate/server-migrate-overview?view=migrate-classic)

### 제약사항
| 구분                | Agentless                                                                                                              | Agent-based                                                               |
| --------------------- | -------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| Azure 권한          | Azure Migrate 프로젝트 생성 권한 및 어플라이언스 배포 시 만들어지는 Microsoft Entra 앱 등록 권한 필요                                                    | 구독에 대한 Contributor 권한 필요                                                  |
| 복제(Replication)   | 단일 어플라이언스 기준, 여러 vCenter 서버에서 최대 500대 VM 동시 복제 가능 (스케일아웃 어플라이언스 사용). <br>포털에서는 한 번에 10대까지 선택 가능 → 더 복제하려면 10대 단위 배치 추가 | 복제 어플라이언스 스케일링을 통해 용량 확장                                                      |
| 어플라이언스 배포         | 온프렘에 Azure Migrate 어플라이언스 배포                                                                                           | 온프렘에 Azure Migrate Replication 어플라이언스 배포                                  |
| Site Recovery 호환성 | 호환됨                                                                                                                        | 이미 Site Recovery로 복제 중인 VM은 Migration & modernization 도구로 복제 불가               |
| 대상 디스크            | Managed Disk                                                                                                               | Managed Disk                                                                  |
| 디스크 제한            | OS 디스크: 최대 2TB데이터 디스크: 최대 32TB최대 디스크 수: 60                                                                                 | OS 디스크: 최대 2TB데이터 디스크: 최대 32TB최대 디스크 수: 63                                    |
| 패스스루 디스크          | 지원 안 함                                                                                                                     | 지원                                                                            |
| UEFI 부팅           | 지원                                                                                                                         | 지원                                                                            |
| 네트워크 연결           | 인터넷- ExpressRoute (Private Peering, Microsoft Peering) - Site-to-site VPN                                              | 인터넷 - ExpressRoute (Private Peering, Microsoft Peering) - Site-to-site VPN |

### Agentless

- vCenter에 연결해 게스트 OS에 에이전트 설치 없이 VMware VM을 Azure로 복제/마이그레이션하는 방식
- 전용 복제 어플라이언스(어플라이언스/게이트웨이) 를 배포 → vCenter와 스토리지에서 스냅샷 기반 증분 복제 수집 → Azure로 전송 → 테스트 마이그레이션 후 컷오버
- 검색이 완료되면 검색된 서버를 그룹으로 수집하고 그룹별로 평가를 실행

#### 동작 흐름
1. 발견(Discovery): vCenter 등록 → 인벤토리/성능 수집    
2. 평가(Assessment): 목표 Azure VM Size/SKU·디스크·비용 산정
3. 복제(Replication): 초기 전체 → 이후 증분 복제(CBT)
4. 테스트 마이그레이션: 다운타임 없이 검증 환경 부팅
5. 마이그레이션(컷오버): 짧은 정지 후 전환, 최종 동기화

## AKS 장애 대응:Node Not Ready, POD Pending 등 이슈 원인 파악 및 대응방법 이해

AKS는 작업자 노드의 상태를 지속적으로 모니터링하고 비정상상태가 되면 노드를 자동 복구하며 두 가지 이중화된 방법으로 상태를 체크합니다.

- .status 업데이트: kubelet이 주기적으로 Node의 리소스 상태를 API 서버에 업데이트
- Lease 객체: kubelet이 10초마다 Lease 객체를 갱신

### Node 자동 복구 작동 방법
AKS가 5분 이상 비정상으로 유지되는 노드를 식별하는 경우 다음 작업을 수행

- AKS가 노드를 다시 부팅
- 부팅 후 노드가 비정상이라면 AKS는 노드를 이미지로 다시 설치
- 이미지 설치 후 노드가 비정상이고 Linux 노드인 경우 AKS가 노드를 다시 배포
- 위 과정은 최대 3회 다시 시도

#### 자동 복구가 수행되지 않는 경우
- 네트워크 구성 오류로 노드 상태가 들어오지 않을 때
- 노드가 처음에 정상 노드로 등록하지 못한 경우
- 노드에 다음 taint중 하나가 있는 경우
  - node.cloudprovider.kubernetes.io/shutdownToBeDeletedByClusterAutoscaler
- 노드가 업그레이드 중인 경우

자동 복구 이벤트는 [링크](https://learn.microsoft.com/ko-kr/azure/aks/node-auto-repair)에서 확인 가능

### Node Not Ready 원인 및 대응 방법
- kubectl get nodes 에 NotReady 표기
- kubectl describe node 의 Conditions에서 Ready=False, NetworkUnavailable=True, MemoryPressure=True, DiskPressure=True, PIDPressure=True 등 확인

#### A. kubelet/컨테이너 런타임 장애

1. ssh를 통해 해당 node에 접속
2. 아래 명령어들을 이용해 kubelet, 컨테이너 런타임 장애여부 확인 
	```bash
	journalctl -u kubelet -n 200 --no-pager
	journalctl -u containerd -n 200 --no-pager
	sudo systemctl status kubelet containerd
	```
3. 컨테이너 런타임 프로세스 재시작
   ```bash 
   sudo systemctl restart containerd kubelet
   ```


#### B. 리소스 부족
1. kubectl describe node의 Pressure=True 확인
   Memory/PID Pressure: 과소요 파드 제한/리소스쿼터 도입, 문제 파드 축출. 필요 시 노드풀 스케일아웃.
2. DiskPressure: 이미지/컨테이너 정리
	```
	sudo crictl images
	sudo crictl rmi --prune
	sudo du -sh /var/lib/containerd/* /var/lib/kubelet/* 2>/dev/null
	```

#### C. 네트워크/CNI 문제
1. NetworkUnavailable=True, kubelet이 API 서버로 Heartbeat 실패
2. 아래 명령어(CoreDNS, konnectivity 예시)를 이용해 장애 여부 확인
	```bash
	kubectl -n kube-system get pods -l k8s-app=kube-dns
	kubectl -n kube-system get pods | grep konnectivity
	```
3. CNI/시스템 파드 재시작, 노드 재부팅, 노드 교체, UDR/NSG 변경 여부 점검

#### D. 시간 동기화/인증 토큰 문제
1. 노드 시간이 크게 틀어진 경우 API 인증 실패 가능성이 존재, node에 접속 후
2. 아래 명령어를 이용해 시간 확인
	```bash
	timedatectl status
	```
3. NTP 동기화 복구, kubelet 재시작

#### E. 노드가 cordon/drain 상태로 방치
1. NotReady,SchedulingDisabled 또는 kubectl get nodes에 SchedulingDisabled
2. 아래 명령어를  통해 node를 uncordon으로 설정 혹은 필요시 drain
   ```bash
	kubectl uncordon <NODE>
	kubectl drain <NODE> --ignore-daemonsets --delete-emptydir-data
	```

### POD Pending 원인 및 대응 방법
- 스케줄러가 아직 파드를 어떤 노드에도 배치하지 못한 상태.
    (이미 스케줄된 뒤 컨테이너 풀/이미지 문제는 보통 ContainerCreating/ImagePullBackOff로 보입니다.)

#### A. 리소스 부족
1. 아래 명령어로 리소스 부족 확인
	```bash
	kubectl describe pod 
	```
2. 진단 결과에 따른 대응
   - 스케일 아웃: 노드 풀 증가
   - 리소스 요청 조정: requests/limits 현실화, 우선순위 검토
   - pod 수 제한(kubelet의 maxPods)에 걸리면 노드 타임/설정 변경


#### B. 스케줄링 제약 불일치
1. nodeSelector/nodeAffinity/topologySpreadConstraints/podAntiAffinity가 현실과 안 맞음, 또는 taint/toleration 미스매치
2. 아래 명령어로 진단
	```bash
	kubectl describe pod <POD> | sed -n '/Events:/,$p'
	```
3. 진단 결과에 따른 대응
   - label/taint 정합성 수정
   - 제약 완화 또는 노드풀에 해당 특성 라벨 부여/증설

#### C. 스토리지 대기(PVC Pending)
1. 파드가 Pending, PVC가 Bound되지 않음
2. 아래 명령어로 진단
	```bash
	kubectl get pvc
	kubectl describe pvc <PVC>
	```
3. 진단 결과에 따른 대응
   - StorageClass 오타
   - 존 불일치
   - 용량, I/O 제한
   - 디스크/SCI 문제
   - 리소스 쿼터 부족


## AKS의 이슈상황 원인과 대응방안 역량: POD Failed, BackOff, POD Schedule Design, Nodegroup scale in 시 고래해야할 POD Life Cycle 설정

이슈상황시 각 node, pod, event 관련 상태 확인 명령어
```bash
# 상태 요약
kubectl get nodes -o wide
kubectl get pods -A --field-selector=status.phase!=Running -o wide
kubectl get events -A --sort-by=.lastTimestamp | tail -n 80

# 개별 상세
kubectl describe pod <POD> -n <NS>
kubectl describe node <NODE>
kubectl logs <POD> -n <NS> -c <CONTAINER> --previous
```

### POD Failed

#### 흔한 원인 
- OOMKilled / Memory cgroup 초과
- Evicted(DiskPressure/EphemeralStorage/MemoryPressure)
- DeadlineExceeded (Job activeDeadlineSeconds 초과)
- Exit code ≠ 0 (프로세스 조기 종료, entrypoint 오타, 권한 문제)


#### 대응 방법
- OOMKilled: 🧭 resources.requests/limits 합리화, 메모리 leak 점검, VPA/HPA 도입, GC/힙 옵션 조정
- Evicted: 노드 DiskPressure해소(이미지/컨테이너/워킹디렉 정리), ephemeral-storage requests/limits 및 emptyDir.sizeLimit 설정, 노드풀 디스크/사이즈 증설
- Job 실패: backoffLimit, activeDeadlineSeconds, 재시도 간격 재설계. 반복 실패면 InitContainer로 프리체크, 종속 서비스 준비(health/endpoint) 확인
- 권한·엔트리포인트: securityContext, command/args 검증, 실행 비사용자(shell) 문제 해결


### BackOff 계열(CrashLoopBackOff, ImagePullBackOff, ErrImagePull 등등..)

#### A) CrashLoopBackOff
원인: 어플리케이션 예외/의존 미준비/잘못된 CMD, liveness probe 오탐 등

대응 방법:
- Startup, Readness, Liveness Probe 분리
- InitContainer로 의존 리소스(DB 등) 준비 확인
- 애플리케이션 종료 신호 처리(SIGTERM)와 graceful shutdown 구성

#### B) ImagePullBackOff / ErrImagePull
원인: 레지스트리 인증, 네트워크 혹은 이미지 태그 오타
- ACR 사용 시 AKS-ACR 연결(Managed Identity attach-acr), 또는 imagePullSecrets 설정
- 프록시/NSG/DNS 확인, 사설 레지스트리면 프라이빗 엔드포인트/방화벽 예외
- 태그 고정(immutable), imagePullPolicy: IfNotPresent 적절히 사용

#### C) CreateContainerConfigError / CreateContainerError
위의 pod pending과 동일한 대응을 통해 예방 가능

### POD 스케줄러 오류 문제 해결

#### 1. Volume node affinity conflict

원인: Persistent Volume이 특정 노드에 대한 nodeAffinity를 지정했지만 해당 라벨과 일치하는 노드가 없는 경우

- kubectl get pv <pv-name> -o yaml로 PV의 nodeAffinity를 확인
- kubectl get nodes --show-labels로 노드 라벨 확인
- PV의 affinity와 일치하도록 노드에 라벨을 추가하거나 PV 설정을 수정

### 2. Insufficient CPU

원인: 요청된 파드 CPU가 노드 여유보다 많거나 전체 클러스터 리소스가 부족할 때

- kubectl describe pod <pod-name>, kubectl describe nodes로 리로스 상태 확인
- 노드풀에 더 큰 VM 또는 더 많은 노드 추가(az aks nodepool scale)
- 필요에 따라 requests/limits 조정

### 3. Untolerated Taints

원인: 노드에 taint가 설정되어 있고 파드에 해당하는 toleration이 없으면 스케줄러가 해당 노드에 파드를 배치하지 않음

- kubectl describe nodes로 taint 정보 확인
- pod toleration에 해당 toleration을 추가하거나 노드의 taint 제거

### Nodegroup Scale-in시 고려할 Pod Lifecycle 설정
Scale-in 시 연결 드레이닝, 데이터 무결성 보장이 중요합니다.

핵심 체크리스트는 아래와 같습니다.

1. Pod Disruption Budget(PDB): 과도한 동시 축출 방지
	```bash
	spec: { maxUnavailable: 1 }   # 또는 minAvailable
	```
2. preStop hook + terminationGracePeriodSeconds
   - preStop에서 LB 등록 헤제/세션 종료/큐 flush
   - SIGTERM 후 readiness가 자동 false되지만, 어플리케이션 자체 graceful 필요
	```bash
	lifecycle:
	  preStop:
	    exec: { command: ["sh","-c","sleep 10; curl -XPOST http://localhost:9000/drain"] }
	terminationGracePeriodSeconds: 60
	```
3. readinessProbe 엄격화: 종료 직전 트래픽 유입 차단 속도를 높이고 정상 동작 중에만 Ready 유지
4. PDB + HPA 조합: 축출 가능한 파드 수와 자동 확장 균형 맞추기
5. safe-to-evict 어노테이션: 스케일인 시 지우면 안되는 파드에 다음과 같이 safe-to-evict 어노테이션 추가
	```bash
	metadata:
	  annotations:
		cluster-autoscaler.kubernetes.io/safe-to-evict: "false"
	```
6. 빈약한 스테이트풀 방지: StatefulSet은 PodManagementPolicy=Parallel와 PodAntiAffinity로 분산, 스토리지는 RWO/PV 바인딩 존 일치.

## Azure Network의 암호화 방식 단답식

**담당님도 잘 모르는 부분이라고 설명하셔서 힌트가 별로 없음. 이외에 아시는 내용이 있으면 알려주시면 감사하겠습니다.**

1. Azure VPN Gateway는 IPsec/IKE 기반 암호화 터널을 사용하며, 내부적으로 AES256/SHA2/PFS 같은 알고리즘을 조합한다
2. ExpressRoute → 기본은 암호화 없음. 필요 시
    - MACsec(L2) : ExpressRoute Direct서 포트 단 암호화(BYOK, Key Vault 보관).
    - IPsec over ER : VPN over ExpressRoute(끝단 간 L3 암호화) 조합 가능.
3. Virtual Network Encryption (VNE) → 동일 VNet/피어링 간 VM↔VM 트래픽을 DTLS로 암호화. 특정 VM SKU/Accelerated Networking 요구, 일부 네트워크 리소스와 비호환.
4. Azure Files: 기본적으로 SMB 3.x + 암호화 필수(암호화 미지원 클라이언트 연결 거부)

예상문제

1. Q. S2S VPN은 어떤 방식으로 암호화하나?  
    A. IPsec/IKE. 필요 시 커스텀 정책(AES256/SHA2/PFS 등) 설정. 
    
2. Q. ExpressRoute는 기본적으로 암호화되나?  
    A. 아니오. 필요하면 MACsec(ER Direct) 또는 IPsec over ER 사용. 
    
3. Q. 동-서(VM↔VM) 트래픽을 네트워크 계층에서 암호화하는 Azure 기능은?  
    A. Virtual Network Encryption(DTLS). 
    
4. Q. VNet Peering 간 트래픽은 암호화 필요한가?  
    A. 필수 아님(Microsoft 백본 사용, 암호화 요구 X). 필요 시 VNE 또는 앱 계층 TLS 적용. 
    
5. Q. MACsec은 어디서 쓸 수 있나?  
    A. ExpressRoute Direct 포트에서 L2 암호화. 키는 Key Vault에 저장/회전. 
    
6. Q. VNE 활성화 시 주의할 점 2가지?      
    A. 지원 VM SKU+Accelerated Networking 필수, 그리고 ExpressRoute Gateway/App Gateway/Azure Firewall/Private Link와 비호환. 
    
7. Q. Azure Files의 전송 중 암호화는?    
    A. SMB 3.x 암호화(기본 강제). 

8. Q. P2S에서 동시접속 제한이 있는 프로토콜은? 대안은?  
    A. SSTP(128 세션) 제한. IKEv2 또는 OpenVPN으로 전환.

## 용도에 따른 Azure Storage Account 선택

**많은 문제 출제가 예상된다고 한 부분으로 내용이 지속적으로 추가될 예정입니다.**

### 1) 스토리지 어카운트가 제공하는 주요 서비스

- 디스크(Managed Disks)
  - 주 용도: VM OS/데이터 디스크. IOPS/Throughput SLA가 필요할 때.
  - 특성: VM에 attach해서 블록 장치처럼 사용. 스냅샷/백업/암호화/공유디스크 등.
- 파일(Azure Files)
  - 주 용도: SMB/NFS 네트워크 파일 공유. 리프트&쉬프트, 앱 설정/로그 공유.    
  - 티어: Transaction Optimized / Hot / Cool (Standard-HDD), Premium(FileStorage-SSD).
  - 스냅샷, Azure AD/Entra ID 기반 인증, Azure File Sync 등.
- 오브젝트(Blob Storage)
  - 주 용도: 비정형 데이터(이미지/동영상/로그/백업 등). HTTP/SDK로 접근.
  - 컨테이너 단위로 보관(= 버킷 개념). 블록 blob 중심.
  - Data Lake Storage Gen2(ADLS Gen2) = Blob에 Hierarchical Namespace+POSIX ACL을 더한 분석 지향 스토리지.
- Table Storage
  - 단순한 구조의 IoT데이터, 사용자 프로필, 메타데이터 저장 등에 적합
  - NoSQL Key-Value Storage
  - 스키마리스 구조, 대규모 비정형 데이터 저장 가능
- Queue Storage
  - 분산시스템 간 비동기 메시징 용도 등
  - 메시지 큐 서비스
  - 최대 메시지 크기 64KB
  


### 3) 라이프사이클 관리
- 규칙 기반으로 Blob을 다른 티어로 이동하거나 삭제/버전 관리
- 계정/컨테이너/prefix/Blob 인덱스 태그 기준으로 타겟팅 가능
- LastModified, LastAccessTime 기준 일수로 결정


### 4) 이벤트 드리븐 관리
Azure에 존재하는 이벤트 드리븐 서비스와 각 서비스의 사용 패턴

| 서비스         | 역할                                         | 자주 쓰이는 패턴                                           | 전달 방식                                   | 보관·재생                                     | 결론                                            |
| --------------- | ------------------------------------------ | --------------------------------------------------- | --------------------------------------- | ----------------------------------------- | --------------------------------------------- |
| Event Grid  | Azure/앱에서 발생한 이벤트(상태 변화)를 구독자에게 푸시 | Blob 업로드 알림→함수 트리거, 리소스 생성/태깅 자동화, IoT MQTT Pub/Sub | 푸시형 Pub/Sub (HTTP & MQTT 브로커)   | 이벤트 자체 보관 X(짧은 재시도/Dead-letter), 스트림 재생 X | “무언가 발생했다”에 빠르게 반응하는 오케스트레이션에 최적.     |
| Event Hubs  | 디바이스/앱/로그의 연속 스트림을 대량 수집           | 테레메트리/클릭스트림/로그→(Spark/ADX/ASA) 실시간 처리               | 풀형 스트림(소비자가 오프셋 관리, 파티션/컨슈머 그룹) | 보존(시간/용량) + 재생 가능(리플레이)           | “많이, 빠르게, 끊임없이 들어오는 데이터”의 빅데이터 파이프라인. |
| Service Bus | 엔터프라이즈 메시징(큐/토픽, 순서/세션/거래/지연/필터)       | 주문·결제·워크플로, 사내 시스템 간 신뢰 전송                          | 브로커 저장 후 소비자 준비되면 전달                | DLQ/중복감지/세션/FIFO로 신뢰성↑                | “유실·중복·순서에 민감한 업무 메시지”에 적합.           |


## Storage Account “Lake형”(ADLS Gen2) & Blob 객체 스토리지 티어/CRUD 제약

### 개요

* **Lake형 = ADLS Gen2**: Blob Storage에 **계층형 네임스페이스(HNS)** 를 켠 모드. 디렉터리/파일, **원자적 rename/move**, **POSIX-유사 ACL** 제공 → 분석·데이터레이크 적합.

### 네임스페이스 & 엔드포인트

* HNS=ON일 때 Blob( `https://{account}.blob.core.windows.net` )과 **DFS**( `https://{account}.dfs.core.windows.net` ) 엔드포인트가 **공존**.
* 폴더/파일 **ACL**은 **HNS=ON**에서만 동작(리소스 RBAC과 병행 가능).

### Blob 유형별 특성

* **Block Blob**: 일반 파일·대용량 객체. **티어(Hot/Cool/Cold/Archive)** 전환 및 **라이프사이클** 지원.
* **Append Blob**: 이어쓰기(로그) 최적화. **티어링·Archive 미지원**(필요 시 Block으로 변환해 티어링).
* **Page Blob**: 512B 페이지 랜덤 R/W(VHD 등). **Hot만** 사용(Cool/Cold/Archive 미지원).

### 액세스 티어 & CRUD 제약

* **온라인 티어**: **Hot / Cool / Cold**

  * **즉시 읽기** 가능.
  * **최소 보관 기간(조기 삭제 페널티)**: Hot 없음 / **Cool 30일** / **Cold 90일**.
  * 내려갈수록 저장비용↓, **트랜잭션/액세스 비용↑**.
* **오프라인 티어**: **Archive**

  * **읽기/수정/삭제 불가**(먼저 **재수화**로 Hot/Cool/Cold로 승격 필요).
  * **최소 180일 보관 페널티**, 재수화에 **시간 지연** 존재.

#### CRUD 관점 요약

* **Create/Update/Delete**: Hot/Cool/Cold = 정상 / **Archive = 재수화 후 가능**.
* **Read**: Hot/Cool/Cold = 즉시 / **Archive = 재수화 후**.

### 계정/중복 옵션 호환성

* **Archive 지원**: **LRS/GRS/RA-GRS**. (**ZRS/GZRS/RA-GZRS 미지원**)
* **Premium Block Blob** 계정: **Set Blob Tier·라이프사이클 미지원**(복사 기반 이전 필요).

### 운영 팁

* **ADLS Gen2**: HNS=ON + 폴더/파일 ACL → 데이터레이크, 팀별 권한 분리에 최적.
* **티어 선택**

  * 자주 접근: **Hot**
  * 가끔: **Cool**
  * 드물지만 **즉시 읽기** 필요: **Cold**
  * 장기보관·지연 허용: **Archive(180일/재수화 고려)**
* **유형 선택**

  * 일반 파일: **Block**
  * 로그/이어쓰기: **Append**(주기적으로 Block으로 굴려 티어링)
  * VHD/랜덤 IO: **Page**
* **자동화**: **Lifecycle Management**(규칙 기반 티어 전환/만료). 단, **Archive → 온라인 재수화는 수동/API**.



## Azure Scope(스코프)

### 한 줄 정의
- **Scope**는 RBAC 역할과 Azure Policy를 **어디에 적용할지** 지정하는 **대상 범위**입니다.

### 계층(상속 방향)
- Tenant (Root Management Group)
- Management Group
- Subscription
- Resource Group
- Resource

> 상위 Scope에 걸린 **RBAC/Policy/잠금/태그**는 **하위로 상속**됩니다.

### 용도별 적용 대상

#### RBAC (Role-Based Access Control, 권한)
- **누가(보안주체: 사용자/그룹/서비스 주체/Managed Identity)**
- **무엇을(역할: Owner/Contributor/Reader/Custom)**
- **어디서(Scope: MG/구독/RG/리소스)**
- **할당(Assignment) = 주체 + 역할 + Scope**
- 원칙: **개인 대신 그룹에 역할**을 부여하고, **가능한 가장 작은 Scope**로 권한을 줍니다(최소권한).

#### Azure Policy (준수/강제)
- 리소스 **상태/구성 규칙**을 **Scope에 할당**합니다. (사용자·그룹에 직접 할당하지 않음)
- **Effect**: `Deny`, `Audit`, `Append`, `Modify`, `DeployIfNotExists`, `Disabled`
- **Initiative(정책 세트)**, **Parameters**, **Exemption(예외)**, **Remediation(시정: 관리 ID 필요)** 지원.

### 예외/부분 적용
- **Exemption**: 특정 하위 범위를 정책 적용에서 제외.
- **NotScopes**: 정책 할당 시 일부 하위 Scope를 명시적으로 제외.

### 우선순위/충돌
- **Policy의 `Deny` > RBAC의 `Allow`**
  - 권한이 있어도 정책이 막으면 생성/변경이 거부됩니다.


### 리소스 ID 예시

```text
Management Group: /providers/Microsoft.Management/managementGroups/mg-prod
Subscription:     /subscriptions/00000000-0000-0000-0000-000000000000
Resource Group:   /subscriptions/.../resourceGroups/rg-app
VM Resource:      /subscriptions/.../resourceGroups/rg-app/providers/Microsoft.Compute/virtualMachines/web01
```

### 상속/중첩 시 “권한이 꼬이는” 전형 케이스와 해석법

#### 해석 절차(체크리스트)

1. **평가 대상 Scope 확정**: 리소스가 속한 **RG/구독/관리그룹**까지 **위로 올라가며** 모든 **Assignment(Policy/Initiative)** 수집
2. **예외 확인**: 해당 리소스/하위 범위에 **Exemption** 또는 Assignment의 **NotScopes**가 있는지
3. **정책 Evaluation**:

   * `Append/Modify` → **요청/배포 시 속성 보강/변경** 후 평가
   * `DeployIfNotExists` → **시정 리소스 배포 권한**(관리 ID/RBAC) 유무 확인
   * **최종 `Deny`가 하나라도 참**이면 **거부**
4. **RBAC 평가**: Deny가 없을 때만 **주체의 역할+Scope**로 최종 권한 계산
5. **Deny Assignment 유무**: Blueprint/Managed Application 등이 만든 **Deny Assignment**가 있으면 **RBAC로도 우회 불가**

#### 흔한 꼬임 패턴

* **패턴 A) 상위 MG의 Deny가 하위를 막음**

  * 예) MG에 “허용 리전=Korea Central” → 하위 구독에서 Japan East로 배포 시 **RBAC Owner라도 Deny**
* **패턴 B) 서로 다른 Initiative에서 상반된 요구**

  * 하나는 “태그 `env=prod` 필수(Modify/Append)”, 다른 하나는 “특정 태그 금지(Deny)” → **정의/파라미터 조정** 필요
* **패턴 C) DeployIfNotExists 실패**

  * Remediation용 **관리 ID 권한 부족**으로 시정 배포 실패 → **RBAC 보강** 필요
* **패턴 D) NotScopes/Exemption 누락**

  * 예외로 빼야 할 RG/리소스가 **누락**되어 예상치 못한 Deny 발생
* **패턴 E) Data-plane vs Mgmt-plane 오해**

  * Policy로 **관리평면 배포**는 막아도, **데이터평면 접근**은 Blob Data Reader 등 **별도 RBAC** 필요



## Azure Blob/Object Storage의 Lifecycle & Event 기반 트리거 (Event Chain 설계)

### 개요

* **Lifecycle(수명주기) 정책**: 규칙 기반으로 **티어 전환/만료/삭제**를 주기적으로 수행(스케줄 평가). 이벤트 없이도 동작.
* **Event 기반 트리거**: Storage Account(Blob/ADLS Gen2)가 **CRUD/관리 이벤트**를 **Event Grid**로 발행 → **Azure Functions / Logic Apps / Service Bus / Event Hubs / Webhook** 등으로 **실시간 처리**.

### 핵심 구분: Lifecycle vs. Event

* **Lifecycle Policy**

  * 목적: **비용/보관 최적화**(예: N일 후 Cool/Cold/Archive, N일 후 삭제)
  * 방식: 규칙 평가(비실시간), 이벤트 사슬 없이 동작
  * 한계: “Archive → 온라인” **재수화는 자동화 규칙으로 불가**(API/수동 필요)
* **Event(이벤트 드리븐)**

  * 목적: **실시간 후처리/연계**(예: Blob 업로드 직후 썸네일 생성, 메타데이터 적재, 파이프라인 기동)
  * 방식: **Event Grid**가 발행/전달, **소비자**(Functions/Logic Apps 등)가 처리
  * 특징: **최소 1회(at-least-once) 전달**, **필터링/라우팅**, **재시도/데드레터 지원**

### Storage가 발행하는 대표 이벤트(개념)

* **Blob/ADLS Gen2 CRUD**: **Created / Deleted / (HNS 켠 경우 Rename/Directory 변동 등)**
* **속성/관리**: **티어 변경, 스냅샷/버전, 라이프사이클 작업 완료(정책 실행 완료 통지)** 등
* **유의**: 정확한 이벤트 타입 이름은 서비스/기능에 따라 다름(설계 시 포털/CLI에서 지원 목록 확인)

### Event Chain을 만들 때 쓰는 Azure 구성요소

* **Event Grid**: Storage의 **시스템 토픽** 자동 생성 → \*\*이벤트 구독(Event Subscription)\*\*으로 대상 설정

  * **대상(핸들러)**: Azure Functions, Logic Apps, **Service Bus(큐/토픽)**, **Event Hubs**, Webhook, Automation 등
  * **필터링**: **Subject/Prefix/Suffix**(예: 컨테이너/접미사 `.jpg`)로 세분화
  * **전달 품질**: 재시도/백오프, **Dead-letter**(Storage 계정에 보관), 배치 전달
* **Azure Functions (Event Grid Trigger)**: 코드로 후처리(썸네일, 메타생성, 태깅, 재수화 호출 등)
* **Logic Apps (Event Grid 트리거)**: 노코드 워크플로(승인, 슬랙/Teams 알림, ITSM 티켓 발행)
* **Service Bus**: **명령/업무 메시징**(요청-응답, 세션, FIFO-like), 트랜잭션/디드레터 큐
* **Event Hubs**: **대량 스트리밍/텔레메트리** 수집(파트ition 기반, 소비자 그룹)
* **Data Factory / Synapse**: 데이터 파이프라인 기동(보통 Functions/Logic Apps에서 트리거)
* **Azure Storage Queue**: 단순 큐(경량 분산 처리)

### 권한/네트워크/운영 포인트

* **권한**: Event Subscription을 만들려면 Event Grid/Storage에 대한 적절한 RBAC가 필요. 소비자는 **Managed Identity**로 대상 리소스 접근.
* **프라이빗 환경**: Storage가 **Private Endpoint**이면, 소비자(Functions/Webhook)가 **접속 가능한 네트워크**에 있어야 함. Event Grid는 **아웃바운드 푸시** → **사설 엔드포인트 통과** 설계 주의.
* **신뢰성/중복**: Event Grid는 **최소 1회** 전달 → **이벤트 핸들러는 멱등성(idempotency)** 설계 필요.
* **순서**: 절대적 순서 보장 X(특히 병렬/다중 파티션). 순서가 필요하면 **Service Bus 세션/단일 파티션 전략** 고려.
* **모니터링**: Event Grid 전송 실패/재시도/데드레터 메트릭, Functions/Logic Apps 실행 로그/대상별 DLQ 모니터.

### 설계 패턴 예시

#### 패턴 1: 업로드 → 후처리 → 메타 적재

1. **Blob Created**(컨테이너: `incoming/`, 접미사: `.jpg`)
2. Event Grid → **Azure Functions**(썸네일 생성)
3. 결과 **processed/** 컨테이너에 저장 + **Cosmos DB**에 메타데이터 기록
4. 실패 시 **Dead-letter**에 원본 이벤트 저장, 재처리 큐 발행

#### 패턴 2: 아카이브 전환 알림 & 승인 기반 재수화

1. **Lifecycle 정책**으로 오래된 Blob을 **Archive**로 전환
2. 정책 완료/티어 변경 이벤트 → **Logic Apps**
3. 담당자 승인 흐름 → 승인 시 **Functions**가 **Rehydrate API** 호출(Hot/Cool/Cold로 승격)
4. 재수화 완료 이벤트 → 알림/다운스트림 잡 기동

#### 패턴 3: 대규모 분석 파이프라인 기동

1. **Blob Created**(데이터 벌크 업로드)
2. Event Grid → **Event Hubs**(버퍼링/스케일)
3. **Stream Analytics/Spark**가 Event Hubs 소비 → **Synapse/ADLS** 적재
4. 완료 후 **Service Bus**로 다음 단계 워크플로 트리거

### 구현 체크리스트

* **이벤트 구독 설계**: 컨테이너/접미사 필터로 **잡음 최소화**, 구독당 처리량/재시도 정책 검토
* **에러 처리**: **Dead-letter** Storage 계정/컨테이너 지정, 핸들러에서 **idempotent key**(이벤트 ID/Blob ETag) 사용
* **보안**: Managed Identity, Private Endpoint, IP 제한/방화벽, Webhook 서명 검증
* **비용**: Event Grid(요청 수 기반), Functions 실행/메모리, Service Bus/Event Hubs 스루풋 단가 고려
* **테스트**: 샘플 Blob 업로드/삭제로 **엔드투엔드** 연동 확인(로컬/스테이징 분리)


## Azure 비용 최적화: Savings Plan vs Reserved Instance (무엇이 더 효과적이고 얼마나 줄일 수 있나)

### 한눈 비교

| 항목    | **Savings Plan for Compute**                                                                                                          | **Reserved VM Instances (RI)**                                                                                                              |
| ----- | ------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| 할인 구조 | **시간당 커밋 금액**(예: \$5/시간)만큼 **모든 리전·여러 Compute 서비스**에 자동 할인 적용                                                                         | **특정 VM/시리즈·리전**에 고정 할인(인스턴스/패밀리·리전 종속)                                                                                                     |
| 유연성   | 높음 — 리전/VM 시리즈 바꿔도 커밋 금액 내에서 자동 적용                                                                                                    | 낮음 — 같은 리전·패밀리 내 **사이즈 유연성** 옵션은 있으나, 기본적으로 특정 리소스형에 종속 ([Microsoft Learn][1])                                                              |
| 최대 할인 | **최대 약 65%**(1년/3년)                                                                                                                   | **최대 약 72%**, **AHB(Windows/SQL 라이선스)** 결합 시 **최대 80%**+까지 가능 ([Microsoft Learn][2], [Microsoft Azure][3])                                  |
| 취소/교환 | **구매 후 취소·교환 불가**(Trade-in: 일부 예약→SP로 전환만 가능) ([Microsoft Learn][4])                                                                  | **취소·환불·교환 가능(제한 있음)** — 12개월 구간 **USD 50,000 한도** 내 환불, 현재 **해지 수수료 미부과**(향후 **12%** 가능성 공지형) ([Microsoft Learn][5], [Microsoft Azure][6]) |
| 적용 범위 | VM, Dedicated Host, Container Instances, Functions Premium, App Service 등 **Compute 요금**(소프트웨어/네트워크/스토리지는 불포함) ([Microsoft Learn][4]) | 주로 **VM**(전용호스트·App Service 등 일부 예약 유형도 존재)                                                                                                 |

> 요약: **최대 할인 폭**은 보통 **RI > Savings Plan**, **운영 유연성**은 **Savings Plan > RI** 입니다. **업무 패턴**(안정/변동)에 따라 선택이 갈립니다. ([Microsoft Learn][7])


[1]: https://learn.microsoft.com/en-us/azure/virtual-machines/reserved-vm-instance-size-flexibility?utm_source=chatgpt.com "Virtual machine size flexibility -Azure Reserved VM Instances"
[2]: https://learn.microsoft.com/en-us/azure/cost-management-billing/savings-plan/discount-application?utm_source=chatgpt.com "How an Azure saving plan discount is applied"
[3]: https://azure.microsoft.com/en-us/pricing/reserved-vm-instances?utm_source=chatgpt.com "Azure Reserved Virtual Machine Instances"
[4]: https://learn.microsoft.com/en-us/azure/cost-management-billing/savings-plan/savings-plan-compute-overview "What is Azure savings plans for compute? - Microsoft Cost Management | Microsoft Learn"
[5]: https://learn.microsoft.com/en-us/azure/cost-management-billing/reservations/exchange-and-refund-azure-reservations?utm_source=chatgpt.com "Self-service exchanges and refunds for Azure Reservations"
[6]: https://azure.microsoft.com/en-us/pricing/offers/reservations?utm_source=chatgpt.com "Azure Reservation Pricing"
[7]: https://learn.microsoft.com/en-us/azure/cost-management-billing/savings-plan/decide-between-savings-plan-reservation?utm_source=chatgpt.com "Decide between a savings plan and a reservation"
[8]: https://azure.microsoft.com/en-us/pricing/offers/savings-plan-compute?utm_source=chatgpt.com "Azure Savings Plan for Compute"


## VMSS(가상 머신 스케일셋) 처리 흐름 & “최신 상태로 부팅” 설계 가이드

### 개요

* **VMSS**는 동일(또는 유사)한 VM 인스턴스를 **자동으로 증감/갱신**하는 Azure의 오토스케일 컴퓨트 풀입니다.
* 새 인스턴스가 **항상 최신 앱/설정/패치**를 가진 상태로 시작하도록 **이미지 빌드 + 부팅 초기화**를 함께 설계합니다.
* “Application Gallary”라 부른 부분은 현재 **Azure Compute Gallery(ACG, 구 Shared Image Gallery)** 를 의미합니다.

---

### 오케스트레이션 모드

#### Uniform

* \*\*동일한 VM 모델(이미지/사양/확장 설정)\*\*로 운영(가장 보편).
* **업그레이드 정책**(Manual/Automatic/Rolling)과 **헬스 프로브/애플리케이션 헬스 확장**을 이용해 **점진 배포** 가능.

#### Flexible

* 서로 다른 크기/시리즈/존을 섞어 **유연한 풀** 구성(가용성/다양성 중시).
* **스케일 인 정책**(OldestVM/NewestVM/Default)과 **인스턴스 보호(ProtectionPolicy)** 로 세밀 제어.

---

### “최신화된 데이터로 시작” 4가지 패턴

#### 1) **골든 이미지 베이크(Bake)**

* **Azure Image Builder(Packer)** 로 **기본 OS + 런타임 + 공통 에이전트/패치**를 **이미지로 베이크** →
  **Azure Compute Gallery(ACG)** 에 **버전**으로 게시(Region 복제 포함).
* VMSS는 ACG의 **이미지 정의**를 참조 → **최신 버전**으로 **Rolling Upgrade** 또는 **Automatic OS image upgrade** 수행.
* 장점: **부팅이 빠르고 일관성↑**, 인터넷 없이도 표준화.
* 단점: 앱 변경 주기가 아주 잦다면 **이미지 재빌드/게시 파이프라인**이 필요.

#### 2) **부팅 시 풀(Pull) & 수렴(Converge)**

* **cloud-init(리눅스)** / **Custom Script Extension** / **DSC/Ansible** 등으로 **부팅 시**

  * 앱 바이너리/패키지 **다운로드**(Storage/DevOps Artifacts/컨테이너 레지스트리)
  * **설정 주입**(Key Vault에서 **Managed Identity**로 시크릿 pull)
  * **마이그레이션/시드 작업** 수행
* 장점: 이미지를 자주 안 갈아도 됨(유연).
* 단점: **부팅 시간↑**, 외부 의존(I/O 실패 시 리스크).

#### 3) **컨테이너 런타임 + 아티팩트 버전 고정**

* VMSS는 **런타임(컨테이너/에이전트)만** 베이크하고, 앱은 **컨테이너 이미지 태그**로 버전 고정하여 pull.
* AKS가 과하지만 VMSS를 써야 할 때 **경량 컨테이너**로도 충분한 시나리오에 적합.

#### 4) **하이브리드**

* OS/러ntime/공통 에이전트는 **이미지 베이크**, 앱만 **부팅 시 Pull**.
* “부팅은 빠르고”, “앱 갱신도 유연”한 절충안.

> **권장 조합**: **ACG 베이크 + Rolling Upgrade**(OS/공통) **+ 부팅 Pull(앱/설정)**
>
> * Key Vault(Managed Identity), 진짜 변경 빈도가 높은 자원은 **런타임 Pull**로 해결.

---

### 스케일 아웃/인 처리 흐름(End-to-End)

#### 스케일 아웃(증설)

1. **Autoscale 트리거**(CPU/큐 길이/스케줄/커스텀 메트릭)
2. VMSS가 **새 인스턴스 프로비저닝**

   * NIC/VNet/Subnet/NSG/UDR/LB 백엔드 풀 연결
   * (선택) **NAT Gateway/Firewall** 통해 egress 고정
3. **부팅 초기화**

   * cloud-init/스크립트/구성관리 실행, Key Vault에서 시크릿 pull
   * 앱 **웜업**(캐시/종속성 연결)
4. **헬스 확인 후 트래픽 편입**

   * **Load Balancer/AGW 헬스 프로브** OK
   * **Application Health Extension**(애플리케이션 레벨 엔드포인트) OK 시만 라우팅
5. **관측/태깅**

   * 부팅/배포 로그, 메트릭, 진단 설정

#### 스케일 인(감축)

1. **스케일 인 정책**(Oldest/Newest/Default) + **Zone 분산 균형** 고려
2. **Scheduled Events**/종료 통지로 **그레이스풀 드레인**(연결 종료/큐 플러시)
3. 인스턴스 **제거/해체**(필요 시 데이터 디태치/스냅샷)

---

### 업그레이드(모델 변경) 흐름

* **VMSS 모델**(이미지/Ext/설정)이 바뀌면 **업그레이드 정책**에 따라 인스턴스에 전파:

  * **Manual**: 운영자가 `apply` 실행 시에만
  * **Automatic**: 저장 즉시
  * **Rolling**: **배치 크기/대기 시간/헬스 체크** 기반 단계 배포(권장)
* **Health 기반 롤링**

  * **Load Balancer Probe** 또는 **Application Health Extension**을 **Health probe**로 연결
  * 배치 실패 시 **자동 중단/롤백**(옵션)

---

### OS 패치 & 이미지 업그레이드

* **Automatic OS image upgrades**: 플랫폼/ACG 이미지의 **새 버전**이 나오면 **자동 롤링**(Uniform 중심).
* **자동 OS 패칭**(게스트 패치)은 이미지 업그레이드와 별개(보안 패치 스케줄링/메인터넌스 윈도우).
* **Azure Update Manager**로 패치 통제 가능(재부팅/윈도우 관리).


### 표준 배포 파이프라인

1. **앱 빌드/테스트** → 아티팩트/컨테이너 푸시
2. **이미지 빌드**(AIB/Packer) → **ACG에 새 버전 게시**(Region 복제)
3. **VMSS 모델 갱신**: ACG 최신 버전 참조 + **Rolling Upgrade**(헬스 기반)
4. **부팅 Pull**: cloud-init/Ext가 **버전 고정 아티팩트**&시크릿 pull
5. **검증/트래픽 전환**: 배치별 헬스 OK → 전체 반영

