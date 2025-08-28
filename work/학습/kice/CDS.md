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

## 엔터프라이즈용 하이브리드 DNS: Azure DNS Private Resolver/Private DNS + 포워딩/방화벽/프로토콜

### 개요

* 사내는 **내부 도메인(예: corp.local)** 을, 퍼블릭 클라우드(Azure)는 **사설 네임해결(ADLS/Privatelink 등)** 을 요구합니다.
* **Azure DNS Private Resolver(이하 “Resolver”)** 와 **Azure Private DNS Zone** 을 조합해 **양방향 포워딩** 구조로 설계합니다.
* 핵심은 **도메인별로 어디로 묻고(Conditional Forwarding), 트래픽이 어떤 경로/포트로 흐르는지** 를 명확히 하는 것.

### 구성 요소

* **Azure Private DNS Zone**: 사설 영역(authoritative). VNet에 **링크**하면 그 VNet 내 리소스가 해당 존을 질의/등록(옵션) 가능.
* **Azure DNS Private Resolver**: 관리형 **재귀/포워딩** 리졸버.

  * **Inbound Endpoint**(프라이빗 IP 할당): **온프렘→Azure** 질의 수신창구.
  * **Outbound Endpoint**(+ **Forwarding Rule Set**): **Azure→온프렘/외부** 로 **조건부 포워딩** 수행.

> 참고: 일부 리전은 지원 범위가 다를 수 있으니 **배포 전 지역 가용성**을 확인하세요(미지원 시 VM 기반 DNS 프록시 대안).

---

### 표준 아키텍처(허브-스포크 권장)

#### 논리 흐름

* **온프렘 → Azure 내부 도메인/Privatelink**: 온프렘 DNS(AD DS)가 **Azure Inbound Endpoint(프라이빗 IP)** 로 포워딩
* **Azure → 온프렘 내부 도메인(corp.local)**: Resolver **Outbound Endpoint + 규칙**으로 **온프렘 DNS IP** 로 포워딩
* **스포크 VNet**: Private DNS Zone **VNet 링크**(+ 필요 시 Auto-registration), **Forwarding Rule Set** 을 스포크와 연결

#### 단계별 구성 순서

1. **허브 VNet** 준비 → `sbn-dns-inbound`, `sbn-dns-outbound` 서브넷(권장: 전용 서브넷)
2. **Resolver 배포**

   * **Inbound Endpoint**: 사설 IP(1\~2개 이상) 할당
   * **Outbound Endpoint**: 전용 서브넷에 연결
3. **Forwarding Rule Set** 생성

   * 예) `corp.local` → 온프렘 DNS `10.10.10.10, 10.10.20.10`
   * Rule Set을 **필요 VNet(허브/스포크)** 에 **연결**
4. **Private DNS Zone** 생성/연결

   * 예) `privatelink.database.windows.net`, `internal.contoso.cloud`
   * 허브/스포크 VNet에 **링크**, 필요 시 **Auto-registration**(VM만)
5. **온프렘 DNS**(AD DS 등)에서 **Conditional Forwarder** 등록

   * `*.privatelink.*`, `internal.*` 등 → **Azure Inbound Endpoint IP들**
6. **방화벽/NSG 규칙** 적용(아래 섹션)
7. **검증**: 온프렘/스포크 VM에서 `nslookup/dig` 로 상호 질의 테스트

---

### 방화벽/NSG 설계(포트/방향/대상)

#### 포트·프로토콜 기본

* **DNS 표준**: **UDP/53**(대부분 질의), **TCP/53**(대응 크기 초과/세그먼트 재전송/특정 기능)
* **Zone Transfer(AXFR/IXFR)**: **TCP/53**(참고: **Azure Private DNS Zone은 외부 서버로 Zone 전송을 제공하지 않습니다**. 동기화는 포워딩/자동화로 해결)

#### 트래픽별 규칙

##### 1) 온프렘 DNS → Azure Inbound Endpoint

* **온프렘 방화벽(→ Azure)**

  * 목적지: **Inbound Endpoint의 사설 IP(들)**
  * 프로토콜/포트: **UDP/53, TCP/53**
  * 경로: **VPN/ExpressRoute** 내부 통신
* **Azure NSG(Resolver Inbound 서브넷)**

  * 소스: **온프렘 주소대역**
  * 목적지: **Inbound Endpoint IP(들)**
  * 포트: **UDP/53, TCP/53** 허용

##### 2) Azure(Resolver Outbound) → 온프렘 DNS

* **중요 메모(보완 사항)**

  * **DNS 포워딩 시, Azure 쪽 소스가 “단일 IP”가 아니라 서비스 인프라의 ***IP 대역*** 으로 보일 수 있습니다.**
  * 따라서 온프렘 방화벽은 **해당 \_대역\_에 대해 UDP/TCP 53을 허용** 해야 안정적입니다.
  * **단일 소스 IP로만 화이트리스트** 해야 한다면 아래 **대안**(DNS 프록시/Firewall DNS Proxy)을 사용하세요.
* **온프렘 방화벽(← Azure)**

  * 소스: **Resolver Outbound의 서비스 IP 대역**(운영 정책상 허용 범위 확인/명시)
  * 목적지: **온프렘 DNS IP(들)**
  * 포트: **UDP/53, TCP/53**
* **Azure NSG(Resolver Outbound 서브넷)**

  * 목적지: **온프렘 DNS IP(들)**
  * 포트: **UDP/53, TCP/53** 허용

### “단일 소스 IP”만 허용해야 하는 경우(대안)

* **대안 A: Azure Firewall의 DNS Proxy 사용**

  * 스포크/허브의 클라이언트/Resolver가 **Firewall(프라이빗 IP: 53)** 로 질의 → Firewall이 **온프렘 DNS** 로 포워딩
  * 온프렘 방화벽에는 **Firewall의 프라이빗 IP** 만 화이트리스트
* **대안 B: DNS 프록시 VM(BIND/Unbound/Windows DNS)**

  * 허브 VNet에 **고정 사설 IP** 로 DNS 프록시 배치 → Resolver의 포워딩 대상은 이 프록시 → 프록시가 온프렘으로 재포워딩
  * 온프렘 방화벽엔 **프록시 IP** 한 개만 허용

---

### DNS 프로토콜/운영 포인트

#### 프로토콜 요약

* **쿼리/응답**: UDP/53 → 크기 초과 시 **TCP/53** 재시도(EDNS0 확장도 흔함)
* **Zone Transfer(AXFR/IXFR)**: TCP/53(권한 있는 서버 간)

  * **사설 존(Azure Private DNS Zone)** 은 **외부로 Zone Transfer 미지원** → **IaC/자동화** 로 데이터 관리
* **암호화(DoT/DoH)**: 하이브리드 경로에선 일반적으로 **53/UDP/TCP** 사용(Resolver 기준)

#### 운영 체크리스트

* **TTL/캐시**: 변경 테스트 전 **DNS 캐시 플러시**(클라이언트/서버)
* **우선순위**: 사설/공용 **Split-horizon** 충돌 주의(예: `example.com` 내부/외부 레코드 혼재)
* **가용성**: Inbound Endpoint **2개 이상**(서브넷/존 분산), 온프렘 DNS **다중화**
* **로그/모니터링**: 온프렘 DNS 로그, 네트워크 플로우(NSG Flow Logs/방화벽 로그), Resolver 진단 설정

---

### 흔한 설계 패턴

#### 양방향 조건부 포워딩

* 온프렘 DNS: `*.privatelink.*`, `internal.*` → **Azure Inbound IP들**
* Resolver Rule: `corp.local` → **온프렘 DNS IP들**
* 스포크 VNet은 **Rule Set 연결 + Private Zone 링크** 로 통일된 네임해결

#### Split-horizon(내부/외부 동명이인)

* `example.com`(공용)과 `internal.example.com`(사설)을 분리
* 외부는 Public DNS, 내부는 Private DNS Zone + 포워딩

---

### 자주 묻는 질문(FAQ)

#### Q. Private DNS Zone을 온프렘으로 **동기화(Zone Transfer)** 할 수 있나요?

* A. **아니오.** Private DNS Zone은 외부로 AXFR/IXFR을 지원하지 않습니다. **존 데이터는 IaC/자동화** 로 관리하고, **해석은 포워딩** 으로 연결하세요.

#### Q. 온프렘 방화벽은 정확히 무엇을 열어야 하나요?

* A. **UDP/53, TCP/53** 입니다. 방향은 **온프렘→Azure Inbound IP들**, **Azure(Resolver Outbound 서비스 대역)→온프렘 DNS** 를 각각 허용하세요. **단일 IP 화이트리스트가 필요**하면 **DNS Proxy(Azure Firewall/VM)** 를 경유하세요.


## AKS 모니터링 개요

### 무엇을, 어디에, 어떻게 수집하나

* **대상(What)**: 컨트롤 플레인 로그(kube-apiserver 등), 노드/파드/컨테이너 **메트릭**, 컨테이너 **로그(stdout/stderr)**, **Kubernetes 이벤트**, 앱 **텔레메트리(트레이스/의존성/예외)**.
* **수집자(How)**: **Azure Monitor Agent(AMA)** 가 클러스터에 **DaemonSet/ReplicaSet** 형태로 배포되어 데이터를 모읍니다.
* **저장소(Where)**:

  * **Container Insights** → **Log Analytics Workspace(LAW)** 로 로그/일부 메트릭 적재(KQL 쿼리).
  * **Managed Prometheus**(Azure Monitor for Prometheus) → 매니지드 시계열 저장(프로메테우스/PromQL).
  * **Application Insights**(Workspace 기반) → 앱 레벨 텔레메트리(분산 트레이싱/성능).
  * **진단 설정(Diagnostic Settings)** 선택 시 **Storage Account/Blob** 으로 **아카이브** 가능.

> **메모 반영(중요):** Azure Monitor/Insights 활성화나 진단 설정 시 **Storage(Account/Blob)** 로 로그를 **아카이브**하도록 구성할 수 있습니다. **보존주기(보존일수) + 수명주기(티어 전환/삭제) 정책**을 **반드시 함께 설계**하세요.

---

### 구성 요소(리소스)와 역할

#### Log Analytics Workspace(LAW)

* KQL로 조회하는 **중앙 로그 저장소**. 컨테이너 로그(`ContainerLogV2`), K8s 이벤트/인벤토리, 일부 메트릭/상태 지표가 들어옵니다.
* **보존 기간**(예: 30/90/365일)과 **데이터 내보내기**(Event Hub/Storage) 정책을 설정합니다.

#### Azure Monitor Agent(AMA) & DCR/DCE

* **AMA**: 에이전트 Pod(예: `ama-logs`, `ama-metrics`)가 **kube-system** 등에 배포됩니다.
* **DCR(Data Collection Rule)**: “**무엇을**(테이블/카테고리) **어디서**(스코프/네임스페이스/노드셀렉터) **어떻게**(필터/변환)\*\* 수집할지” 정의.
* **DCE(Data Collection Endpoint)**: 수집 엔드포인트(사설/공용) 정의. **프라이빗 링크(AMPLS)** 연계 시 필수.

#### Container Insights

* AKS 전용 모니터링 경험(노드/파드/컨테이너 헬스, 컨트롤플레인 상태, KubeEvents 등).
* “**AKS 모니터링 애드온**”을 켜면 AMA + DCR이 붙고 LAW에 연결됩니다.

#### Managed Prometheus & Managed Grafana(옵션)

* **Prometheus** 스크랩을 매니지드로 제공(에이전트가 스크랩/전송).
* **Managed Grafana** 로 대시보드 바로 연결(프로메테우스 데이터 소스).

#### Application Insights(Workspace 기반)

* 앱 코드(ASP.NET/Java/Node/Python 등)에 **OpenTelemetry/SDK** 삽입 → **분산 트레이스/요청/의존성/예외** 수집.
* **Live Metrics**, **스마트 탐지**로 성능/오류 감지.

#### Diagnostic Settings(클러스터/노드풀/리소스)

* **컨트롤 플레인 로그/메트릭**(kube-apiserver, scheduler, controller-manager, cluster-autoscaler 등)을
  **LAW / Event Hub / Storage** 로 전송(아카이브/SIEM 연동).

#### Storage Account(아카이브/장기보관)

* 진단 로그/메트릭 아카이브 용도로 사용. **컨테이너(Blob)** 에 원본 그대로 저장.
* **수명주기 정책**으로 **Hot→Cool/Cold/Archive** 전환 및 **기간 경과 삭제** 자동화 가능.

---

### 라이프사이클(설치→운영→업데이트→폐기)

#### 설치(Enable)

1. AKS 생성 시 또는 사후에 **모니터링 애드온(Container Insights)** 활성화.
2. LAW 선택/생성 → DCR/DCE 자동 생성 → **AMA Pod** 가 DaemonSet으로 배포.
3. (옵션) **Managed Prometheus/Grafana** 활성화.
4. (옵션) **Application Insights** 리소스 생성 후 앱에 **OTel/SDK** 적용.

#### 운영(수집/조회/알림)

* **KQL**(LAW)과 **PromQL**(Prometheus)로 탐색/대시보드 구성.
* **Alert**: 로그 기반(Alert rule), 메트릭 기반(Alert rule) 설정 → Action Group(Webhook/ITSM/Teams/Email).
* **보안/네트워크**:

  * 공용 통신 시 **Monitor 수집/쿼리 엔드포인트**로의 **아웃바운드 허용** 필요.
  * **사설 통신**은 **AMPLS(Azure Monitor Private Link Scope)** + **DCE/PE** 로 구성.

#### 업데이트(Agent/Rule)

* AMA/확장/애드온은 **클러스터 확장(Extension)** 으로 **롤링 업데이트**.
* DCR은 코드(IaC)로 관리하여 **환경 간 일관성** 유지(파드/네임스페이스 필터 등).

#### 폐기/정리

* 애드온 비활성화/에이전트 제거 → 수집 중단.
* **LAW/Storage 보존 기간** 지나면 자동 삭제되도록 정책 설정. **필요 데이터는 Export** 후 보관.

---

### 데이터 범주(무엇이 어디로 가는가)

#### 로그/이벤트

* **컨테이너 로그**: stdout/stderr → LAW(`ContainerLogV2`)
* **Kubernetes 이벤트**: `KubeEvents`
* **인벤토리**: `KubePodInventory`, `KubeNodeInventory`, `KubeServices` …

#### 메트릭

* **플랫폼 메트릭**(노드/노드풀/컨트롤플레인 일부): Azure Monitor 메트릭(MDM)
* **애드온 메트릭/애플리케이션 메트릭**:

  * Container Insights(LAW 기반 메트릭 테이블/뷰)
  * 또는 **Managed Prometheus**(권장: 메트릭은 시계열에, 로그는 LAW에)

#### 애플리케이션 텔레메트리

* **Application Insights**(Workspace 기반): 요청/의존성/예외/트레이스/Live Metrics
* **OpenTelemetry** 추천(벤더 중립, 추후 백엔드 전환 용이)

---

### 보존/비용/아카이브 설계(강조)

#### 보존 정책

* **LAW 보존**: 워크스페이스 단위(예 30\~730일). 테이블별 보존/차등 과금 가능.
* **Application Insights(LAW 기반)**: 워크스페이스 보존을 따름.
* **Prometheus**: 서비스 요금/보존 선택(대시보드/알람 고려).

#### 아카이브(진단 → Storage)

* **Diagnostic Settings** 로 **Storage Account**에 **원본 로그**를 장기보관.
* **Storage 수명주기**:

  * **N일 후 Cool/Cold/Archive**(티어 전환)
  * **M일 후 삭제**
  * **Append/Page 제약** 고려(대부분 Blob은 Block Blob로 저장)

#### 비용 최적화 팁

* **필터링 수집**(DCR에서 네임스페이스/컨테이너 라벨 기반 제외)로 **GB 수집량 절감**
* 장기보관은 LAW 대신 **Storage 아카이브** + 필요 시 **On-Demand 조회 파이프라인**
* 메트릭은 **Managed Prometheus**, 로그는 **LAW**로 역할 분리

---

### 네트워크/보안

#### 프라이빗 수집(강추천)

* **AMPLS + Private Endpoint** 로 Monitor 수집/쿼리 엔드포인트를 사설화.
* AKS 서브넷 NSG/UDR 확인(방화벽 경유 시 **Azure Monitor FQDN 태그** 사용).

#### 권한

* AMA가 쓰는 **관리 ID**(클러스터/에이전트)에 LAW **Data Ingest** 권한.
* 진단 설정(컨트롤 플레인 로그) 작성 권한: 구독/RG **Monitoring Contributor** 이상.

---

### 운영 팁(현업 체크리스트)

#### 수집 스코프/노이즈 관리

* **DCR**에서 **네임스페이스/라벨 기반 포함·제외**. 빌드/배치 파드 소음 최소화.
* **High-Cardinality** 라벨(동적 UUID 등) 메트릭은 Prometheus에서 **리레이블/삭제**.

#### 경보/런북

* **PodRestart 폭증, OOMKilled, CrashLoopBackOff**, **API 서버 5xx**에 알람.
* **진단 로그 누락/수집 실패**(에이전트 크래시/권한 오류) 알람 추가.

#### 거버넌스(메모 연계)

* **Azure Policy**로 “**모니터링 애드온 필수/진단 설정 필수**” 표준화(상위 MG/구독에서 강제).
* **예외는 Exemption/NotScopes** 로 관리(교차 환경 혼선 방지).

---

### 빠른 절차(운영팀 핸즈온)

#### 1) 애드온/LAW 연결

* 포털/CLI로 **Container Insights** 활성화(기존 LAW 선택).
* (옵션) **Managed Prometheus** + **Managed Grafana** 활성화.

#### 2) DCR 최적화

* 수집 제외(예: `kube-system`, `gatekeeper-system` 등) 또는 특정 라벨만 포함.
* 컨테이너 로그 필드(시간/레벨/메시지) 추출 규칙 구성.

#### 3) 진단 설정 + 스토리지

* AKS 리소스 진단 설정: **LAW + Storage 아카이브** 동시 전송.
* **Storage 수명주기 정책**: 30일 Hot → 60일 Cool → 180일 Archive → 365일 삭제(예시).

#### 4) 알림

* 메트릭/로그 알림 룰 + **Action Group**(Teams/ITSM/Webhook) 연결.
* **쿼리 템플릿**(KQL/PromQL)과 런북 문서화.


## Azure 메시징 선택 가이드: Kafka, Event Hubs, Service Bus, Event Grid, Storage Queue

### 개요

* **무엇을 고를까?**

  * **Event Grid**: *이벤트 알림(reactive), 푸시, 팬아웃, 라우팅/필터링*
  * **Event Hubs**: *스트리밍 수집(telemetry), 초고속 쓰기, 파티션, 소비자 그룹*
  * **Service Bus**: *업무 메시징(command/workflow), 순서/중복방지/스케줄/트랜잭션/DLQ*
  * **Storage Queues**: *단순·저비용 큐*
  * **Kafka**: *풍부한 생태계·프로토콜 표준, 자체 운영(또는 Confluent) / Event Hubs의 **Kafka 호환 엔드포인트**로 대체 가능*

> **요점**: “이벤트 알림”은 **Event Grid**, “스트리밍/로그”는 **Event Hubs**, “업무 메시징”은 **Service Bus**, “간단 큐”는 **Storage Queue**, “카프카가 표준인 조직/프레임워크”는 **Kafka 또는 Event Hubs(Kafka 프로토콜)**.

---

### 서비스별 핵심 개념

#### Event Grid

* **패턴**: *Push 기반 이벤트 라우팅(Pub/Sub)*
* **특징**: 구독(Subscription)별 **필터/라우팅**, **재시도/Dead-letter**, 다수의 Azure 소스(Blob, Resource Events 등)와 호환
* **사용처**: \*“무언가 발생했다”\*를 여러 소비자(Functions, Logic Apps, Webhook 등)에게 **즉시 알림/트리거**

#### Event Hubs

* **패턴**: *대량 스트리밍/로그 수집*
* **특징**: **파티션**·**소비자 그룹**, “읽고 또 읽는” 스트림, **Capture**로 Blob/ADLS에 원본 적재, **Kafka 프로토콜 호환**(브로커 대체)
* **사용처**: IoT/앱 로그/텔레메트리, Databricks/Synapse/ASA로 실시간 분석

#### Service Bus (Queues/Topics)

* **패턴**: *엔터프라이즈 메시징(명령/워크플로)*
* **특징**: **세션(순서 보전/FIFO 유사), 중복 감지, 스케줄 발송, 지연 메시지, 트랜잭션, DLQ**, 구독 규칙(토픽)
* **사용처**: 결제/주문/업무 플로우, **정확성/순서/보상 처리**가 중요한 B2B/백오피스

#### Storage Queues

* **패턴**: *경량 비동기 처리*
* **특징**: 간단·저비용, 기능은 최소(순서/세션/트랜잭션 없음)
* **사용처**: 보조 작업, 비용 민감 환경, 아주 단순한 비동기화

#### Kafka (자체/Confluent) & Event Hubs(Kafka 호환)

* **Kafka 자체(또는 Confluent Cloud/Platform)**: Connect/Streams/KSQL 등 **생태계 기능**이 꼭 필요하거나 **벤더 표준이 Kafka**인 조직
* **Event Hubs의 Kafka 호환**: **브로커 주소만 교체**로 상당수 Kafka 클라이언트를 **비수정** 연결 가능(프로토콜=Kafka/TLS)

---

### 선택 기준(결정 트리)

#### 1) 이벤트냐 메시지냐 스트림이냐?

* **이벤트 알림/트리거**: **Event Grid**
* **업무 메시지(명령/워크플로)**: **Service Bus**
* **로그/텔레메트리 스트림**: **Event Hubs**
* **진짜 단순 큐**: **Storage Queues**

#### 2) 순서/중복/트랜잭션이 필요한가?

* **필요함** → **Service Bus**(세션·중복감지·트랜잭션·DLQ)
* **불필요/대량 스트림** → **Event Hubs**

#### 3) Kafka 생태계에 의존?

* **Kafka Connect/Streams 등 필수** → **Kafka(자체/Confluent)**
* **그렇진 않지만 Kafka 클라를 유지** → **Event Hubs(Kafka 호환)**

#### 4) 소비 모델

* **푸시(웹훅/Functions 트리거)** → **Event Grid**
* **풀(컨슈머가 오프셋 관리하며 읽음)** → **Event Hubs/Kafka/Service Bus**

---

### 네트워킹/보안(포트·엔드포인트·프라이빗)

#### 네트워크 경유

* **Event Grid**: **HTTPS 443**(웹훅/핸들러), 사설 필요 시 **Private Link(Endpoint)** 지원 대상 리소스 사용
* **Event Hubs**: **AMQP 5671**, **AMQP over WebSockets 443**(프록시/방화벽 우회), **Kafka TLS 포트(일반적으로 9093)**
* **Service Bus**: **AMQP 5671**, **AMQP over WebSockets 443**, REST 443
* **Storage Queue**: HTTPS 443

#### 프라이빗 액세스

* **Event Hubs/Service Bus/Storage**: **Private Endpoint** 지원 → VNet 내부 전용 통신
* **팔로업**: 사설 경로면 **DNS**(Private DNS Zone)와 **아웃바운드 라우팅**(NAT GW/Firewall) 동반 설계

#### 인증/권한

* **SAS 토큰**(키 기반), **Azure AD RBAC/토큰**(Managed Identity 권장)
* **메시지 핸들러는 멱등성**: 최소 1회 전송/재시도에 대비

> **운영 메모(보완 연계)**: *로그·진단은 Azure Monitor/Insights로 전송 가능하며, Storage(Blob)에 아카이브 시 **보존/수명주기 정책**을 반드시 설계하세요.*

---

### 운영·패턴별 설계

#### Event-driven(알림/후행처리)

* **Event Grid → Azure Functions/Logic Apps**
* 구독별 **필터링(Subject/Prefix/Suffix)**, **Dead-letter**로 실패 이벤트 보존
* *예*: Blob 업로드 → 이미지 처리(함수) → 결과 저장(앞서 다룬 “후행 처리 체인”)

#### Streaming(텔레메트리/로그)

* **Event Hubs → Stream Analytics/Spark/Databricks/Synapse**
* **Capture**로 ADLS/Blob에 **원본 보관** → 거버넌스/재처리 용이(라이프사이클 정책 적용)

#### Enterprise Messaging(명령/워크플로)

* **Service Bus Queue/Topic**
* **세션**으로 **FIFO 유사** 보장, **중복감지/스케줄/지연/트랜잭션/DLQ**
* **사가(Saga)** / 보상 트랜잭션, **요청-응답**(코릴레이션), **리트라이** 정책

#### Kafka 생태계가 기준

* **자체/Confluent Kafka**: Connectors/Streams/KSQL 등 전체 스택 활용
* **Event Hubs (Kafka 호환)**: 브로커 교체형 마이그레이션, Azure 관리형 스케일

---

### 비교 표(요약)

| 항목           | Event Grid          | Event Hubs             | Service Bus | Storage Queue | Kafka(자체/Confluent)  |
| ------------ | ------------------- | ---------------------- | ----------- | ------------- | -------------------- |
| 주 용도         | 이벤트 알림/트리거          | 스트리밍 수집                | 업무 메시징      | 경량 큐          | 스트리밍(풀 스택)           |
| 소비 모델        | Push(웹훅/함수)         | Pull(오프셋)              | Pull(큐/토픽)  | Pull          | Pull                 |
| 순서/세션        | ✖️                  | 파티션 내 상대적 순서           | ✔️(세션)      | ✖️            | ✔️(파티션/키)            |
| 트랜잭션         | ✖️                  | ✖️                     | ✔️          | ✖️            | ✔️                   |
| 라우팅/필터       | ✔️(구독 필터)           | 소비자 그룹                 | ✔️(토픽+규칙)   | ✖️            | ✔️(토픽/스트림)           |
| DLQ          | ✔️(Dead-letter 이벤트) | 컨슈머 구현                 | ✔️          | 제한적(가시성 타임아웃) | 컨슈머 구현               |
| 네트워크 포트      | 443                 | 5671/443, (Kafka) 9093 | 5671/443    | 443           | 9092/9093 등          |
| Private Link | 일부 시나리오             | ✔️                     | ✔️          | ✔️            | 자체 설계(프록시/프라이빗 클러스터) |

> 표의 수치·상세 한도(사이즈/보존 등)는 SKU/지역에 따라 다르므로 **설계 시 최신 문서로 확인**하세요.

---

### 실전 선택 레시피

1. **웹훅 기반 반응형 자동화** → **Event Grid + Functions**
2. **수십\~수백 MB/s 텔레메트리** → **Event Hubs + Capture + 분석(ASA/Databricks)**
3. **주문/결제 등 업무 플로우** → **Service Bus(세션/트랜잭션/DLQ)**
4. **Kafka 표준 조직** → **Confluent/Azure VM/AKS Kafka** 또는 **Event Hubs(Kafka)**
5. **아주 단순 비동기** → **Storage Queue**

---

### 네트워크/방화벽 체크리스트

* **Event Hubs/Service Bus**:

  * **AMQP 5671**(TLS), **AMQP over WebSockets 443**(프록시 환경), **Kafka 9093**(TLS)
  * **Private Endpoint** 사용 시 **Private DNS** 및 **경로(UDR/NAT)** 확인
* **Event Grid**: **443**(웹훅 핸들러), 구독 검증(Validation) 통과 필요
* **아웃바운드 제어**: FQDN 기준 허용이 필요하면 **Azure Firewall**의 **FQDN 규칙** 사용(단순 NSG는 FQDN 불가)


## AKS 오토스케일 총정리: Pod(HPA/KEDA/VPA) ↔ NodePool(Cluster Autoscaler/VMSS)

### 왜 두 층을 구분해야 하나?

* **Pod 오토스케일**은 **복제본 수**를 조정해 처리량/지연을 맞추고,
* **Node 오토스케일**은 **VMSS 인스턴스 수**를 조정해 **스케줄 불가(Pending) Pod**를 수용합니다.
* 흐름: **HPA/KEDA가 Pod 수 증가 → Pending 발생 → CA가 노드 증설**. 부하 하락 시 CA가 안전하게 축소.

### 용어·구성요소 한 눈에

* **HPA**: CPU/메모리/커스텀 지표 기반 **수평 Pod 스케일**
* **KEDA**: 큐 길이·Kafka lag 등 **이벤트 지표**로 HPA를 **구동**
* **VPA**: Pod의 **requests/limits**를 권고/자동 조정(수직)
* **Cluster Autoscaler(CA)**: Pending Pod를 근거로 **NodePool(=VMSS) 증감**
* **VMSS**: AKS NodePool의 실제 VM 풀

### Pod 오토스케일

#### HPA( Horizontal Pod Autoscaler )

* **전제**: Pod에 **requests** 선언, **Metrics Server** 가동
* **지표**: CPU/메모리 이용률, **외부/커스텀 지표**(Prometheus Adapter/KEDA)
* **튜닝**: `stabilizationWindowSeconds`, `behavior.scaleUp/Down.policies`, `min/maxReplicas`

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: web-hpa
spec:
  scaleTargetRef: { apiVersion: apps/v1, kind: Deployment, name: web }
  minReplicas: 2
  maxReplicas: 20
  behavior:
    scaleUp:   { stabilizationWindowSeconds: 60 }
    scaleDown: { stabilizationWindowSeconds: 300 }
  metrics:
    - type: Resource
      resource:
        name: cpu
        target: { type: Utilization, averageUtilization: 70 }
```

#### KEDA( Event-Driven Autoscaling )

* **역할**: `ScaledObject`가 **HPA를 생성/관리**
* **장점**: 큐/토픽 길이 등으로 **정밀 스케일**

```yaml
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata: { name: worker-sb }
spec:
  scaleTargetRef: { name: worker }
  minReplicaCount: 0
  maxReplicaCount: 50
  triggers:
    - type: azure-servicebus
      metadata: { queueName: jobs, messageCount: "50", namespace: sb-namespace }
```

#### VPA( Vertical Pod Autoscaler )

* **용도**: requests/limits **권고/자동 조정**
* **주의**: HPA와 **같은 리소스**를 동시에 조정하지 않도록(출렁임 방지). 일반적으로 **HPA=복제 수**, **VPA=requests**.

### NodePool(=VMSS) 오토스케일

#### Cluster Autoscaler 트리거 조건

* **증설**: 스케줄러가 배치 못해 **Pending** 발생
* **축소**: **저활용 노드** 비우고 제거(PDB 준수)
* **영향 요소**: **PDB**, **taint/toleration**, **node affinity**, **GPU/로컬SSD/특정 SKU/Zone** 요구

#### AKS CA 프로파일(예시)

* `scan-interval`(탐지 주기), `scale-down-delay-after-add`, `scale-down-unneeded-time`, `balance-similar-node-groups`

```bash
az aks update -g rg -n aks \
  --cluster-autoscaler-profile scan-interval=20s \
  scale-down-delay-after-add=10m \
  scale-down-unneeded-time=10m \
  balance-similar-node-groups=true
```

#### VMSS 관점 유의점

* **서브넷 IP 여유**(Azure CNI/Overlay), **구독 vCPU/리소스 쿼터**, **리전/존 SKU 가용성**,
* **이미지/부팅 초기화**: **ACG 이미지 + cloud-init/확장**으로 **최신 상태** 보장

### 자주 발생하는 이슈와 해법

#### HPA 쪽

* **증설 안 됨**: `requests` 없음 / Metrics Server 오류 / 커스텀 지표 매핑 불일치
* **과민 스케일**: `stabilizationWindow`/정책 완화
* **콜드스타트**: `initialDelaySeconds` 조정 + **오버프로비저닝**(낮은 우선순위 placeholder)

#### KEDA 쪽

* **인증 실패**: MI/연결문자열 권한
* **지표 해석**: 트리거 스펙과 실제 메트릭 **단위/이름** 일치

#### CA/노드 쪽

* **Pending인데 증설 안 함**: taint/affinity/리소스/볼륨 조건 충돌, **맞는 Pool 부재**, IP/Quota/SKU 부족
* **축소 안 됨**: 고정 Pod/로컬 상태/PDB 제약, 축소 지연 파라미터 과도

### 실전 설계 레시피

#### 1) 기준값 정하기

* **HPA** 목표 이용률(예: CPU 60\~70%), `min/maxReplicas`, **stabilizationWindow**
* **KEDA** 큐/lag 임계값에 **SLA 반영**
* **CA** 프로파일로 **확장 민감도↑/축소 안정성↑**

#### 2) 노드풀 분리

* 역할별 Pool(일반/메모리/GPU/스팟) + **taint/toleration** 라우팅

#### 3) 오버프로비저닝 패턴

* **낮은 priorityClass** 의 placeholder를 상시 유지 → 급증 시 즉시 수용, CA가 뒤따라 증설

#### 4) VMSS 최신화

* **ACG(Compute Gallery)** 버전 관리 + **롤링 업그레이드** + **Application Health** probe

#### 5) 네트워크·보안

* **NAT Gateway** 로 egress IP 고정(외부 화이트리스트)
* **NSG 최소 허용**
* 모니터링/아카이브는 **Azure Monitor/Container Insights/Prometheus** + **Storage 보존·수명주기 정책** 함께 설계

### 빠른 체크리스트

#### HPA/KEDA

* [ ] Pod **requests/limits**
* [ ] Metrics Server/Adapter 정상
* [ ] HPA **stabilization/behavior**
* [ ] KEDA 트리거 권한/지표 매핑

#### Cluster Autoscaler/NodePool

* [ ] Pool **min/max** 및 **CA 활성화**
* [ ] **서브넷 IP/Quota/SKU** 사전 점검
* [ ] **taint/affinity/PDB** 점검
* [ ] **CA 프로파일** 튜닝


## Kubernetes 네트워킹/스토리지 기본: **Ingress Controller · CNI · CSI** 정리

### 1) Ingress Controller란?

#### 이론 및 개념

* **Ingress Controller**는 Kubernetes 환경에서 **L7(HTTP/HTTPS)** 트래픽을 **클러스터 외부 → 내부 서비스**로 라우팅하는 컴포넌트입니다.
* **Ingress 리소스**는 *경로/호스트/TLS 등 트래픽 규칙*을 **선언**하고, 실제 **분배/정책 적용은 Controller**가 수행합니다. (두 개념은 명확히 분리)

#### Kubernetes Ingress ↔ Ingress Controller 관계

| 구성요소                   | 역할                               |
| ---------------------- | -------------------------------- |
| **Ingress 리소스**        | 트래픽 흐름/분배 정책의 **선언적 정의** 제공      |
| **Ingress Controller** | 정책 **해석** 후 실제 **라우팅/SSL 종료** 수행 |

#### AKS의 주요 Ingress Controller 유형

| 종류                                               | 특징                                                                            |
| ------------------------------------------------ | ----------------------------------------------------------------------------- |
| **애플리케이션 라우팅(Add-on)**                           | Azure 관리형 **NGINX** 기반, **Azure DNS 자동 등록/갱신**, **Key Vault** 인증서 연동, 손쉬운 활성화 |
| **Application Gateway Ingress Controller(AGIC)** | **Azure Application Gateway** 연동, **WAF/SSO/SSL 종료**, 대규모 엔터프라이즈 기능           |
| **기타(직접 설치/관리)**                                 | **Istio/Kong/Emissary/Traefik** 등 원하는 솔루션 직접 구성                               |

#### 주요 옵션 (Ingress 스펙/어노테이션)

| 옵션명                                                     | 값 예시                                          | 설명                  |
| ------------------------------------------------------- | --------------------------------------------- | ------------------- |
| `ingressClassName`                                      | `webapprouting.kubernetes.azure.com`, `nginx` | 여러 컨트롤러 동시 사용 시 구분자 |
| `spec.rules[].host`                                     | `myapp.example.com`                           | 트래픽 도메인             |
| `spec.rules[].http.paths[].path`                        | `/`, `/api`                                   | 요청 URI 경로           |
| `spec.rules[].http.paths[].pathType`                    | `Prefix`, `Exact`                             | 경로 매칭 방법            |
| `spec.rules[].http.paths[].backend.service.name`        | 서비스명                                          | 백엔드 서비스             |
| `spec.rules[].http.paths[].backend.service.port.number` | 포트 번호                                         | 백엔드 포트              |
| `spec.tls[].hosts[]`                                    | `[myapp.example.com]`                         | TLS 적용 호스트          |
| `spec.tls[].secretName`                                 | `my-tls-secret`                               | TLS 인증서 Secret      |
| `metadata.annotations["kubernetes.io/ingress.class"]`   | `nginx`                                       | (레거시) 컨트롤러 지정       |
| `nginx.ingress.kubernetes.io/rewrite-target`            | `/`                                           | 경로 재작성              |
| `nginx.ingress.kubernetes.io/ssl-redirect`              | `"true"`                                      | HTTP→HTTPS 리다이렉트    |
| `nginx.ingress.kubernetes.io/backend-protocol`          | `HTTP/HTTPS/GRPC`                             | 백엔드 프로토콜            |

#### Ingress 리소스 예시 (YAML)

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
  annotations:
    kubernetes.io/ingress.class: webapprouting.kubernetes.azure.com
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
spec:
  ingressClassName: webapprouting.kubernetes.azure.com
  tls:
    - hosts:
        - myapp.example.com
      secretName: myapp-tls
  rules:
    - host: myapp.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: my-service
                port:
                  number: 80
```


### Ingress Controller “최근 2가지” 방식 핵심 추가

* **NGINX Ingress(Ingress API 기반)**

  * 장점: 이식성 높음(온프렘/멀티클라우드), 유연한 라우팅·재작성·gRPC/WS, 비용 효율.
  * 유의: WAF/mTLS 등 엔터프라이즈 보안은 **별도 솔루션 연동**이 일반적.
* **Gateway API 기반 컨트롤러(예: Azure Application Gateway for Containers, NGINX Kubernetes Gateway)**

  * 장점: `Gateway/GatewayClass/HTTPRoute`로 **역할 분리**(인프라팀=Gateway, 앱팀=Route), **WAF/mTLS/사설 L7** 등 클라우드 L7과 **네이티브 통합** 용이.
  * 유의: 구현체별 세부기능 상이, 도입 시 **권한/ReferenceGrant** 등 개념 학습 필요.

#### 선택 포인트(시험용 한 줄 정리)

* **보안/거버넌스 중심** → *Gateway API*
* **이식성/민첩성 중심** → *NGINX Ingress*


---

### 2) CNI(Container Networking Interface)란?

#### 개념과 역할

* **CNI**는 Pod 네트워크 인터페이스 구성, **IP 할당/라우팅/네트워크 정책**을 위한 **표준 플러그인 인터페이스**입니다.
* Pod가 네트워크에 연결될 때 필요한 환경을 만들고 **올바르게 라우팅**되도록 보장합니다.

#### AKS 네트워킹 모델 (개요)

| 네트워킹 모델                         | 설명                               | 특징                                  |
| ------------------------------- | -------------------------------- | ----------------------------------- |
| **Azure CNI Overlay**           | Pod에 **논리 IP**를 터널링(VXLAN 등)로 할당 | IP 효율↑, 대규모 확장, 격리 용이               |
| **Azure CNI Flat(Transparent)** | Pod가 **VNet 서브넷 실제 IP**를 직접 할당   | 온프렘 연동 용이, **IP 소모 큼**              |
| **kubenet**                     | 노드만 실제 IP, Pod는 별도 논리망(NAT)      | 400노드 제한, **Windows 미지원**, 2028 EoS |

#### 주요 CNI 옵션/파라미터

| 옵션명                     | 예시값                                                       | 설명               |
| ----------------------- | --------------------------------------------------------- | ---------------- |
| `networkPlugin`         | `azure`, `kubenet`                                        | 네트워킹 플러그인        |
| `networkPolicy`         | `calico`, `azure`, `none`                                 | Pod 간 네트워크 정책    |
| `networkPluginMode`     | `overlay`, `transparent`                                  | CNI 동작 모드        |
| `podCidr`               | `10.244.0.0/16`                                           | Overlay Pod CIDR |
| `vnetSubnetId`          | `/subscriptions/.../subnets/mysubnet`                     | 실제 VNet 서브넷      |
| `serviceCidr`           | `10.0.0.0/16`                                             | Service IP 풀     |
| `dnsServiceIp`          | `10.0.0.10`                                               | CoreDNS IP       |
| `outboundType`          | `loadBalancer`, `managedNATGateway`, `userDefinedRouting` | 아웃바운드 방식         |
| `nsgId`/`routeTableId`  | 리소스 ID                                                    | NSG/UDR 연결       |
| `privateClusterEnabled` | `true/false`                                              | 프라이빗 클러스터        |

#### 동작 원리

* **Overlay**: PodCidr 내 **논리 IP** → VXLAN 등 터널 → 노드/Pod 간 직접 통신, 외부는 **SNAT**. **대형/격리**에 유리.
* **Flat(Transparent)**: Pod가 **VNet 실 IP** 직접 사용 → 외부 시스템 호환성↑, **IP 계획 중요**.
* **kubenet**: 노드만 실 IP, Pod는 사설망 + **NAT**. 제한/미지원 사항 많아 **점진 종료 예정**.

#### 비교 요약

| 특성            | Azure CNI Overlay   | Azure CNI Flat | kubenet   |
| ------------- | ------------------- | -------------- | --------- |
| 최대 노드 수       | **5,000+**          | VNet IP 범위에 좌우 | \~400     |
| Pod IP        | 논리 Overlay          | **VNet 실제 IP** | 사설망 + NAT |
| Pod 간 통신      | 직접(터널)              | 직접             | NAT/경로 의존 |
| IP 효율         | **높음**              | 중간             | 낮음        |
| Windows 지원    | 예                   | 예              | 아니오       |
| 정책            | Azure/Calico/Cilium | 유사             | 제한적       |
| Virtual Nodes | 가능                  | 가능             | 미지원       |
| 복잡도           | 중간                  | 낮음             | 높음        |

#### 권장 사항/마이그레이션

* 신규 AKS는 **Azure CNI Overlay** 권장.
* **kubenet/IP 부족** 이슈는 **Overlay**로 전환 검토.
* 온프렘/기존 VNet과 **긴밀 연동/보안 정책** 요구 시 **Flat** 고려.
* 대규모/격리/모니터링 중시 시 **Overlay 최적**.

### AKS Pod IP 구성 2모델(내부형) 비교 보강

* **Azure CNI Overlay (Internal Overlay)**

  * Pod는 **논리 IP(Overlay CIDR)**, 노드 간 **터널링**(VXLAN 등), 외부는 **노드 SNAT**.
  * **IP 절약/대규모 확장**에 유리, 온프렘 경로설정 단순.
  * 체크: `podCidr`, `networkPlugin=azure`, `networkPluginMode=overlay`.
* **Azure CNI Flat/Transparent (서브넷 실IP 할당)**

  * Pod가 **VNet 서브넷 실제 IP**를 직접 사용 → 온프렘/방화벽/소스IP 보존 시나리오에 유리.
  * 단점: **IP 소모 큼** → 서브넷/쿼터/UDR/NSG 계획 필수.
  * 체크: `networkPluginMode=transparent`, `vnetSubnetId` 대역 충분.

#### 네트워킹 실수 방지 메모

* **서브넷 IP 부족**이면 CA/VMSS 증설 실패(Flat).
* **Outbound**: `managedNATGateway`(권장, egress 고정) 또는 LB/UDR.
* **Network Policy**: Overlay/Flat 모두 Azure/Calico 사용 가능(구성 일관성 확인).

---

### 3) CSI(Container Storage Interface)란?

#### 개념 및 목적

* **CSI**는 쿠버네티스가 **외부 스토리지 백엔드(블록/파일/오브젝트)** 와 통신하기 위한 **표준 인터페이스**입니다.
* in-tree 드라이버 한계를 탈피, **플러그인 방식**으로 독립적 개발/배포/업그레이드가 가능.

#### 주요 기능

* **동적 프로비저닝/해제**, **마운트/언마운트**, **볼륨 확장**, **스냅샷**, **다중 접근 모드(RWO/RWX)**

#### 구조/동작 메커니즘

| 구성 요소                 | 역할                                               |
| --------------------- | ------------------------------------------------ |
| **Controller Plugin** | PVC 생성 시 **실제 볼륨 생성/삭제/관리**                      |
| **Node Plugin**       | 노드에 볼륨 **Attach/Detach**, Pod에 **Mount/Unmount** |
| **Provisioner**       | PVC 이벤트 감시 → **PV 생성 요청**                        |
| **Attacher**          | 워크로드 사용 시 **마운트 절차** 수행(다중 노드 연결 포함)             |

#### AKS 주요 CSI 드라이버

| 드라이버                | 설명/특징                      | 프로토콜/특성                         |
| ------------------- | -------------------------- | ------------------------------- |
| **Azure Disk CSI**  | 고성능 **블록** 스토리지, **RWO**   | Managed Disk (SSD/HDD)          |
| **Azure Files CSI** | **SMB/NFS** 공유 파일, **RWX** | SMB 3.0 / NFS, Premium/Standard |
| **Azure Blob CSI**  | **오브젝트**를 파일처럼 사용          | BlobFuse/NFS, 대용량 비정형           |

#### (Azure Files CSI) 주요 파라미터

| 옵션명                    | 값 예시                                       | 설명              |
| ---------------------- | ------------------------------------------ | --------------- |
| `provisioner`          | `file.csi.azure.com`                       | 프로비저너 식별자       |
| `skuName`              | `Standard_LRS`/`Premium_LRS`/`Premium_ZRS` | 성능/내구성/SKU      |
| `protocol`             | `smb`/`nfs`                                | 접근 프로토콜         |
| `location`             | `koreacentral` 등                           | 리전 지정           |
| `allowVolumeExpansion` | `true/false`                               | 동적 확장 허용        |
| `reclaimPolicy`        | `Delete`/`Retain`                          | 삭제 시 동작         |
| `mountOptions`         | `dir_mode=0777` 등                          | 마운트 옵션          |
| `maxShares`            | `"10"`                                     | 동시 접근 한도(제약 있음) |

#### StorageClass 예시 (Azure Files)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: azurefile-premium
provisioner: file.csi.azure.com
parameters:
  skuName: Premium_LRS
  protocol: smb
allowVolumeExpansion: true
reclaimPolicy: Delete
mountOptions:
  - dir_mode=0777
  - file_mode=0777
```

#### PVC 예시

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: azurefiles-pvc
spec:
  storageClassName: azurefile-premium
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
```

#### Azure Disk CSI 주요 사항

* **블록 스토리지**, 고성능 DB/워크로드 적합, **RWO(ReadWriteOnce)**
* **Premium/Standard SSD, Standard HDD** 지원, **스냅샷/볼륨 확장** 지원(무중단 크기 변경 가능)
* **VM SKU별 디스크 수 한도/대역폭** 제약 주의

#### 장애/운영 체크리스트

* **PVC Pending**: StorageClass 파라미터/권한/PE 네트워크 확인
* **마운트 실패**: K8s 이벤트/Pod 로그/Storage 상태/네트워크(Private Endpoint) 점검
* **성능 이슈**: SKU 변경, **NFS/SMB 프로토콜** 교체, 대역폭 모니터링
* **키 관리**: **Key Vault/Managed Identity** 연동
* **보호**: 스냅샷/백업 정책 수립(복구 테스트 포함)


### PV/PVC ↔ Azure Files 매핑(옵션·제약) + Private Endpoint 개념 정리

* **왜 Azure Files인가?**

  * **RWX(여러 노드 동시 읽기/쓰기)** 가 필요 → **Azure Files(CSI)** 사용.
  * **Azure Disk(CSI)** 는 일반적으로 **RWO(단일 노드)**. *공유 디스크* 시나리오는 특수(제약 多) — **시험에선 RWX=Files, RWO=Disk**로 구분이 안전.
* **주요 PVC 옵션과 Azure Files의 실제 의미**

  * `accessModes`: **ReadWriteMany(RWX)** 지원(파일 공유).
  * `resources.requests.storage`: 용량 지정(확장 `allowVolumeExpansion: true` 가능).
  * `storageClassName`: `file.csi.azure.com`용 SC 선택(아래 예시).
  * `reclaimPolicy`: **Delete/Retain**

    * **Delete**: PVC 삭제 시 **파일 공유도 삭제**(주의).
    * **Retain**: PVC 삭제해도 **데이터 보존**(사후 수동 정리/마이그레이션에 유용).
  * `volumeBindingMode`: **WaitForFirstConsumer 권장**(스케줄 후 바인딩 → 영역·서브넷 제약 충돌 완화).
  * `mountOptions`: `dir_mode/file_mode`, 캐시/권한 등 조정.
  * `parameters`: `skuName(Premium/Standard)`, `protocol(smb/nfs)`, `location`, `maxShares` 등.

#### StorageClass/PVC 예시(Azure Files, RWX, Retain)

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: azurefile-premium-retain
provisioner: file.csi.azure.com
parameters:
  skuName: Premium_LRS
  protocol: nfs            # Linux RWX에 유리(권장), Windows는 smb 사용
allowVolumeExpansion: true
reclaimPolicy: Retain
mountOptions:
  - vers=4.1               # NFS 예시
  - rsize=1048576
volumeBindingMode: WaitForFirstConsumer
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-share
spec:
  accessModes: [ ReadWriteMany ]
  storageClassName: azurefile-premium-retain
  resources:
    requests:
      storage: 200Gi
```

#### 인증/자격증명(시험 포인트)

* **SMB**: 스토리지 계정 **액세스 키/SAS** 또는 **AD 기반(Kerberos)**.
* **NFS**: IP 기반 접근 제어(사설망/PE로 제한), POSIX 권한.
* **AKS에서 CSI** 는 보통 **Secret**(키/SAS) 또는 **Managed Identity + Key Vault** 조합으로 안전 관리.

#### Private Endpoint vs Private Link(헷갈리기 쉬운 포인트)

* **Private Link(개념 상위)**: PaaS를 **VNet 사설 IP**로 노출하는 **기술/제품군**.
* **Private Endpoint(리소스)**: 스토리지 **서브리소스(file)** 등에 붙는 **사설 NIC**.

  * Azure Files용 **PE 대상 서브리소스: `file`**
  * **Private DNS Zone**: `privatelink.file.core.windows.net`(자동/수동 등록)
  * 온프렘 접속 시 **ER/VPN + DNS 분기** 로 **PE 사설 IP** 해석되게 해야 함.
  * **보안**: 스토리지 **방화벽 “선택 네트워크만”** + **PE** 조합, **공용 접근 차단**.

#### 운영 체크(시험용 한 줄 요약)

* **RWX 필요** → Azure Files(+PE)
* **데이터 보존 필요** → `reclaimPolicy=Retain`
* **폐쇄망** → **Private Endpoint + Private DNS + ER/VPN**
* **Windows/SMB** vs **Linux/NFS** 프로토콜 선택 주의

### 빠른 대비용 표(요지)

| 항목     | Azure Disk(CSI) | Azure Files(CSI)       |
| ------ | --------------- | ---------------------- |
| 접근 모드  | **RWO**(일반)     | **RWX**(다중 노드)         |
| 프로토콜   | 블록(파일시스템은 노드에서) | **SMB/NFS**            |
| 사용처    | DB/저지연 단일 인스턴스  | 다중 Pod 공유(웹, 리포트, 업로드) |
| 확장     | 크기 확장 OK        | 크기 확장 OK               |
| 네트워크   | 노드 ↔ 디스크        | **PE로 폐쇄망 구성 용이**      |
| 마이그레이션 | 스냅샷/복제          | 공유 복사/동시 접근 편리         |


## GitHub Actions CI/CD 핵심 정리: 트리거·워크플로 위치·잡/스텝·시크릿 관리

### 언제 실행되나? (Event Trigger)

* **커밋/브랜치/태그**

  * `push`: 브랜치/태그 푸시 시
  * `pull_request`: PR 열림/수정/동기화 시 (기본적으로 *포크 PR*에는 시크릿 미노출)
  * `release`: 릴리스 생성/게시
* **수동/예약/외부**

  * `workflow_dispatch`: **수동 실행** (UI/API, 입력 파라미터 가능)
  * `schedule`: **크론(UTC)** 기반 예약 실행
  * `repository_dispatch`: 외부 시스템이 **웹훅**으로 트리거
  * `workflow_call`: **재사용 워크플로** 호출(모듈화)
* **이슈/코드 스캔 등**

  * `issue_comment`, `pull_request_review`, `code_scanning_alert` 등 상황별 세부 트리거

> **필터링**: `branches`, `tags`, `paths`, `paths-ignore` 로 세밀 제어
> **주의**: 포크에서 온 `pull_request`는 **시크릿 접근 불가**(보안). 필요 시 `pull_request_target`를 쓰되 **권한·체크아웃 대상**을 엄격히 제한.

---

### 액션/워크플로 파일은 어디에?

* **워크플로(Workflow) 정의**: 레포지토리 **`.github/workflows/*.yml`**
* **커스텀 액션(선택)**

  * 레포 내 **`.github/actions/<name>/action.yml`** (Composite/JS/Docker 액션)
  * 또는 **별도 레포**에서 버전 태그로 참조(`uses: org/repo@v1`)
* **러너(Runner)**: GitHub-hosted(ubuntu/windows/macos) 또는 **Self-hosted** (네트워크 제약, 사설망 배포에 적합)

---

### 워크플로 기본 골격 (Jobs/Steps/권한/캐시/아티팩트)

```yaml
name: ci

on:
  push:
    branches: [ main ]
    paths: [ "src/**", ".github/workflows/ci.yml" ]
  workflow_dispatch:

permissions:
  contents: read          # GITHUB_TOKEN 최소권한 원칙
  id-token: write         # OIDC(클라우드 단기 토큰) 사용 시 필요

concurrency:
  group: ci-${{ github.ref }} # 동일 브랜치 중복 실행 방지
  cancel-in-progress: true

jobs:
  build-test:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        node: [18, 20]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: ${{ matrix.node }} }
      - run: npm ci
      - run: npm test
      - uses: actions/cache@v4
        with:
          path: ~/.npm
          key: npm-${{ runner.os }}-${{ hashFiles('package-lock.json') }}
      - uses: actions/upload-artifact@v4
        with:
          name: test-report
          path: coverage/**

  deploy:
    needs: [ build-test ]
    runs-on: ubuntu-latest
    environment: prod          # 환경 보호 규칙(승인/시크릿 범위) 활용
    steps:
      - uses: actions/checkout@v4
      - name: Login to Azure via OIDC
        uses: azure/login@v2
        with:
          client-id: ${{ secrets.AZURE_CLIENT_ID }}
          tenant-id: ${{ secrets.AZURE_TENANT_ID }}
          subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
          # 위 3개는 "페더레이션(Workload Identity)" 사전 구성이 전제
      - run: az deployment group create -g rg -f main.bicep -p env=prod
```

* **Jobs**: 독립 실행 단위(병렬/의존관계 `needs`)
* **Steps**: 잡 내부의 단계(`uses` 액션 호출 or `run` 셸 명령)
* **`permissions`**: `GITHUB_TOKEN`의 최소 권한 설정(기본 “읽기 전용” 권장)
* **`concurrency`**: 중복 실행 취소(배포 파이프라인 필수)
* **캐시/아티팩트**: `actions/cache`, `upload-artifact`/`download-artifact`

---

### 시크릿(Secret)과 크리덴셜 관리 (ID/PW, 키, 토큰)

* **종류와 우선순위**

  * **Repository secrets**: 레포 전용 암호값
  * **Environment secrets**: 특정 **environment**(dev/stage/prod) 전용 + **보호 규칙(승인/시간제한)**
  * **Organization secrets**: 여러 레포에서 공유
  * **Variables**: 민감정보가 아닌 일반 값(브랜치/경로 등)
* **기본 토큰**

  * **`GITHUB_TOKEN`**: 워크플로마다 발급되는 **단기 토큰**. 레포 접근/릴리스/PR 코멘트 등 자동화에 사용(권한은 `permissions`로 축소)
* **클라우드 권한 부여 (강력 권장)**

  * **OIDC + Federated Credentials** (예: Azure **Workload Identity**):
    장기 **클라이언트 시크릿 없이**, 워크플로 런타임에 **단기 토큰** 발급 → **비밀 유출 위험↓**

    * Azure: `azure/login@v2` + Entra ID **Federated Credential**(repo/브랜치 조건) 구성
* **보안 수칙**

  * 시크릿은 **로그에 출력 금지**(GitHub가 자동 마스킹하나, 문자열 조작하면 누설 가능)
  * 포크 PR에 시크릿 **미제공**(기본). `pull_request_target` 사용 시 **체크아웃 대상 커밋**을 반드시 고정(신뢰된 기준 브랜치)
  * 필요한 환경에만 **Environment secrets** 할당, **승인자** 설정
  * 주기적 **로테이션**, 사용 이력/권한 **리뷰**
  * 가능하면 **SAS/Access Key 대신 IAM(OIDC/MI)** 사용

---

### 파일 배치/명명/패턴 모음

* **`.github/workflows/*.yml`**: 워크플로 정의(파일명 자유)
* **`.github/actions/<name>/action.yml`**: 레포 내 커스텀 액션(Composite/JS/Docker)
* **재사용 워크플로**: 별도 레포의 `.github/workflows/reusable.yml` → `workflow_call`로 가져와 공통화

---

### 트리거 필터링/PR 보안 예시

```yaml
on:
  pull_request:
    branches: [ main ]
    paths:
      - "app/**"
      - "!app/docs/**"     # 제외
jobs:
  pr-check:
    if: ${{ github.event.pull_request.head.repo.fork == false }} # 포크 PR 제한
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: npm run lint
```

---

### 실무 체크리스트(요약)

* [ ] 트리거: `push/pull_request/workflow_dispatch/schedule` 등 **필요 최소로 명시**, `paths` 필터 적용
* [ ] `permissions` 최소화, `concurrency`로 중복 배포 차단
* [ ] 환경 분리: **`environment` + env secrets + 보호 규칙(승인)**
* [ ] 시크릿: **OIDC(Workload Identity)** 로 **장기 키 제거**, 로테이션/권한 리뷰
* [ ] 포크 PR: 시크릿 미노출, `pull_request_target` 시 **체크아웃 커밋 고정**
* [ ] 캐시/아티팩트 적극 활용, 재사용 워크플로로 **중복 제거**

## Azure 로드 밸런싱 선택 가이드 — **제품/가용성(조널·리저널·글로벌) 관점**

### 한눈에 보기(무엇을 언제 쓰나)

| 계층/범위            | 조널(Zonal)                                         | 리저널(Region)                                                      | 글로벌(Global)                                         | 주요 용도                                   |
| ---------------- | ------------------------------------------------- | ---------------------------------------------------------------- | --------------------------------------------------- | --------------------------------------- |
| **L4 (TCP/UDP)** | **Azure Load Balancer Standard** (프런트엔드/백엔드 존 지정) | **Azure Load Balancer Standard** (Zone-redundant, Cross-zone LB) | **Cross-region Load Balancer**                      | 비HTTP 트래픽, 게임/IoT/TCP/UDP, 내부 서비스 L4 분산 |
| **L7 (HTTP/S)**  | (존 배치 기반)                                         | **Application Gateway v2**(WAF/Autoscale/Zone-redundant)         | **Azure Front Door**(Std/Premium, Anycast, WAF, 캐시) | 웹/REST, 경로/호스트 기반 라우팅, WAF              |
| **DNS 기반**       | -                                                 | -                                                                | **Traffic Manager**                                 | 프로토콜 무관 글로벌 엔드포인트 선택(DNS 레벨)            |
| **서비스 체인**       | -                                                 | **Gateway Load Balancer**                                        | -                                                   | NVA(방화벽/IDS) 인라인 삽입                     |
| **아웃바운드**        | -                                                 | **NAT Gateway**                                                  | -                                                   | 고정 egress IP/포트 스케일(로드밸런서 아님)           |

> 포인트: “내부/공개”보다 **제품/가용성 범위**로 먼저 고릅니다. L7 글로벌=**Front Door**, L7 리저널/WAF=**Application Gateway**, L4=**Load Balancer**, DNS 레벨 스티어링=**Traffic Manager**.

---

### Azure Load Balancer (L4) — 조널·리저널·글로벌

#### 핵심

* **계층**: L4(TCP/UDP). 백엔드=NIC/VM/VMSS.
* **가용성**:

  * **Zonal**: 프런트엔드를 특정 Zone에 고정 가능.
  * **Zone-redundant**: 다중 Zone에 걸쳐 프런트엔드/데이터평면 분산.
  * **Cross-region**: 여러 **리저널 LB**를 백엔드로 두는 **글로벌 L4**.
* **해alth Probe**: TCP(핸드셰이크만) / HTTP(S) 200응답 확인(웹이면 **HTTP Probe 권장**).
* **세션**: 5-tuple 해시, **Session persistence**(None/ClientIP/ClientIP+Protocol).
* **HA Ports**: 모든 포트 로드밸런싱(방화벽/게이트웨이 앞단에 유용).
* **아웃바운드**: SNAT 포트 한계 존재 → **NAT Gateway**로 분리 설계 권장.

#### 자주 하는 실수

* 웹인데 **TCP Probe** 사용 → 앱이 응답 불가여도 포트만 열려 있으면 “정상”으로 판단.
* **AzureHealthProbe 서비스 태그** 미허용(NSG) → 프로브 실패로 백엔드 제외.
* egress를 LB Outbound Rule로만 구성 → **SNAT 고갈**로 실패.

---

### Application Gateway v2 (L7, 리저널)

#### 핵심

* **HTTP/S** 전용 L7, **경로/호스트 기반**, 리라이트/리디렉션, **WAF(OWASP)**, **Autoscale**, **Zone-redundant**.
* **엔드투엔드 TLS**(프런트 종료 + 백엔드 재암호화), **mTLS**, 쿠키 기반 세션 어피니티.
* **AKS 연동**: **AGIC**로 Ingress 규칙 → AppGW 설정 반영(리저널 L7).

#### 언제 쓰나

* 리전 내 **엔터프라이즈 웹/WAF** 요구, 내부(Private) 또는 외부(Public) L7, 세밀한 라우팅/정책.

---

### Azure Front Door (L7, 글로벌)

#### 핵심

* **글로벌 Anycast 엣지**에서 TLS 종료, **헬스 프로브 + 원본그룹**으로 **지역 간 활성/활성**.
* **WAF**, 캐싱(Std/Premium), **세션 어피니티(쿠키)**, \*\*프라이빗 링크 오리진(프리미엄)\*\*로 사설 원본 보호.

#### 언제 쓰나

* **전 세계 사용자** 대상, 최단 엣지 접속/페일오버, 글로벌 L7 라우팅/가속.

---

### Traffic Manager (DNS, 글로벌)

#### 핵심

* **DNS 레벨** 트래픽 스티어링(프로토콜 무관). **Priority/Weighted/Performance/Geo/Subnet** 프로파일.
* DNS **TTL**에 따라 장애전파 지연. 클라이언트/리졸버 캐시 영향.

#### 언제 쓰나

* L4/L7 제품과 **조합**하여 **글로벌 엔드포인트 선택**이 필요할 때 (예: TM → AppGW/Front Door).

---

### Gateway Load Balancer (서비스 체인, 리저널)

#### 핵심

* **Geneve** 캡슐화로 **NVA 인라인 삽입**. 기존 L4/L7 앞뒤에 “투명” 부착.
* 대형 방화벽/IDS/IPS를 **스케일아웃**으로 배치.

---

### NAT Gateway (Egress 전용, 리저널)

#### 핵심

* **아웃바운드 전용**. **고정 퍼블릭 IP/대량 SNAT 포트** 제공.
* 내부 서비스에서 외부 API 호출 시 **고정 소스 IP** 보장(화이트리스트 대응).

---

### 가용성 설계 패턴

* **존 내 고가용성**: AppGW **Zone-redundant**, LB **Zone-redundant**/Cross-zone.
* **리전 DR**: 리전별 **AppGW/LB** + **Front Door(글로벌)** 로 활성/활성, 또는 **Traffic Manager Priority**로 활성/대기.
* **보안 체인**: **Gateway LB** + NVA + **AppGW/LB**(HA Ports) 조합.

---

### 선택 레시피(요구조건 → 제품)

* **비HTTP L4, 내부 서비스** → **Azure Load Balancer(Standard)**
* **리전 L7/WAF, Private 또는 Public** → **Application Gateway v2**
* **글로벌 L7, 엣지 가속/페일오버** → **Azure Front Door**
* **프로토콜 무관 글로벌 라우팅(DNS)** → **Traffic Manager**
* **NVA 인라인** → **Gateway Load Balancer**
* **고정 egress IP/대량 동시접속** → **NAT Gateway**

---

### 운영 체크리스트

* **Probe 경로/포트**: 웹은 **HTTP(S) 200** 확인, NSG에 **AzureLoadBalancer/AzureHealthProbe** 허용.
* **세션 전략**: 상태 저장 앱은 **어피니티**(AppGW/Front Door) 또는 **외부 세션 스토어**.
* **SNAT**: 대량 아웃바운드는 **NAT GW** 우선.
* **DNS**: Front Door/TM 도입 시 **TTL/캐싱/헬스 프로브** 동작 이해.
* **코스트**: 데이터 전송/규칙/처리 단가(Front Door, AppGW)와 **스케일**에 따른 비용 확인.



## VMware → Azure 마이그레이션(Agentless 중심) — OS 제약·요건·프로세스 한눈에 정리

### 1) 마이그레이션 방식 요약 (Agentless vs Agent-based)

| 구분    | Agentless (권장)                                      | Agent-based                      |
| ----- | --------------------------------------------------- | -------------------------------- |
| 방식    | vCenter/ESXi 스냅샷을 **마이그레이션 어플라이언스**가 읽어 Azure로 복제   | 각 VM에 **Mobility Agent** 설치 후 복제 |
| 장점    | 에이전트 설치 불필요, 빠른 착수, 일괄 이행에 유리                       | 광범위 OS 지원, 특수 게스트/파일시스템 지원 폭 넓음  |
| 제한    | 특정 디스크/부팅/암호화 조합 미지원(아래 표)                          | 게스트 내 에이전트 설치/유지보수 필요            |
| 동시 복제 | vCenter당 **최대 300**(단일 어플라이언스), **최대 500**(스케일아웃 시) | 시나리오/인프라에 의존                     |

> Microsoft는 VMware→Azure에 대해 **Agentless를 우선 권장**합니다. 단, 제약에 걸리면 Agent-based를 사용하세요. 

---

### 2) vSphere·네트워크 선행 요건(Agentless)

* **vCenter/ESXi**: vCenter **6.5/6.7/7.0/8.0**, ESXi **6.5/6.7/7.0/8.0** 지원.
* **어플라이언스 배치**: vCenter에 **Azure Migrate Appliance(OVA/스크립트)** 배포 후 등록. 대규모 이행은 **스케일아웃 어플라이언스** 사용. 
* **필수 포트**

  * vCenter **TCP 443 (인바운드)**: 스냅샷 생성/삭제 등 오케스트레이션.
  * ESXi **TCP 902 (인바운드/아웃바운드)**: 스냅샷에서 데이터 복제/하트비트.
  * 어플라이언스 → Azure **TCP 443 (아웃바운드)**: 복제 데이터 업로드/제어.

---

### 3) **OS 지원/제약(Agentless)** — “어디까지 그대로 올릴 수 있나”

#### Windows / Linux 지원선

* **Windows**: *문서상* **Windows Server 2003 이상** 지원 **(단, EOS OS는 결과 보장 불가·업그레이드 권장)**.
* **Linux**: Azure가 지원하는 배포판 전반을 커버. RHEL/Ubuntu/SLES/Debian/Oracle/Alma/Rocky 등 주요 배포판은 **자동 수정(waagent 설치 등) 범위** 제공. 일부 커널/설정은 수동 조치 필요.

> **EOL OS 경고**: Windows Server 2003/2008/2012(R2 포함)는 **지원 종료(EOS)** 로 **일관된 결과를 보장하지 않음** → **사전 업그레이드 권장**. 

#### 부팅/디스크·파일시스템 제약(핵심만 발췌)

* **UEFI → Azure Gen2** 로 변환되며, **Secure Boot는 Agentless 경로에서 미지원** → 마이그레이션 후 **Trusted Launch**로 재활성 권장. 
* **동적 디스크(Windows OS 디스크)**: **미지원** → **Basic** 으로 전환 후 진행. 
* **암호화 디스크/볼륨(BitLocker 등)**: **미지원** → 암호화 해제 후 마이그레이션.
* **RDM/Independent/NVMe/iSCSI 타깃/Multipath IO**: **미지원** (복제 제외).
* **NFS/ ReiserFS** 마운트: **복제 대상 아님**.
* **NIC Teaming/IPv6**: **미지원**.
* **디스크 크기 한도**: OS 디스크 Gen1 **≤2TB**, Gen2 **≤4TB** / 데이터 디스크 **≤32TB**.
* **부트 파티션 규칙**: `/boot`(Linux) 또는 **EFI/System Reserved**는 **OS 디스크 내**에 존재해야 함(다른 디스크로 분산 금지). 

---

### 4) 게스트 OS 준비 팁(Agentless 공통)

* **Windows**

  * **RDP 활성화**, 방화벽에 **TCP/UDP 3389 허용**, **SAN 정책=OnlineAll** 확인.
* **Linux**

  * **SSH 활성화**, 방화벽 포트 허용.
  * `waagent` 설치에 필요한 **Python/OpenSSL/OpenSSH, sfdisk/fdisk/parted** 등 패키지 확인.
  * **SELinux Enforced**는 자동 설정/에이전트 설치 실패 가능 → **Permissive 권장**.

---

### 5) Agent-based를 고려해야 하는 경우

* 위 **Agentless 제약**(동적/암호화/RDM/특수 파일시스템/네트워킹) 중 **하나라도 충족 불가**.
* OS/커널 조합이 **Site Recovery**(현대화 경험) 쪽에서 더 폭넓게 보장될 때. **(OS·커널 매트릭스는 ASR 기준과 동일)**

---

### 6) 표준 이행 프로세스(Agentless 관점)

1. **어세스먼트**: Azure Migrate Discovery & Assessment로 사이징/종속성 파악.
2. **어플라이언스 배포**: vCenter에 **Azure Migrate Appliance**(OVA/스크립트) 설치·등록, VDDK 준비. 
3. **복제 구성**: 대상 VM 선택, 저장소/네트워크/VM 크기 매핑, **동시 복제 수** 고려. 
4. **Test Migration**: 격리된 네트워크에 가동·기능/성능 검증.
5. **컷오버(Migrate)**: 변경동기화 → 전환(다운타임 극소화) → DNS/보안 정책 적용.
6. **후속 작업**: **Azure VM Agent/Diagnostics**, 백업/모니터링/보안 기준(Defender) 정착.

---

### 7) 운영·트러블슈팅 체크리스트

* **포트/프록시/SSL 검사**: 어플라이언스→Azure 443, vCenter/ESXi 443/902 허용.
* **스냅샷 실패**: vCenter 권한(디스크 임대/스냅샷) 누락 여부, 데이터스토어 여유공간 확인.
* **복제율 저하**: 어플라이언스 리소스, WAN 대역폭, 스케일아웃 도입 검토.
* **부팅 실패**: Secure Boot 사용 VM, 동적 디스크, 부트 파티션 분산 여부 확인(상단 제약 참고). 

---

### 8) 시험에 자주 묻는 포인트(요약)

* **vSphere/포트 요건**(443/902), **어플라이언스 개념**, **Agentless 제약(동적/암호화/RDM/UEFI-SecureBoot 등)**, **UEFI→Gen2 변환**. 
* **동시 복제 상한/스케일아웃** 수치 기억. 
* **EOL OS 경고**: 결과 보장 X → 업그레이드 권장. 

---

### 예상문제 3개 (정답 포함)

1. **객관식**
   Agentless VMware→Azure 마이그레이션의 **네트워크 요구사항**으로 옳지 않은 것은?
   A. 어플라이언스→Azure로 **TCP 443** 아웃바운드 필요
   B. vCenter로 **TCP 443 인바운드** 필요
   C. ESXi와 **TCP 902** 통신 필요
   D. **IPv6 전용** 환경에서도 복제가 완전 지원됨
   **정답:** D (Agentless는 **IPv6 미지원**). 

2. **단답형**
   Agentless 경로에서 **보안 부팅(Secure Boot)** 을 사용하던 UEFI VM을 이관할 때 권장 대응은?
   **모범답안:** **Gen2**로 마이그레이션 후 **Trusted Launch VM** 으로 전환해 Secure Boot 등 보안 기능을 재활성화. 

3. **서술형**
   동적 디스크(OS)·BitLocker·RDM 디스크가 혼재한 VM을 Azure로 옮겨야 한다. **방식 선택**과 **사전 조치**를 서술하라.
   **모범답안 요지:**

* Agentless는 **동적/암호화/RDM 미지원**이므로 **Agent-based(Mobility)** 고려. 또는 사전 조치로 **동적→Basic 변환**, **암호화 해제**, **RDM 제거/데이터 재배치** 후 Agentless 진행.

---

### 참고 문서

* VMware vSphere 마이그레이션 지원 매트릭스(Agentless/Agent-based, 제약/포트/동시복제 등)
* 어플라이언스 요건(VDDK/배포 옵션) & 스케일아웃
* Site Recovery(Agent-based) OS·커널 상세 매트릭스(현대화 경험) 

> 필요하면, 환경(버전/디스크/보안) 스냅샷을 알려주면 **Agentless/Agent-based 선택안**과 **사전 수정 체크리스트**를 바로 깔끔하게 뽑아줄게요.


## Azure Functions 선택 가이드(Durable 포함) & Azure Disk Detach/리사이즈 영향

### Azure Functions: 언제 **Durable**을 쓸까?

#### 실행/호스팅 옵션 한눈에

| 항목      | Consumption   | Premium          | Dedicated(앱 서비스/Isolated) |
| ------- | ------------- | ---------------- | ------------------------- |
| 콜드스타트   | 있음            | 거의 없음(프리워밍)      | 없음                        |
| VNET 통합 | 제한적           | **네이티브 지원**      | 지원                        |
| 장시간 실행  | 제한(기본 5\~10분) | **확장(무제한에 가까움)** | 확장                        |
| 비용      | 사용량 기반        | 사용량+예약           | 고정형                       |

> **Durable Functions**는 **상태/장시간/워크플로**가 필요한 경우에 적합하며, **Premium/Isolated** 플랜과 궁합이 좋습니다.

#### Functions vs Durable Functions vs Logic Apps

| 요구사항                                            | 권장                                                  |
| ----------------------------------------------- | --------------------------------------------------- |
| 단일 이벤트 처리(짧은 수명), 서버리스 핸들러                      | **Functions**(Timer/HTTP/Queue 등 트리거)               |
| **장시간** 오케스트레이션, **상태 유지**, 단계적 비동기, **팬아웃/팬인** | **Durable Functions**(Orchestrator/Activity/Client) |
| **시각적 워크플로**, SaaS 커넥터 다수, 낮은 코드 의존             | **Logic Apps**                                      |

#### Durable Functions 핵심 패턴

* **Function Chaining**: 순차 단계 실행(주문→결제→알림)
* **Fan-out/Fan-in**: 병렬 실행 후 결과 집계(대량 이미지 처리)
* **Async HTTP API**: 즉시 202 응답 + 상태 폴링 엔드포인트
* **Monitor/Recurring**: 크론성 모니터링(외부 시스템 상태 체크)
* **Human Interaction**: 휴먼 승인 이벤트까지 **일시중단/타임아웃**
* **Saga/보상 트랜잭션**: 분산 단계 실패 시 보상 로직 실행
* **Durable Entities**: 소규모 **키-상태** 액터(카운터/세션 상태)

#### 트리거 선택 요령(요약)

* **HTTP**: 동기 요청/짧은 처리, 장시간은 **Durable Async HTTP** 패턴
* **Queue/Service Bus**: 백그라운드 작업, 재시도/사이드이펙트 안전
* **Event Grid**: Blob 업로드/리소스 변경 등 **이벤트 구동**
* **Timer**: 배치/스케줄 작업(대용량이면 Durable로 워크분할)


## Terraform로 AKS 만들 때 “Pod 네트워크” 설정 잡는 법(문법·블록·패턴별 예시)

### 목적

* Terraform **기본 문법**(블록/변수/참조/for\_each 등)과
* AKS 리소스에서 **Pod 네트워킹**을 제어하는 **정확한 위치와 문장**을 한 번에 정리합니다.
* 시험에서 자주 묻는: **Overlay/Transparent(kubenet 포함)** 설정, **필드명 혼동 포인트**, **NAT egress 고정**까지 체크.

---

### Terraform 문법 초간단 요약

* **블록 구조**: `resource`, `data`, `module`, `variable`, `output`, `locals`
* **키=값 인자**: `name = "foo"`, 중첩은 **블록**으로 표현
* **참조**: `resource.type.name.attr` (예: `azurerm_subnet.aks.id`)
* **변수**:

  ```hcl
  variable "location" { type = string; default = "koreacentral" }
  ```

  사용: `var.location`
* **for\_each / count**: 반복 생성

  ```hcl
  resource "azurerm_resource_group" "rg" {
    for_each = toset(["dev","prod"])
    name     = "rg-${each.key}"
    location = var.location
  }
  ```
* **동적 블록**:

  ```hcl
  dynamic "tags" {
    for_each = local.common_tags
    content { key = tags.key value = tags.value }
  }
  ```

---

### “어디에 쓰나?” — AKS의 **Pod 네트워크**는 여기서 설정

* 리소스: `resource "azurerm_kubernetes_cluster" "aks" { ... }`
* 핵심: **`network_profile { ... }` 블록**
  여기서 **CNI 종류, 모드, Pod/Service CIDR, Network Policy, Outbound 방식**을 지정합니다.
* 노드 서브넷은 `default_node_pool { vnet_subnet_id = ... }` 에서 지정.

> 시험 포인트: **`network_profile` 블록 유무/내용으로 “Pod 네트워크 설정 문장이 있는지”를 확인**할 수 있어야 함.

---

### 패턴 1) **Azure CNI Overlay** (Pod는 논리 IP, IP 절약·대규모에 적합)

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-overlay"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksovl"

  default_node_pool {
    name            = "system"
    vm_size         = "Standard_D4s_v5"
    node_count      = 3
    vnet_subnet_id  = azurerm_subnet.aks_nodes.id   # 노드가 붙을 서브넷
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin       = "azure"          # Azure CNI
    network_plugin_mode  = "overlay"        # 오버레이 모드(= Pod 논리 IP)
    pod_cidr             = "10.240.0.0/16"  # Pod 논리 대역(오버레이용)
    service_cidr         = "10.0.0.0/16"
    dns_service_ip       = "10.0.0.10"
    network_policy       = "azure"          # 또는 "calico"
    outbound_type        = "managedNATGateway"  # egress 고정(권장)
  }
}
```

* **키 포인트**: `network_plugin = "azure"`, `network_plugin_mode = "overlay"`, `pod_cidr` 사용.

---

### 패턴 2) **Azure CNI Transparent(Flat)** (Pod가 VNet 실IP를 직접 사용)

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-flat"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "aksflat"

  default_node_pool {
    name           = "system"
    vm_size        = "Standard_D4s_v5"
    node_count     = 3
    vnet_subnet_id = azurerm_subnet.aks_pod.id     # ❗Pod가 여기 대역에서 IP를 소모
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin       = "azure"           # Azure CNI
    network_plugin_mode  = "transparent"     # Flat/Transparent
    # ⚠ Pod CIDR 미사용. 서브넷 IP를 많이 잡아야 함.
    service_cidr         = "10.1.0.0/16"
    dns_service_ip       = "10.1.0.10"
    network_policy       = "calico"
    outbound_type        = "managedNATGateway"
  }
}
```

* **키 포인트**: `network_plugin_mode = "transparent"`이고 **Pod가 서브넷 실제 IP**를 사용 → **서브넷 IP 계획 필수**.

---

### 패턴 3) **kubenet** (점진 종료 예정 시나리오, 시험에 언급만)

```hcl
resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-kubenet"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "akskube"

  default_node_pool {
    name           = "system"
    vm_size        = "Standard_D4s_v5"
    node_count     = 3
    vnet_subnet_id = azurerm_subnet.aks_nodes.id
  }

  identity { type = "SystemAssigned" }

  network_profile {
    network_plugin  = "kubenet"
    pod_cidr        = "10.244.0.0/16"  # 노드에서 NAT
    service_cidr    = "10.2.0.0/16"
    dns_service_ip  = "10.2.0.10"
    network_policy  = "calico"
    outbound_type   = "managedNATGateway"
  }
}
```

* **요점**: Pod는 별도 사설망→노드가 NAT. 제한 및 미지원 사항이 많아 **신규는 비권장**.

---

### (보너스) NAT Gateway로 **egress IP 고정** 예시

```hcl
resource "azurerm_public_ip" "natgw_pip" {
  name                = "pip-natgw"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "natgw" {
  name                = "natgw-aks"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "Standard"
}

resource "azurerm_nat_gateway_public_ip_association" "natgw_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.natgw.id
  public_ip_address_id = azurerm_public_ip.natgw_pip.id
}

resource "azurerm_subnet_nat_gateway_association" "subnet_nat" {
  subnet_id      = azurerm_subnet.aks_nodes.id  # 또는 Pod 서브넷(Transparent)
  nat_gateway_id = azurerm_nat_gateway.natgw.id
}
```

* AKS 쪽 `network_profile.outbound_type = "managedNATGateway"` 와 **동일/정합**하게 설계.

---

### 프로바이더/버전별 **필드명 혼동 주의**

* `network_plugin_mode` ↔ 과거 예시의 `network_mode`
* `service_cidr`(단수) ↔ 일부 버전/샘플의 `service_cidrs`(복수)
* 결론: **사용 중인 azurerm 버전에 맞춘 스키마**를 확인하고, 팀 표준 모듈에서 **한 가지 표기**로 통일하세요.

---

### 체크리스트 (시험 대비)

* [ ] AKS 리소스 안의 **`network_profile { ... }`** 유무로 **Pod 네트워크 설정**을 찾을 수 있는가?
* [ ] Overlay ↔ Transparent의 차이(**`network_plugin_mode`**, IP 소비, `pod_cidr` 필요 여부) 설명 가능?
* [ ] `network_policy`(azure/calico)와 `outbound_type`(managedNATGateway 등) 위치를 기억하는가?
* [ ] 노드 서브넷은 **`default_node_pool.vnet_subnet_id`** 에서 지정한다는 점?
* [ ] NAT Gateway 연동은 **서브넷 연결 + AKS outbound\_type**을 함께 본다?

## Istio Service Mesh — Virtual Host와 핵심 리소스 치트시트

### 한눈에 개념 맵
	•	Gateway: 엣지(ingress/egress) 리스너(포트/프로토콜/TLS/SNI) 정의
	•	VirtualService: 가상 호스트(hosts) + 라우팅 규칙(경로/헤더/쿠키 매칭 → 목적지)
	•	DestinationRule: 백엔드 서브셋(subset=버전 라벨) 및 연결 정책(LB/재시도/회로차단/TLS)
	•	ServiceEntry: 메시 외부(인터넷/온프렘) 서비스를 메시에 등록
	•	Sidecar: 네임스페이스의 egress 통신 범위 축소(성능·보안)
	•	보안 리소스: PeerAuthentication(mTLS), RequestAuthentication(JWT), AuthorizationPolicy(RBAC)
	•	관측/확장: Telemetry, EnvoyFilter/WasmPlugin

### Virtual Host란?
	•	Envoy 개념: 하나의 리스너에서 여러 도메인(Host/SNI) 별로 각기 다른 라우팅 테이블을 갖는 단위
	•	Istio에서: VirtualService.spec.hosts 항목이 가상 호스트 역할
	•	Ingress 경로: Gateway.spec.servers.hosts 와 VirtualService.spec.hosts 교집합일 때 매칭
	•	메시 내부: 사이드카가 VirtualService.hosts를 기준으로 클러스터 라우트 구성

### 리소스 간 관계(요약 흐름)
	1.	Gateway 가 수신 포트/프로토콜/TLS·SNI를 연다
	2.	VirtualService 가 호스트/경로/헤더 매칭으로 목적지 라우팅
	3.	DestinationRule 이 목적지 버전(subset) 및 연결 정책 부여
	4.	ServiceEntry 로 외부 도메인/IP를 메시에 등록
	5.	Sidecar 로 egress 허용 범위를 축소
	6.	mTLS/JWT/RBAC 으로 신뢰·인증·인가를 정책화

### 자주 쓰는 트래픽 제어 레시피
	•	카나리/버저닝: DestinationRule.subsets + VirtualService.http.route.weight
	•	헤더/쿠키 기반 라우팅: match.headers/cookie/uri
	•	회복력: retries, timeout, outlierDetection, connectionPool
	•	장애 주입: fault.delay/abort 로 혼잡/장애 테스트
	•	리라이트: rewrite, headers.request/response.add/remove

### Ingress/Egress 패턴
	•	Ingress: Gateway + VirtualService(hosts 교집합)로 외부→내부 라우팅
	•	Egress(외부 호출)
	•	간단: ServiceEntry 로 외부 목적지 등록 후 직접 아웃바운드
	•	감사/고정 IP: Egress Gateway 경유 + VirtualService 로 경로 고정

### 보안(Zero-Trust)
	•	mTLS: PeerAuthentication(STRICT) + DestinationRule.trafficPolicy.tls(mode: ISTIO_MUTUAL)
	•	인증: RequestAuthentication 로 JWT 검증
	•	인가: AuthorizationPolicy 로 주체/대상/조건 기반 허용 리스트

### 성능·스코프 최적화
	•	Sidecar 로 egress 대상 축소(기본 */* → 필요한 서비스/네임스페이스/도메인만)
	•	OutlierDetection 으로 불량 인스턴스 자동 격리, LB 가중치로 비율 제어

### YAML 예시

예시 ① Ingress + Virtual Host + 카나리(80%:v1, 20%:v2)

```yaml
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: web-gw
  namespace: web
spec:
  selector:
    istio: ingressgateway
  servers:
  - port: { number: 443, name: https, protocol: HTTPS }
    tls: { mode: SIMPLE, credentialName: web-tls }
    hosts: ["shop.example.com"]
---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata:
  name: cart
  namespace: web
spec:
  host: cart.web.svc.cluster.local
  trafficPolicy:
    loadBalancer: { simple: ROUND_ROBIN }
    outlierDetection: { consecutive5xx: 5, interval: 2s, baseEjectionTime: 30s }
  subsets:
  - name: v1
    labels: { version: v1 }
  - name: v2
    labels: { version: v2 }
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: cart
  namespace: web
spec:
  hosts: ["shop.example.com"]          # ← Virtual Host
  gateways: ["web/web-gw"]
  http:
  - match:
    - uri: { prefix: "/cart" }
    route:
    - destination: { host: cart.web.svc.cluster.local, subset: v1, port: { number: 8080 } }
      weight: 80
    - destination: { host: cart.web.svc.cluster.local, subset: v2, port: { number: 8080 } }
      weight: 20
    retries: { attempts: 2, perTryTimeout: 1s }
    timeout: 3s
```

예시 ② mTLS(STRICT) + JWT + 인가(RBAC)

```yaml
apiVersion: security.istio.io/v1beta1
kind: PeerAuthentication
metadata:
  name: mtls-strict
  namespace: web
spec:
  mtls: { mode: STRICT }
---
apiVersion: security.istio.io/v1beta1
kind: RequestAuthentication
metadata:
  name: jwt
  namespace: web
spec:
  selector: { matchLabels: { app: cart } }
  jwtRules:
  - issuer: "https://login.example.com/"
    jwksUri: "https://login.example.com/.well-known/jwks.json"
---
apiVersion: security.istio.io/v1beta1
kind: AuthorizationPolicy
metadata:
  name: allow-premium
  namespace: web
spec:
  selector: { matchLabels: { app: cart } }
  action: ALLOW
  rules:
  - to:
    - operation: { paths: ["/cart/checkout"], methods: ["POST"] }
    when:
    - key: request.auth.claims[tier]
      values: ["premium"]
```

예시 ③ 외부 API를 Egress Gateway로만 나가게(고정 egress IP·감사)

```yaml
apiVersion: networking.istio.io/v1beta1
kind: ServiceEntry
metadata: { name: ext-payments, namespace: web }
spec:
  hosts: ["api.payments.com"]
  ports: [{ number: 443, name: tls, protocol: TLS }]
  resolution: DNS
  location: MESH_EXTERNAL
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata: { name: vs-ext-pay, namespace: web }
spec:
  hosts: ["api.payments.com"]
  gateways: ["istio-system/egressgateway"]
  tls:
  - match:
    - port: 443
      sniHosts: ["api.payments.com"]
    route:
    - destination:
        host: istio-egressgateway.istio-system.svc.cluster.local
        port: { number: 443 }
---
apiVersion: networking.istio.io/v1beta1
kind: DestinationRule
metadata: { name: dr-egress, namespace: istio-system }
spec:
  host: istio-egressgateway.istio-system.svc.cluster.local
  trafficPolicy:
    tls: { mode: ISTIO_MUTUAL }
```


### 체크리스트
	•	Gateway.servers.hosts ↔ VirtualService.hosts 교집합 확인(SNI/Host 매칭)
	•	DestinationRule.subsets.labels ↔ Pod 라벨 일치
	•	mTLS STRICT 시 DestinationRule.tls(mode: ISTIO_MUTUAL) 설정
	•	외부 호출은 ServiceEntry 등록, Egress Gateway 경유 시 고정 출구·감사 용이
	•	Sidecar 로 egress 범위 축소(성능·보안 최적화)

### 자주 나오는 함정
	•	VirtualService.hosts 와 Gateway.hosts 불일치 → Ingress 매칭 실패
	•	카나리 가중치만 조정하고 subsets 라벨 미배치 → 전량 v1로 라우팅
	•	STRICT mTLS 인데 DestinationRule.tls 누락 → 503
	•	Egress는 열었지만 Sidecar 스코프 기본값(*/*) 방치 → 라우트 범람/성능 저하

### 예상문제 3개
	1.	객관식: Ingress에서 Virtual Host 매칭이 성립하려면?
	•	A. DestinationRule.host = VirtualService.hosts
	•	B. ServiceEntry.hosts = VirtualService.hosts
	•	C. Gateway.servers.hosts ∩ VirtualService.hosts 가 교집합
	•	D. PeerAuthentication.mode = STRICT
정답: C
	2.	단답형: 카나리(v1/v2) 기준을 어디에 정의하며 무엇과 일치해야 하는가?
	•	정답: DestinationRule.subsets.labels 에 정의하며, Deployment의 Pod 라벨과 일치해야 한다.
	3.	서술형: 외부 결제 API 호출을 고정 egress IP 로 집출하고 감사를 강화하려면 어떤 리소스를 어떻게 조합하나?
	•	모범요지: ServiceEntry 로 외부 도메인 등록 → VirtualService 로 Egress Gateway 경유 라우팅 → Egress GW에 고정 퍼블릭 IP/NAT 부여 및 AuthorizationPolicy/Telemetry 적용.

⸻

## ExpressRoute(전용선) 가용성 선택 치트시트 — 오픈북용

### TL;DR
- **거점(도시) 장애까지** 버티려면 → **ExpressRoute Metro** *(또는 서로 다른 Peering Location 2개)*
- **다른 지오/해외 리전 VNet** 연결 → **Premium Add-on**
- **On-Prem ↔ On-Prem** 을 Azure 백본으로 연결 → **Global Reach**
- **게이트웨이/존 이중화** → **ErGw3AZ(Zone-redundant) + Active-Active**
- **레이턴시/처리량 개선** → **FastPath 지원 GW**
- **회선 자체 암호화** → **ExpressRoute Direct + MACsec** *(또는)* **IPsec over ER**

### 요구조건 ➜ 제품/옵션 맵
| 요구조건/문제 | 선택 |
|---|---|
| 회선/포트/장비 이중화(기본) | **ER 회선 1개(이중 포트)** + **ErGw3AZ** + **Active-Active** |
| **Peering Location(거점) 장애 대비** | **ExpressRoute Metro** *또는* 서로 다른 Location에 **ER 회선 2개** |
| **타 지오(해외) 리전 VNet 연결** | **Premium Add-on** |
| **On-Prem ↔ On-Prem** 전용 경로 | **Global Reach** |
| 고성능/저지연 | **FastPath + 고급 GW SKU(ErGw3AZ/UltraPerformance)** |
| 회선 레벨 암호화 | **ExpressRoute Direct + MACsec** *또는* **IPsec over ER** |
| QoS/대역폭 보장 | **설계·계약 사안**(ER 자체 QoS 기능 없음) |

### 용어 빠른정리
- **ER Circuit**: 전용선 **논리 회선**(MSEE↔통신사). 기본 **이중 포트**.
- **Peering Location**: 사업자와 MS가 만나는 **물리 거점**(도시 단위).
- **ER Gateway**: VNet 종단. **ErGw3AZ(Zone-redundant)** 권장, **Active-Active** 가능.
- **Premium Add-on**: **타 지오 리전 연결/라우트 한계 확장**(가용성 기능 아님).
- **Global Reach**: **On-Prem ↔ On-Prem** 을 **Azure 백본**으로 연결.
- **ExpressRoute Metro**: 같은 메트로의 **서로 다른 Location 2곳**을 단일 논리 회선으로 묶어 **거점 이중화**.
- **FastPath**: 데이터 경로에서 **GW 우회**로 레이턴시/처리량 개선(지원 SKU 필요).
- **ExpressRoute Direct**: **10/100Gb 전용 포트**, **MACsec** 가능.

### 가용성 범위별 설계 패턴

#### 1) 기본 HA(장비/포트/존)
- 구성: **ER 회선 1개(이중 포트)** + **ErGw3AZ** + **Active-Active**
- 커버: 장비/포트 장애, GW 존 장애
- 미커버: **Peering Location 전체 장애**

#### 2) 거점(도시) 장애까지
- **ExpressRoute Metro** *(단일 논리 회선, Location 2곳)*
- 또는 **Location A/B에 ER 회선 2개** + 통신사 **이원화**

#### 3) 리전 DR/다지오
- 동일 지오(Central↔South): **Standard**
- **타 지오(해외 리전)**: **Premium Add-on**

#### 4) On-Prem ↔ On-Prem
- 양측 **ER 회선** 보유 + **Global Reach** 활성화

#### 5) 성능/암호화
- **FastPath + 고급 GW SKU** / **ExpressRoute Direct + MACsec**
- Direct 불가 시 → **IPsec over ER(VPN 병행)**

### 미니 플로우차트

```text
[거점 장애까지?] --예--> [ExpressRoute Metro] or [Dual Location 2회선]
       |
       아니오
       v
[기본 HA만?] --예--> [ER 1회선(이중포트) + ErGw3AZ + Active-Active]
       |
       v
[타 지오 VNet 필요?] --예--> [Premium Add-on]
       |
       v
[On-Prem 간도 연결?] --예--> [Global Reach]
       |
       v
[저지연/처리량↑?] --예--> [FastPath + 적절 GW SKU]
       |
       v
[회선 암호화 필요?] --예--> [Direct+MACsec] or [IPsec over ER]
```

### 체크리스트
	•	ErGw3AZ + Active-Active 사용
	•	Metro 또는 Dual Location으로 거점 이중화 설계
	•	Premium Add-on은 타 지오 연결 목적임을 명시
	•	Global Reach는 On-Prem↔On-Prem 용도임을 구분
	•	FastPath 지원 여부와 필요성 확인
	•	암호화는 Direct+MACsec 또는 IPsec over ER로 설계

### 자주 나오는 함정
	•	Premium = 가용성이라고 오해 ❌ → 가용성 아님, 다지오 연결/라우트 확장용
	•	거점 장애를 이중 포트로 해결 가능하다고 오해 ❌ → Metro 또는 Dual Location 필요
	•	QoS/대역폭 보장을 ER 기능으로 기대 ❌ → 통신사 계약/설계 사안
	•	FastPath 자동 적용 기대 ❌ → 지원 SKU/구성 필요


## Storage/DB 암호화 — 오픈북 치트시트 (GFM)

### 한눈에 개념 맵
- **저장소 at-rest**: **SSE**(기본 자동) → **PMK**(플랫폼 키) / **CMK**(고객 키·Key Vault) / *(일부 서비스)* **이중 암호화**
- **클라이언트 측 암호화(CSE)**: 앱/SDK가 업로드 전에 암/복호, **키 분실 시 복구 불가**
- **DBMS**
  - **TDE**: 데이터/로그/백업 **파일 전체** 암호화(컬럼 아님, 쿼리 동작 불변)
  - **Always Encrypted(컬럼)**: 특정 컬럼을 **클라이언트 드라이버**가 암/복호(서버는 평문 미보유)
  - **DDM**: **표시 마스킹**일 뿐 암호화 아님
- **전송구간**: TLS(HTTPS/SMB3/NFS-TLS/JDBC-TLS) 별도 고려
- **키 관리**: Key Vault(+Managed Identity/RBAC/회전), BYOK/MHSM(HSM)

### 저장소(Blob/Files/Disk) at-rest 암호화
#### SSE(Server-Side Encryption)
- **기본값**: 별도 설정 없어도 저장 시 자동 암호화.
- **키 종류**
  - **PMK**: Microsoft 관리 키(운영 간편, 비용 無).
  - **CMK**: **Key Vault**의 고객 키로 암호화(**규제/감사** 대응, **키 회전/폐기** 통제).
- **이중 암호화(Double Encryption)**: 일부 스토리지/지역/계층에서 제공(규제 대응용).

#### CSE(Client-Side Encryption)
- 앱/SDK가 **업로드 전에** 암호화하여 저장(서버는 **암호문만** 보관).
- **장점**: 제3자 노출 최소화. **단점**: 키 분실 시 **영구 복구 불가**, 앱 구현/성능 부담.

#### 자주 나오는 함정
- “**CMK** 쓰면 평문 접근 불가” → ❌ **RBAC/ACL 허용** 시 서비스가 **복호 후 평문 제공**.
- “사설망(Private Endpoint)이면 전송구간 암호화 불필요” → ❌ **TLS는 별도**로 유지.
- “Archive/Cold 계층은 암호화 예외” → ❌ **SSE는 모든 계층 적용**.

### DBMS 암호화(출제 빈도 높음: 컬럼 암호화 vs 마스킹 함정)
#### TDE(Transparent Data Encryption)
- **목적**: 파일·백업 **매체 탈취** 방어.
- **영향**: 쿼리/인덱스/LIKE/정렬/조인 **영향 없음**(컬럼 암호화 아님).

#### Always Encrypted(컬럼 암호화)
- **동작**: **클라이언트 드라이버**가 암/복호 → 서버/DBA는 **평문 미접근**.
- **키**: CMK(Key Vault 등) → CEK로 컬럼 암호화.
- **모드**
  - **Deterministic**: 동일 평문→동일 암호문 → **동등 비교/조인 가능**, **패턴 노출 위험**.
  - **Randomized**: 매번 다른 암호문 → **보안↑**, **검색/조인 불가**.
- **제약**: LIKE/범위/정렬/함수/인덱스에 제한. **Enclave**(SGX 등) 환경에서 일부 완화 가능.

#### DDM(Dynamic Data Masking)
- **표시 마스킹**(클라이언트/툴에서 **가려 보이게**). **저장은 평문**, 권한자는 **원문** 조회 가능 → **암호화 아님**.

#### 컬럼 암호화 개념 예시(T-SQL)
```sql
-- CMK/CEK 개념: CMK(Key Vault)로 CEK를 보호, 컬럼은 CEK로 암호화
CREATE TABLE Customer (
  Id   INT IDENTITY PRIMARY KEY,
  Name NVARCHAR(100) NOT NULL,
  SSN  NVARCHAR(13)
    ENCRYPTED WITH (
      COLUMN_ENCRYPTION_KEY = CEK1,
      ENCRYPTION_TYPE       = DETERMINISTIC,  -- 동등 비교/조인 허용
      ALGORITHM             = 'AEAD_AES_256_CBC_HMAC_SHA_256'
    ) NULL
);
```

### 전송구간(TLS)
- **Storage**: HTTPS(Blob/Files), SMB3 암호화, NFS-TLS(지원 환경).
- **DB**: JDBC/ODBC/TDS TLS. **Private Endpoint**/사설망이어도 TLS는 **권장**.

### 키 관리·감사·규정
- **Key Vault**: RBAC + **Managed Identity**, **키 회전 주기**/책임자 문서화.
- **BYOK/MHSM(HSM)**: 강한 규제 요건 시.
- **폐기 영향**: 키 폐기 = 데이터 **영구 접근 불가**(특히 **CSE/AE**). **Risk Acceptance** 기록.
- **감사**: 키 사용/회전/거부 이벤트를 **Monitor/Activity/Defender**로 수집.

### 시험 함정 체크리스트(빠른 정답 선택 가이드)
- [ ] “**TDE = 컬럼 암호화**” → ❌ (파일 암호화, 쿼리 영향 없음)
- [ ] “**DDM = 암호화**” → ❌ (표시 마스킹일 뿐)
- [ ] “**AE(Randomized)**인데 검색/조인 필요” → ❌ (불가)
- [ ] “**Storage CMK**면 평문 불가” → ❌ (서비스가 복호 제공 가능)
- [ ] “**CSE**는 키 없어도 복구 가능” → ❌ (불가)
- [ ] “사설망이면 **TLS 불필요**” → ❌ (여전히 필요/권장)

### 비교 표(요지)
| 항목 | TDE | Always Encrypted(컬럼) | DDM | Storage SSE(PMK/CMK) | CSE |
|---|---|---|---|---|---|
| 보호 단위 | 파일/백업 | **특정 컬럼** | 표시 | 저장 시 객체/디스크 | 객체(앱 암호화) |
| 서버 평문 접근 | 가능 | **불가** | 가능 | 가능 | 불가(앱만 키) |
| 앱 수정 | 불필요 | **드라이버/연결/코드 영향** | 불필요 | 불필요 | **필요** |
| 검색/조인 | 영향 없음 | 제한(Deterministic 권장) | 영향 없음 | 영향 없음 | 앱 처리 |
| 주 목적 | 미디어 탈취 방어 | 최소공개/규제 | 화면 보호 | 규제/키 소유권 | 제3자 노출 최소화 |

### 예상문제 3개
1) **객관식**  
민감 컬럼(예: 주민번호)을 서버/DBA가 평문으로 보지 못하게 하면서 **동등 비교** 검색이 필요하다. 가장 적절한 선택은?  
- A. **Always Encrypted(Deterministic) + Key Vault CMK + 드라이버 구성**  
- B. Always Encrypted(Randomized) + LIKE 검색  
- C. TDE + DDM  
- D. Storage CSE  
**정답:** A

2) **단답형**  
“DDM은 암호화가 아니다”를 한 줄로 설명하라.  
**정답 예시:** DDM은 **표시 마스킹**만 수행하고 저장 데이터는 **평문**이라 권한자는 원문을 볼 수 있다.

3) **서술형**  
AE(Randomized) 적용 후 검색/정렬/조인이 불가하다. **보안**과 **기능 요구**를 균형 있게 만족시키는 개선 2가지를 쓰고, 각 단점 1개씩 적어라.  
**모범요지:** (1) **Deterministic**로 전환 → 동등 비교/조인 가능, **패턴 노출 위험** 증가.  
(2) **분리 설계**(식별키=Deterministic, 고보호 필드=Randomized) → 기능 충족, **설계/운영 복잡도** 증가.


## Azure VNet Flow Logs — 두 가지 종류 비교(오픈북 치트시트)

### 한눈에 요약
- **종류는 두 가지**  
  1) **Virtual Network Flow Logs** *(권장, VNet 단위 수집)*  
  2) **NSG Flow Logs** *(레거시, NSG 단위 수집 — 은퇴 예정)*  
- **권장 사용**: 새 구축/표준화는 **Virtual Network Flow Logs**로 일원화. 동일 리소스에 **두 로그를 동시 활성화하면 중복 비용**이 발생할 수 있으므로 주의.
- **저장소**: Blob(StorageV2 권장) + 수명주기(Lifecycle)로 비용 최적화(Hot→Cool→Archive).

---

### 무엇이 다른가? (핵심 비교표)

| 항목 | **Virtual Network Flow Logs** | **NSG Flow Logs** |
|---|---|---|
| **스코프/활성 위치** | **VNet 단위**: 한 번에 VNet 전체 흐름 수집 | **NSG 단위**: Subnet/NIC에 연결된 **각 NSG별** 개별 설정 필요 |
| **정책 평가** | NSG 규칙 **+**(선택) 상위 보안 관리자 규칙(AVNM) 반영, VNet 암호화 상태 필드 제공 | **NSG 규칙만** 기준(서브넷/ NIC에 바인딩된 NSG의 Allow/Deny) |
| **커버리지** | VNet 경계 관점(게이트웨이/서비스 연계 커버 폭넓음) | AppGW v2 서브넷 등 일부 조합 제약 존재 |
| **운영 난이도** | **상위에서 일괄 관리**(리소스 누락·중복 낮음) | **여러 NSG에 반복 적용**(누락/중복 개연성 높음) |
| **지원 상태** | **현행/권장** | **레거시(은퇴 예정)** — 신규 도입 지양 |
| **포맷/주기** | L4 흐름, JSON, 일반적으로 **1분 단위** 롤업 | L4 흐름, JSON, 일반적으로 **1분 단위** 롤업 |

> 포인트: “어디서 켜느냐(스코프)”가 가장 큰 차이. **VNet Flow Logs**는 상위에서 **한 방**에, **NSG Flow Logs**는 바인딩된 **각 NSG마다**.

---

### 언제 무엇을 쓰나?
- **새 프로젝트/표준화 목표** → **Virtual Network Flow Logs** 단일화.  
- **기존에 NSG Flow Logs만 사용** → **VNet Flow Logs로 전환** 계획 수립 후, 대시보드/쿼리/알림 이식.  
- **게이트웨이/하이브리드 경로까지 가시화** → VNet Flow Logs가 일관되게 수집하기 용이.

---

### 설정 체크리스트
#### 공통
- 해당 리전에 **Network Watcher**가 **활성화**되어 있어야 함.
- **Blob Storage 계정** 준비(로그 전용 컨테이너 권장, 수명주기 규칙 필수).
- **Private Endpoint/방화벽**으로 사설화 + **CMK(Key Vault)** 필요 시 적용.
- **중복 수집 방지**: 동일 VNet/NSG 대상에 두 로그를 **동시에 켜지 않기**.

#### VNet Flow Logs 특이사항
- 저장소 계정은 **동일 테넌트/가급적 동일 리전**에 두고, 키/접속 변경 시 **재연결 확인**.
- Private Endpoint 흐름은 **소스 VM 측 관점**으로 로깅됨.

#### NSG Flow Logs 특이사항(레거시)
- Subnet/NIC에 연결된 **모든 NSG에 각각 활성화**해야 정확.
- AppGW/ER/VPN 서브넷 조합은 제약이 있을 수 있어 가이드 확인.

---

### 저장소/비용 운영
- **수명주기 규칙(예시)**: 30일 **Cool**, 180일 **Archive**, 730일 **삭제**.
- **소형 JSON 파일**이 다량 생성됨 → **Parquet로 컴팩션** + 파티션 디렉터리 체계화:  
  `service=vnet/region=kr-central/vnet=<name>/yyyy=2025/mm=08/dd=28/hh=10/`
- **감사/불변**: Immutable(시간기반 보존) / Legal Hold를 **로그 전용 컨테이너**에만 적용.

```json
{
  "rules": [{
    "name": "flowlogs-lifecycle",
    "enabled": true,
    "type": "Lifecycle",
    "definition": {
      "filters": { "blobTypes": ["blockBlob"], "prefixMatch": ["flowlogs/"] },
      "actions": {
        "baseBlob": {
          "tierToCool":    { "daysAfterModificationGreaterThan": 30 },
          "tierToArchive": { "daysAfterModificationGreaterThan": 180 },
          "delete":        { "daysAfterModificationGreaterThan": 730 }
        }
      }
    }
  }]
}
```

---

### 분석/연계
- **Traffic Analytics**(Azure Monitor)로 Top talkers/허용·거부 트렌드/지리/포트 분석.  
- **ADX(Kusto)** 외부 테이블 연결 → **KQL**로 대용량 조회.  
- **SIEM**(Sentinel/Splunk 등)으로 실시간 상관 분석.

---

### IaC 예시
#### Bicep — VNet Flow Logs(개념 예시)
```bicep
param location string = resourceGroup().location
param vnetId string
param storageId string

resource nw 'Microsoft.Network/networkWatchers@2023-09-01' existing = {
  name: 'NetworkWatcher_${location}'
  location: location
}

resource fl 'Microsoft.Network/networkWatchers/flowLogs@2023-09-01' = {
  name: '${nw.name}/vnet-flowlogs'
  properties: {
    targetResourceId: vnetId         // ← VNet 리소스 ID
    enabled: true
    storageId: storageId
    format: {
      type: 'JSON'
      version: 2
    }
    flowAnalyticsConfiguration: {
      networkWatcherFlowAnalyticsConfiguration: {
        enabled: true // Traffic Analytics 사용 시
        workspaceResourceId: '<LogAnalytics-Resource-ID>'
        trafficAnalyticsInterval: 60
      }
    }
  }
}
```

#### (참고) NSG Flow Logs — 레거시
```bicep
param nsgId string
param storageId string

resource flNsg 'Microsoft.Network/networkWatchers/flowLogs@2023-09-01' = {
  name: 'NetworkWatcher_${location}/nsg-flowlogs'
  properties: {
    targetResourceId: nsgId          // ← NSG 리소스 ID
    enabled: true
    storageId: storageId
    format: { type: 'JSON'; version: 2 }
  }
}
```

---

### 운영 관제 체크리스트
- [ ] 수집 실패/지연 알림: 진단 설정/활동 로그 경보
- [ ] 저장 용량/비용 대시보드: Blob Inventory, Cost Management
- [ ] 수명주기/불변/삭제 이벤트 **감사** 적재
- [ ] 중복 수집 여부 상시 점검(VNet vs NSG)

---

### 예상문제 3개
1) **객관식**  
VNet 전체 흐름을 한 번에 수집하고, NSG별 개별 설정을 줄이려면 어떤 방식을 택해야 하는가?  
- A. NSG Flow Logs  
- **B. Virtual Network Flow Logs**  
- C. 둘 다  
- D. Flow Logs 비활성화 후 Traffic Analytics만  
**정답: B**

2) **단답형**  
동일 자원에 VNet Flow Logs와 NSG Flow Logs를 동시에 켜면 주로 어떤 문제가 생기는가?  
**정답 예시:** **중복 기록으로 비용 증가** 및 분석 중복/혼선.

3) **서술형**  
하이브리드(ER/VPN)와 Private Endpoint가 혼재된 대규모 허브-스포크 네트워크에서 흐름 가시성과 비용 최적화를 동시에 달성하려면 어떤 설계가 적절한가?  
**모범요지:** 허브/스포크 **각 VNet에 Virtual Network Flow Logs**를 표준으로 적용하고, **NSG Flow Logs는 비활성화**. Blob Lifecycle로 티어링, Event Grid→Functions로 **JSON→Parquet 컴팩션**, ADX KQL로 분석, Traffic Analytics로 요약 지표 시각화. Private Endpoint 트래픽은 **소스 VM 기준** 로깅임을 감안해 필터/태깅을 일관화.

## AKS 접근제어(Entra ID 중심) — 인증/인가 3경로 치트시트 (GFM)

### 한눈에 요약
- **사람(개발/운영자)**: **Microsoft Entra ID(OIDC)** + `kubelogin`으로 **인증**, 권한은 **Kubernetes RBAC** *또는* **Azure RBAC for Kubernetes**로 **인가** ← **권장**
- **브레이크글래스**: **로컬 관리자 kubeconfig(클러스터-admin)**. 가급적 **비활성화/보관**하고 **필요 시에만 사용**.
- **자동화/봇/CI**: **Kubernetes ServiceAccount**(짧은 수명 토큰, 최소권한). *참고*: **Workload Identity**는 **Azure 리소스 접근**용이며 **K8s API 인증 대체가 아님**.

---

### 경로 1 — Entra ID 기반 사용자 접근(권장)

#### 인증(로그인 흐름)
- 사용자는 `kubectl` 호출 시 **OIDC**(Entra ID)로 로그인.
- kubeconfig는 **exec 플러그인**(`kubelogin`)을 통해 토큰을 받아 API Server에 제시.
- 로그인 방법: 브라우저/디바이스 코드/CLI 토큰(`--login azurecli`) 등.

```bash
# 필수 도구
az extension add -n aks-preview     # 필요 시
az aks install-cli                  # kubelogin 설치(환경에 따라)
# kubeconfig 병합
az aks get-credentials -g <rg> -n <cluster> --overwrite-existing
# (조직 정책에 따라) 로컬 계정 비활성화 상태 권장
```

#### 인가(권한 부여) — 두 가지 모드
- **모드 A: Kubernetes RBAC**
  - Entra **사용자/그룹(Object ID)** 를 **(Cluster)RoleBinding**에 매핑.  
  - 세분화/네임스페이스 단위 설계 용이.  
  - **예)** `ClusterRole=admin`을 `Group=aks-platform-admins`에 바인딩.
- **모드 B: Azure RBAC for Kubernetes**
  - Azure의 **빌트인 역할**(예: *Azure Kubernetes Service RBAC Viewer/Writer/Admin*)을 **Azure Role Assignment**로 부여.  
  - 중앙집중 거버넌스(Entra+Azure RBAC) 및 PIM/감사 연계에 유리.  
  - 세밀 정책은 K8s RBAC보다 제한적일 수 있어 **혼합 설계** 고려.

> 실무 팁: **사람 = Entra ID + (Azure RBAC for K8s 또는 K8s RBAC)**, **토큰 수명·MFA·조건부 액세스**는 Entra 정책으로 통제.

---

### 경로 2 — 로컬 관리자 kubeconfig(브레이크글래스)

#### 개요
- `az aks get-credentials --admin` 으로 받는 **클러스터-admin 인증서** 기반 kubeconfig.
- **목적**: **Entra 장애/비상조치** 등 **브레이크글래스**.
- **권장**: 기본 **비활성화(`--disable-local-accounts`)**, 오프라인 금고에 저장, **접근기록/경보**.

#### 운영 수칙
- 사용 후 **즉시 회수/폐기**, **API Server Authorized IP Ranges**로 접근원 IP 제한.
- **Private Cluster** + Bastion/프록시 경유.
- **Cert/자격 증명 로테이션** 표준 운영 절차 수립.

---

### 경로 3 — ServiceAccount(자동화/봇/CI)

#### 개요
- K8s **ServiceAccount(SA)** + **Role/RoleBinding**으로 **최소권한 부여**.
- **Bound SA Token**(짧은 수명 OIDC JWT) 사용(시크릿 장기 토큰 지양).
- GitHub Actions/GitLab CI 등에서 K8s 배포 시 **SA 토큰만으로 kubectl** 수행 가능.

```yaml
# 예시: 네임스페이스 단위 read-only SA
apiVersion: v1
kind: ServiceAccount
metadata:
  name: deploy-bot
  namespace: web
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: ro
  namespace: web
rules:
- apiGroups: [""]
  resources: ["pods","services","configmaps"]
  verbs: ["get","list","watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: ro-bind
  namespace: web
subjects:
- kind: ServiceAccount
  name: deploy-bot
  namespace: web
roleRef:
  kind: Role
  name: ro
  apiGroup: rbac.authorization.k8s.io
```

> 주의: **Workload Identity(Entra OIDC 연동)** 는 **Pod→Azure 리소스** 자격 증명(예: Key Vault/Storage)에 쓰이며, **K8s API 권한**은 **여전히 SA+RBAC**로 별도 관리.

---

### 네트워크/접근 경계 보강(사람·봇 공통)
- **API Server Authorized IP Ranges**: 허용 소스 IP만 접근 가능.
- **Private Cluster**: API 서버 **사설 IP화**, 운영망에서만 접근.
- **네트워크 보안**: 방화벽/프록시/NAT 경유, 이그레스 고정 IP(감사/정책).
- **감사·모니터링**: Audit Log(Cluster), Azure Monitor(Container Insights), Defender for Cloud 경보.

---

### 운영 체크리스트
- [ ] **Entra ID 통합 활성화**(OIDC), `kubelogin` 표준 도구화.
- [ ] **모드 선택**: *K8s RBAC* vs *Azure RBAC for K8s*(또는 혼합) 문서화.
- [ ] **로컬 계정 비활성화** + 브레이크글래스 보관/경보.
- [ ] **SA 최소권한** + **짧은 수명 토큰**, 네임스페이스 분리.
- [ ] **API Server IP 제한** / **Private Cluster** / **감사 로그**.
- [ ] **PIM/조건부 액세스/MFA**로 사람 접근 강화.

---

### 자주 나오는 함정
- “**Service Principal**로 사람 접근” → ❌ (인간 사용자엔 **Entra 사용자/그룹** 사용, SP는 앱/자동화)
- “**Workload Identity**면 K8s RBAC 불필요” → ❌ (Azure 리소스용, **K8s API 권한은 별도**)
- “로컬 admin kubeconfig 항상 사용” → ❌ (**브레이크글래스 전용**)
- “Azure RBAC for K8s = K8s RBAC 완전 대체” → ❌ (범위/세분화 차이, 필요 시 **혼합**)

---

### 예상문제 3개

1) **객관식**  
AKS에서 **사람 사용자**의 표준 접근 방식으로 가장 적절한 것은?  
- A. ServiceAccount 토큰으로 로그인  
- **B. Entra ID(OIDC) + `kubelogin` 인증, 권한은 (Azure RBAC for K8s 또는 K8s RBAC)**  
- C. 항상 `--admin` kubeconfig 사용  
- D. Workload Identity로 K8s API 호출  
**정답:** B

2) **단답형**  
브레이크글래스용 **로컬 관리자 kubeconfig**를 평시 차단하려면 어떤 클러스터 옵션을 켜야 하나?  
**정답 예시:** `--disable-local-accounts`(로컬 계정 비활성화).

3) **서술형**  
조직이 **Entra 기반 SSO·MFA·PIM**을 요구한다. AKS에서 **사람 접근**, **자동화 접근**, **네트워크 경계**를 포함한 표준 접근 제어 설계를 제시하라.  
**모범요지:** 사람은 Entra OIDC + `kubelogin`, 인가는 Azure RBAC for K8s 또는 K8s RBAC(그룹 매핑). 로컬 admin 계정 비활성화, 브레이크글래스 금고 보관. 자동화는 SA 최소권한 + 짧은 수명 토큰(네임스페이스 분리). API Server Authorized IP Ranges/Private Cluster 적용, 감사·경보 구성(Defender/Monitor).



## AKS 무중단 롤링/스케일-인 성능 가이드 — 시스템/유저 노드풀 & 프로브/종료 설정 (GFM)

### 한눈에 요약
- **노드풀 분리**: *System* 노드풀은 **클러스터/인프라 애드온 전용**, *User* 노드풀은 **비즈니스 워크로드 전용**으로 **taint/toleration**로 구분.  
- **5xx 방지의 2축**  
  1) **기동 시**: `startupProbe`→`readinessProbe`(준비 완료 전 노출 금지), `minReadySeconds`, 롤링업데이트 **`maxUnavailable: 0`**.  
  2) **종료/스케일-인 시**: `preStop` 훅 + **충분한 `terminationGracePeriodSeconds`** + **PDB**로 **드레인→연결정리→엔드포인트 제거** 순서 보장.  
- **오토스케일**: HPA(파드) ↔ Cluster Autoscaler(노드풀) **동작 순서·지연 파라미터**와 **PDB**의 상호작용을 이해.

---

### 시스템/유저 노드풀 설계(성능·안정성 기본)
- **System 노드풀**  
  - 목적: kube-system/모니터링/인그레스 등 **플랫폼 애드온**.  
  - **Taint(예: `CriticalAddonsOnly=true:NoSchedule`)** 유지 → 애드온에 **toleration** 부여.  
  - 스케일 변동 적게, **고가용(≥2~3 노드)**, 빠른 디스크(OS Ephemeral 선호), 고성능 VM.
- **User 노드풀**  
  - 목적: **앱 워크로드**. 오토스케일 허용, 워크로드 레이블/taint로 **클래스(웹, 배치, ML)** 분리.  
  - **Cluster Autoscaler 활성화**(예: `minCount/maxCount`).  
  - 장시간 I/O 앱은 **속성 맞는 VM SKU / 디스크** 분리(예: IOPS↑).

#### 스케줄링 가이드
- **PriorityClass**: platform(높음) ↔ app(표준) 계층.  
- **TopologySpreadConstraints/PodAntiAffinity**: 동일 노드/존 쏠림 방지 → 스케일-인 시 대량 5xx 완화.  
- **Requests/Limits** 준수(QoS 보장) + **`safe-to-evict` 주석**으로 데몬·사이드카 보호.

---

### (축 1) 컨테이너 **기동 시** 5xx 방지 — 탐침/롤링 파라미터
- **`startupProbe`**: 느린 초기화 서비스의 **초기 부팅 보호막**(성공 전 **Liveness/Readiness 비활성**).  
- **`readinessProbe`**: **정상 기동 완료 후에만** 엔드포인트 등록.  
- **`livenessProbe`**: **자기치유용**(다운 판별/재시작); *레디니스 대체 X*.  
- **배포 롤링 전략**:  
  - **`maxUnavailable: 0`** (기존 용량 보존) + **`maxSurge: 1+`** (여유분 먼저 기동)  
  - **`minReadySeconds`**(준비 후 N초 안정화), **`progressDeadlineSeconds`**(배포 실패 빠른 감지)

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web
spec:
  replicas: 6
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0       # 기동 중 용량 보존
      maxSurge: 2             # 여유 파드 먼저 올림
  minReadySeconds: 10          # 준비 후 10초 안정화
  progressDeadlineSeconds: 600
  selector: { matchLabels: { app: web } }
  template:
    metadata:
      labels: { app: web, tier: frontend }
    spec:
      # 유저 노드풀만 스케줄하도록 (예: taint: role=user:NoSchedule)
      tolerations:
      - key: "role"           # ← 유저풀 taint 예시
        operator: "Equal"
        value: "user"
        effect: "NoSchedule"
      containers:
      - name: app
        image: myrepo/web:1.2.3
        ports: [ { containerPort: 8080 } ]
        readinessProbe:
          httpGet: { path: /health/ready, port: 8080 }
          initialDelaySeconds: 5
          periodSeconds: 5
          timeoutSeconds: 2
          failureThreshold: 3
        livenessProbe:
          httpGet: { path: /health/live, port: 8080 }
          initialDelaySeconds: 30
          periodSeconds: 10
          timeoutSeconds: 2
          failureThreshold: 3
        startupProbe:
          httpGet: { path: /health/startup, port: 8080 }
          failureThreshold: 30   # 최대 30×3s=90s 대기(아래 periodSeconds와 곱)
          periodSeconds: 3
```

> **팁**: 레디니스는 **DB/캐시 연결 포함** “실사용 가능한 상태”를 의미해야 하며, **버전 전환 직후 캐시 워밍**이 필요하면 `minReadySeconds`로 급한 트래픽 유입을 지연.

---

### (축 2) **종료/스케일-인** 5xx 방지 — 드레인/종료 순서
**목표: “엔드포인트 제거 → 기존 연결 마무리 → 프로세스 종료”**  
- **`preStop`** 훅에서 **새 연결 수락 중단**(앱 자체 플래그/서버 종료) 후 **짧게 대기(예: 10~30s)**.  
- **`terminationGracePeriodSeconds`**는 **최대 처리시간 + 버퍼**(gRPC/WebSocket은 더 길게).  
- **레디니스 즉시 false** → 서비스 엔드포인트에서 **제거**(LB/Ingress 트래픽 차단).  
- **PDB(PodDisruptionBudget)**: **동시 축출 상한**(예: `maxUnavailable: 1`)으로 오토스케일/드레인 충돌 시 5xx 억제.  
- **Cluster Autoscaler**는 PDB/우선순위를 **존중**하므로, **PDB 없으면 대량 축출** 위험.

```yaml
# 파드 종료 시 단계: readiness false → preStop 처리 → grace 기간 내 종료
spec:
  terminationGracePeriodSeconds: 60
  containers:
  - name: app
    lifecycle:
      preStop:
        exec:
          command: ["/bin/sh", "-c", "curl -s localhost:8080/quit || true; sleep 15"]
    # 위 /quit: 앱이 새 요청 수락 중단(Drain 신호)하도록 구현

---
# 동시 축출 제한: 가용성 보장
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata: { name: web-pdb }
spec:
  selector: { matchLabels: { app: web } }
  maxUnavailable: 1
```

> **팁**: 인그레스/프록시 타임아웃(gRPC/WebSocket 포함) ≥ `terminationGracePeriodSeconds`로 **정렬**. 종료 중 **엔드포인트 제거 지연**이 없도록 레디니스 전환을 코드로 보장(예: `/quit`가 헬스체크 실패 상태로 전환).

---

### HPA × Cluster Autoscaler × 스케일-인 상호작용
- **HPA(파드 수)**가 먼저 줄어들고 → **노드 여유 발생** → **Cluster Autoscaler(노드 수)**가 **지연 후** 축소.  
- **지연 파라미터**(예시): *scaleDownDelayAfterAdd*, *scanInterval* 등(개념 이해).  
- **PDB**가 있으면 **허용치 이상 축출 불가** → 노드 축소 지연/보류 ⟶ 5xx 대신 안정성↑.  
- **장수 연결** 서비스는 **`preStop`+충분한 grace**와 **프록시 타임아웃 정렬**이 핵심.

---

### 서술형 모범 답안(요지 템플릿)
> **“AKS에서 5xx를 줄이려면, 노드풀을 System/User로 분리해 인프라와 앱 스케줄을 분리하고, 롤링·스케일-인 시 ‘기동 타이밍’과 ‘종료 타이밍’을 엄격히 제어해야 한다. 기동 시엔 `startupProbe`로 초기화를 보호하고 `readinessProbe`가 성공하기 전에는 절대 엔드포인트에 노출하지 않는다. 배포는 `maxUnavailable: 0`과 `minReadySeconds`로 안정화 시간을 보장한다. 종료/스케일-인 시엔 `preStop`에서 수락 중단 신호를 보내고 `terminationGracePeriodSeconds`를 충분히 부여하여 기존 연결을 정상 완료시킨다. 동시에 PDB로 동시 축출을 제한해 Cluster Autoscaler와의 충돌을 방지한다. TopologySpread/Anti-Affinity로 쏠림을 방지하고, Requests/Limits·PriorityClass로 핵심 워크로드를 보호한다. 이 조합으로 엔드포인트 연결 타이밍을 통제해 롤링/스케일-인 전 구간에서 5xx를 예방한다.”**

---

### 체크리스트
- [ ] System/User 노드풀 **분리**, taint/toleration 적용  
- [ ] `startupProbe`/`readinessProbe`/`livenessProbe` **역할 구분**  
- [ ] Deployment: **`maxUnavailable: 0`**, 적절한 **`maxSurge`**, **`minReadySeconds`**  
- [ ] **`preStop`** 구현(+ 앱 수락중단 엔드포인트) & **충분한 `terminationGracePeriodSeconds`**  
- [ ] **PDB**로 동시 축출 제한, **TopologySpread/Anti-Affinity**  
- [ ] HPA/Cluster Autoscaler **동작 순서 이해**(지연 파라미터, PDB 영향)  
- [ ] 인그레스/프록시 **타임아웃과 정렬**(gRPC/WebSocket 포함)

---

### 예상문제 3개
1) **서술형**  
롤링 업데이트 및 스케일-인 상황에서 5xx를 최소화하기 위한 **탐침·배포 전략·종료 시퀀스**를 설명하라.  
**모범요지:** 위 “서술형 모범 답안” 참조(기동 타이밍: startup→readiness, 롤링: maxUnavailable 0/minReadySeconds, 종료: preStop+grace, PDB/토폴로지/오토스케일 상호작용).

2) **단답형**  
느린 초기화 앱에서 레디니스/라이브니스가 조기 실패하는 문제를 막기 위해 추가해야 하는 프로브는?  
**정답:** `startupProbe`.

3) **객관식**  
스케일-인 시 파드 동시 축출로 5xx가 발생한다. **가장 직접적인** 완화책은?  
- A. `livenessProbe` 간격을 늘린다  
- **B. `PodDisruptionBudget`으로 `maxUnavailable`을 낮춘다**  
- C. `maxSurge`를 0으로 한다  
- D. `terminationGracePeriodSeconds`를 5로 줄인다  
**정답:** B


## Azure Service Bus — 치트시트 (GFM)

### 핵심 개념 맵
	•	Queue: 1:1(점대점) 비동기 큐. 소비자 수를 늘려 경합(Competing Consumers) 패턴으로 처리량 확장.
	•	Topic / Subscription: 1:다 퍼블리시-서브스크라이브. Subscription마다 필터(SQL/Correlation) 로 메시지 선택·분기.
	•	Delivery 모드:
	•	Peek-Lock(권장): 메시지를 잠그고 처리 후 Complete()로 확정. 실패 시 Abandon/Dead-letter.
	•	Receive-and-Delete: 수신 즉시 삭제(손실 위험).
	•	Exactly-once에 가까운 처리: 본질은 at-least-once. 중복감지(Duplicate Detection) + 트랜잭션 + 멱등성으로 실무 달성.
	•	Session(FIFO/그룹화): SessionId 동일 메시지는 순서 보장 + 단일 소비자로 처리. 상태(Session State) 저장 가능.
	•	Dead-letter Queue(DLQ): MaxDeliveryCount 초과/필터 불일치/TTL 만료 등 격리 보관. DLQ는 각 큐/서브스크립션에 종속.
	•	고급 기능: 스케줄링(예약 발송), Deferral(처리 지연/보류), 메시지 Defer/Defered retrieval, 지연 재시도.

### SKU·성능·네트워킹 요약
	•	Standard: 대부분 기능(토픽/세션/중복감지/스케줄링/트랜잭션) 제공, 공유 인프라.
	•	Premium: 전용 리소스 격리(Messaging Unit), 예측 가능 성능·지연, 가용성 옵션 강화(예: 존 배치), 대규모 연결·고부하에 적합.
	•	네트워킹: Private Endpoint/Private Link로 사설화, Firewall 규칙/IP 필터로 공용 접근 제어.
	•	지역 복구: Geo-DR(alias) 로 네임스페이스 페어링/페일오버(메타데이터 수준). 데이터 복제는 애플리케이션 설계(양방향 복제/재발행) 가 필요.

### 핵심 운영 파라미터
	•	LockDuration: 5~300초. 긴 처리라면 자동 잠금 갱신(Auto-renew) 사용.
	•	Message TTL: 만료 시 DLQ 이동(옵션에 따라).
	•	MaxDeliveryCount: 재시도 횟수. 초과 시 DLQ.
	•	DuplicateDetectionHistoryTimeWindow: 중복감지 기억 창(예: 10분). MessageId 가 반드시 고유해야 작동.
	•	PrefetchCount: 성능 향상(왕복 감소). 단, 과도 프리페치 + 긴 처리는 잠금 만료 위험.

### 필터링(토픽/서브스크립션)
	•	CorrelationFilter: CorrelationId, MessageId, Subject(Label), 사용자 속성 등 정확 일치.
	•	SQLFilter: 사용자 속성에 대한 SQL 표현식(예: priority > 5 AND region = 'KR').
	•	Rule Action: 메시지에 헤더/속성 추가·변경.

### 트랜잭션·중복·순서 보장
	•	중복감지: 네임스페이스/엔터티에서 활성화 + MessageId 지정 ⇒ 창 내 중복 투입 자동 폐기.
	•	트랜잭션: 동일 네임스페이스 내 다중 작업(완료+보내기 등) 을 한 단위로 커밋/롤백.
	•	순서(FIFO): SessionId 기반으로 세션 처리기를 사용(세션 단일 소비자). 순서+중복을 함께 요구하면 세션 + 중복감지 병행.

### 재시도·에러 처리 패턴
	•	지수 백오프(Jitter 포함)로 일시 오류 흡수.
	•	DLQ 운영: 원인 태그(사유/컬렉션) 기록 → KQL/워크플로우로 triage → 필요 시 재게시(리드라이브).
	•	Poison 메시지: 재현·패치 후 수동/자동 리드라이브.
	•	Idempotency: 업무 키를 MessageId로 매핑, 처리 로그/아웃박스로 중복 커밋 방지.

### 운영·스루풋 팁
	•	Processor 기반 소비자(Auto-complete 끄고 수동 Complete()): 예측 가능한 처리.
	•	MaxConcurrentCalls / MaxConcurrentSessions: 워커 동시성 제어(세션 사용 시 세션 단위).
	•	큰 메시지: 256KB(Std)/1MB(Prem) 근방이면 청크/Blob 오프로드 고려.
	•	메트릭 관찰: Incoming/Outgoing Messages, Active/Dead-lettered, Server Errors, Throttled Requests, Connections, CPU/MU(Premium).

### 코드 스니펫(예: .NET, 세션 + 중복감지 + 수동 완료)

```javascript
var client = new ServiceBusClient(connStr);
var processor = client.CreateSessionProcessor(
    "orders", new ServiceBusSessionProcessorOptions {
        AutoCompleteMessages = false,
        MaxConcurrentSessions = 8,
        MaxConcurrentCallsPerSession = 1,   // 세션 내 순서 보장
        PrefetchCount = 100
    });

processor.ProcessMessageAsync += async args => {
    try {
        // 멱등성: MessageId 로 중복 처리 방지 (예: Redis/DB 체크)
        var msg = args.Message;
        // 비즈니스 처리 ...
        await args.CompleteMessageAsync(msg);   // 성공 시 확정
    } catch (TransientException) {
        await args.AbandonMessageAsync(args.Message); // 재시도 대상
    } catch (Exception ex) {
        await args.DeadLetterMessageAsync(args.Message, "ProcessingFailed", ex.Message);
    }
};
processor.ProcessErrorAsync += err => {
    Console.WriteLine(err.Exception);
    return Task.CompletedTask;
};
await processor.StartProcessingAsync();
```

### 자주 나오는 함정
	•	레디스/DB와의 분산 트랜잭션 기대 ❌ → 동일 네임스페이스 내 버스 작업만 트랜잭션. 외부 저장소는 Outbox/InBox 패턴.
	•	중복감지 ON인데 MessageId 미설정 → 효과 없음.
	•	세션 사용 중 동시성 2↑ → 순서 깨짐.
	•	프리페치↑ + 처리 지연 → 락 만료로 이중 소비. 자동 Lock 갱신 또는 프리페치 튜닝.
	•	Geo-DR이 데이터 동기화로 오해 → 메타데이터 페일오버일 뿐, 메시지 복제 아님.

### 선택 가이드(비교)
	•	Service Bus vs Storage Queue
	•	Service Bus: 세션/FIFO, 트랜잭션, 중복감지, 필터링, 스케줄링 필요할 때.
	•	Storage Queue: 초저가·단순 대량 쌓기/폴링, 기능 요구가 낮을 때.
	•	Service Bus vs Event Hubs
	•	Service Bus: 명령/워크플로우, 업무 트랜잭션.
	•	Event Hubs: 텔레메트리/스트리밍(초당 수십만 이벤트, 소비자별 오프셋).

### 체크리스트
	•	큐/토픽에 중복감지(윈도)와 TTL/MaxDelivery/DLQ 정책 명시
	•	세션/순서 필요 여부 판단 → SessionProcessor 채택
	•	지수 백오프 + DLQ 운영 설계(리드라이브 절차 포함)
	•	Private Endpoint/Firewall로 네트워크 경계 확정
	•	멀티 엔티티 트랜잭션(가능 범위)과 멱등 처리 결합
	•	대형 페이로드는 외부 저장소 + 포인터 패턴

예상문제 3개
	1.	객관식
주문ID별로 순서 보장과 단일 소비자 처리가 필요하다. 가장 적절한 구성은?

	•	A. 토픽 + SQL 필터
	•	B. 큐(또는 토픽 서브스크립션) + SessionId=주문ID + Session Processor
	•	C. 큐 + Prefetch=0
	•	D. 토픽 + 여러 구독
정답: B

	2.	단답형
중복감지를 활용하려면 엔티티 설정 외에 메시지에 어떤 필드를 반드시 지정해야 하는가?
정답: MessageId(업무 키로 고유 값 설정).
	3.	서술형
Service Bus로 at-least-once 환경에서 멱등 처리와 DLQ 운영을 결합해 “사실상 정확히 한 번”을 달성하는 방법을 설명하라.
모범요지: MessageId를 업무 키로 고정 + 중복감지 윈도 활성화, 소비자는 Outbox/InBox/처리로그로 멱등성 확보, 지수 백오프 재시도 적용. MaxDeliveryCount 초과 시 DLQ로 격리해 원인 분석 후 리드라이브(재게시). 세션/FIFO가 필요하면 SessionId 병행. 네트워크는 Private Endpoint로 사설화.


## Azure Front Door Premium — 글로벌 엣지 + 사설 오리진(Private Link) + WAF 치트시트 (GFM)

### TL;DR
	•	문제: 인터넷에 노출하지 않고(Private) 전 세계로 빠르게 배포 + L7 보안 필요
	•	해결: AFD Premium + Origin Private Link + WAF Policy
	•	핵심: 엣지(Front Door)만 Public, 오리진은 VNet 내부 IP(Private Endpoint) 로 잠그고, AFD가 승인된 Private Link 로만 진입

⸻

### 구성요소 한눈에
	•	Front Door(Std/Prem): 글로벌 L7 리버스 프록시/엣지, 라우팅·압축·캐시·장애극복(오리진 그룹)
	•	WAF Policy: OWASP 규칙 + 사용자 정의(Geo, IP, Rate Limit 등), 라우트별/도메인별 연동
	•	Origin Group: 백엔드 풀(Region 다중화), 헬스 프로브/부하분산 정책
	•	Origin Private Link(Prem): AFD ↔ 오리진 사설 연결(오리진 Public 차단)
	•	도메인/인증서: 커스텀 도메인(CNAME/ALIAS) + Managed/Bring-your-own TLS
	•	Rules Engine: 리다이렉트/리라이트/헤더 삽입/캐시 제어/경로 기반 라우팅

⸻

### 표 — 언제 Premium + Private Link?

요구	선택
오리진 Public 완전 차단	Premium + Origin Private Link
단순 전역 배포(오리진 Public 허용)	Standard/Premium(PL 불필요)
L7 보안(WAF, Rate Limit)	Standard/Premium + WAF
멀티-Region 액티브/액티브	Origin Group + 프로빙/우선순위
정적 캐시 가속	Rules Engine + 캐시 정책


⸻

### 아키텍처(사설 오리진: Private Link)
	1.	오리진(웹앱/VM/AppGW/Storage) 를 VNet Private Endpoint 로 구성(공용 접근 차단).
	2.	AFD Premium 생성 → Origin Group 추가 → Origin에 “Private Link” 사용 체크.
	3.	오리진 리소스에서 “AFD Private Link 연결 승인”(Pending 승인 흐름).
	4.	WAF Policy 작성(관리형 규칙 + Geo/IP/Rate 제한) → Front Door에 연결(Association).
	5.	Routes: example.com → /api/*는 App1, /static/*은 Storage 등 경로/도메인 기반 분기.
	6.	DNS: www.example.com을 Front Door 엔드포인트로 CNAME/ALIAS, AFD에서 TLS 인증서 바인딩.

방화벽/NSG: 오리진 네트워크는 해당 Private Endpoint NIC(및 AFD가 설정한 링크)만 허용. 불필요한 Public Inbound 전면 차단.

⸻

### 헬스 프로브/부하분산 베스트 프랙티스
	•	프로브 경로 전용(/healthz) + 200 OK 명확화
	•	오리진별 호스트 헤더 일치(가상호스팅)
	•	우선순위+가중치로 액티브/스탠바이 또는 액티브/액티브
	•	세션 부하편중 필요 시: Session Affinity(cookie) 사용(필요할 때만)

⸻

### Rules Engine(자주 쓰는 규칙)
	•	HTTP→HTTPS 리다이렉트
	•	경로 기반 라우팅/리라이트: /app/* → /index.html SPA
	•	캐시 Key 튜닝: 헤더/쿼리 선택 포함/제외
	•	보안 헤더 추가: HSTS, X-Content-Type-Options, CSP 등

IF: Request scheme == HTTP
THEN: Redirect to HTTPS (301)

IF: Path begins_with "/static/"
THEN: Route to Storage-origin, Cache-control: public, max-age=86400


⸻

보안(Zero Trust) 체크리스트
	•	오리진 Public 비활성 + Private Endpoint 강제
	•	AFD Premium Origin Private Link로만 진입(연결 승인 필수)
	•	WAF Policy(관리형 + 사용자 규칙/Rate Limit)
	•	TLS 최신 정책, HSTS 적용
	•	도메인 소유 검증 + Managed cert 자동 갱신
	•	로그/메트릭(Access, WAF, 프록시 로그) → Log Analytics/SIEM

⸻

운영 팁
	•	전환 절차: 새 AFD 라우트 준비 → 저 TTL로 DNS 스위치 → 모니터링 후 TTL 복구
	•	오리진 장애 시 응답: 커스텀 에러 페이지/Failover 정책 세팅
	•	비용: 요청 수, 아웃바운드, 룰 평가, WAF 평가에 비례 → 캐시/압축/경로 분리로 최적화
	•	관측: 상태 코드 분포, WAF 매칭, 오리진 응답시간/실패율, 캐시 적중률

⸻

자주 나오는 함정
	•	Private Link 승인 누락 → 오리진 Unreachable
	•	오리진 Host 헤더 불일치 → 4xx/5xx
	•	WAF 정책 연결 위치(전역 vs 라우트별) 혼동 → 의도치 않은 차단/통과
	•	캐시 키에 불필요한 쿼리/헤더 포함 → 캐시 적중률 급락
	•	DNS Apex 루트를 CNAME 못함 → ALIAS/ANAME 또는 프록시 DNS 기능 사용

⸻

미니 절차(체크리스트)
	1.	오리진 Private Endpoint 만들고 Public 접근 Off
	2.	AFD Premium → Origin Group → Origin(Private Link) 추가
	3.	오리진 리소스에서 Private Link “승인”
	4.	WAF Policy 작성/연결, Rules Engine 구성
	5.	커스텀 도메인 + TLS 바인딩
	6.	헬스 프로브/우선순위/가중치 튜닝
	7.	로그/경보 배선 후 릴리즈

⸻

예상문제 3개
	1.	객관식
오리진을 인터넷에 노출하지 않고 전 세계에 서비스하려면 가장 적절한 조합은?

	•	A. Standard Front Door + Service Endpoint
	•	B. Premium Front Door + Origin Private Link + WAF Policy
	•	C. Application Gateway + Public IP
	•	D. CDN(3rd party) + NSG
정답: B

	2.	단답형
AFD Premium에서 Private한 오리진으로만 트래픽을 유도하려면 오리진에 무엇을 활성화하고 어떤 절차가 필요한가?
정답: Origin Private Link 활성화 후, 오리진 리소스 측 Private Link 연결 “승인”.
	3.	서술형
/static/* 정적 파일은 캐시로, /api/* 는 동적 백엔드(사설 오리진)로 라우팅하면서 L7 보안을 적용하라.
모범요지: AFD Premium 구성 → Origin Group(Static=Storage, API=App) + API 오리진은 Private Link. Routes로 경로 분기, Rules Engine으로 /static/* 캐시/압축, /→https 리다이렉트. WAF Policy(관리형 규칙 + Rate Limit) 연결. 커스텀 도메인/TLS, 헬스 프로브와 우선순위 설정, 로그/경보 배선.