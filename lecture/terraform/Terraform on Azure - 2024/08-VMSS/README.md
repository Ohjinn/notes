# Info
Terraform VMSS Example

* vnet CIDR 은 10.0.0.0/16
* Subnet CIDR 은 10.0.1.0/24, 10.0.2.0/24

* SSH 허용을 위한 Admin 용 security_rule 과 HTTP 웹 접속 허용을 위한 Web security_rule 내용으로 security_group 생성
* Admin Security Group 에는 SSH(22) 포트를 본인 IP 허용하는 Rule 생성
* Web Security Group 에는 HTTP(80) 포트를 모두 허용 하는 Rule 생성

* VM 을 2개 생성
* 각 VM 생성 후, custom_data 를 통해 index.html 테스트 웹 파일 생성
* Public IP를 생성
* LoadBalancer를 생성하고 설정
* VMSS 생성 및 설정

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
subnet_cidr1         =          "10.0.1.0/24"
subnet_cidr2         =          "10.0.2.0/24"
password             =          "azureCIA!234567"
admin_access_cidrs   =          "<Your Public IP>/24"


```
* Prefix 는 알맞게 변경
* Region 은 본인이 사용할 region 코드로 변경가능 - koreacentral 유지
* Subnet 의 CIDR 값은 본인 값에 맞게 변경 가능
* SSH 접속 허용할 IP 값 변경
* password는 12자리이상, 특수문자, 숫자, 대문자 조합으로 생성 필요
* ssh-keygen (엔터3번) 으로 키 생성
```
ssh-keygen
```
* Blob storage 업로드 한 파일의 URL로 Web1.sh, Web2.sh 업데이트 필요    

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

# Resource 삭제

## 1. destroy
Destroy 명령으로 삭제 수행
```
terraform destroy --var-file=module.tfvars
```
