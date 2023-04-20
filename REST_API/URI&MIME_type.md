- [URI \& URL \& URN](#uri--url--urn)
- [MIME type](#mime-type)
  - [개별타입](#개별타입)
    - [application/x-www-form-urlencoded](#applicationx-www-form-urlencoded)
    - [application/octet-stream](#applicationoctet-stream)
  - [멀티파트 타입](#멀티파트-타입)


# URI & URL & URN
정리되어 있다. [http-client](../http/http-client.md#uri와-url)   

<br><br><br> 
# MIME type
클라이언트에게 전송된 문서의 다양성을 알려주기 위한 메커니즘으로 브라우저들은 리소스를 내려받았을 때 해야 할 동작이 무엇인지 결정하기 위해 MIME 타입을 사용한다.
MIME 타입의 구성은 다음과 같다.

    type/subtype

/로 구분된 타입과 서브타입으로 구성되는데 type은 카테고리를 나타내며 개별 혹은 멀티파트 타입이 될 수 있다. subtype은 각각의 타입에 한정된다.

## 개별타입
개별타입의 종류는 다음과 같다
| 타입 | 설명 | 일반적 서브타입  |
| ----- | ---------- | ----------------------- |
| text | 텍스트를 포함하는 모든 문서 | text/plain, text/html, text/css, text/javascript |
| image | 모든 종류의 이미지 | image/gif, image/png, image/jpeg |
| audio | 오디오 파일 | audio/midi, audio/mpeg |
| video | 비디오 파일 | video/webm |
| application | 이진데이터 | application/xml, application/octet-stream |


### application/x-www-form-urlencoded
폼을 이용한 POST 전송중에 가장 단순한 방식이 application/x-www-form-urlencoded 방식인데 이는 body의 key와 value가 =, 각각의 요소는 &로 연결된다.

### application/octet-stream
이진 파일을 위한 기본값으로 Content-Disposition 헤더가 attachment와 함께 설정되어 save 여부를 결정한다.


## 멀티파트 타입
멀티파트 타입은 다른 MIME타입들을 지닌 개별적인 파트들로 나누어지는 문서의 카테고리를 가리킨다.

multipart/form-data는 브라우저에서 HTML 폼을 전송시 사용할 수 있는데 --로 구분되어지는 다른 파트들로 구성된다.

```
POST / HTTP/1.1
Host: localhost:8000
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:50.0) Gecko/20100101 Firefox/50.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: keep-alive
Upgrade-Insecure-Requests: 1
Content-Type: multipart/form-data; boundary=---------------------------8721656041911415653955004498
Content-Length: 465

-----------------------------8721656041911415653955004498
Content-Disposition: form-data; name="myTextField"

Test
-----------------------------8721656041911415653955004498
Content-Disposition: form-data; name="myCheckBox"

on
-----------------------------8721656041911415653955004498
Content-Disposition: form-data; name="myFile"; filename="test.txt"
Content-Type: text/plain

Simple file.
-----------------------------8721656041911415653955004498--
```


일전에 폼 데이터 인코딩이 두번돼서 오는 문제가 있었던 적이 있었는데 스트럿츠 기반의 오래된 시스템이라 이해가 안되고 어느 부분에서 인코딩 되는지도 몰라서 그냥 서버에서 두번 디코딩 하는 임시방편을 썼었는데. 브라우저가 [나 몰래](https://datatracker.ietf.org/doc/html/rfc1866#section-8.2.1) 하고있었구나..


출처  
[mozilla](https://developer.mozilla.org/ko/docs/Web/HTTP/Basics_of_HTTP/MIME_types  )