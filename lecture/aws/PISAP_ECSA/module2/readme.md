
# ECSA

## GWLB(GateWay Load Balancer)

NAT처리가 아닌 Geneve Header를 이용해 Header 추가만으로 Source, Target IP의 변환 없이 처리  
타겟 WAF, FW도 Geneve 프로토콜을 지원해야 사용 가능

## Network Firewall

정책 운영이 어렵다, suricata 기반이라..

Drop All: 모든 TCP 패킷이 차단되기 때문에 어떤 상태 기반 규칙 그룹과도 일치하지 않는 경우 Drop이지만, return이 가지 못하기 때문에 전부 차단된다고 보면 된다.

Drop Established: 어떤 상태 기반 규칙 그룹과도 일치하지 않는 경우 TCP 세션 수립 후라면 Drop(3 hand handshake 패킷만 통과)

Alert All: 어떤 상태 기반 규칙 그룹과도 일치하지 않는경우 로그 기록하고 Paas(도메인 정보가 남지 않는다.)

Alert Established: 어떤 상태 기반 규칙 그룹과도 일치하지 않는 경우라면 로그 기록하고 Pass(허용된 로그는 안남음)

SIEM 환경에서 Network Firewall에서 막힌 트래픽이 안 찍힌 이유는 Alert에 대한 로그와, Network Firewall 로그를 켜 놓지 않아서였는데, 기본적으로 Network Firewall의 로그 정책이 Pass만 되어있는 경우 Network Firewall 정책에 찍히지 않으므로, Pass, Alert를 번갈아가면서 설정해놔야 로그가 찍히게 된다.

DNS 서버에 갔다가 IP를 들고온 후 IP를 가지고 uri를 헤더에 넣고 가져가는 경우에는 나갈 수도 있다

Check Ride

1. 객관식 시험
   1. 원래는 객관식 + 주관식으로 구성되어 있으나 주관식에서 철자, 스페이스 때문에 틀리는 경우가 있어서 객관식만으로 만들려고 준비중
2. 구현
   1. drawio로 아키텍쳐 그린 후 목요일 저녁까지 제출
   2. 그린 아키텍쳐를 목요일까지 구현
   3. 수강생끼리 토의하거나 서로 참고해도 되나, 본인이 그린 아키텍쳐에 대한 설명은 가능해야 함
   4. 마지막날은 개인 아키텍쳐에 대한 발표할 수도 있음(보통 오후 4시 언저리에서 끝났음)

## Landing zone

landing zone: 사전 구성된 안전한 AWS 환경

AWS Landing Zone Solution: 위의 컨셉을 구현, Control Tower의 등장으로 2020년 이후로 업데이트 중지

AWS Control Tower: AWS Landing Zone의 AWS Managed Service 버전

### Multi Account 전략

## AWS Organization

계정 생성, 자원 생성 등

- Management Account
  - Security OU
    - Security Tooling
    - Log Archive
  - Infrastructure OU
    - Networking
    - Operations Tooling
    - Shared Services

OU는 2level로 두는 것을 권장한다.

### Service Catalog

Service Catalog: 새로 만들어지는 계정에 대한 기본 서비스 셋(Stack Set을 이용)

템플릿을 재사용 가능(여러 팀에서 동일한 서비스를 요구할 때 등)

### Account

Core, Additional Account 두 가지 종류가 존재

- Core(Management)
  - Control Tower 구성 및 운영 관리
  - OU 관리
  - SCP 관리
  - 통합 빌링 정보 확인
  - Account Factory를 실행해 AWS 계정 생성
  - Control Tower 외의 리소스 접근은 최소화 해야 함
- Core(Log Archive, 보안 로그를 적재하기 위한 계정)
  - S3 버킷
  - Cloud Trail 로그 적재
  - 보안 관련 로그 중앙 적재
  - 보안팀만 접근
- Core(Audit) 보안 로그를 여기서 확인함
  - GuardDuty master 계정의 결과를 조회하고 관리하는 역할
- Additional(Shared Service)
  - 전사 공용 서비스 용도(개별 애플리케이션 공통 컴포넌트는 아님)
  - Shared Services VPC
  - Active Directory
  - DNS
  - 배포 관련 공용 서비스
- Additional(Network)
  - 전사적 연결성 제공
  - Secure VPC(Ingress)
  - Shared VPC
  - Transit GateWay
  - VPN 및 DX
- Additional(개별 워크로드, Sandbox)

OU 설계에서 Policy Staging, Suspended 정도는 기본적으로 한다.

## Control Tower

AWS Control Tower가 만들어져 있다면 Organizations에서의 직접 조작은 지양해야 한다.

### Controls library

Preventive Guardrail은 Nested OU로 상속
Detective Guardrail은 적용 당시의 Register 여부를 따름
OU Register시 OU내에 Enroll 되지 않은 모든 Account는 병렬로 Enroll이 수행

보안 40 Control Tower 30개
총 70개

개념이라 크게 어려운 문제는 없다.

SSO는 Shared Service 계정에서 하면 좋을 것 같다.

Prod와 Dev가 서로 통신하면 안되지만, Shared Service는 둘 다 통신 가능해야 한다.

DVWA 헬스체크 302포트다

IGW를 못만들게 하는게 Ingress 막는거다.