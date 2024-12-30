# Info
Terraform vnet Subnet Example


* vnet CIDR 은 10.0.0.0/16
* Subnet CIDR 은 10.0.x.0/24

# Step

## 1. 변수 설정
subnet.tfvars 파일 확인
실행 환경에 맞게 변경  

```
# subnet.tfvars 파일
prefix      =       "user00"
region      =       "koreacentral"
vnet_cidr    =       "10.0.0.0/16"
subnet_cidr1     =       "10.0.1.0/24"
subnet_cidr2     =       "10.0.2.0/24"

```
* Prefix 는 알맞게 변경
* Region 은 본인이 사용할 region 코드로 변경가능 - koreacentral 유지
* Subnet 의 CIDR 값은 본인 값에 맞게 변경 가능


## 2. init  
Init 명령으로 Terraform 수행을 위한 provider plugin 초기화 및 다운로드 수행

```
terraform init
```

## 3. plan  
Plan 명령으로 Terraform 수행 전 실행 시뮬레이션 확인
```
terraform plan --var-file=subnet.tfvars
```  

## 4. apply  
Apply 명령으로 Terraform 을 통한 Resource 생성 수행
```
terraform apply --var-file=subnet.tfvars
```  

## 5. 실행 내용 확인
vnet 과 subnet 구성 생성 내용 확인


# Resource 삭제

## 1. destroy
Destroy 명령으로 삭제 수행
```
terraform destroy --var-file=subnet.tfvars
```
