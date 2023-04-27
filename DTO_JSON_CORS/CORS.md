- [CORS란](#cors란)
  - [동일 출처 정책](#동일-출처-정책)
  - [JSONP](#jsonp)
  - [Access-Control-Allow-Origin](#access-control-allow-origin)
- [@CrossOrigin](#crossorigin)


# CORS란

## 동일 출처 정책
동일 출처만 처리해준다는 원칙, 도메인과 포트까지 포함

## JSONP
script 태그는 동일 출처를 따지지 않는다는 점을 이용해서 서버에서 JSON을 전달하는게 아니라 실행되는 자바스크립트 코드를 전달하는 방식

## Access-Control-Allow-Origin

    HTTP/1.1 200 OK
    Access-Contorl-Allow-Origin: https://ohjinn.com


# @CrossOrigin

Spring web MVC에서

    response.addHeader("Access-Control-Allow-Origin", "*");
이런식으로 서블릿에 헤더를 추가해 줄 수도 있지만  
스프링에서 @CrossOrigin을 추가해주면 된다