- [V 모델](#v-모델)
- [Test Matrix](#test-matrix)
- [JUnit](#junit)
- [테스트](#테스트)
  - [단위 테스트(Unit Test)](#단위-테스트unit-test)
  - [E2E 테스트](#e2e-테스트)
  - [통합 테스트(Integration Test)](#통합-테스트integration-test)






# V 모델
프로그래밍은 비즈니스 문제를 해결하기 위함이다.
문제를 잘 정의하고 문제가 해결된 모습을 그려보면 어느정도 확신이 가능하다.  

V 모델은 각 단계에 대한 테스트를 나누고, 처음부터 어떻게 테스트해야 하는지 결정하려고 노력한다.

1. 요구사항 분석 -> 사용자 중심 => 인수테스트
2. 시스템 설계 -> 시스템 사양 결정 => 시스템 테스트
3. 아키텍쳐 설계 -> 고수준 설계 => 통합테스트
4. 모듈 설계 -> 저수준 설계 => 단위테스트
5. 구현

# Test Matrix
테스트를 위한 템플릿, 테스트를 세분화한 시트라고 생각하면 된다.
보통 시각적으로 보이는 것은 외적품질, 클린코드와 같은 것들을 내적품질이라고 말할 수 있다.  
내적 품질을 올리면 외적 품질을 올리기 좋다.

![테스팅](https://developertesting.rocks/wp-content/uploads/2018/01/testingquads_dt.png)

간단하게 생각해보면 스트럿츠로 작성된 프로그램은 빈 등록을 익숙하지 않은 xml로 해주고 있었기 때문에 원하는 기능을 구현하기 위해서 이미 적혀진 코드를 해석하는데만 반나절이었다. DB 문서도 제대로 작성되어있지 않아서 더욱 그랬다.

# JUnit
자바로 작성된 프로그램의 테스트를 지원하는 도구로 이름엔 Unit이 들어있지만 유닛 테스트만 지원하는 것은 아니고 통합테스트, E2E테스트까지 지원한다.


# 테스트
![테스트](https://martinfowler.com/articles/practical-test-pyramid/testPyramid.png)  
Test Pyramid (출처: https://martinfowler.com/articles/practical-test-pyramid/testPyramid.png)
해당 테스트 피라미드 개념은 지나치게 단순하게 세분화해 부족해보일 수 있기 때문에 두 가지만 기억하면 된다.
1. 다양하게 세분화해서 테스트 작성
2. 높은 수준의 테스트일수록 적은 테스트를 가져가야 한다


## 단위 테스트(Unit Test)
단위테스트는 일반적으로 클래스나 메서드 수준에서의 테스트를 의미한다. 테스트 대상의 단위 크기를 작게 설정해서 최대한 간단하고 디버깅하기 쉽게 작성해야 한다. 단위테스트는 화이트박스 테스트다.



## E2E 테스트
End-to-End 테스트의 약자로 애플리케이션의 흐름을 처음부터 끝까지 테스트 하는 것을 의미한다. 단위 테스트나 통합 테스트가 모듈의 무결성을 증명해주지만 모듈의 무결성이 애플리케이션 동작의 무결성을 증명할 수는 없기 때문에 실제 사용자의 시나리오를 테스트해 애플리케이션의 무결성을 증명할 수 있다.

## 통합 테스트(Integration Test)

Spring의 힘을 빌려서 IoC 컨테이너를 사용하거나 Spring web MVC로 구현된 부분을 테스트 할 때 통합 테스트라고 부른다. 단위 테스트를 작성할 때 일반적으로 더 나은 격리와 빠른 테스트를 위해 생략하는 데이터베이스, 파일시스템, 다른 애플리케이션에 대한 네트워크 호출등을 모두 사용해 테스트 하는 것이 통합테스트다.

출처:  
[마파](https://martinfowler.com/articles/practical-test-pyramid.html)
[테코블](https://tecoble.techcourse.co.kr/post/2021-05-25-unit-test-vs-integration-test-vs-acceptance-test/)  
[MS](https://learn.microsoft.com/ko-kr/dotnet/core/testing/unit-testing-best-practices)
[카카오enter](https://fe-developers.kakaoent.com/2023/230209-e2e/)