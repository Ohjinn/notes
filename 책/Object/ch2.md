- [02 객체지향 프로그래밍](#02-객체지향-프로그래밍)
  - [요구사항 살펴보기](#요구사항-살펴보기)
  - [협력, 객체, 클래스](#협력-객체-클래스)
    - [도메인의 구조를 따르는 프로그램 구조](#도메인의-구조를-따르는-프로그램-구조)
    - [클래스 구현하기](#클래스-구현하기)
    - [자율적인 객체](#자율적인-객체)
    - [프로그래머의 자유](#프로그래머의-자유)
    - [협력하는 객체들의 공동체](#협력하는-객체들의-공동체)
    - [협력](#협력)
  - [할인 요금 계산을 위한 협력 시작하기](#할인-요금-계산을-위한-협력-시작하기)
    - [할인 정책과 할인 조건](#할인-정책과-할인-조건)
  - [상속과 다형성](#상속과-다형성)
    - [컴파일 시간 의존성과 실행 시간 의존성](#컴파일-시간-의존성과-실행-시간-의존성)
    - [차이에 의한 프로그래밍](#차이에-의한-프로그래밍)
    - [상속과 인터페이스](#상속과-인터페이스)
    - [다형성](#다형성)
    - [인터페이스와 다형성](#인터페이스와-다형성)
  - [추상화와 유연성](#추상화와-유연성)
    - [유연한 설계](#유연한-설계)
    - [추상 클래스와 인터페이스 트레이드오프](#추상-클래스와-인터페이스-트레이드오프)
  - [코드 재사용](#코드-재사용)
    - [상속](#상속)
    - [합성](#합성)


# 02 객체지향 프로그래밍
이번 장은 앞으로의 주제들은 얕은 수준으로 훑어보는 장이다.

## 요구사항 살펴보기
이번 장은 온라인 영화 예매 시스템이다

제목, 상영시간, 가격정보 등을 가지고 있는 명사는 `영화` 실제로 관객들이 영화를 관람하는 사건은 `상영`이며 하나의 영화는 하루 중 다양한 시간대에 걸쳐 한 번 이상 상영될 수 있다.

특정 조건을 만족하는 예매자는 요금을 할인받을 수 있으며 할인액은 `할인 조건`, `할인 정책` 두 가지 규칙에 의해 결정된다.

할인 정책은 다음과 같다.
- 할인 조건: 가격의 할인 여부를 결정하며 순서조건과 기간 조건을 섞는 것은 가능하다.
  - 순서 조건: 영화의 순번을 이용해 할인 여부를 결정하는 규칙
  - 기간 조건: 영화 상영 시작 시간을 이용해 할인 여부를 결정, 기간 조건은 아래 세 부분으로 구성되며 영화 시작 시간이 해당 기간 안에 포함될 경우 요금을 할인한다.
    - 요일
    - 시작시간
    - 종료시간
- 할인 정책: 영화별로 최대 하나의 할인 정책만 할당 가능하다.
  - 금액 할인 정책
  - 비율 할인 정책


## 협력, 객체, 클래스
객체지향 설계를 위해선 어떤 클래스를 필요로 하는 지가 아닌 객체에 초점을 맞춰야 한다.

1. 어떤 클래스가 필요한지 고민하기 전에 어떤 객체들이 필요한지 고민하라.
   - 어떤 객체들이 어떤 상태와 행동을 가지는지 결정해야 한다.
2. 객체를 독립적인 존재가 아닌 협력하는 공동체의 일원으로 봐야 한다.
   - 공동체의 일원으로 보는 것은 설계를 유연하고 확장 가능하게 만든다.
   - 객체의 윤곽이 잡히면 공통된 특성과 상태를 가진 객체들을 타입으로 분류하고 타입을 기반으로 클래스를 구현한다.


### 도메인의 구조를 따르는 프로그램 구조
도메인: 문제를 해결하기 위해 사용자가 프로그램을 사용하는 분야  

객체지향 패러다임은 요구사항을 분석하는 초기 단계부터 구현 단계까지 객체라는 동일한 추상화 기법을 사용할 수 있다. 요구사항과 프로그램을 객체라는 동일한 관점에서 바라볼 수 있기 때문에 도메인을 구성하는 개념들이 객체와 클래스로 매끈하게 연결된다. 도메인의 구조와 클래스의 구조는 유사한 형태를 띠어야 한다.

도메인을 구성하는 개념과 관계는 다음과 같고
![도메인 구조](Images/2-1.png)

도메인 구조를 기반으로 유사한 형태의 클래스 구조는 다음과 같다.
![클래스 구조](Images/2-2.png)

### 클래스 구현하기
클래스를 구성하는 인스턴스 변수의 가시성은 private이고 메서드의 가시성은 public이다. 외부에서는 객체의 속성에 직접 접근할 수 없도록 막고 적절한 public 메서드를 통해서만 내부 상태를 변경할 수 있게 해야한다.


클래스 경계의 명확성은 객체의 자율성을 보장하고 프로그래머에게는 구현의 자유를 제공한다.

### 자율적인 객체
객체의 특성은
- 객체는 `상태`와 `행동`을 함께 가지는 복합적인 존재다.
- 객체는 스스로 판단하고 행동하는 `자율적 존재`다.

데이터와 기능을 객체 내부로 함께 묶는 것을 캡슐화라고 부른다. 대부분의 OOP 언어들은 상태와 행동을 캡슐화하는 것에서 나아가 접근제어(access control) 메커니즘을 제공하는데 이를 위해 접근 수정자(access modifier)를 제공한다.

캡슐화와 접근 제어는 객체를 두 부분 `퍼블릭 인터페이스` `구현` 두 가지로 나눈다.이는 `인터페이스와 구현의 분리` 원칙이다. 퍼블릭 인터페이스는 오직 public 메서드, private이나 protected, 속성은 구현에 포함된다.

### 프로그래머의 자유
프로그래머의 역할을 `클래스 작성자` `클라이언트 프로그래머`로 구분해서 클래스 작성자는 클라이언트 프로그래머에게 필요한 부분만 공개하고 나머지는 숨겨야 한다. 클라이언트 프로그래머가 숨겨 놓은 부분에 마음대로 접근할 수 없도록 방지해 외부 영향을 걱정하지 않아도 된다. 이를 `구현 은닉`이라고 부른다.

### 협력하는 객체들의 공동체

Money처럼 의미를 좀 더 명시적이고 분명하게 표현할 수 있다면 객체를 사용해서 해당 개념을 구현하는 것이 설계의 명확성과 유연성을 높이는데 좋다.

<details>
  <summary>Money</summary>

  ```java
public class Money {
    public static final Money ZERO = Money.wons(0);

    private final BigDecimal amount;

    public static Money wons(long amount) {
        return new Money(BigDecimal.valueOf(amount));
    }

    public static Money wons(double amount) {
        return new Money(BigDecimal.valueOf(amount));
    }

    public Money(BigDecimal amount) {
        this.amount = amount;
    }

    public Money plus(Money amount) {
        return new Money(this.amount.add(amount.amount));
    }

    public Money minus(Money amount) {
        return new Money(this.amount.subtract(amount.amount));
    }

    public Money times(double percent) {
        return new Money(this.amount.multiply(
                BigDecimal.valueOf(percent)
        ));
    }

    public boolean isLessThan(Money other) {
        return amount.compareTo(other.amount) < 0;
    }

    public boolean isGreaterThanOrEqual(Money other) {
        return amount.compareTo(other.amount) >= 0;
    }
}

  ```

</details>

영화를 예매하기 위해 Screening, Movie, Reservation 인스턴스는 서로의 메서드를 호출해 상호작용한다. 이를 `협력`이라고 부른다.
<details>
  <summary>Screening</summary>

  ```java
public class Screening {
    private Movie movie;
    private int sequence;
    private LocalDateTime whenScreened;

    public Screening(Movie movie, int sequence, LocalDateTime whenScreened) {
        this.movie = movie;
        this.sequence = sequence;
        this.whenScreened = whenScreened;
    }

    public LocalDateTime getStartTime() {
        return whenScreened;
    }

    public boolean isSequence(int sequence) {
        return this.sequence == sequence;
    }

    public Money getMovieFee() {
        return movie.getFee();
    }

    public Reservateion reserve(Customer customer, int audienceCount) {
        return new Reservateion(customer, this, calculateFee(audienceCount), audienceCount);
    }

    private Money calculateFee(int audienceCount) {
        return movie.calculateMovieFee(this).times(audienceCount);
    }
}

  ```
</details>

<details>
  <summary>Reservation</summary>

  ```java
public class Reservateion {
    private Customer customer;
    private Screening screening;
    private Money fee;
    private int audienceCount;

    public Reservateion(Customer customer, Screening screening, Money fee, int audienceCount) {
        this.customer = customer;
        this.screening = screening;
        this.fee = fee;
        this.audienceCount = audienceCount;
    }
}
  ```
</details>
<br>

### 협력
- 객체의 내부 상태는 외부에서 접근하지 못하도록 감춰야 한다. 객체는 다른 객체의 인터페이스에 공개된 행동을 수행하도록 `요청`할 수 있다. 요청을 받은 객체는 자율적인 방법에 따라 요청을 처리한 후 `응답`한다.

- 객체가 다른 객체와 상호작용할 수 있는 유일한 방법은 메시지를 `전송`하는 것 뿐이고 다른 객체에게 요청이 도착할 때 해당 객체가 메시지를 `수신`했다고 이야기한다. 

- 메시지를 수신한 객체는 스스로의 결정에 따라 자율적으로 자신의 방법인 `메서드`를 통해 처리한다.

- 메시지와 메서드를 확실하게 구분하는 것에서 다형성이 출발한다.


## 할인 요금 계산을 위한 협력 시작하기
예매 요금을 계산하는 협력을 살펴보자. Movie는 제목, 상영시간, 기본요금, 할인정책을 속성으로 가진다.

<details>
  <summary>Movie</summary>

  ```java
public class Movie {
    private String title;
    private Duration runningTime;
    private Money fee;
    private DiscountPolicy discountPolicy;

    public Movie(String title, Duration runningTime, Money fee, DiscountPolicy discountPolicy) {
        this.title = title;
        this.runningTime = runningTime;
        this.fee = fee;
        this.discountPolicy = discountPolicy;
    }

    public Money calculateMovieFee(Screening screening) {
        return fee;
    }

    public Money getFee(Screening screening) {
        return fee.minus(discountPolicy.calculateDiscountAmount(screening));
    }
}

  ```
</details>

위의 코드에서는 어떤 할인 정책을 사용할 것인지 사용할 정책 종류를 판단하지 않는 것처럼 보인다.  
하지만, 여기에는 `상속`과 `다형성`이 내재되어 있다. 그리고 그 기반은 `추상화`에서 나온다.

### 할인 정책과 할인 조건
할인조건은 `금액 할인 정책`과 `비율 할인 정책`으로 나뉜다고 이야기했다. 두 가지 할인 정책을 각각 AmountDiscountPolicy와 PercentDisountPolicy라는 클래스로 구현할 것이다. 두 코드의 공통 코드를 보관할 장소가 부모클래스이자 추상 클래스인 DiscountPolicy다.

<details>
<summary>DiscountPolicy abstract class</summary>

```java
public abstract class DiscountPolicy {
    private List<DiscountCondition> condition = new ArrayList<>();

    public DiscountPolicy(DiscountCondition ... conditions) {
        this.condition = Arrays.asList(conditions);
    }

    public Money calculateDiscountAmount(Screening screening) {
        for(DiscountCondition each: condition) {
            if (each.isSatisfiedBy(screening)) {
                return getDiscountAmount(screening);
            }
        }
    }

    abstract protected Money getDiscountAmount(Screening screening);
}
```

</details>

discountPolicy는 DiscountCondition의 리스트인 conditions를 인스턴스 변수로 가지기 때문에 하나의 할인 정책은 여러 개의 할인 조건을 포함할 수 있다.

calculateDiscountAmount 메서드는 isSatisfiedBy 메서드를 실행시키고 isSatisfiedBy 인자로 전달된 Screening이 할인 조건을 만족시키는지 여부를 검사해 하나라도 있는 경우 추상 메서드 getDiscountAmount를 호출해 할인 요금을 반환한다.

부모 클래스에 기본적인 알고리즘 흐름을 구현하고 중간에 필요한 처리를 자식 클래스에게 위임하는 디자인 패턴을 `Template Method` 패턴이라고 부른다.

<details>
<summary>DiscountCondition interface</summary>

```java
  public interface DiscountCondition {
      boolean isSatisfiedBy(Screening screening);
  }
```
</details>

<details>
<summary>AmountDiscountPolicy</summary>

```java
public class AmountDiscountPolicy extends DiscountPolicy{
    private Money discountAmount;

    public AmountDiscountPolicy(Money discountAmount, DiscountCondition... conditions) {
        super(conditions);
        this.discountAmount = discountAmount;
    }

    @Override
    protected Money getDiscountAmount(Screening screening) {
        return discountAmount;
    }
}
```
</details>

<details>
<summary>PercentDiscountPolicy</summary>

```java
public class AmountDiscountPolicy extends DiscountPolicy{
    private Money discountAmount;

    public AmountDiscountPolicy(Money discountAmount, DiscountCondition... conditions) {
        super(conditions);
        this.discountAmount = discountAmount;
    }

    @Override
    protected Money getDiscountAmount(Screening screening) {
        return discountAmount;
    }
}
```
</details>

DiscountCondition은 인터페이스를 이용해 선언돼있다. 영화 예매 시스템에는 순번 조건과 기간 조건의 두 가지 할인 조건이 존재하고, SequenceCondition과 PeriodCondition이라는 클래스로 구현한다.

<details>
<summary>SequenceCondition</summary>

```java
public class SequenceCondition implements DiscountCondition{
    private int sequence;

    public SequenceCondition(int sequence) {
        this.sequence = sequence;
    }

    @Override
    public boolean isSatisfiedBy(Screening screening) {
        return screening.isSequence(sequence);
    }
}
```
</details>

DiscountCondition의 자식들 모두 각각의 내부 인스턴스와 getDiscountAmount 메서드를 통해 할인되어야 하는 가격을 반환한다.

SequenceCondition은 할인 여부로 순번을 이용하고

<details>
<summary>PeriodCondition</summary>

```java
public class PeriodCondition implements DiscountCondition{
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;

    public PeriodCondition(DayOfWeek dayOfWeek, LocalTime startTime, LocalTime endTime) {
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    @Override
    public boolean isSatisfiedBy(Screening screening) {
        return screening.getStartTime().getDayOfWeek().equals(dayOfWeek) &&
                startTime.compareTo(screening.getStartTime().toLocalTime()) <= 0 &&
                endTime.compareTo(screening.getStartTime().toLocalTime()) >= 0;
    }
}

```
</details>

PeriodCondition은 상영 시작 시간이 특정한 기간 안에 포함되는지 여부를 판단한다.

위의 코드를 다이어그램으로 그리면 다음과 같다.
![Policy, Condition](Images/2-3.png)

이제 지금까지 만든 것을 사용해보자.

<details>
<summary>Movie Reservateion</summary>

```java
public class MovieReservation {
    public static void main(String[] args) {
        Movie avatar = new Movie(
                "아바타",
                Duration.ofMinutes(120),
                Money.wons(10000),
                new AmountDiscountPolicy(
                        Money.wons(800),
                        new SequenceCondition(1),
                        new SequenceCondition(10),
                        new PeriodCondition(
                                DayOfWeek.MONDAY,
                                LocalTime.of(10, 0),
                                LocalTime.of(11, 59)),
                        new PeriodCondition(
                                DayOfWeek.THURSDAY,
                                LocalTime.of(10, 0),
                                LocalTime.of(20, 59)
                        )
                )
        );
    }
}
```
</details>

한 타임의 영화는 하나의 AmountDiscountPolicy(비율 혹은 amount)만 설정 가능하고 DiscountCondition은 여러개가 설정 가능하다.

## 상속과 다형성

### 컴파일 시간 의존성과 실행 시간 의존성
Movie 클래스 자체에는 할인 정책에 대한 판단을 하지 않는데 이는 상속과 다형성에 의해 가능하다.

![polymorphism](Images/2-4.png)

코드 수준에서 Movie는 DiscountPolicy에 의존하지만 실행 시에는 AmountDiscountPolicy 혹은 PercentDiscountPolicy 둘 중 하나에 의존한다.

- 확장 가능한 객체지향 설계가 가지는 특징: 코드의 의존성과 실행 시점의 의존성이 다르다.
  - 장점: 코드가 더 유연해지고 확장 가능해진다
  - 단점: 이해하기 힘들다. 코드를 이해하기 위해 코드뿐만 아니라 객체의 생성과 연결부분을 찾아야 한다

### 차이에 의한 프로그래밍
클래스를 추가하고 싶을 때 기존 클래스와 유사하다면 재사용 하는 것이 나은 방법인데 그것을 가능케 하는게 `상속`이다. 

부모 클래스와 다른 부분만을 추가해서 새로운 클래스를 쉽고 빠르게 만드는 방법을 `차이에 의한 프로그래밍`이라고 부른다.

### 상속과 인터페이스
상속은 단순한 메서드나 인스턴스 변수의 재사용이 아니다.  
인터페이스는 객체가 이해할 수 있는 메시지의 목록을 정의한다. 상속을 통해 자식 클래스는 자신의 인터페이스에 부모 클래스의 인터페이스를 포함하게 된다. 자식 클래스는 부모클래스와 동일한 타입으로 간주할 수 있다. 자식 클래스가 부모 클래스를 대신하는 것을 `업캐스팅`이라고 한다.

![업캐스팅](Images/2-5.png)
<br><br>

### 다형성
```java
public Money getFee(Screening screening) {
    return fee.minus(discountPolicy.calculateDiscountAmount(screening));
}
```
Movie에서 DiscountPolicy 인스턴스에게 calculateDiscountAmount라는 `메시지`를 전달한다. 실행되는 `메서드`는 연결된 객체의 클래스에 따라 달라진다. 이를 `다형성`이라 부른다. 다시말해 다형성은 동일한 메시지를 수신했들 때 객체의 타입에 따라 다르게 응답할 수 있는 능력을 의미한다.

메시지와 메서드를 실행 시점에 바인딩 하는 것을 `지연 바인딩` 혹은 `동적 바인딩` 이라고 부른다. 그 반대를 `초기 바인딩` 혹은 `정적 바인딩`이라고 부른다.


```markdown
상속은 `구현 상속(서브클래싱)`과 `인터페이스 상속(서브타이핑)`으로 구분되는데 순수한 코드 재사용 목적을 구현상속, 부모와 자식의 인터페이스 공유 상속을 인터페이스 상속이라 부른다. 인터페이스 재사용이 아닌 구현 재사용 목적의 상속은 변경에 취약한 코드를 낳는다.
```

### 인터페이스와 다형성
구현의 공유는 필요없고 순수하게 인터페이스만 공유하고 싶을 때는 `인터페이스`라는 프로그래밍 요소를 사용하면 된다. DiscountCondition이 이에 해당된다.

## 추상화와 유연성
추상 클래스와 인터페이스 모두 구현의 일부 혹은 전체를 자식 클래스가 결정할 수 있도록 결정권을 위임한다. 이런 추상화를 사용하면
- 추상화의 계층만 따로 떼어놓고 보면 요구사항의 정책을 높은 수준에서 서술할 수 있다.
  - 굳이 개수를 언급할 필요 없이 `영화 예매 요금은 최대 하나의 할인 정책과 다수의 할인조건을 이용해 계산할 수 있다.`라고 표현 가능하다.
  - 세부 내용을 무시한 채 상위정책을 쉽고 간단하게, 도메인의 중요한 개념을 설명할 수 다.
  - 추가적인 할인 정책이나 조건의 추가가 기존의 협력 흐름 Movie -> DiscountPolicy -> DiscountCondition을 따르게 된다.
  - 디자인 패턴이나 프레임워크 모두 추상화를 이용해 상위 정책을 정의하는 객체지향 매커니즘을 활용한다.
- 설계가 더 유연해진다.


### 유연한 설계
이제 할인 정책이 적용되지 않은 NoneDiscountPolicy도 구현해보자.

<details>
<summary>NoneDiscountPolicy</summary>

```java
public class NoneDiscountPolicy extends DiscountPolicy{
    
    @Override
    protected Money getDiscountAmount(Screening screening) {
        return Money.ZERO;
    }
}
```
</details>

기존의 Movie와 DiscountPolicy를 수정하지 않고 새로운 클래스의 추가만으로 애플리케이션의 기능을 확장할 수 있다. 이를 `컨텍스트 독립성`이라 한다.

### 추상 클래스와 인터페이스 트레이드오프
NoneDiscountPolicy의 getDiscountAmount메서드는 어떤 값을 반환해도 사실 상관이 없다. 

```java
    public Money calculateDiscountAmount(Screening screening) {
        for(DiscountCondition each: condition) {
            if (each.isSatisfiedBy(screening)) {
                return getDiscountAmount(screening);
            }
        }
        return Money.ZERO;
    }
```
DiscountPolicy의 부모 클래스에 정의되어 있는 calculateDiscountAmount에서 DiscountCondition이 존재하지 않기 때문에 Money.ZERO가 반환되게 되어있다. 해당 개념을 명확하게 하기 위해 인터페이스를 추가해도 된다.

```java
public interface DiscountPolicy {
  Money calculateDiscountAmount(Screening screening);
}
```

```java
public abstract class DefaultDiscountPolicy implements DiscountCondition {
  ...
}
```

```java
public class NoneDiscountPolicy implements DiscountPolicy {
  @Override
  public Money calculateDiscountAmount(Screening screening) {
    return Money.ZERO;
  }
}
```

이렇게 구현하면 개념적 혼란 자체를 줄일 수 있다. 다이어그램은 다음과 같다.

![abstract to interface](Images/2-6.png)

이상적으로는 좋지만 현실적으로는 NoneDiscountPolicy만을 위해 인터페이스를 추가하는 것은 과하다. 항상 트레이드오프를 생각해야 한다.

## 코드 재사용
코드 재사용 방법에는 `상속`과 `합성`이 있다. 합성은 다른 객체의 인스턴스를 자신의 인스턴스 변수로 포함해서 재사용하는 방법으로 코드 재사용을 위해 합성이 더 좋은 방법이다.

### 상속
상속의 단점은
- 캡슐화를 위반한다.
  - 상속을 이용하기 위해선 부모클래스의 내부 구조를 잘 알고 있어야 한다.
    - 부모 클래스의 구현이 자식 클래스에 노출되며 강하게 결합돼 부모 클래스를 변경하면 자식클래스도 변경되어야 할 확률이 올라간다.
  - 설계가 유연하지 않다.
    - 부모 클래스와 자식 클래스 사이의 관계를 컴파일 시점에 결정하기 때문에 실행 시점에 객체의 종류를 변경하는 것은 불가능하다.
    - 실행 시점에 금액 할인을 비율 할인으로 변경하고 싶다면 이미 생성된 객체의 클래스를 변경할 수 없기 때문에 PercentDiscountPolicy 인스턴스를 생성한 후 AmountDiscountPolicy 상태를 복사할 수 밖에 없다.

상속이 아닌 인스턴스 변수로 연결한 기존 방법을 사용하면 실행 시점에 할인 정책을 간단하게 변경할 수 있다.
```java
public class Movie{
  private DiscountPolicy discountPolicy;

  public void changeDiscountPolicy(DiscountPolicy discountAmount) {
    this.discountPolicy = discountPolicy;
  }
}

Movie avatar = new Movie(
        "아바타",
        Duration.ofMinutes(120),
        Money.wons(10000),
        new AmountDiscountPolicy(Money.wons(800), ...)

avatar.changeDiscountPolicy(new PercentDiscountPolicy(0, 1));
```

이 예제를 보면 상속보다 인스턴스 변수로 관계를 연결한 설계가 더 유연하다.

### 합성
Movie는 요금 계산을 위해 DiscountPolicy의 코드를 재사용한다. 상속과 다른 점은 상속은 부모와 자식 클래스를 컴파일 시점에 강하게 결합하지만 Movie는 DiscountPolicy의 인터페이스를 통해 약하게 결합된다.

Movie는 DiscountPolicy의 내부 구현에 대해는 전혀 알지 못한다. 합성은 상속의 두 가지 문제점을 모두 해결하고 설계를 유연하게 만든다. 코드 재사용을 위해서는 상속보다는 합성을 사용하는 것이 더 좋은 방법이다.


객체지향 설계의 핵심은 적절한 협력을 식별하고 협력에 필요한 역할을 정의한 후에 역할을 수행할 수 있는 적절한 객체에게 적절한 책임을 할당하는 것이다.