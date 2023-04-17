
- [API(Application Programming Interface)](#apiapplication-programming-interface)
- [정보은닉(Information Hiding)과 캡슐화(Encapsulation)](#정보은닉information-hiding과-캡슐화encapsulation)
  - [둘의 차이](#둘의-차이)
- [Architecture와 Architecture Style의 차이](#architecture와-architecture-style의-차이)
- [REST(7가지 제약 조건)](#rest7가지-제약-조건)

---

# API(Application Programming Interface)
어플리케이션을 만드는 인터페이스

Interface
- Communication
- Specification
- Information Hiding
- Encapsulation
- Implementation

# 정보은닉(Information Hiding)과 캡슐화(Encapsulation)

## 둘의 차이

# Architecture와 Architecture Style의 차이

Architecture은 구조
Architecture style은 그걸 구현하기 위해 사용된 공통적인 구조
# REST(7가지 제약 조건)

1. Starting with the Null style
2. Client-Sever
3. Stateless
4. Cache
5. **Uniform Interface**
    - REST Architecture style을 다른 스타일과 비교해 특별하게 만들어주는 핵심 특징이다
    - 소프트웨어 엔지니어링의 일반적 원리를 적용함으로써 단순성과 가시성을 증가시킨다
    - 실행이 서비스와 분리돼 독립성을 증가시킨다
    - 하지만 표준화된 폼으로 인해 효율성을 낮춘다
    - 일반적인 웹을 위한 많은 양의 하이퍼미디어 데이터 전송에 있어서 효과적인게 REST다
    - 필딩 제약 조건
        - Indentification of Resources
        - Manipulation of Resources through Representations
        - Self-descriptive Messages
        - Hypermedia as the Engine of Application
6. Layered System
7. Code On Demend

일반적으로는 리처드슨 성숙도 모델 레벨 2에 Collection Pattern만 만족해도 REST API라고 부르고 있다
