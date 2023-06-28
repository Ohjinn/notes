- [CORS(Cross-Origin Resource Sharing)](#corscross-origin-resource-sharing)
  - [JSONP](#jsonp)
  - [Access-Control-Allow-Origin](#access-control-allow-origin)
  - [Preflight](#preflight)
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
script 태그는 동일 출처를 따지지 않는다는 점을 이용해서 서버에서 JSON을 전달하는게 아니라 실행되는 자바스크립트 코드를 전달하는 방식으로 과거에나 사용됐다.

## Access-Control-Allow-Origin
웹 브라우저가 동일 출처 정책에 예외를 방법을 제공하는데 CORS는 HTTP 응답 헤더를 이용해 이 문제를 해결할 수 있다.

헤더에 다음과 같은 요소를 하나 넣어주면  

```http
    HTTP/1.1 200 OK
    Access-Contorl-Allow-Origin: https://ohjinn.com
```

ohjinn.com이 origin인 자원을 모든 곳에서 사용할 수 있게 된다.

## Preflight
응답 헤더에 허용 여부가 있다면 데이터가 많이 들어간 요청이 있다면 비효율을 야기한다.  
따라서, OPTIONS 메서드를 이용해 Preflighted Request를 보낼 수 있다.

```http
OPTIONS /resource/foo
Access-Control-Request-Method: DELETE
Access-Control-Request-Headers: origin, x-requested-with
Origin: https://foo.bar.org
```

위와 같이 preflight를 이용해 간을 보면 서버에서는

```http
HTTP/1.1 204 No Content
Connection: keep-alive
Access-Control-Allow-Origin: https://foo.bar.org
Access-Control-Allow-Methods: POST, GET, OPTIONS, DELETE
Access-Control-Max-Age: 86400
```
이렇게 응답을 해 준다.

# @CrossOrigin

Spring web MVC에서

    response.addHeader("Access-Control-Allow-Origin", "*");
이런식으로 서블릿에 헤더를 추가해 줄 수도 있지만  
스프링에서 @CrossOrigin을 추가해주면 된다