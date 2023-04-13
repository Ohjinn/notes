- [HTTP](#http)
- [HTTP와 HTTPS의 차이(TLS)](#http와-https의-차이tls)
- [클라이언트-서버 모델](#클라이언트-서버-모델)
- [stateless와 stateful](#stateless와-stateful)
- [HTTP Cookie와 HTTP Session](#http-cookie와-http-session)
  - [쿠키 설정 방법](#쿠키-설정-방법)
- [HTTP 메시지 구조](#http-메시지-구조)
  - [HTTP 요청(Reuqest)와 응답(Response)](#http-요청reuqest와-응답response)
    - [multipart/form-data](#multipartform-data)
  - [HTTP 요청 메서드(HTTP request methods)](#http-요청-메서드http-request-methods)
    - [멱등성](#멱등성)
  - [HTTP 응답 상태 코드(HTTP response status code)](#http-응답-상태-코드http-response-status-code)
    - [리다이렉션](#리다이렉션)


<br><br><br><br>

# HTTP
HTTP(HyperText Transfer Protocol)는 전송규약으로 HTML, Text, 이미지, JSON등 거의 모든 형태의 데이터를 전송하는 용도로 사용할 수 있다.

OSI 7계층으로 보면 다음과 같다

| 계층 숫자 | 계층 이름 | 주요 식별자 | 설명 |
| ------- | ------- | -------- | -- |
| 7 | Application Layer | HTTP |  |
| 6 | Presentation Layer |  |  |
| 5 | Session Layer | TLS(SSL) |  |
| 4 | Transport Layer | TCP/UDP | Port 번호 |
| 3 | Network Layer | Internet | IP 주소 |
| 2 | Data Link Layer | Ethernet | MAC 주소 |
| 1 | Physical Layer | HTTP | 실제 랜선의 길이 등 |

HTTP는 여러 버전이 존재하는데 현재 주로 사용하는 것은 HTML/1.1 버전이며 HTTP/3은 UDP 방식을 사용하는 차이점이 있다.
<br><br><br><br>

# HTTP와 HTTPS의 차이(TLS)

TLS는 네트워크로 연결된 두 개의 어플리케이션이 보안과 신뢰성을 가지고 통신할 수 있게 만드는 프로토콜이다.<br>
SSL(Secure Sockets Layers)로 일컬어지던 HTTPS 기술을 국제 표준화기구에서 TLS로 지정하므로써 명명됐다.<br>
관습적으로 HTTPS는 80포트를, HTTPS는 443포트를 사용한다.

TLS는 세 가지 주요 서비스를 제공한다.
- 인증
  - 커뮤니케이션에 대한 각각의 당사자가 상대방이 주장하는 사람인지 검증한다.
- 암호화
  - 데이터는 클라이언트와 서버 사이에 전송되는동안 읽히거나 가로채지는 것을 방지하기 위해 암호화된다.
- 무결성
  - 암호화하고 전송, 복호화하는 동안 정보의 수정, 손실, 위변조되지 않음을 보장한다.


<br><br><br><br>

# 클라이언트-서버 모델
클라이언트는 요청, 서버는 응답하는 역할을 하는데 웹의 리소스를 특정하기 위해 URL을 사용한다.


# stateless와 stateful
- stateless: 서버가 클라이언트의 상태를 보존하지 않는 것으로 여러 서버를 운영해도 항상 같은 응답을 받을 수 있다.
  - 장점: 서버 확장성이 좋다.
  - 단점: 클라이언트가 매 요청마다 추가 데이터를 전송해야 한다.

- stateful: 서버가 클라이언트의 상태를 보존하는 것으로 sticky session같이 항상 동일한 서버로 보내주는 로드밸런서가 필요하다.
  - 장-단점: stateless와 반대된다.

<br><br>

# HTTP Cookie와 HTTP Session
HTTP Cookie의 사용처는 다음과 같다.
- 사용자 로그인 세션 관리
- 사용자 선호 테마 등의 세팅
- 광고 정보등을 트래킹할 때

다만 모든 요청마다 쿠키가 함께 전송되기 때문에 성능상의 문제를 고려해야 한다.

## 쿠키 설정 방법

- Set-Cookie
  
Set-Cookie를 통해 쿠키를 설정할 수 있고 브라우저는 서버로 응답할 때 모든 쿠키를 회신한다.

Set-Cookie: expires=Sat, 26-Dec-2020 04:39:21 GMT 등과 같이 만료시점을 지정하거나
Set-Cookie: max-age=3600 (3600초) 등과 같이 시간을 지정할 수 있다.

- Path

Path를 지정하면 해당 Path의 하위 도메인에서만 쿠키가 접근한다.<br>
예를 들어 **path = /ohjinn** 이라면 **/ohjinn/name** 에도 동일하게 적용된다.

- Secure
secure을 적용하면 https인 경우에만 쿠키를 전송한다.

- HttpOnly
XSS 공격을 방지하고 자바스크립트에서 접근이 불가능하다. HTTP 전송에만 사용된다.

- SameSite
XSRF 공격을 방지하고
요청 도메인과 쿠키에 설정된 도메인이 같은 경우만 쿠키를 전송한다.




<br><br><br>

# HTTP 메시지 구조
HTTP 메시지는 서버와 클라이언트 간의 메시지 교환 방식으로 구조는 다음과 같으며 모두 문자열로 이루어져 있다.<br>
HTTP 메시지의 시작 줄과 헤더를 묶어 head라고 부르며 바디는 payload라고 한다.


## HTTP 요청(Reuqest)와 응답(Response)

1. 시작 줄에는 실행되어야 할 요청, 수행에 대한 성공, 실패가 기록되어 있다.
2. HTTP 헤더 세트가 들어가는데 일반 헤더, 요청 헤더, 응답 헤더, 표현 헤더 등의 헤더가 존재한다.
3. 요청에 대한 모든 메타 정보가 전송되었음을 알리는 빈 줄이 삽입된다.
4. 요청과 관련된 HTML이나 문서 등이 들어가며 본문의 존재나 크기는 첫줄과 HTTP 헤더에 명시된다.

RFC2616에서는 엔티티로 명명했으나 RFC723x의 등장으로 표현이라는 단어로 바꼈다.

### multipart/form-data
MIME타입, 콘텐츠 타입은 인터넷에 전달되는 파일 포멧과 컨텐츠를 위한 식별자로 미디어 타입은 type, subtype, 매개변수로 이루어져 있다.  
예를 들어 HTML 파일은 text/html; charset=UTF-8로 지정되는데 text가 type, html이 subtype, charset이 매개변수다.  

type으로는 다음과 같은 것들이 존재한다.  
application, audio, example, font, image, message, model, multipart, text, video.

application/x-www-form-urlencoded: 일반적인 form 데이터를 보내는데 사용된다.
여기서 multipart/form-data는 바이너리 파일을 보낼 때 사용된다. 속도상의 이점을 위해 사용할 듯 싶다.



## HTTP 요청 메서드(HTTP request methods)

1. GET: READ
2. POST: SUBMIT
3. PUT: UPDATE
4. PATCH: UPDATE
5. DELETE: DELETE
6. HEAD: GET without body
7. OPTIONS: 지원 확인

### 멱등성
호출 횟수에 상관없이 결과가 같음을 보장하는 것을 멱등이라고 하며  
GET, PUT, DELETE는 멱등, POST, PATCH는 멱등을 보장하지 않는다.

## HTTP 응답 상태 코드(HTTP response status code)
상태 코드
1. 1xx(Informational): 요청이 수신되어 처리중, 거의 사용되지 않음
2. 2xx(Successful)
   - 200 OK: 
   - 201 Created: 성공 후 새로운 리소스가 생성됨
   - 202 Accepted: 접수되었으나 처리되지 않음
   - 204 No Content: 요청을 수행했지만 보낼 데이터가 없음
3. 3xx: 요청을 완료하기 위해 유저 에이전트의 추가 조치 필요(redirect)
   - 300 Multiple Choices: 안쓴다
   - 301 Moved Permanently: Location: /new-location 등으로 새로운 위치를 보내준다. 메서드가 GET으로 변하며 본문 제거 가능성 있음
   - 302 Found: 일시적 변경으로 요청 메서드가 GET으로 변하며 본문 제거 가능성 있음
   - 303 See Other: 위와 같지만 본문 제거 가능성은 없음
   - 304 Not Modified: 캐시를 목적으로 사용, 메시지 바디를 포함하면 안된다.
   - 307 Temporary Redirect: 리다이렉트시 요청 메서드와 본문 유지
   - 308 Permanent Redirect: 301과 동일하지만 메서드와 본문이 유지된다.
4. 4xx: 클라이언트 오류
   - 400 Bad Request: 클라이언트가 잘못된 요청을 해서 서버가 처리할 수 없음
   - 401 Unauthorized: 클라이언트가 해당 리소스에 대한 인증이 필요함, WWW-Authenticate 헤더와 함께 인증 방법을 설명해줘야 함
   - 403 Forbidden: 서버가 요청을 이해했지만 승인을 거부함
   - 404 Not Found: 요청 리소스가 서버에 없음, 해당 리소스에 대한 인가문제시 민감한 정보를 숨기기 위해서도 403이 아닌 404 사용 가능
5. 5xx: 서버 오류
   - 500 Internal Server Error: 서버 문제
   - 503 Service Unavailable: 서비스 이용 불가
### 리다이렉션
리다이렉션에 세 가지 종류가 잆다.
1. 영구 리다이렉션: 특정 리소스의 URI가 영구적으로 이동(301, 308)
2. 일시 리다이렉션: 일시적인 변경(302, 303, 307)
   - PRG 상황(주문 완료 후 해당 페이지에 그대로 있으면 새로고침만 해도 동일한 POST가 요청될 수 있기 때문에 완료 화면으로 redirection)
3. 특수 리다이렉션: 결과 대신 캐시를 사용

대부분의 웹 브라우저들이 302와 함께 GET으로 메서드를 바꿔버리므로 자동 리다이렉션시 GET으로 변해도 된다면 302를 사용해도 문제가 없다.



출처<br>
https://developer.mozilla.org/ko/docs/Web/HTTP/Cookies  
https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC/dashboard  
https://developer.mozilla.org/ko/docs/Web/Security/Transport_Layer_Security  