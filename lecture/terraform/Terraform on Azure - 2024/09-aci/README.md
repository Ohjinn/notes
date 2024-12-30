# Info
Terraform aci Example



# Step

## 1. 변수 설정
aci.tfvars 파일 확인
실행 환경에 맞게 변경  

```
* aci.tfvars 파일
prefix      =       "user00"
region      =       "koreacentral"
subscription_id      =          "<your subscription_id>"
* Prefix 는 알맞게 변경
* Region 은 본인이 사용할 region 코드로 변경가능 - koreacentral 유지
* subscription_id 에는 구독 id를 찾아 입력
```

## 2. init  
Init 명령으로 Terraform 수행을 위한 provider plugin 초기화 및 다운로드 수행

```
terraform init
```

## 3. plan  
Plan 명령으로 Terraform 수행 전 실행 시뮬레이션 확인
```
terraform plan --var-file=aci.tfvars
```  

## 4. apply  
Apply 명령으로 Terraform 을 통한 Resource 생성 수행
```
terraform apply --var-file=aci.tfvars
```  

## 5. 실행 내용 확인

* ACI 로 배포된 Container 구성 생성 내용을 Portal 에서 확인
* output 으로 출력된 public ip -> 웹브라우저에서 접속
* 테트리스 한판.

# Resource 삭제

## 1. destroy
Destroy 명령으로 삭제 수행
```
terraform destroy --var-file=aci.tfvars
```
