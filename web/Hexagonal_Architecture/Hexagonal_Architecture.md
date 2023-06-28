- [Hexagonal Architecure](#hexagonal-architecure)
- [POJO](#pojo)
- [우아한객체지향 세미나](#우아한객체지향-세미나)
  - [1. 의존성을 이용해 설계 진화시키기](#1-의존성을-이용해-설계-진화시키기)
    - [클래스 의존성](#클래스-의존성)
    - [패키지 의존성](#패키지-의존성)
    - [양방향 의존성을 피해라](#양방향-의존성을-피해라)
    - [다중성이 적은 방향을 선택해라](#다중성이-적은-방향을-선택해라)
    - [의존성이 필요 없다면 제거하라](#의존성이-필요-없다면-제거하라)
    - [패키지 사이의 의존성 사이클을 제거하라](#패키지-사이의-의존성-사이클을-제거하라)


# Hexagonal Architecure
전통적 3계층은 다음과 같은 구성을 갖는데
1. Presentation
2. Domain
3. Data

알리스테어 콕번의 논의에 따르면 다음과 같이 표현될 수 있다.
1. User-side
2. Application
3. Database-side

Application을 제외한 외부는 여러개가 존재할 수 있고 이게 여럿이라는 걸 드러내기 위해 Hexagonal이라는 말을 쓴다. 애플리케이션과 어댑터는 포트로 연결되며 포트라는 인터페이스만 잘 사용하면 그 너머의 어댑터가 뭔지 몰라도 된다.

Hexagonal Architecture를 사용하는 이유는 UI와 비즈니스 로직이 뒤섞이는 문제를 해결하기 위함이다. 기존의 Layered Architecture에서 Application Layer 외의 계층들을 모두 외부로 취급하면 그게 Hexagonal Architecture다.

이렇게 사용하면 프로그램이 다른 외부 요소와 분리돼 테스트하기 쉽고, 재사용하기도 쉬워진다.

# POJO

# 우아한객체지향 세미나
## 1. 의존성을 이용해 설계 진화시키기
A가 B에 의존성을 가진다는 의미는 B가 바뀔 때 A가 바뀔 가능성이 있다는 것을 나타낸다.

### 클래스 의존성
4가지로 정리할 수 있다.
1. 연관관계
A에서 B로 이동할 수 있는 객체 참조가 존재하는 것
```java
class A {
    private B b;
}
```

2. 의존관계
코드에서 파라미터, 리턴타입, 메서드 내의 인스턴스 생성 등이 존재하는 것으로 일시적으로 관계를 맺고 헤어진다.
```java
class A {
    public B method(B b) {
        return new B();
    }
}
```

3. 상속관계
구현이 바뀌면 영향이 있는 것
```java
class A extends B {
}
```

1. 실체와 관계
인터페이스의 시그니쳐가 변경되면 영향이 있는 것
```java
class A implements B{
}
```

### 패키지 의존성
다른 패키지 import가 존재한다면 패키지 의존성이 존재한다고 말한다.

### 양방향 의존성을 피해라
```java
class A {
    private B b;
    public void setA(B b) {
        this.b = b;
        this.b.setA(this);
    }
}

class B {
    private A a;

    public void setA(A a) {
        this.a = a;
    }
}
```
여기선 양방향 의존성을

```java
class A {
    private B b;

    public void setA(B b) {
        this.b = b;
    }
}

class B {
}
```
여기선 A만 B에 의존하고 있다.

### 다중성이 적은 방향을 선택해라
```java
class A {
    private Collection<B> bs;
}
class B {
}
```

```java
class A {
}
class B {
    private A a;
}
```
A가 B의 List를 가지는 것 보다는 B가 A를 단방향 참조하는 것이 리스크를 작게 가져갈 수 있다.

### 의존성이 필요 없다면 제거하라

### 패키지 사이의 의존성 사이클을 제거하라
패키지 사이의 양방향 의존성, 사이클을 만들어내는 것은 모두 피해야 한다.



DB는 foreign키로 모든 탐색이 가능하지만 객체 지향에서는 어떤 방식이든 구현을 해줘야 한다.
관계의 방향 = 협력의 방향 = 의존성의 방향


정리중...