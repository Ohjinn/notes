
- [Ansible 이해](#ansible-이해)
  - [Ansible을 선택한 이유](#ansible을-선택한-이유)
  - [Ansible이란](#ansible이란)
  - [특징](#특징)
  - [사전준비사항](#사전준비사항)
  - [실행 구조의 이해](#실행-구조의-이해)
    - [Playbook](#playbook)
    - [Inventory](#inventory)
    - [Module](#module)
- [Ansible 명령어](#ansible-명령어)
  - [제어문](#제어문)
    - [become](#become)
    - [loop](#loop)
    - [when](#when)
    - [ignore\_errors](#ignore_errors)
    - [with\_\<lookup\_plugin\>](#with_lookup_plugin)
    - [environment](#environment)
    - [retries](#retries)
    - [until](#until)
    - [delay](#delay)
    - [async](#async)
    - [poll](#poll)
    - [args](#args)
    - [notify](#notify)
    - [gether\_facts](#gether_facts)
    - [name](#name)

# Ansible 이해

## Ansible을 선택한 이유
Push Based 방식으로 Agent가 존재하지 않음

Puppet, Chef, SaltStack 등등은 Pull Based 방식(Agent 존재)로 각 서버에 Agent 설치가 필요

Ansible Chef Puppet
정의 Yaml DSL, DSL
개발 Python Ruby Ruby
Agent여부 필요없음(SSH) 필요 필요
JSON REST/STOMP HTTP/SSL


|구분|Ansible|Chef|Puppet|
|--|--|--|--|
|정의|YAML|DSL|DSL|
|개발|Python|Ruby|Ruby|
|Agent여부|필요없음(SSH)|필요|필요|
|통신|JSON|REST/STOMP|HTTP/SSL|
|순차적 실행의 SSH를 통해 노드에 명령 모듈을 보내는 다중 푸시 모델||||

## Ansible이란
Python으로 구현된 오픈소스 IT 자동화 도구로 대상 서버에 Python 설치가 필수

## 특징
- Agentless
  - Target서버 Agent 설치 불필요
  - SSH 및 WinRM 지원
  - Target 서버에 대한 손쉬운 관리
- Easy/Simple
  - YAML 형식으로 쉽게 학습 가능
  - 단순 코딩으로 쉽게 적용 가능
  - 멱등성 지원/ 효율성 좋음
- Compatibility
  - 다양한 종류의 서버와 네트워크 지원
  - 동시에 여러 Target 서버에 작업 가능
  - 완벽한 구성관리와 Orchestrate


## 사전준비사항
- Python Package 설치
- 대상서버의 IP 정보
- 네트워크 구간 방화벽 open
- SSH Port Listen
- OpenSSH/WinRM 환경 구성
- Ansible 수행용 계정(Root 제외)
- SSH RSA 인증키 발행

## 실행 구조의 이해
User -> Playbook 작성(작업절차 정의) -> Inventoy(대상장비 정의) -> Ansible
Ansible은 SFTP Copy릁 통해 명령어를 전송해 실행한다.

대량을 실행할때 WinRM이나 네트워크 장비는 Core 통해 실행하기 때문에 성능도 고려해야 한다.

### Playbook
- Ansible 환경 설정 및 배포를 가능하게 지원
- YAML
- Linux 기반의 권한관리(user, group) 지원
- 하나의 Playbook에서 하나 또는 그이상의 작업을 정의할 수 있으며 role과 task를 매핑하는 역할을 담당
- 반복문, 조건 분기문, 다른 Playbook 참조, 외부 참조, 환경설정, 파일 등 참조
- Target, Vars, Tasks Section으로 구분해서 작성

### Inventory
- Remote서버에 대한 Meatdata를 기술하는 파일
- 관리 대상 서버를 기술: Host, IP, 접속계정
- Remote Host를 Grouping 가능
- Inventory설정 기본 파일: /etc/ansible/hosts
- ansible-playbook 명령의 -i 옵션으로 파일 강제 지정 가능

### Module
- 특정 목적을 위해 주로 Python으로 작성된 Ansible 백엔드
- 대표 Module
  - Package 관리: yum, apt ...
  - 서비스 제어: Service 시작/정지 등
  - 파일 처리: File, Copy, Fetch, Template 등
  - Command 실행: command, shell, 외부 명령 수행
  - 소스 코드 관리: git, subversion



# Ansible 명령어
제어문, 반복문, 조건문

## 제어문

### become
- Task 실행될 때 다른 계정 권한으로 변경
- 설정 안하면 root가 기본
- 권한 승계에 따른 사용할 method 정의
- become_flags: -i 옵션을 주지 않으면 환경변수가 하나도 설정되지 않는다.


### loop
- Task의 반복 수행할 목록
- 정의된 element를 item 변수에 저장
- 명령어를 command 뒤에 적으면 해당 명령어가 실행됨
- register를 사용하면 해당 정보를 변수에 입력 가능
- loop_control를 이용해 loop를 조절 가능


### when
- Task 또는 반복문이 실행될지 여부를 결정 ex) when: ansible_of_family == "Debian"
- fail: when: "'FAILED' in result.stdout" 같은 방법으로 소프트웨어가 뱉은 출력 값으로 제어


### ignore_errors
- Task 수행 실패를 무시하고 이후 수행
- 접속 실패의 경우는 예외


### with_<lookup_plugin>
- loop와 동일하지만 자동으로 lookup plugin의 output을 item list 만들 때 추가


### environment
- 환경변수 컨트롤을 위한 문장
- 쉘에서 env 변수로 export 하는 것과 동일


### retries
- 반복문에서 반복될 횟수, until과 함께 사용
- until 없이 사용할 경우 해당 값은 무시


### until
- 반복문에 기재된 조건이 만족할 때까지 또는 retries limit을 만날 때까지 반복
- retries 반복 회수 조정 가능


### delay
- 재시도 하기 전 간격을 얼마나 둘 것인가


### async
- Task를 비동기 방식으로 수행
- Sync로 수행될 경우 SSH Connection이 연결된 상태로 block된 상태로 유지
- blocking과 timeout 이슈를 피하기 위해 async를 사용하여 한번에 모든 task를 수행하고 완료될 때까지 polling


### poll
- 비동기 Task에 대한 Polling 주기 설정
- Default 10초


### args
- Task에 Argument를 추가하여 다른 방법으로 수행 가능
- Module이 free_form을 요구하는 경우 반드시 필요


### notify
- 실행 결과에 대해 ok & change일 경우 notify 핸들러


### gether_facts
- Setup Task 자동 수행 여부 확인


### name
- Task나 핸들러읫 ㅓㄹ명
- 내용은 수행시 로그에서 Task 구분을 위해서도 사용 가능





