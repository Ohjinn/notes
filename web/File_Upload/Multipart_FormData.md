- [Multipart FormData](#multipart-formdata)
- [`@ModelAttribute`](#modelattribute)



# Multipart FormData
HTML 문서에서 input 태그의 type을 file로 지정하면 사용자가 파일을 선택할 수 있다. 이를 전송하기 위해서 전통적인 방법인 multipart/form-data를 많이 사용한다.

# `@ModelAttribute`
request로 들어온 데이터를 지정한 객체에 바인딩 해주는 어노테이션으로

1. 해당되는 객체를 생성한다.
2. 요청 파라미터의 이름으로 객체의 프로퍼티를 찾고 해당 프로퍼티의 setter를 호출해서 파라미터 값을 바인딩한다

만약 타입이 다르면 BindException이 발생하게 된다.

@ModelAttribute는 파라미터에서 생략도 가능하다.
