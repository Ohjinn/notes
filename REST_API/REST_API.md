
- [API(Application Programming Interface)](#apiapplication-programming-interface)
- [정보은닉(Information Hiding)과 캡슐화(Encapsulation)](#정보은닉information-hiding과-캡슐화encapsulation)
  - [둘의 차이](#둘의-차이)
- [Architecture와 Architecture Style의 차이](#architecture와-architecture-style의-차이)
- [REST(7가지 제약 조건)](#rest7가지-제약-조건)

---

# API(Application Programming Interface)
API란 정의 및 프로토콜 집합을 이용해 두 소프트웨어 구성 요소가 서로 통신할 수 있게 하는 매커니즘으로 인터페이스는 두 애플리케이션 간의 계약이라고 할 수 있다.

Interface
객체가 정의하는 연산의 모든 시그니처(이름, 매개변수, 반환)을 일컫는 말로 객체의 인터페이스는 객체가 받아서 처리할 수 있는 연산의 집합이다.  
아래는 인터페이스의 장점들이다.
- Communication
- Specification
- Information Hiding
- Encapsulation
- Implementation

# 정보은닉(Information Hiding)과 캡슐화(Encapsulation)
정보은닉과 캡슐화 모두 응집력을 높이고 결합도를 낮춘다.  
캡슐화는 경계를 만들고 요소들을 묶는다. 이로써 소프트웨어는 응집력을 얻는다.  
정보은닉은 추상화 레이어를 제공함으로써 각각의 코드 사이의 의존성을 낮춘다.  

캡슐화는 자바에서 주로 클래스와 추상화를 통해 이뤄지는데 하나의 클래스 안에 여러 메서드들을 구현해 놓는것이 이에 해당한다.  
정보은닉은 캡슐화된 요소들의 세부 구현 사항을 외부에 숨기는 장치로 사용자에게는 인터페이스로 메서드를 제공하고 내부 알고리즘을 변경할 수 있어 추후 변경사항이 있을 때 유용하다. 자바에서 정보은닉은 주로 접근제어자에 의해 이루어진다.
## 둘의 차이

# Architecture와 Architecture Style의 차이

Architecture은 구조 그 자체
Architecture style은 그걸 구현하기 위해 사용된 공통적인 구조로 그 스타일을 따르는 아키텍쳐가 지켜야 하는 제약조건들의 집합이다.

# REST(7가지 제약 조건)
REST란 REpresentational State Transfer로 State는 웹 애플리케이션의 상태, Transfer는 상태의 전송을 의미한다.  
representation은 어떤 리소스의 특정 시점의 상태를 반영하고 있는 정보로 representation data와 representation metadata로 구성되는데 전자는 "hello"와 같은 response data를 의미하고 후자는 Content-Type: text/plain 같은 metadata를 의미한다. 후자에는 [요건](https://datatracker.ietf.org/doc/html/rfc7231#section-3.1)에 만족하는 것과 아닌것이 존재한다.


1. Starting with the Null style
   - 아키텍쳐 설계 과정에는 두 가지 관점이 있다.
      - 0부터 시작해서 의도된 시스템의 니즈를 충족할 때 까지 친숙한 요소들로 채우는 것으로 창의성을 가져온다.
      - 시스템 니즈를 전체로 점진적으로 제약조건들을 확인하고 적용함으로써 자연스럽게 전체 시스템을 만들어 가는 것으로 시스템 문맥의 이해와 제약을 강조한다
    - REST는 두번째 프로세스를 이용해 만들어졌다.
2. Client-Sever
   - 관심사의 분리는 Client-Server 제약조건에서 가장 중요한 요소로 유저 인터페이스 관점을 데이터 저장 관점에서 분리시킨다.
   - 해당 관점은 유저 인터페이스에게 다양한 플랫폼에서의 범용성과 서버 요소의 확장 가능성의 관점에서 중요하다.
   - 결론적으로 관심사의 분리를 통해 각각의 요소가 독립적으로 발전할 수 있게 해준다.
3. Stateless
   - 클라이언트와 서버의 통신은 stateless여야 한다. 클라이언트가 보내는 요청은 해당 작업을 하기 위해 서버가 필요로 하는 모든 것을 포함하고 있어야 한다.
   - 해당 제약조건은 가시성, 신뢰성, 확장성을 가져다준다.
   - 하지만 반복적인 데이터를 증가시켜 네트워크 퍼포먼스를 낮추고 상태를 클라이언트에 저장하므로써 서버의 일관된 작업과 방해한다
4. Cache
   - 네트워크 효율을 위해 캐시 제약을 추가했다.
   - 캐시 제약은 요청에 대한 응답에 암시적이나 명시적으로 캐시가능한지 여부를 알려줘야 한다. 만약 응답이 캐싱돼있다면 클라이언트 캐시는 동등한 다음 요청에 대해 재사용한다.
   - 하지만 효율성, 확장성, 사용자 만족도를 높여주지만 오래된 데이터에 의해 신뢰성을 낮춘다
5. **Uniform Interface**
    - REST Architecture style을 다른 스타일과 비교해 특별하게 만들어주는 핵심 특징이다
    - 소프트웨어 엔지니어링의 일반적 원리를 적용함으로써 단순성과 가시성을 증가시킨다
    - 실행이 서비스와 분리돼 독립성을 증가시킨다
    - 하지만 표준화된 폼으로 인해 효율성을 낮춘다
    - 일반적인 웹을 위한 많은 양의 하이퍼미디어 데이터 전송에 있어서 효과적인게 REST다
    - 필딩 제약 조건
        - Indentification of Resources
          - URI 등으로 리소스를 식별할 수 있게 해야 하며 시간에 따른 상태 변화가 있을 수 있으므로 그에 대한 고려도 포함되어야 한다.
        - Manipulation of Resources through Representations
          - 주어진 resource의 representation과 metadata의 조합으로 클라이언트가 리소스를 조작할 수 있어야 한다.
        - Self-descriptive Messages
          - 클라이언트가 문맥을 파악해 데이터를 찾을 수 있도록 표준 MIME 타입 등을 이용해야 한다. 
        - Hypermedia as the Engine of Application(HATEOAS)
          - 표현에 상태 전환에 필요한 링크가 포함되어야 한다
6. Layered System
   - 미래의 인터넷 스케일 요구에 대응해 layered system이 추가됐다.
   - 계층 관계에서 직접 통신하는 계층 너머를 알 수 없게 만든다. 이로써 단일 계층의 복잡성을 제한하고 기질 독립성을 촉진한다.
   - 레거시 서비스를 캡슐화하고 새로운 서비스를 레거시 클라이언트로부터 보호한다.
   - 잘 사용되지 않는 공유 중계 컴포넌트들을 단순화한다.
   - 공유 중계 컴포넌트는 시스템 확장성도 증진시킨다
   - 방화벽과 같은 레이어로 보안성을 강화시킬 수도 있다.
   - 하지만 layered system은 데이터를 처리하는데 오버헤드를 일으켜서 latency를 만들어 유저 경험을 하락시킨다 이는 캐시로 상쇄시킬 수 있다.
   - layered system은 self-descriptive한 REST의 특성 때문에 중계 컴포넌트가 활발하게 메시지를 전송할 수 있다 
7. Code On Demend
   - 클라이언트가 스크립트나 applets(어도비 같은 내장 프로그램) 코드를 다운로드하고 실행하므로써 확장될 수 있게 해준다.
   - 따라서 클라이언트는 미리 실행되어야할 기능들의 갯수를 단순화할 수 있고 시스템의 확장성에 따라 배포 이후에 다운받을 수 있게 해준다.
   - 하지만 가시성을 낮추기 때문에 REST 제약조건 중 유일하게 선택사항이다.

일반적으로는 리처드슨 성숙도 모델 레벨 2에 Collection Pattern만 만족해도 REST API라고 부르고 있다




출처  
https://nsikakimoh.com/blog/encapsulation-vs-information-hiding#what-is-encapsulation
https://www.ics.uci.edu/~fielding/pubs/dissertation/rest_arch_style.htm#fig_5_1  
https://blog.npcode.com/2017/04/03/rest%ec%9d%98-representation%ec%9d%b4%eb%9e%80-%eb%ac%b4%ec%97%87%ec%9d%b8%ea%b0%80/