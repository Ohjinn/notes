- [03 설계 품질과 트레이드오프](#03-설계-품질과-트레이드오프)
  - [데이터 중심의 영화 예매 시스템](#데이터-중심의-영화-예매-시스템)
  - [설계 트레이드오프](#설계-트레이드오프)
  - [데이터 중심의 영화 예매 시스템의 문제점](#데이터-중심의-영화-예매-시스템의-문제점)
    - [캡슐화 위반](#캡슐화-위반)
    - [높은 결합도](#높은-결합도)
    - [낮은 응집도](#낮은-응집도)
  - [자율적인 객체를 향해](#자율적인-객체를-향해)
    - [스스로 자신의 데이터를 책임지는 객체](#스스로-자신의-데이터를-책임지는-객체)
  - [하지만 여전히 부족하다](#하지만-여전히-부족하다)
    - [캡슐화 위반](#캡슐화-위반-1)
    - [높은 결합도](#높은-결합도-1)
    - [낮은 응집도](#낮은-응집도-1)
  - [데이터 중심 설계의 문제점](#데이터-중심-설계의-문제점)
    - [데이터 중심 설계는 객체의 행동보다는 상태에 초점을 맞춘다.](#데이터-중심-설계는-객체의-행동보다는-상태에-초점을-맞춘다)
    - [데이터 중심 설계는 객체를 고립시킨 채 오퍼레이션을 정의하도록 만든다.](#데이터-중심-설계는-객체를-고립시킨-채-오퍼레이션을-정의하도록-만든다)



# 03 설계 품질과 트레이드오프
객체지향 패러다임의 관점에서 핵심은 `역할` `책임` `협력`이었듯 설계에서도 핵심은 같다.

클래스, 상속, 지연 바인딩이 중요하지 않은 것은 아니지만 구현 측면에서 중요한 것이고 객체지향 패러다임의 본질과는 거리가 멀다. 객체지향의 본질은 협력하는 객체들의 공동체를 창조하는 것이다.

- 협력: 객체들이 어플리케이션의 기능을 구현하기 위해 메세지를 주고받는 객체들 사이의 상호작용
- 책임: 객체가 협력에 참여하기 위해 수행하는 행동
- 역할: 대체 가능한 책임의 집합

책임이 객체지향 어플리케이션 전체의 품질을 결정한다.  

객체지향 설계란 올바른 객체에게 올바른 책임을 할당하면서 낮은 결합도와 높은 응집도를 가진 구조를 창조하는 활동이다.
해당 정의에는 두 가지 관점이 섞여 있다.
- 객체지향 설계의 핵심이 책임이다.
- 책임을 할당하는 작업이 응집도와 결합도 같은 설계 품질과 깊이 연관돼있다.

훌륭한 설계는 합리적인 비용 안에서 변경을 수용할 수 있는 구조를 만드는 것이며, 이는 응집도가 높고 서로 느슨하게 결합돼 있는 요소로 구성된다.

객체의 상태가 아니라 행동에 초점을 맞추면 결합도와 응집도를 합리적인 수준으로 유지할 수 있다.

해당 장에서는 데이터 중심 설계와 객체지향 설계의 특징과 훌륭한 설계를 달성하기 위해 사용할 수 있는 책임 할당 원칙을 이해할 수 있다.

## 데이터 중심의 영화 예매 시스템

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

    public Money getFee() {
        return fee;
    }

    public void setFee(Money fee) {
        this.fee = fee;
    }

    public List<DiscountCondition> getDiscountConditions() {
        return discountConditions;
    }

    public void setDiscountConditions(List<DiscountCondition> discountConditions) {
        this.discountConditions = discountConditions;
    }

    public MovieType getMovieType() {
        return movieType;
    }

    public void setMovieType(MovieType movieType) {
        this.movieType = movieType;
    }

    public Money getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(Money discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getDiscountPercent() {
        return discountPercent;
    }

    public void setDiscountPercent(double discountPercent) {
        this.discountPercent = discountPercent;
    }
}
```
</details>

1. 할인 조건의 목록이 인스턴수 변수로 포함
2. 할인 금액과 할인 비율을 직접 정의
3. 두 개 중 선택을 MovieType으로 한다.

```java
public enum MovieType {
    AMOUNT_DISCOUNT,
    PERCENT_DISCOUNT,
    NONE_DISCOUNT
}
```

데이터 중심 설계는 객체가 포함해야 하는 데이터에 집중한다.  
객체의 종류를 저장하고 인스턴스에 종류에 따라 배타적으로 사용될 인스턴스 변수를 하나의 클래스 안에 넣는 것은 완전 데이터 중심 설계다.

할인 조건을 구현해보자

<details>
<summary>DiscountCondition</summary>

```java
public class DiscountCondition {
    private DiscountConditionType type;

    private int sequence;

    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;

    public DiscountConditionType getType() {
        return type;
    }

    public void setType(DiscountConditionType type) {
        this.type = type;
    }

    public int getSequence() {
        return sequence;
    }

    public void setSequence(int sequence) {
        this.sequence = sequence;
    }

    public DayOfWeek getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(DayOfWeek dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public LocalTime getStartTime() {
        return startTime;
    }

    public void setStartTime(LocalTime startTime) {
        this.startTime = startTime;
    }

    public LocalTime getEndTime() {
        return endTime;
    }

    public void setEndTime(LocalTime endTime) {
        this.endTime = endTime;
    }
}

public enum DiscountConditionType {
    SEQUENCE,
    PERIOD
}
```
</details>

<details>
<summary>Screening</summary>

```java
public class Screening {
    private Movie movie;
    private int sequence;
    private LocalDateTime whenScreened;

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public int getSequence() {
        return sequence;
    }

    public void setSequence(int sequence) {
        this.sequence = sequence;
    }

    public LocalDateTime getWhenScreened() {
        return whenScreened;
    }

    public void setWhenScreened(LocalDateTime whenScreened) {
        this.whenScreened = whenScreened;
    }
}

```
</details>

<details>
<summary>Reservation</summary>

```java
public class Reservation {
    private Customer customer;
    private Screening screening;
    private Movie movie;
    private int audienceCount;

    public Reservation(Customer customer, Screening screening, Movie movie, int audienceCount) {
        this.customer = customer;
        this.screening = screening;
        this.movie = movie;
        this.audienceCount = audienceCount;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public Screening getScreening() {
        return screening;
    }

    public void setScreening(Screening screening) {
        this.screening = screening;
    }

    public Movie getMovie() {
        return movie;
    }

    public void setMovie(Movie movie) {
        this.movie = movie;
    }

    public int getAudienceCount() {
        return audienceCount;
    }

    public void setAudienceCount(int audienceCount) {
        this.audienceCount = audienceCount;
    }
}
```
</details>

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

마지막 ReservationAgency를 보면 reserve는 두 부분으로 나뉜다.
1. DiscountCondition에 대해 루프를 돌면서 할인 가능 여부를 확인하는 for
2. discountable 변수의 값을 체크하고 적절한 할인 정책에 따라 예매 요금을 계산하는 if

해당 코드를 책임 중심의 설계 방법과 비교해보며 장단점을 파악해보자.

## 설계 트레이드오프
캡슐화, 응집도, 결합도 세 가지 기준을 가지고 보면

- 캡슐화: 외부에서 알 필요가 없는 부분을 감춤으로써 대상을 단순화하는 추상화의 한 종류로 변경될 가능성이 높은 부분은 `구현`, 상대적으로 안정적인 부분을 `인터페이스`라고 부른다.
  - 변경의 파급효과를 조절하기 위해 필요하다.
  - 캡슐화를 목표로 인식할 때 객체지향 프로그래밍을 통한 장점을 취득 가능하다.
  - 객체지향의 이유 중 하나인 유지보수성을 높히기 위해(변경에 자유로워지기 위해) 필요하다.


- 응집도: 모듈에 포함된 내부 요소들이 연관돼 있는 정도로 모듈들이 하나의 목적을 위해 협력한다면 높은 응집도를 갖는다.
  - 객체 또는 클래스에 얼마나 관련 높은 책임들을 할당했는지

- 결합도: 의존성의 정도를 나타내며 다른 모듈에 대해 얼마나 많은 지식을 갖고 있는지 나타내는 척도

하지만 일반적으로 그 정도를 측정하기가 쉽지 않다.  
변경의 관점에서 응집도란 `변경이 발생할 때 모듈 내부에서 발생하는 변경의 정도`로 응집도가 높은 설계에서는 하나의 요구사항 변경을 반영하기 위해 하나의 모듈만 수정하면 된다.

결합도는 `한 모듈이 변경되기 위해서 다른 모듈의 변경을 요구하는 정도`로 측정할 수 있다. 결합도가 높으면 변경해야 하는 모듈 수가 늘어나기 때문에 변경하기가 어려워진다.

캡슐화를 지키면 모듈 안의 응집도는 높아지고 모듈 사이의 결합도는 낮아진다.

## 데이터 중심의 영화 예매 시스템의 문제점

- 캡슐화 위반
- 높은 결합도
- 낮은 응집도

데이터 중심 설계의 세 가지 문제점을 가지고 코드를 보면

### 캡슐화 위반
getFee, setFee 등의 메서드는 Movie 내부에 fee라는 이름의 인스턴스 변수가 존재한다는 사실을 퍼블릭 인터페이스에 드러낸다. 객체에게 중요한 것은 책임이다. 구현을 캡슐화하기 위한 적절한 책임은 협력을 고려할 때만 얻을 수 있다.

이와 같은 접근자와 수정자에 과도하게 의존하는 설계 방식을 `추측에 의한 설계 전략`이라고 부른다. 객체가 사용될 협력을 고려하지 않고 객체가 다양한 상황에서 사용될 수 있을 것이라는 추측에 기반해 설계하기 때문에 캡슐화를 위반한다.

### 높은 결합도
객체 내부의 구현이 인터페이스에 드러난다는 것은 클라이언트가 구현에 강하게 결합된다는 것을 의미한다.

```java
public class ReservationAgency{
    public Reservation reserve(Screening screening, Customer customer, int audience) {
        Movie fee;
        if(discountable) {
            fee = movie.getFee().minus(discountAmount).times(audienceCount);
        }
    }
}
```

인터페이스가 드러났기 때문에 인스턴스 변수 fee의 가시성은 사실상 private이 아닌 public이다.

ReservationAgency는 모든 객체에 대해 의존하고 있기 때문에 시스템 안의 어떤 변경도 ReservationAgency의 변경을 유발한다.

![ReservationAgency](Images/4-1.png)

데이터 중심 설계와 결합도가 관련해서 가지는 치명적인 문제로 전체 시스템 전체를 하나의 거대한 의존성 덩어리로 만들어 버린다.

### 낮은 응집도
서로 다른 이유로 변경되는 코드가 하나의 모듈 안에 공존할 때 모듈의 응집도가 낮다고 말한다.

응집도는 변경이 발생할 때 모듈 내부에서 발생하는 변경의 정도라고 했다. ReservationAgency는 할인 정책, 조건, 요금 등 어떤 것만 바뀌어도 코드가 수정되야 한다.

- ReservationAgency 안에 할인 정책을 선택하는 코드와 할인 조건을 판단하는 코드가 함께 존재하기 때문에 할인 정책을 추가하는 작업이 할인 조건에 영향을 미칠 수 있다.
- 할인 정책 추가는 movieType에 새로운 열거형 값을 추가하고 ReservationAgency의 reserve에 switch구문 추가, Movie도 수정해줘야 한다.

어떤 요구사항 변경을 수용하기 위해 하나 이상의 클래스를 수정해야 한다는 것은 설계의 응집도가 낮다는 증거다.

```
단일 책임 원칙(SRP): 클래스는 단 한가지의 변경 이유(책임)만을 가져야 한다.
```

## 자율적인 객체를 향해
### 스스로 자신의 데이터를 책임지는 객체
상태와 행동을 하나의 단위로 묶는 이유는 객체 스스로 자신의 상태를 처리할 수 있게 하기 위해서다. 
객체를 설계할 때 `이 객체가 어떤 데이터를 포함해야 하는가?`라는 질문을 두 개의 개별적인 질문으로 분리해야 한다.
- 이 객체가 어떤 데이터를 포함해야 하는가?
- 이 객체가 데이터에 대해 수행해야 하는 오퍼레이션은 무엇인가?

<details>
<summary>DiscountCondition</summary>

```java
public class DiscountCondition {
    private DiscountConditionType type;
    private int sequence;
    private DayOfWeek dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;

    public DiscountConditionType getType() {
        return type;
    }
    
    public boolean isDiscountable(DayOfWeek dayOfWeek, LocalTime time) {
        if (type != DiscountConditionType.PERIOD) {
            throw new IllegalArgumentException();
        }
        return this.dayOfWeek.equals(dayOfWeek) &&
                this.startTime.compareTo(time) <= 0 &&
                this.endTime.compareTo(time) >= 0;
    }
    
    public boolean isDiscountable(int sequence) {
        if(type != DiscountConditionType.SEQUENCE) {
            throw new IllegalArgumentException();
        }
        return this.sequence == sequence;
    }
}
```
</details>

DiscountCondition은 스스로 할인 여부을 판단할 수 있어야 한다.

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

    public MovieType getMovieType() {
        return movieType;
    }

    public Money calculateAmountDiscountedFee() {
        if(movieType != MovieType.AMOUNT_DISCOUNT) {
            throw new IllegalArgumentException();
        }
        return fee.minus(discountAmount);
    }

    public Money calculatePercentDiscountedFee() {
        if(movieType != MovieType.PERCENT_DISCOUNT) {
            throw new IllegalArgumentException();
        }
        return fee.minus(fee.times(discountPercent));
    }

    public Money calculateNoneDiscountedFee() {
        if(movieType != MovieType.NONE_DISCOUNT) {
            throw new IllegalArgumentException();
        }
        return fee;
    }

    public boolean isDiscountable(LocalDateTime whenScreened, int sequence) {
        for(DiscountCondition condition : discountConditions) {
            if (condition.getType() == DiscountConditionType.PERIOD) {
                if (condition.isDiscountable(whenScreened.getDayOfWeek(), whenScreened.toLocalTime())) {
                    return true;
                }
            } else {
                if (condition.isDiscountable(sequence)) {
                    return true;
                }
            }
        }
        return false;
    }
}
```
</details>

Movie는 DiscountCondition의 isDiscountable을 호출한다.

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

    public Money calculateFee(int audienceCount) {
        switch (movie.getMovieType()) {
            case AMOUNT_DISCOUNT:
                if (movie.isDiscountable(whenScreened, sequence)) {
                    return movie.calculateAmountDiscountedFee().times(audienceCount);
                }
                break;
            case PERCENT_DISCOUNT:
                if (movie.isDiscountable(whenScreened, sequence)) {
                    return movie.calculatePercentDiscountedFee().times(audienceCount);
                }
            case NONE_DISCOUNT:
                movie.calculateNoneDiscountedFee().times(audienceCount);
        }

        return movie.calculateNoneDiscountedFee().times(audienceCount);
    }
}
```
</details>

Screening은 Movie가 할인 정책을 지원할 경우 Movie의 isDiscountable을 호출해 할인 가능 여부를 판단한 후 요금을 계산한다.

![improved architecture](Images/4-2.png)

이 객체들은 스스로를 책임진다.

## 하지만 여전히 부족하다

### 캡슐화 위반

객체들은 자기 자신의 데이터를 스스로 처리하지만 DiscountCondition은 자기 자신의 데이터를 이용해 할인 가능 여부를 스스로 판단한다. 하지만 isDiscountable의 DayOfWeek와 LocalDateTime 파라미터를 보면 인터페이스를 통해 외부에 인스턴스 변수를 노출하고 있다. 두번째 isDiscountable(int sequence)메서드 역시 똑같다. 내부 구현의 변경이 외부로 퍼져나가는 `파급 효과`는 캡슐화가 부족하다는 증거다.

Movie에서 각 메서드는 파라미터로 속성에 대한 정보를 노출하지 않지만 세 가지 할인정책이(calculateAmountDiscountedFee, calculatePercentDiscountedFee, calculateNoneDiscountedFee) 존재한다는 사실을 외부로 퍼트리고 있다.

진정한 캡슐화란 변하는 어떤 것이든 감추는 것이다.

### 높은 결합도
DiscountCondition의 내부 구현 노출로 Movie와 결합도가 높다. 
- DiscountCondition의 기간 할인 조건의 명칭이 PERIOD에서 다른 값으로 변경된다면 Movie를 수정해야 한다.
- DiscountCondition의 종류가 추가되거나 삭제된다면 Movie안의 if~else 문을 수정해야 한다.
- DiscountCondition의 만족 여부를 판단하는데 필요한 정보가 변경된다면 Movie의 isDiscountable메서드로 전달된 파라미터를 변경, Movie의 isDiscountable을 변경시키고, Screening도 변경시킬 것이다.

### 낮은 응집도
바로 위에서 이야기했듯 DiscountCondition의 변화가 Screening까지 영향을 미칠 수 있는데 이는 설계의 응집도가 낮다는 증거다.

## 데이터 중심 설계의 문제점
두 번째 설계의 문제는 캡슐화를 위반했다.
- 데이터 중심의 설계는 본질적으로 너무 이른 시기에 데이터에 관해 결정하도록 강요한다.
- 데이터 중심의 설계에서는 협력이라는 문맥을 고려하지 않고 객체를 고립시킨 채 오퍼레이션을 결정한다.

### 데이터 중심 설계는 객체의 행동보다는 상태에 초점을 맞춘다.
데이터 중심의 관점에서 객체는 그저 단순한 데이터의 집합체로 데이터 객체를 사용하는 절차를 분리된 별도의 객체 안에서 구현하게 된다. 이것이 첫 번째 설계가 실패한 이유다.

데이터를 먼저 결정하고 데이터를 처리하는데 필요한 오퍼레이션을 나중에 결정하는 방식은 데이터에 대한 지식이 인터페이스에 그대로 드러나게 된다. 이것이 두 번째 설계가 실패한 이유다.

데이터 중심의 설계는 너무 이른 시기에 데이터에 대해 고민하기 때문에 객체 내부 구현이 인터페이스를 어지럽힌다.

### 데이터 중심 설계는 객체를 고립시킨 채 오퍼레이션을 정의하도록 만든다.
객체지향 애플리케이션은 협력하는 객체의 공동체를 구축하는 것을 의미한다. 올바른 객체지향 설계의 무게 중심은 객체의 내부가 아니라 외부에 맞춰져 있어야 한다.