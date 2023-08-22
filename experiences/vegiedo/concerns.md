- [1. 프로젝트 세팅](#1-프로젝트-세팅)
  - [깃 브랜치 전략](#깃-브랜치-전략)
  - [공통 개발환경 구상](#공통-개발환경-구상)
  - [협업을 위한 API 명세서 작성](#협업을-위한-api-명세서-작성)
- [2. 양방향 연관관계에서 주인에 값을 입력하지 않으면 데이터베이스에 외래키가 반영되지 않는다.](#2-양방향-연관관계에서-주인에-값을-입력하지-않으면-데이터베이스에-외래키가-반영되지-않는다)

# 1. 프로젝트 세팅

## 깃 브랜치 전략
본래 git-flow를 사용하려 했으나 3명의 팀원으로 구성된 작은 조직에서 운용하기는 무겁다고 판단  
- develop
- alpha
- main 
- 본인의 이름을 딴 브랜치

이렇게 네 종류의 브랜치를 사용하기로 했다. 각각의 개발은 본인의 브랜치에서 진행하고 이를 병합하고 테스트 서버를 운영하기 위한 develop 브랜치, 병합한 브랜치의 버전을 관리할 alpha브랜치, 실제 배포를 진행할 main브랜치로 구성됐다.


## 공통 개발환경 구상
각자 다른 환경(mac, windows)에서 개발을 진행하기 때문에 테스트 환경을 통일하기 위해 docker-compose를 선택했다. 

`Dockerfile`
```bash
FROM openjdk:17 AS builder
# xargs 에러 해결을 위한 install
RUN microdnf install findutils

COPY gradlew .
COPY gradle gradle
COPY build.gradle .
COPY settings.gradle .
COPY src src
RUN chmod +x ./gradlew
RUN ./gradlew bootJar

FROM openjdk:17
COPY --from=builder build/libs/*.jar app.jar

ENV TZ=Asia/Seoul
ENTRYPOINT ["java", "-jar", "app.jar"]
VOLUME /tmp
```

`docker-compose.yml`
```bash
version: "3.9"
services:
  database:
    container_name: mysql-vegiedo
    image: mysql:8.0.30
    platform: linux/x86_64
    restart: always
    ports:
      - "3306:3306"
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: vegiedo_mysql
      MYSQL_USER: vegiedo
      MYSQL_PASSWORD: password
      TZ: Asia/Seoul
    volumes:
      - ./db/data:/var/lib/mysql
      - ./db/config:/etc/mysql/conf.d
      - ./db/init:/docker-entrypoint-initdb.d
    healthcheck:
      test: [ "CMD", "mysqladmin" ,"ping", "-h", "localhost" ]
      interval: 3s
      timeout: 20s
      retries: 10
    networks:
      - dev-network

  application:
    container_name: server
    restart: always
    build:
      dockerfile: Dockerfile
    ports:
      - "8000:8080"
    environment:
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql-vegiedo:3306?allowPublicKeyRetrieval=true
      SPRING_DATASOURCE_USERNAME: "vegiedo"
      SPRING_DATASOURCE_PASSWORD: "password"
    depends_on:
      database:
        condition: service_healthy
    networks:
      - dev-network
    command: ./gradlew bootRun

networks:
  dev-network:

```

JAVA 17, MySQL8.0.3 버전을 사용하며 데이터베이스와 어플리케이션의 의존관계로 인한 다수의 부팅을 방지하기 위해 mysqldml healthcheck를 spring application의 의존성으로 추가했다.  
각각의 서버는 dev-network라는 네트워크에서 서로의 컨테이너 이름으로 통신하게 된다.

## 협업을 위한 API 명세서 작성
API 명세서는 SPRING REST DOCS를 이용해 구성하기로 했지만 개발이 진행 된 후 테스트 코드 작성 후에야 가능한 조건이었기 때문에 notion 협업 페이지에 API 명세서를 작성했습니다.

# 2. 양방향 연관관계에서 주인에 값을 입력하지 않으면 데이터베이스에 외래키가 반영되지 않는다.
