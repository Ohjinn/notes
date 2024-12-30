# Info
Terraform Blob Storage Example


* vnet CIDR 은 10.0.0.0/16
* Subnet CIDR 은 10.0.1.0/24, 10.0.2.0/24
* Blob Storage 설정 후 컨테이너에 이미지 저장

* **각 Resource 를 생성하는 코드를 모두 Module 로 제작**

# Step

## 1. 변수 설정
module.tfvars 파일 확인
실행 환경에 맞게 변경  

```
# module.tfvars 파일

prefix               =          "user**"
region               =          "koreacentral"
vnet_cidr            =          "10.0.0.0/16"


```
* Prefix 는 알맞게 변경
* Region 은 본인이 사용할 region 코드로 변경가능 - koreacentral 유지


## 2. init  
Init 명령으로 Terraform 수행을 위한 provider plugin 초기화 및 다운로드 수행

```
terraform init
```

## 3. plan  
Plan 명령으로 Terraform 수행 전 실행 시뮬레이션 확인
```
terraform plan --var-file=module.tfvars
```  

## 4. apply  
Apply 명령으로 Terraform 을 통한 Resource 생성 수행
```
terraform apply --var-file=module.tfvars
```  

## 5. 실행 내용 확인
Blob Storage Container 에 생성 내용 확인, output에 출력된 url 로 접속 확인

## 6. 해당 코드는 destroy 하지 않습니다.
