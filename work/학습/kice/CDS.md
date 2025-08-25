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
  


### 2) 오브젝트 스토리지의 티어와 용도

Preminum은 티어가 아닌 성능 계층으로 티어는 Hot, Cool, Cold, Archive 네 가지 종류가 있다고 봐야 합니다.

- Hot: 빈번한 읽기/쓰기. 단가 높음 , 액세스 비용은 낮음. 일반 운영 데이터.
- Cool: 가끔 접근(>30일). 저장 단가 낮음, 최소 보관 30일 및 조기 삭제 비용 있음. 단기 보관/백업.
- Cold: Cool보다 더 드문 접근(>90일). 저장 단가 더 ↓, 최소 보관 90일. 장기 보관(준아카이브).
- Archive: 보관 전용(>180일 가정). 읽기 전 Rehydrate 필요, 지연 큼. 최저가 장기 보존.
- Premium(블록 Blob Premium): SSD 기반 고성능·낮은 지연, 비용은 높음. 핫 워크로드에 한정.
    

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
