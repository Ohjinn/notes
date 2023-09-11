- [의존성 관리하기](#의존성-관리하기)
  - [1. 의존성 이해하기](#1-의존성-이해하기)
    - [변경과 의존성](#변경과-의존성)
    - [의존성 전이](#의존성-전이)
    - [런타임 의존성과 컴파일타임 의존성](#런타임-의존성과-컴파일타임-의존성)
    - [컨텍스트 독립성](#컨텍스트-독립성)
    - [의존성 해결하기](#의존성-해결하기)
  - [유연한 설계](#유연한-설계)
    - [의존성과 결합도](#의존성과-결합도)
    - [지식이 결합을 낳는다](#지식이-결합을-낳는다)
    - [추상화에 의존하라](#추상화에-의존하라)
      - [명시적 의존성](#명시적-의존성)
    - [new는 해롭다](#new는-해롭다)
    - [가끔은 생성해도 무방하다](#가끔은-생성해도-무방하다)
    - [표준 클래스에 대한 의존은 해롭지 않다](#표준-클래스에-대한-의존은-해롭지-않다)
    - [컨텍스트 확장하기](#컨텍스트-확장하기)
    - [조합 가능한 행동](#조합-가능한-행동)

# 의존성 관리하기
잘 설계된 객체는 작은 한 가지 역할을 가지고 다른 역할을 지닌 객체와 잘 협력한다. 하지만 과도한 협력은 다른 객체에 대해 알 것을 강요한다.  
따라서 필요한 의존성을 의존성을 유지하면서도 변경을 방해하는 의존성은 제거하는 것이 중요하다.

객체지향 설계란 의존성을 관리하고 객체가 변화를 받아들일 수 있게 의존성을 정리하는 기술이라고 할 수 있다.

이번 장에서는 의존성을 관리하는 방법에 대해 살펴본다.

## 1. 의존성 이해하기

### 변경과 의존성

의존성은 실행 시점과 구현 시점에 서로 다른 의미를 가진다.

- 실행 시점: 의존하는 객체가 정상적으로 동작하기 위해 실행 시에 의존 대상 객체가 반드시 존재해야 한다.
- 구현 시점: 의존 대상 객체가 변경될 경우 의존하는 객체도 함께 변경된다.

```java
public class PeriodCondition implements DiscountCondition {
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;

    public boolean isSatisfiedBy(Screening screening) {
        return screening.getStartTime().getDayOfWeek().equals(dayOfWeek) &&
        startTime.compareTo(screening.getStartTime().toLocalTime()) <= 0 &&
        endTime.compareTo(screening.getStartTime().toLocalTime) >= 0;
    }
}
```


![PeriodCondition](Images/8-1.png)

위의 코드에서 PeriodCondition은 Screening에 의존성을 가진다고도 할 수 있다.

![PeriodCondition Dependency](Images/8-2.png)

추가적으로 인스턴스로 DayOfWeek, LocalTime에 의존성을 가지고 인터페이스인 DiscountCondition에도 의존성을 가지고 있다.

### 의존성 전이


![Transitive Dependency](Images/8-3.png)

PeriodCondition이 Screening에 의존하고 있기 때문에 Screening이 의존하고 있는 Movie, LocalDateTime, Customer에도 간접적으로 의존하게 된다.

의존성은 함께 변경될 수 있는 가능성을 의미한다. 만약 Screening이 내부 구현을 효과적으로 캡슐화 했다면 의존성은 전이되지 않을 것이다.

의존성은
- 직접 의존성
  - 한 요소가 다른 요소에 직접 의존하는 경우(PeriodCondition과 Screening의 관계)
- 간접 의존성
  - 의존성 전이에 의해 영향이 전파되는 경우

두 가지로 나누기도 한다.

### 런타임 의존성과 컴파일타임 의존성
런타임 의존성과 컴파일 타임 의존성은 다를 수 있으며 유연하고 재사용 가능한 코드를 설계하기 위해서는 두 종류의 의존성을 서로 다르게 만들어야 한다.

Movie는 컴파일 타임에 DiscountPolicy에만 의존하기 때문에 AmountDiscountPolicy와 PercentDiscountPolicy에 대해 모르지만 런타임에는 둘 중 하나와 협력해야 한다.

![Movie Dependency](Images/8-4.png)

어떤 클래스의 인스턴스가 다양한 클래스의 인스턴스와 협력하기 위해서는 협력할 인스턴스의 구체적 클래스를 알아서는 안된다. 협력할 객체는 런타임에 해결돼야 한다. 컴파일 타임 구조와 런타임 구조 사이의 거리가 멀수록 설계가 유연해지고 재사용 가능해진다.

### 컨텍스트 독립성

유연한 설계를 위해서는 가능한 한 자신이 실행될 컨텍스트에 대해 구체적 정보를 최대한 적게 알아야 된다.

### 의존성 해결하기
컴파일 타임 의존성을 실행 컨텍스트에 맞는 적절한 런타임 의존성으로 교체하는 것을 의존성 해결이라고 부르는데 의존성 해결을 위해 일반적으로 세 가지 방법을 사용한다.

- 객체를 생성하는 시점에 생성자를 통해 의존성 해결
- 객체 생성 후 setter 메서드를 통해 의존성 해결
- 메서드 실행 시 인자를 이용해 의존성 해결

어떤 영화의 요금 계산에 금액 할인 정책을 적용하고 싶다면 Movie 생성 시에 AmountDiscountPolicy의 인스턴스를 Movie 생성자에 인자로 전달하면 된다.

첫 번째는

```java
Movie avatar = new Movie("아바타",
    Duration.ofMinutes(120),
    Money.wons(10000),
    new AmountDiscountPolicy
)
```

이렇게 생성자로

두 번째는

```java
public class Movie{
    public void setDiscountPolicy(DiscountPolicy discountPolicy) {
        this.discountPolicy = discountPolicy;
    }
}
```

객체 생성 이후에도 의존 대상을 변경하고 싶을 때 유용한데 인스턴스 변수를 설정하기 전까지 NullPointerException이 날 가능성이 있기 때문에 두 가지 방법을 혼합하는 것이 더 나은 방법이다.

## 유연한 설계
의존성을 관리하기 위한 몇 가지 원칙과 기법을 알아보자.

### 의존성과 결합도
의존성은 재사용성과 관련이 있는데 어떤 의존성이 다양한 환경에서 클래스를 재사용할 수 없도록 제한한다면 그 의존성은 바람직하지 못한 것이다. 다른 환경에서 재사용하기 위해 내부 구현을 변경하게 만드는 의존성은 바람직하지 않은 의존성이다. 이를 판단하는 기준이 `결합도`가 된다.

만약 Movie가 DiscountPolicy가 아니라 PercentDiscountPolicy에 의존하는 상황에서 AmountDiscountPolicy와 협력해야 하는 상황이 온다면 Movie는 PercentDiscountPolicy에 강하게 결합된다고 할 수 있고 좋은 의존이 아니다.

### 지식이 결합을 낳는다
더 많이 알수록 더 많이 결합된다. Movie가 DiscountPolicy가 아닌 PercentDiscountPolicy에 의존하는 경우 알고있는 지식의 양이 더 많아진다고 할 수 있다.

### 추상화에 의존하라
추상화는 세부 구조를 의도적으로 감춤으로써 결합도를 느슨하게 유지할 수 있다.

- 구체 클래스 의존성
- 추상 클래스 의존성
- 인터페이스 의존성

위에서 아래로 갈 수록 결합도가 느슨해진다.

#### 명시적 의존성

```java
public class Movie{
    private DiscountPolicy discountPolicy;

    public Movie(String title, Duration runningTime, Money fee, DiscountPolicy discountPolicy) {
        this.discountPolicy = discountPolicy;
    }
}
```
위에처럼 코드를 적어주면 명시적으로 의존성을 드러내줬기 때문에 코드를 직접 수정해야 하는 위험을 피할 수 있다.

의존성은 내부 구현에 숨겨두면 안되고 명시적으로 드러내야 한다.

### new는 해롭다
new를 사용하면 클래스 사이의 결합도가 극단적으로 높아진다.

- new 연산자 사용을 위해서는 구체 클래스의 이름을 직접 기술해야 한다.
- new연산자는 생성하려면 구체 클래스뿐만 아니라 어떤 인자를 이용해 클래스의 생성자를 호출해야 하는지도 알아야 한다.

구체 클래스에 직접 의존하면 결합도가 높아진다.

```java
public class Movie{
    private DiscountPolicy discountPolicy;

    public Movie(String title, Duration runningTime, Money fee) {
        this.discountPolicy = new AmountDiscountPolicy(
            Money.wons(800),
            new SequenceCondition(1),
            ...
        );
    }
}
```
다음과 같이 AmountDiscountPolicy의 변경에 의존하게 되기 때문에 불필요한 결합도를 급격하게 높이게 된다.

이 코드를 바로 위의 코드처럼 사용하게 되면 AmountDiscountPolicy 생성 책임은 Movie의 클라이언트로 옮겨지게 된다.

사용과 생성의 책임을 분리해서 Movie의 결합도를 낮추면 설계를 유연하게 만들 수 있다.

### 가끔은 생성해도 무방하다
협력하는 기본 객체를 설정하고 싶은 경우 클래스 안에 인스턴스를 직접 생성하는 방식이 유용한 경우도 있다.

만약 Movie가 주로 AmountDiscountPolicy와 협력하고 가끔 PercentDiscountPolicy와 협력한다면 인스턴스 생성 책임을 클라이언트로 넘긴담녀 클라이언트들 사이의 불필요한 중복이 될 수 있다.

이를 해결하기 위해 기본 객체를 생성하는 생성자를 추가하고 이 생성자에서 DiscountPolicy의 인스턴스를 인자로 받는 생성자를 체이닝하면 된다.

```java
public class Movie{
    private DiscountPolicy discountPolicy;

    public Movie(String title, Duration runningTime, Money fee) {
        this(title, runningTime, fee, new AmountDiscountPolicy());
    }

    public Movie(String title, Duration runningTime, Money fee, DiscountPolicy discountPolicy) {
        this.discountPolicy = discountPolicy;
    }
}
```
이런식으로 생성해주면 클라이언트는 추가된 생성자를 통해 AmountDiscountPolicy와 협력하면서 의존성을 교체할 수도 있다.

```java
public class Movie{
    private DiscountPolicy discountPolicy;

    public Money calculateMovieFee(Screening screening) {
        return calculateMovieFee(screening, new AmountDiscountPolicy());
    }

    public Money calculateMovieFee(Screening screening,
        DiscountPolicy discountPolicy) {
            return fee.minus(discountPolicy.calculateDiscountAmoun(screening));
        }
}
```

다음과 같이 메서드 오버로딩하는 경우에도 사용할 수 있다.

### 표준 클래스에 대한 의존은 해롭지 않다
변경될 확률이 거의 없는 클래스라면 의존성이 문제가 되지 않는다.

### 컨텍스트 확장하기

추상화를 통해 Movie의 변경 없이도 다양한 할인 정책에 대한 가격 계산을 할 수 있다.

1. 할인 혜택을 제공하지 않는 영화의 예매 요금 계산하기

할인 혜택을 제공하지 않는 경우 Movie 내의 discountPolicy 인스턴스를 null로 설정하고 계산시 null을 체크하는 로직을 넣을수도 있지만 그러면 Movie의 내부 코드를 직접 수정해야 하고 이는 버그 가능성을 높인다.

```java
public class NoneDiscountPolicy extends DiscountPolicy {
    @Override
    protected Money getDiscountAmount(Screening screening) {
        return Money.ZERO;
    }
}
```

할인 정책이 존재하지 않는 사실을 할인 정책의 한 종류로 간주하기 위해 NoneDiscountPolicy 클래스를 DiscountPolicy의 자식 클래스로 만들면 된다.

2. 중복 적용이 가능한 할인 정책
중복 할인 정책을 구현하는 OverlappedDiscountPolicy를 DiscountPolicy의 자식 클래스로 만들면 Movie와 DiscountPolicy의 협력 방식 수정 없이 할인 정책을 적용할 수 있다.

```java
class OverlappedDiscountPolicy extends DiscountPolicy {
  private discountPolicies: DiscountPolicy[] = new Array();

  constructor(...discountPolicies: DiscountPolicy[]) {
    super();
    this.discountPolicies = discountPolicies;
  }
}

const avatar = new Movie(
  "아바타",
  120,
  10000,
  new OverlappedDiscountPolicy(new AmountDiscountPolicy(...), new PercentDiscountPolicy(...))
);
```
설계가 유연했던 이유는 다음과 같다.
1. Movie가 DiscountPolicy라는 추상화에 의존하고 생성자를 통해 DiscountPolicy에 대한 의존성을 명시적으로 드러냈다.
2. new와 같은 구체 클래스를 직접적으로 다뤄야 하는 책임을 Movie 외부로 옮겼다.
3. DiscountPolicy 클래스에 자식 클래스를 추가해 간단하게 Movie가 사용될 컨텍스트를 확장할 수 있었다.


### 조합 가능한 행동
어떤 객체와 협력하느냐에 따라 객체의 행동이 달라지는 것은 유연하고 재사용 가능한 설계가 가진 특징으로 애플리케이션의 기능 확장이 쉬워진다.

유연하고 재사용 가능한 설계는 객체가 어떻게 하는지에 대한 나열이 아니라 객체의 조합을 통해 무엇을 하는지를 표현하는 클래스들로 구성된다.

의존성 관리를 잘하면 객체의 조합을 선언적으로 표현하는데 도움이 된다.