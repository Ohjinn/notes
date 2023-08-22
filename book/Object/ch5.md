- [05 책임 할당하기](#05-책임-할당하기)
  - [책임 주도 설계를 향해](#책임-주도-설계를-향해)
    - [데이터보다 행동을 먼저 결정하라](#데이터보다-행동을-먼저-결정하라)
    - [협력이라는 문맥 안에서 책임을 결정하라](#협력이라는-문맥-안에서-책임을-결정하라)
  - [책임 할당을 위한 GRASP 패턴](#책임-할당을-위한-grasp-패턴)
    - [도메인 개념에서 출발](#도메인-개념에서-출발)
    - [INFORMATION EXPERT패턴(정보 전문가에게 책임을 할당하라)](#information-expert패턴정보-전문가에게-책임을-할당하라)
    - [LOW COUPLING과 HIGH COHESION](#low-coupling과-high-cohesion)
    - [CREATER패턴](#creater패턴)
  - [구현을 통한 검증](#구현을-통한-검증)
    - [POLYMORPHISM패턴(다형성을 통해 분리하기)](#polymorphism패턴다형성을-통해-분리하기)
    - [Movie 클래스 개선하기](#movie-클래스-개선하기)
    - [변경과 유연성](#변경과-유연성)
  - [책임 주도 설계의 대안](#책임-주도-설계의-대안)


# 05 책임 할당하기
책임에 초점을 맞춰서 설계할 때 가장 큰 어려움은 어떤 객체에게 어떤 책임을 할당할지를 결정하기가 쉽지 않다는 것이다.  
다양한 책임 할당 방법이 존재하며 이번 장에서는 GRASP 패턴에 대해 이야기한다.

## 책임 주도 설계를 향해
데이터 중심 설계에서 책임 중심 설계로 전환하기 위해서는 두 가지 원칙을 따라야 한다.
- 데이터보다 행동을 먼저 결정하라
- 협력이라는 문맥 안에서 책임을 결정하라

### 데이터보다 행동을 먼저 결정하라
객체에게 중요한 것은 데이터가 아니라 외부에 제공하는 행동이다. 우리에게 필요한 것은 객체의 데이터에서 행동으로 무게 중심을 옮기기 위한 기법이다. 책임 중심 설계에서는 `이 객체가 수행해야 하는 책임은 무엇인가`를 결정한 후에 `이 책임을 수행하는데 필요한 데이터는 무엇인가`를 결정한다.

### 협력이라는 문맥 안에서 책임을 결정하라
객체에게 할당된 책임의 품질은 협력에 적합한 정도로 결정된다. 객체의 책임이 협력에 어울리지 않는다면 그 책임은 나쁜 것이다. 객체에게 책임이 어색해 보이더라도 협력에 적합하다면 좋은 것이다.

협력에 적합한 책임이란 메시지 수신자가 아닌 전송자에게 적합한 책임이어야 한다. 객체를 결정한 후 메시지를 선택하는 것이 아니라 메시지를 결정한 후 객체를 선택해야 한다.

클라이언트는 임의의 객체가 메시지를 수신할 것이라는 사실을 믿고 자신의 의도를 표현한다. 수신 객체는 메시지를 처리할 `책임`을 할당받게 된다. 메시지 송신자는 수신자에 대한 어떤 가정도 할 수 없기 때문에 메시지 전소앚의 관점에서 메시지 수신자가 깔끔하게 캡슐화되게 된다.

## 책임 할당을 위한 GRASP 패턴
크레이그 라만이 패턴 형식으로 제안한 GRASP(General Responsibility Assignment Software Pattern)패턴이 객체지향 책임 할당 기법중에 가장 잘 알려져있다.

### 도메인 개념에서 출발
설계 전 도메인에 대한 개략적인 모습을 그려보며 도메인 안의 무수한 개념들을 책임 할당의 대상으로 사용하면 코드에 도메인을 투영하기 쉬워진다. 초반의 도메인 개념을 정리하는데 많은 시간을 쓰는 것보단 설계를 시작하는 것이 중요하다.

### INFORMATION EXPERT패턴(정보 전문가에게 책임을 할당하라)
책임 주도 설계 방식의 첫 단계는 애플리케이션이 제공해야 하는 기능을 애플리케이션의 책임으로 생각하는 것이다. 책임을 애플리케이션에 대해 전송된 메시지로 간주하고 이 메시지를 책임질 객체를 선택하는 것으로 설계를 시작한다. 메시지는 메시지를 수신할 객체가 아니라 전송할 객체의 의도를 반영해서 결정해야 한다.

```markdown
책임을 수행하는데 필요한 정보를 가지고 있는 객체(정보전문가)에게 할당하는 것이 INFORMATION EXPERT패턴이다.

정보를 알고 있는 객체만이 책임을 어떻게 수행할지 스스로 결정할 수 있기 때문에 객체가 자율적인 존재여야 한다는 사실을 상기시킨다. 정보와 행동을 최대한 가까운 곳에 위치시키기 때문에 캡슐화를 유지할 수 있고, 필요한 정보를 가진 객체들로 책임이 분산되기 때문에 응집력있고 이해하기 쉬워진다. 이는 높은 응집도, 낮은 결합도를 가져다준다.

여기서 정보는 데이터와 다르다. 정보 전문가가 데이터를 반드시 저장하고 있을 필요는 없다.
```

![영화 도메인](Images/5-1.png)

영화 예매를 예로 들어보자. 첫 번째 질문은 다음과 같다.

1. 메시지를 전송할 객체는 무엇을 원하는가?
   1. 이 객체가 원하는 것은 `예매하라`가 적절한다.
2. 메시지를 수신할 적합한 객체는 누구인가?
   1. 객체는 상태와 행동을 통합한 캡슐화의 단위이자 자신의 상태를 스스로 처리하는 자율적 존재다.
   2. 객체에게 책임을 할당하는 첫 번째 원칙은 책임을 수행할 정보를 알고 있는 객체에게 책임을 할당하는 것이다.
   3. GRASP에서는 이를 INFORMATION EXPERT패턴이라고 부른다.
   4. 예매하는데 필요한 정보를 가장 많이 알고 있는 객체는 상영이라는 도메인 개념이다.
3. `상영` 도메인은 메시지를 혼자 처리할 수 있는가?
   1. 상영 도메인은 가격을 계산하는데 필요한 정보를 모른다.
   2. 외부의 객체의 도움을 요청해 가격을 얻어야 한다.
   3. 해당 정보를 가지고 있는 객체에게 `가격을 계산하라`를 요청해야 한다.
   4. 메시지를 책임질 객체로 `영화` 도메인을 선택한다.
4. `영화` 도메인은 메시지를 혼자 처리할 수 있는가?
   1. 영화 도메인은 할인 여부를 확인할 수 없다.
   2. 할인조건 도메인에게 할인 여부가 확인 가능하다.

### LOW COUPLING과 HIGH COHESION

GRASP에서는 LOW COUPLING(낮은 결합도)패턴과 HIGH COHESION(높은 응집도) 패턴이 존재한다.

위처럼 도메인끼리 메시지를 전달해 Screening부터 DiscountCondition까지 도달하는 방법도 있지만 Screening과 DiscountCondition이 직접 상호작용하는 방법도 있을 것이다. 하지만 이 방법은 Screening에서 DiscountCondition에 직접 메시지를 보내기 때문에 추가적인 결합도가 생기게 된다. LOW COUPLING 관점에서 좋은 방법이 아니다.

Screening의 가장 중요한 책임은 예매를 생성하는 것인데 Screening이 DiscountCondition과 협력해야 한다면 Screening은 영화 요금 계산 책임 일부를 떠안아야 한다. 요금 계산 방식이 변경될 경우 Screening도 함께 변경되게 된다. 따라서 HIGH COHESION 관점에서도 Movie가 DiscountCondition과 협력하는 것이 더 나은 설계 대안이다.

### CREATER패턴
영화 예매 협력의 최종 결과물은 Reservation 인스턴스를 생성하는 것인데 협력을 참여하는 어떤 객체에게는 Reservation 인스턴스를 생성할 책임을 할당해야 한다. GRASP의 CREATER(창조자) 패턴은 이 같은 경우에 사용할 수 있는 책임 할당 패턴으로 객체를 생성할 책임을 어떤 객체에게 할당할지에 대한 지침을 제공한다.

```markdown
객체 A를 생성해야 할 때 어떤 객체에게 객체 생성 책임을 할당해야 하는가? 아래 조건을 최대한 많이 만족하는 B에게 객체 생성 책임을 할당하라

- B가 A객체를 포함하거나 참조한다.
- B가 A 객체를 기록한다.
- B가 A 객체를 긴밀하게 사용한다.
- B가 A 객체를 초기화하는데 피룡한 데이터를 가지고 있다

CREATER 패턴의 의도는 생성되는 객체와 연결되거나 관련될 필요가 있는 객체에 해당 객체를 생성할 책임을 맡기는 것으로 이미 결함돼 있는 객체에게 생성 책임을 할당하는 것은 설계의 전체적인 결합도에 영향을 미치지 않는다. CREATER 패턴은 이미 존재하는 객체 사이의 관계를 이용하기 때문에 설계가 낮은 결합도를 유지할 수 있게 한다.
```

Screening은 모든 객체에 대해 알고 있기 때문에 CREATER로 선택하는 것이 적절하다.

## 구현을 통한 검증
Screening을 구현하는 것으로 시작하는데 Screening은 영화를 예매할 책임을 맡으며 Reservation인스턴스를 생성할 책임을 수행해야 한다.

<details>
<summary>Screening</summary>

```java
public class Screening {
    private Movie movie;
    private int sequence;
    private LocalDateTime whenScreened;
    
    public Reservation reserve(Customer customer, int audienceCount) {

    }

    public Screening(Customer customer, int audienceCount) {
    }

    public Reservation reserve(Customer customer, int audienceCount) {
        return new Reservation(customer, this, calculateFee(audienceCount), audienceCount);
    }

    private Money calculateFee(int audienceCount) {
        return movie.calculateMovieFee(this).times(audienceCount);
    }

    public int getSequence() {
        return sequence;
    }
}

```
</details>

Screening에서 Movie에 전송하는 메시지 시그니쳐는 calculateMovieFee로 했는데 내부 구현을 고려하지 않고 메시지를 결정해 캡슐화가 가능하다.

<details>
<summary>Movie</summary>

```java
public class Movie {
    private String title;
    private Duration runningTime;
    private Money fee;
    private List<DiscountCondition> discountConditions;

    private MovieType movieType;
    private Money discountAmount;
    private double discountPercent;

    public Money calculateMovieFee(Screening screening) {
        if(isDiscountable(screening)) {
            return fee.minus(calculateDiscountAmount());
        }
        return fee;
    }

    private boolean isDiscountable(Screening screening) {
        return discountConditions.stream()
                .anyMatch(condition -> condition.isSatisfiedBy(screening));
    }

    private Money calculateDiscountAmount() {
        switch (movieType) {
            case AMOUNT_DISCOUNT -> {
                return calculateAmountDiscountAmount();
            }
            case PERCENT_DISCOUNT -> {
                return calculatePercentDiscountAmount();
            }
            case NON_DISCOUNT -> {
                return calculateNoneDiscountAmount();
            }
        }
        throw new IllegalStateException();
    }

    private Money calculateAmountDiscountAmount() {
        return discountAmount;
    }

    private Money calculatePercentDiscountAmount() {
        return fee.times(discountPercent);
    }

    private Money calculateNoneDiscountAmount() {
        return Money.ZERO;
    }
}

```
</details>

<details>
<summary>MovieType</summary>

```java
public enum MovieType {
    AMOUNT_DISCOUNT,
    PERCENT_DISCOUNT,
    NON_DISCOUNT
}

```
</details>

<details>
<summary>DiscountCondition</summary>

```java
public class DiscountCondition {
    private DiscountConditionType type;
    private int sequence;
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;

    public boolean isSatisfiedBy(Screening screening) {
        if(type == DiscountConditionType.PERIOD) {
            return isSatisfiedByPeriod(screening);
        }
        return isSatisfiedBySequence(screening);
    }

    private boolean isSatisfiedByPeriod(Screening screening) {
        return dayOfWeek.equals(screening.getWhenScreened().getDayOfWeek()) &&
                startTime.compareTo(screening.getWhenScreened().toLocalTime()) <= 0 &&
                endTime.isAfter(screening.getWhenScreened().toLocalTime());
    }

    private boolean isSatisfiedBySequence(Screening screening) {
        return sequence == screening.getSequence();
    }
}
```
</details>

해당 코드의 문제점은 변경에 취약한 코드다. DiscountCondition은 세 가지 이유로 변경될 수 있다.

- 새로운 할인 조건 추가
  - isSatisfiedBy 메서드 안에 if-else 문을 수정해야 한다.
- 순번 조건을 판단하는 로직 변경
  - isSatisfiedBySequence 메서드의 내부 구현을 수정해야 한다. 순번 조건을 판단하는데 필요한 데이터가 변경된다면 DiscountCondition의 sequence 속성 역시 변경돼야 한다.
- 기간 조건을 판단하는 로직이 변경되는 경우
  - isSatisfiedByPeriod 메서드의 내부 구현을 수정해야 한다. 기간 조건을 판단하는데 필요한 데이터가 변경된다면 DiscountCondition의 dayOfWeek, startTime, endTime 속성 역시 변경돼야 한다.

DiscountCondition은 하나 이상의 변경 이유를 가지기 때문에 응집도가 낮다. 낮은 응집도를 해결하기 위해 `변경의 이유에 따라 클래스를 분리해야 한다.`

DiscountCondition 안에 구현된 isSatisfiedBySequence메서드와 isSatisfiedByPeriod메서드는 서로 다른 이유로 변경된다. isSatisfiedBySequence메서드는 순번 조건에 대한 요구사항이 달라질 경우 구현이 변경된다. isSatisfiedByPeriod 메서드는 기간 조건에 대한 요구 사항이 달라질 경우에 구현이 변경된다.

DiscountCondition은 서로 다른 이유로 다른 시점에 변경될 확률이 높다. 변경의 이유를 찾는 방법은 다음과 같다.
1. 변경의 이유에 따라 클래스를 분리한다.
2. 인스턴스 변수가 초기화되는 시점에 따라 분리한다.
   - 응집도가 높은 클래스는 인스턴스를 생성할 때 모든 속성을 초기화한다.
   - `함께 초기화되는 속성을 기준으로 코드를 분리해야 한다.`
2. 메서드들이 인스턴스 변수를 사용하는 방식을 살펴본다.
   - 모든 메서드가 객체의 모든 속성을 사용한다면 클래스의 응집도는 높다고 볼 수 있다.
   - `속성 그룹과 해당 그룹에 접근하는 메서드 그룹을 기준으로 코드를 분리해야 한다.`


DiscountCondition의 가장 큰 문제는 순번 조건과 기간 조건이라는 두 개의 독립적인 타입이 하나의 클래스 안에 공존하고 있다는 것이다. 해결 방법은 두 타입을 SeqeunceCondition과 PeriodCondition이라는 두 개의 클래스로 분리하는 것이다.

<details>
<summary>PeriodCondition</summary>

```java
public class PeriodCondition {
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;

    public PeriodCondition(DayOfWeek dayOfWeek, LocalTime startTime, LocalTime endTime) {
        this.dayOfWeek = dayOfWeek;
        this.startTime = startTime;
        this.endTime = endTime;
    }

    public boolean isSatisfiedBy(Screening screening) {
        return dayOfWeek.equals(screening.getWhenScreened().getDayOfWeek()) &&
                startTime.compareTo(screening.getWhenScreened().toLocalTime()) <= 0 &&
                endTime.isAfter(screening.getWhenScreened().toLocalTime());
    }
}
```
</details>

<details>
<summary>SeqeunceCondition</summary>

```java
public class SequenceCondition {
    private int sequence;

    public SequenceCondition(int sequence) {
        this.sequence = sequence;
    }
    
    public boolean isSatisfiedBy(Screening screening) {
        return sequence == screening.getSequence();
    }
}
```
</details>

이 방법은 새로운 문제를 야기하는데
1. Movie 클래스가 PeriodCondition과 SeqeunceCondition 클래스 양 쪽 모두에게 결합된다. 전체적인 결합도가 높아진 것이다.
2. 수정 후에 새로운 할인 조건을 추가하기가 더 어려워졌다.

### POLYMORPHISM패턴(다형성을 통해 분리하기)
Movie 입장에서 SeqeunceCondition과 PeriodCondition이 동일한 책임을 수행한다는 것은 동일한 역할을 수행한다는 것을 의미한다. 역할은 협력 안에서 대체 가능성을 의미하기 때문에 SeqeunceCondition과 PeriodCondition에 역할의 개념을 적용하면 Movie가 구체적인 클래스를 알지 못한 채 역할에 대해서만 결합되도록 의존성을 제한할 수 있다.

할인 조건의 경우 클래스가 구현을 공유할 필요는 없으니 DiscountCondition이라는 이름의 인터페이스를 이용해 역할을 구현하자.

```java
public interface DiscountCondition {
    boolean isSatisfiedBy(Screening screening);
}
```

객체의 타입에 따라 행동을 분기해야 한다면 암시적인 타입을 명시적인 클래스로 정의하고 행동을 나눔으로써 응집도 문제를 해결할 수 있다. 다시 말해 객체의 타입에 따라 변하는 행동이 있다면 타입을 분리하고 변화하는 행동을 각 타입의 책임으로 할당하라는 것으로 POLYMORPHISM(다형성) 패턴이라고 부른다.

```markdown
POLYMORPHISM 패턴은 객체의 타입을 검사해서 타입에 따라 여러 대안들을 수행하는 조건적인 논리를 사용하지 말고 다형성을 이용해 새로운 변화를 다루기 쉽게 확장하라고 권고한다.
```


이제 두 개의 서로 다른 변경이 두 개의 서로 다른 클래스 안으로 캡슐화되며 새로운 할인 조건이 추가되는 경우 Movie가 영향을 받지 않는다. 이처럼 변경을 캡슐화하도록 책임을 할당하는 것을 PROTECTED VARIATIONS(변경 보호) 패턴이라고 부른다.

하나의 클래스가 여러 타입의 행동을 구현하고 있는 것처럼 보인다면 클래스를 분해하고 POLYMORPHISM 패턴에 따라 책임을 분산시켜야 한다.

### Movie 클래스 개선하기

Movie또한 금액 할인 정책 영화와 비율 할인 정책 역할 두 가지 타입을 하나의 클래스 안에서 구현하고 있기 때문에 하나 이상의 이유로 변경될 수 있다. 여기서도 역시 POLYMORPHISM패턴을 이용해 서로 다른 행동을 타입별로 분리하면 다형성의 혜택을 누릴 수 있다.

Movie의 경우 구현을 공유할 필요가 있으니 추상 클래스를 이용해 역할을 구현할 수 있다.

<details>
<summary>Movie</summary>

```java
public abstract class Movie {
    private String title;
    private Duration runningTime;
    private Money fee;
    private List<DiscountCondition> discountConditions;

    public Movie(String title, Duration runningTime, Money fee, List<DiscountCondition> discountConditions) {
        this.title = title;
        this.runningTime = runningTime;
        this.fee = fee;
        this.discountConditions = discountConditions;
    }
    
    protected Money getFee(){
        return fee;
    }

    public Money calculateMovieFee(Screening screening) {
        if(isDiscountable(screening)) {
            return fee.minus(calculateDiscountAmount());
        }
        return fee;
    }

    private boolean isDiscountable(Screening screening) {
        return discountConditions.stream()
                .anyMatch(condition -> condition.isSatisfiedBy(screening));
    }

    abstract protected Money calculateDiscountAmount();
    
}
```
</details>

<details>
<summary>AmountDiscountMovie</summary>

```java
public class AmountDiscountMovie extends Movie {
    private Money discountAmount;

    public AmountDiscountMovie(String title, Duration runningTime, Money fee, List<DiscountCondition> discountConditions, Money discountAmount) {
        super(title, runningTime, fee, discountConditions);
        this.discountAmount = discountAmount;
    }

    @Override
    protected Money calculateDiscountAmount() {
        return discountAmount;
    }
}

```
</details>

<details>
<summary>PercentDiscountMovie</summary>

```java
public class PercentDiscountMovie extends Movie{
    private double percent;

    public PercentDiscountMovie(String title, Duration runningTime, Money fee, List<DiscountCondition> discountConditions) {
        super(title, runningTime, fee, discountConditions);
    }

    @Override
    protected Money calculateDiscountAmount() {
        return getFee().times(percent);
    }
}
```
</details>

<details>
<summary>NoneDiscountMovie</summary>

```java
public class NoneDiscountMovie extends Movie{
    public NoneDiscountMovie(String title, Duration runningTime, Money fee, List<DiscountCondition> discountConditions) {
        super(title, runningTime, fee, discountConditions);
    }

    @Override
    protected Money calculateDiscountAmount() {
        return Money.ZERO;
    }
}
```
</details>


모든 클래스의 내부 구현이 캡슐화돼 있고 모든 클래스는 변경의 이유를 오직 하나씩만 가진다.

![책임 중심의 영화 예매 시스템](Images/5-2.png)

```markdown
도메인 모델은 단순히 설계에 필요한 용어를 제공하는 것을 넘어 코드의 구조에도 영향을 미친다.  
도메인 모델에는 도메인 안에서 변하는 개념과 이들 사이의 관계가 투영돼 있어야 한다.  
도메인의 구조가 코드의 구조를 이끌어내는 것은 자연스러울뿐만 아니라 바람직한 것이다.
```

### 변경과 유연성
현재 설계에서는 할인 정책을 구현하기 위해 `상속`을 이용하고 있기 때문에 실행 중에 할인 정책을 변경하기 위해서는 새로운 인스턴스를 생성한 후 필요한 정보를 복사해야 한다.

새로운 할인 정책이 추가될 때마다 인스턴스를 생성, 복사, 식별자를 관리하는 코드는 오류가 발생하기 쉽다. 이 경우 코드의 복잡성이 높아지더라도 할인 정책의 변경을 쉽게 수용할 수 있게 코드를 유연하게 만드는 것이 더 좋은 방법이다.

해결 방법은 상속 대신 `합성`을 사용하는 것이다.

Movie 상속 계창 안에 구현된 할인 정책을 독립적인 DiscountPolicy로 분리한 후 Movie에 합성시키면 유연한 설계가 완성된다.

![상속 대신 합성](Images/5-3.png)

이렇게 하면 금액 할인 정책이 적용된 영화를 비율 할인 정책으로 바꾸는 일이 DiscountPolicy의 인스턴스를 교체하는 단순한 작업으로 바뀐다. 유연성의 정도에 따라 결합도를 조절할 수 있는 능력은 객체지향 개발자가 갖춰야 하는 중요한 기술 중 하나다.

## 책임 주도 설계의 대안
책임 주도 설계에 익숙해지기는 어렵다. 따라서 최대한 빠르게 목적한 기능을 수행하는 코드를 작성한 후에 리팩터링을 통해 내부 구조를 변경하는 것이 좋은 대안이다.

4장 초반의 코드에는 ReservationAgency에 모든 절차가 집중돼있었다.

<details>
<summary>ReservationAgency</summary>

```java
public class ReservationAgency {
    public Reservation reserve(Screening screening, Customer customer,
                               int audienceCount) {
        Movie movie = screening.getMovie();

        boolean discountable = false;
        for(DiscountCondition condition : movie.getDiscountConditions()) {
            if (condition.getType() == DiscountConditionType.PERIOD) {
                discountable = screening.getWhenScreened().getDayOfWeek().equals(condition.getDayOfWeek()) &&
                        condition.getStartTime().compareTo(screening.getWhenScreened().toLocalTime()) <= 0 &&
                        condition.getEndTime().compareTo(screening.getWhenScreened().toLocalTime()) >= 0;
            } else {
                discountable = condition.getSequence() == screening.getSequence();
            }

            if (discountable) {
                break;
            }
        }

        Money fee;
        if (discountable) {
            Money discountAmount = Money.ZERO;
            switch(movie.getMovieType()) {
                case AMOUNT_DISCOUNT:
                    discountAmount = movie.getDiscountAmount();
                    break;
                case PERCENT_DISCOUNT:
                    discountAmount = movie.getFee().times(movie.getDiscountPercent());
                    break;
                case NONE_DISCOUNT:
                    discountAmount = Money.ZERO;
                    break;
            }

            fee = movie.getFee().minus(discountAmount).times(audienceCount);
        } else {
            fee = movie.getFee().times(audienceCount);
        }

        return new Reservation(customer, screening, fee, audienceCount);
    }
}
```
</details>

긴 메서드는 응집도가 낮기 때문에 이해하기도 어렵고 재사용하기도 어려우며 변경하기도 어렵다. 응집도 높은 메서드는 변경되는 이유가 단 하나여야 한다. 클래스가 작고, 목적이 명확한 메서드들로 구성돼 있다면 변경을 처리하기 위해 어떤 메서드를 수정해야 하는지를 쉽게 판단할 수 있고 재사용하기도 쉽다. 또한, 코드를 이해하기도 쉽다.

```java
public class ReservationAgency {
    public Reservation reserve(Screening screening, Customer customer,
                               int audienceCount) {
        boolean discountable = checkDiscountable(screening);
        Money fee = calculateFee(screening, discountable, audienceCount);
        return createReservation(screening, customer, audienceCount, fee);
    }

    private boolean checkDiscountable(Screening screening) {
        return screening.getMovie().getDiscountConditions().stream()
                .anyMatch(condition -> condition.isDiscountable(screening));
    }

    private Money calculateFee(Screening screening, boolean discountable,
                               int audienceCount) {
        if (discountable) {
            return screening.getMovie().getFee()
                    .minus(calculateDiscountedFee(screening.getMovie()))
                    .times(audienceCount);
        }

        return  screening.getMovie().getFee();
    }

    private Money calculateDiscountedFee(Movie movie) {
        switch(movie.getMovieType()) {
            case AMOUNT_DISCOUNT:
                return calculateAmountDiscountedFee(movie);
            case PERCENT_DISCOUNT:
                return calculatePercentDiscountedFee(movie);
            case NONE_DISCOUNT:
                return calculateNoneDiscountedFee(movie);
        }

        throw new IllegalArgumentException();
    }

    private Money calculateAmountDiscountedFee(Movie movie) {
        return movie.getDiscountAmount();
    }

    private Money calculatePercentDiscountedFee(Movie movie) {
        return movie.getFee().times(movie.getDiscountPercent());
    }

    private Money calculateNoneDiscountedFee(Movie movie) {
        return movie.getFee();
    }

    private Reservation createReservation(Screening screening,
                                          Customer customer, int audienceCount, Money fee) {
        return new Reservation(customer, screening, fee, audienceCount);
    }
}
```

이렇게 메서드를 분리하면 메서드가 어떤 일을 하는지 한눈에 알아볼 수 있다. 메서드 안의 응집도는 높아졌지만 ReservationAgency의 응집도는 여전히 낮다. 이제 변경의 이유가 다른 메서드들을 적절한 위치로 분배해야 한다.

자신이 소유하고 있는 데이터를 자기 스스로 처리하도록 만드는 것이 자율적인 객체를 만드는 지름길이다. 메서드가 사용하고 있는 데이터를 저장하고 있는 클래스로 메서드를 이동시키면 된다. 어떤 데이터를 사용하는지 가장 쉽게 알 수 있는 방법은 메서드 안에서 어떤 클래스의 접근자 메서드를 사용하는지 파악하는 것이다.