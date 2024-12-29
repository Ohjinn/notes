# Introduction 

본 세션에서는 Resilience의 4가지 매커니즘에 대해 설명한다.

Resilience Hub 실습 링크(72h 유효)  
<http://bit.ly/3zYchQB>

## Resilience: 워크로드가 장애에 대응하고 신속하게 복구할 수 있는 능력

- 고가용성
- 업무 연속성
- 지속적인 회복력

## 복원력 수명 주기 프레임워크

목표 설정, 설계 및 구현, 평가 및 테스트, 운영, 대응 및 학습

## 복원력 평가하기 위한 툴, 메커니즘들

- WAF: Well Architected Review
  - 6개의 필러
  - 설계원칙
  - 질의응답
  - 모범사례
- ARH: AWS Resilience Hub
  - CI/CD 과정 전체를 녹여서 스코어를 받고, 추천 작업이 나타난다.
  - CloudFormation, EKS Cluster 등의 그룹 단위로 평가 가능
- RA2: Resilient Application Readiness Assessment
  - APN 접속해서 고객사 입력하고 수행 가능하며
  - 질문에 대해 대답하고 나면 결과, 평가, 권장조치들에 대한 결과들을 수령할 수 있다.
- RCP: Resilience Core Program
  - 컨설턴트 주도 프로그램으로 사업기회가 클 경우 AWS와 함께 수행

# Building Resilience Through Fault Isolation

- Falut Isolation: 영향 범위를 제한하고 연쇄적인 장애를 방지
- Redundancy: 단일 장애 지점이 없거나 장애에도 정상적인 기능을 유지/복구
- Sufficient

|물리적|논리적|
|--|--|
|Partition|Account|
|Region|Microserviec|
|AZ|cells|
|EC2||

Partition: Commercial Partition, China Partition, GovCloud(US) Partition등 여러 파티션으로 나눠져있다.

Control Plain: 리소스를 Create, update, dlete, list, describe하는 업무  
많은 Dependency가 있는 복잡한 Application  
ex) EC2 실행, 배치

Data Plain: 일상적인 Application

## Static Stability

정적 상태에서 작동하고 변경할 필요 없이 정상적으로 계속 작동할 수 있게 하는 것

- 순환 종속성 방지
- 사전 프로비저닝 용량
- 기존 상태 유지
- Synchronous integraction 제거

Control Plain API를 최대한 사용하지 않고 Data Plain의 API를 주로 사용하도록 만들면 장애 대응에 조금 더 낫다. 주로 Control Plain에 장애가 일어난다. 예를 들어 Route53의 Control plain의 역할과 Data Plain의 역할을 보면 대부분의 Read 작업들은 Control Plain 장애시에도 정상 작동하니 Data Plain을 사용하는 API만 사용하면 된다.

### Shuffle Sharding

MSA에서 고양이가 장애가 나더라고 고양이와 함께 격리된 환경이 격리된 또 다른 환경에서 다른 서비스와 배포되어 있다면 장애의 전이를 막을 수 있다.

### Cellular Architecture

각각의 서비스가 독립적인 하나의 어플리케이션을 구성해 아무것도 공유하지 않고도 정상 작동할 수 있게 만들어놓는 것, DB 때문에 쉽지 않지만 만들어논다면 장애의 영향을 받지 않는다. 가격과 서비스의 중요성의 Trade off가 될 것 같다.

# 멀티리전

주제

- 멀티리전 기본 사항
- 조직의 페일오버 전략
- 멀티리전 아키텍쳐 패턴

## 멀티리전 기본 사항

리전 내에서 충분한 복원력을 가지고 있는지
장애에 대한 정의 및 절차가 정의되어 있는지
리전 내 장애에 대한 운영 기준명확
비즈니스 요구사항에 대한 정의

- 멱등성
- 최종 일관성(최종적인 일관성은 맞도록)
- 정적 안정화(다른 곳에서 장애가 발생해도)
- Exponential Backoff(장애시 과부하 방지)
- 스로틀링(서비스 과부하 방지)
- 서킷 브레이킹(실패시 다른 라우트로)

### 비즈니스에 대한 이해

### 데이터에 대한 이해가 필요

일관성에 대한 이해(데이터 일관성의 중요도에 따른 Replica 동작방식)
데이터 접근 방식에 대한 이해(Read or Write 가중치)

### 의존성에 대한 이해

원하는 지역에 AWS 서비스가 존재하는지

### 모니터링

다른 리전으로의 중요한 메트릭, 로그는 전송하며, 다른 리전에서도 모니터링이 가능하도록 만들어야 한다.

비용과 노력, 복잡성, 운영 부담, 일관성 & 지연을 이길 정도로 비즈니스의 복원력이 중요한 경우 시행해야 한다.

## 기업의 페일오버 전략

- Component-level: 양극화된 동작과 테스트 복잡성이 발생
- Application-level
- Dependency-graph
- -portpolio

pattern #1: Active/passive  

pattern #2: Active/Active

- 극도의 고가용성

pattern #2.2: Active/Active

- Single Writer, Multiple Readers

pattern #2.3: Active/Active

- Single Writer, Multiple Readers(Strong Consistency)
- 쓰기 후 즉시 읽기 강한 일관성

pattern #2.5: Active/Active

- Multiple Writers, Multiple Readers

# Detecting and mitigating gray failure

outlier 탐지

Demension(AZ 정보)를 수집하면 어느곳에서 장애가 났는지 확인 가능하다.

AZ Gray Failure 완화 방법

1. 기다리기
2. AZ 대피
3. Region DR

가장 쉬운 방법은 AZ affinity

CloudMap, DynamoDB, Systems Manager 등을 이용해 같은 AZ 안에서의 통신만 유도해 통신요금을 아낄 수 있다.

<https://github.com/bamcis-io/multi-az-observability>

# ARC(Application Recovery Controller)

Route53의 Data Plain

# Chaos Engineering

알지도 못하고 이해하지 못하는 혼돈의 상황을 대비하기 위한 것
https://signin.aws.amazon.com/federation?Issuer=workshopstudio&Destination=https://us-east-1.console.aws.amazon.com/console/home&SigninToken=4eYK7tHtk937ddwDd_K06OQV1NjCglZHei93TJ0XuZ7UFb_PamAl11dhLS5DLz_kJ_n8ZITT67bMa-ePcVtLbTZ-TQ-GGDPwRN8peIXKw0pSk5gXwxmj5yjGv8Wu7H6d5xPJyR76w6mo1PJKfYkg_rV5wEj0NXciELptwtfIHWJYZaWC6zqBGMMGXk_aRg3iSEuxQnhnMjVEsNw-M3PXQo97LWPYwNniYIyLqBtEk-G5Hoq5rdrqI6Tj9UylzYztftl_u4PATrG5ZYU-FloOAm7cHjE8VZduK_LD5CTw0dt7ne5oMX7yvpxdXsJjEtdrMyHIv7DA0XC1mVKetR6uyXi8Xhu-zQjQ86QwTDaIf60cGE2QfJJ2x-gTUYcMSB9GPIDtHHBYoMYwjStiqC9Ep32j1kxxBHaR3JPnOcCIgGxJKdFYLySrynfo4sU-bPSlbX18y98KY_k6hOVzeio_kQFwggceYAfo_G0Fu7sJHBM9Yav2KbEK9F0aiAK6iKG_VOfaCfmaZA4gK3FJb-19Pt0ywxj-oROOOth_20Vii5BAusGrD59LAo2rM0TUmddxK7ndEa31YKkVgAH8HgaZYdYxRhTKHOBoIehkJBOTsR4mMr_MYcuH-gb6ZAfNNpNKk3fuxw_Ecg5AB0LgaAYKz07kCO9wxhoOAb8NvybpfLLGkA8IlDt6NXSV3Q4DmBHryjpN0_HuYeA6SVL1lG2UpBRmcI6RUAvAxGyzoULCX7-vH1Y3x1I6YhCm4AhNcPlJ1PzCB41EHKkiAgUqUFFsMXvUcAN6ulwPlPxxP98WsQPmhBRsMEFYC6GNksmmC2w4N1jUllkSfaPxxq57bWtfVO7VYnmZ06hpzAuWYab0E_VZf3kcjSCIdO3xsj8z0s97TqJElkh0fmojB19A57-xVSkhurn_TYOhomJPocdQG9EglhzLG60_n3TbaQj1zi_FT72Bv9E4nQwlvj1gFtsO81kOhed_j2DyL7eaJ_jgl8j1xxTmONNe0J2kNtKEL-DYFSVUmJvdNkV0GEoMc_U1MrLgFtJYcaQWxVJJjsmI8JkBVqQkEC2pzMn36X7tF_6Wzbp0j9EWkCp_OBYnRCNDqg4RE9cf5VeV459yKTDXGBLdKrjOBcjxIg6OL07K_ggEJNepbS6W6SoABIsPD2kLyKynM1DWqXtkVIaOi2gHYPAv7SBwGO_qN2i8pxHPkYi3G1uPBAEEgaVVfKHKY-6Vicv1qKjRxjOL55ZIxUUeOUg_N3vPmcHkdhtUiiS7THR6xHwatYwrXDRhW_8tVv_1niaP-uDKTd2biZSFtwq2BXArOhkyBDWHil7HhubsJ6P0v-ZzgVjsqc-8LqULMKtPIpF7EtzBTCj-oP6bD1o3JhplbnOdAF8vvQS-37Y3i7ftfVCFwD8HWAixbfeJIOqjuYNAgsTj232nODPPaJw&Action=login