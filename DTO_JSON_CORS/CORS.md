- [CORS(Cross-Origin Resource Sharing)](#corscross-origin-resource-sharing)
  - [JSONP](#jsonp)
  - [Access-Control-Allow-Origin](#access-control-allow-origin)
- [@CrossOrigin](#crossorigin)


# CORS(Cross-Origin Resource Sharing)
웹 브라우저는 동일 출처 정책이라는 것이 존재한다. 동일 출처만 처리해준다는 원칙, 도메인과 포트까지 포함된 것으로 이는 어떤 출처에서 불러온 문서나 스크립트가 다른 출처에서 가져온 리소스와 상호작용하는 것을 제한하는 보안 방식이다. 동일 출처 정책은 출처가 불분명한 문서를 참조함으로써 받을 수 있는 공격의 경로를 줄여주는 정책이다.

```
GET /posts HTTP/1.1
Host: http://localhost:8080 → Back-end (REST API)
Origin: http://localhost:3000 → Front-end
```

HTTP 헤더를 보면 Origin을 명시해주는데 당장 이렇게 포트만 달라도 CORS 오류가 나오게 된다.



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