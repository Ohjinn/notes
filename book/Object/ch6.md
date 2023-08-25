- [메시지와 인터페이스](#메시지와-인터페이스)
  - [협력과 메시지](#협력과-메시지)
    - [클라이언트-서버 모델](#클라이언트-서버-모델)
    - [메시지와 메서드](#메시지와-메서드)
    - [퍼블릭 인터페이스와 오퍼레이션](#퍼블릭-인터페이스와-오퍼레이션)
    - [시그니처](#시그니처)
  - [인터페이스와 설계 품질](#인터페이스와-설계-품질)
  - [원칙의 함정](#원칙의-함정)
    - [디미터 법칙은 하나의 도트를 강제하는 규칙이 아니다.](#디미터-법칙은-하나의-도트를-강제하는-규칙이-아니다)
    - [결합도와 응집도의 충돌](#결합도와-응집도의-충돌)
  - [명령-쿼리 분리 원칙(CQS)](#명령-쿼리-분리-원칙cqs)
    - [반복 일정의 명령과 쿼리 분리하기](#반복-일정의-명령과-쿼리-분리하기)
    - [명령-쿼리 분리의 참조 투명성](#명령-쿼리-분리의-참조-투명성)
    - [책임에 초점을 맞춰라](#책임에-초점을-맞춰라)

# 메시지와 인터페이스
클래스는 객체지향을 위한 도구 중 하나다. 하지만 클래스라는 구현 도구에 지나치게 집착하면 경직되고 유연하지 못한 설계에 이르게 된다.
클래스 사이의 정적인 관계에서 메시지 사이의 동적인 흐름으로 초점을 전환하는 것이 객체지향 설계의 시작이다.

훌륭한 퍼블릭 인터페이스를 얻기 위해서는 책임주도 설계 뿐만 아니라 다양한 설계 원칙과 기법을 익히고 적용해야 한다. 이번 장은 이런 원칙과 기법에 대해 살펴본다.

## 협력과 메시지

### 클라이언트-서버 모델
협력은 어떤 객체가 다른 객체에게 무언가를 요청할 때 시작된다. 두 객체 사이의 협력 관계에서 사용하는 전통적 메타포(은유)는 `클라이언트-서버 모델`이다.  
협력은 클라이언트가 서버의 서비스를 요청하는 단방향 상호작용이다.

객체는 협력에 참여하는 동안 클라이언트와 서버의 역할을 동시에 수행하는 것이 일반적이다. 객체는 독립적으로 수행할 수 있는 것보다 더 큰 책임을 수행하기 위해 다른 객체와 협력해야 한다. 그리고 그 협력은 메시지를 통해서 한다.

- 메시지: 객체들이 협력하기 위해 사용할 수 있는 유일한 의사소통 수단
- 메시지 전송(메시지 패싱): 객체가 다른 객체에게 도움을 요청하는 것
- 메시지 전송자: 메시지를 전송하는 객체
- 메시지 수신자: 메시지를 수신하는 객체
- 인자 + 오퍼레이션명: 메시지의 구성요소
- 메시지 수신자 + 오퍼레이션명 + 인자: 메시지 전송

condition.isSatisfiedBy(screening) 순서대로 수신자 + 오퍼레이션명 + 인자로 구성돼있다.

### 메시지와 메서드
condition은 DiscountCondition의 인터페이스였다. 그 안에서 실제로 실행되는 함수 또는 프로시저를 `메서드`라고 부른다.  
따라서, 코드 상에서 동일한 변수에게 동일한 메시지를 전송하더라도 객체의 타입에 따라 실행되는 메서드가 달라질 수 있다.

계산을 메시지와 메서드로 분리하고 실행 시간에 수신자의 클래스에 기반해 메시지를 메서드에 바인딩한다.

이런 메시지와 메서드의 구분은 메시지 전송자와 수신자의 느슨한 결합을 만든다. 이런 메커니즘은 두 객체 사이의 결합도를 낮춰 유연하고 확장 가능한 코드를 작성할 수 있게 만든다.

### 퍼블릭 인터페이스와 오퍼레이션
객체가 의사소통을 위해 외부에 공개하는 메시지의 집합을 `퍼블릭 인터페이스`라고 부른다.

퍼블릭 인터페이스에 포함된 메시지를 `오퍼레이션`이라고 부른다. 오퍼레이션은 내부의 구현 코드는 제외하고 단순히 메시지와 관련된 시그니처를 가리키는 경우가 대부분이다.

메시지를 수신했들 때 실제로 실행되는 코드는 `메서드`라고 부른다.

객체가 다른 객체에게 메시지를 전송하면 런타임 시스템은 메시지 전송을 오퍼레이션 호출로 해석하고 객체의 실제 타입을 기반으로 적절한 메서드를 찾아 실행한다.  
퍼블릭 인터페이스와 메시지의 관점에서 보면 `메서드 호출` 보다는 `오퍼레이션 호출`이라는 단어가 더 적절하다.

### 시그니처
오퍼레이션의 이름과 파라미터 목록을 합쳐 `시그니처`라고 부른다. 오퍼레이션은 실행 코드 없이 시그니처만을 정의한 것으로 일반적으로 메시지를 수신하면 오퍼레이션의 시그니처와 동일한 메서드가 실행된다.

## 인터페이스와 설계 품질
인터페이스는 최소한의 인터페이스와 추상적인 인터페이스라는 조건을 만족해야 한다. 책임 주도 설계 방식은 메시지를 먼저 선택해 협력과는 무관한 오퍼레이션이 인터페이스에 스며드는 것을 방지한다.
또한 객체가 메시지를 선택하는 것이 아니라 메시지가 객체를 선택해 클라이언트의 의도를 메시지에 표현할 수 있게 한다.

퍼블릭 인터페이스의 품질에 영향을 미치는 원칙과 기법에 관해 살펴보자.
- 디미터 법칙
  - 협력하는 객체 내부 구조에 대한 결합으로 인해 발생하는 설계 문제를 해결하기 위한 원칙
  - 객체의 내부 구조에 강하게 결합되지 않게 협력 경로를 제한하라
  - 클래스 내부의 메서드가 아래 조건을 만족하는 인스턴스에만 메시지를 전송해야 한다.
    - this객체
    - 메서드의 매개변수
    - this의 속성
    - this의 속성인 컬렉션의 요소
    - 메서드 내에서 생성된 지역 객체
  - screening.getMovie().getDiscountConditions();
  - 메시지의 전송자가 수신자의 내부 구조에 대해 물어보고 반환받은 요소는 연쇄적 메시지를 전송하는데 이를 기차 충돌이라고 부른다.
  - 객체 내부 구조를 묻는 메시지가 아니라 수신자에게 무언가를 시키는 메시지가 더 좋은 메시지다.
- 묻지 말고 시켜라
  - 훌륭한 메시지는 객체의 상태에 관해 묻지 말고 원하는 것을 시켜야 한다.
- 의도를 드러내는 인터페이스(의도를 드러내는 선택자)
  - 메서드를 명명하는 방법은 `메서드가 작업을 어떻게 수행하는지를 나타내도록 이름 짓는 것`, `어떻게가 아니라 무엇을 하는지를 드러내는 것` 두 가지 방법이 있다.
    - isSatisfiedByPeriod와 isSatisfiedBySequence 모두 할인 조건을 판단하는 동일한 작업을 수행하는데 메서드 수준에서 캡슐화를 위반한다.
    - 무엇을 하는지를 드러내는 이름은 유연한 코드를 낳는다.
    - 어떻게 수행하는지를 드러내는 이름은 메서드의 내부 구현을 설명한다. 협력을 설계하기 전에 클래스의 내부 구현에 관해 고민할 수밖에 없다. 
    - 무엇을 하는지를 드러내도록 메서드의 이름을 짓기 위해서는 객체가 협력 안에서 수행해야 하는 책임에 관해 고민해야 한다.
  - 두 메서드는 할인 여부를 판단하기 위한 작업을 수행하기 때문에 두 메서드 모두 클라이언트의 의도를 담을 수 있도록
    - isSatisfiedBy로 명명하는 것이 적절하다.
    - DiscountCondition 인터페이스에 isSatisfiedBy를 정의하면 클라이언트 입장에서 두 메서드 모두 동일한 방식으로 사용할 수 있다.
- 명령-쿼리 분리

```java
public class Theater {
    private TicketSeller ticketSeller;

    public Theater(TicketSeller ticketSeller) {
        this.ticketSeller = ticketSeller;
    }

    public void enter(Audience audience) {
        if (audience.getBag().hasInvitation()) {
            Ticket ticket = ticketSeller.getTicketOffice().getTicket();
            audience.getBag().setTicket(ticket);
        } else {
            Ticket ticket = ticketSeller.getTicketOffice().getTicket();
            audience.getBag().minusAmount(ticket.getFee());
            ticketSeller.getTicketOffice().plusAmount(ticket.getFee());
            audience.getBag().setTicket(ticket);
        }
    }
}
```
다음 enter 메서드는 디미터 법칙을 위반한 코드의 전형적인 모습을 보여준다.
Theater가 인자로 전달된 audience와 인스턴스 변수인 ticketSeller에게 메시지를 전송하는 것은 문제 없지만 Theater가 audience와 ticketSeller내부에 포함된 객체에도 접근하고 있다.  
이는 인터페이스와 구현의 분리 원칙을 위반한다. 객체의 내부 구조는 구현으로 getBag을 포함시키는 순간 객체의 구현이 인터페이스를 통해 외부로 새어나간다.

Theater는 TicketSeller와 Audience의 내부 구조에 묻지 않고 원하는 작업을 시켜야 한다.

<details>
<summary>Theater</summary>

```java
public class Theater {
    private TicketSeller ticketSeller;

    public Theater(TicketSeller ticketSeller) {
        this.ticketSeller = ticketSeller;
    }

    public void enter(Audience audience) {
        ticketSeller.setTicket(audience);
    }
}
```
</details>

<details>
<summary>Audience</summary>

```java
public class Audience {
    private Bag bag;

    public Audience(Bag bag) {
        this.bag = bag;
    }

    public Long setTicket(Ticket ticket) {
        return bag.setTicket(ticket);
    }
}
```
</details>

<details>
<summary>TicketSeller</summary>

```java
public class TicketSeller {
    private TicketOffice ticketOffice;

    public TicketSeller(TicketOffice ticketOffice) {
        this.ticketOffice = ticketOffice;
    }

    public void setTicket(Audience audience) {
        ticketOffice.plusAmount(audience.setTicket(ticketOffice.getTicket()));
    }
}
```
</details>

<details>
<summary>Bag</summary>

```java
public class Bag {
    private Long amount;
    private Invitation invitation;
    private Ticket ticket;

    public Bag(long amount) {
        this(null, amount);
    }

    public Bag(Invitation invitation, long amount) {
        this.invitation = invitation;
        this.amount = amount;
    }

    public Long setTicket(Ticket ticket) {
        if (hasInvitation()) {
            this.ticket = ticket;
            return 0L;
        } else {
            this.ticket = ticket;
            minusAmount(ticket.getFee());
            return ticket.getFee();
        }
    }

    private boolean hasInvitation() {
        return invitation != null;
    }

    private void minusAmount(Long amount) {
        this.amount -= amount;
    }
}
```
</details>

디미터 법칙에 따라 각각의 객체가 협력을 위해 다른 객체에게 묻지 않고 시키고 있다.

Audience는 스스로 자신의 상태를 제어하는 자율적인 존재가 됐다.

이제 여기에서 인터페이스에 의도를 드러내보자.
TicketSeller의 setTicket과 Audience의 setTicket이 각각 무엇을 의도하는지 한눈에 들어오지 않는다.

Theater는 ticketSeller에게 Audience에게 티켓을 판매하라고 명령하고 싶었기 때문에 sellTo로 명명을,  
TicketSeller는 Audience에게 티켓을 사도록 명령하고 싶었기 때문에 buy()로,
Audience는 Bag에게 티켓 보관을 명령하고 싶었기 때문에 hold로 변경한다면 클라이언트의 의도를 분명하게 표현할 수 있다.

디미터 법칙은 객체간의 협력을 설계할 때 캡슐화를 위반하는 메시지가 인터페이스에 포함되지 않도록 제한하고  
묻지 말고 시켜라 원칙은 디미터 법칙을 준수하는 협력을 만들기 위한 스타일을 제시한다.  
의도를 드러내는 인터페이스 원칙은 객체의 퍼블릭 인터페이스에 어떤 이름이 드러나야 하는지 지침을 제공해 코드의 목적을 명확하게 해준다.  

## 원칙의 함정
### 디미터 법칙은 하나의 도트를 강제하는 규칙이 아니다.
```java
IntStream.of(1, 15, 20, 3, 9).filter(x -> x > 10).distinct().count();
```
하나 이상의 도트가 디미터 법칙의 위반을 의미하는 것은 아니다. 객체의 내부 구현에 대한 어떤 정보도 외부에 노출하지 않는다면 디미터 법칙을 준수한 것이다.

### 결합도와 응집도의 충돌
위의 Theater를 보면 Audience내부에 포함된 Bag에 대해 질문한 후 반환된 결과를 이용해 Bag을 반환하는데 Thaeter는 Audience의 내부 구조에 강하게 결합된다.
이 문제를 해결하기 위해서 질문하고, 판단하고, 상태를 변경하는 모든 코드를 Audience로 옮기면 된다.

<details>
<summary>Audience</summary>

```java
public class Audience{
    public Long buy(Ticket ticket) {
        if (bag.hasInvitation()) {
            bag.setTicket(ticket);
            return 0L;
        } else {
            bag.setTicket(ticket);
            bag.minusAmount(ticket.getFee());
            return ticket.getFee();
        }
    }
}
```
</details>

하지만 묻지 말고 시켜라와 디미터 법칙이 항상 옳다고는 할 수없다. 모든 상황에서 맹목적으로 위임 메서드를 추가하면 같은 퍼블릭 인터페이스 안에 어울리지 않는 오퍼레이션들이 공존하게 된다.  
객체는 상관 없는 책임들을 한번에 떠안아 결과적으로 응집도가 낮아진다.

<details>
<summary>PeriodCondition</summary>

```java
public class PeriodCondition implements DiscountCondition {
    public boolean isSatisfiedBy(Screening screening) {
        return screening.getStartTime().getDayOfWeek().equals(dayOfWeek) &&
            startTime.compareTo(screening.getStartTime().toLocalTime()) <= 0 &&
            endTime.compareTo(screening.getStartTime().toLocalTime()) >= 0;
    }
}
```
</details>

여기서 isSatisfiedBy메서드가 screening에게 질의한 상영 시작 시간을 이용해 할인 여부를 결정한다. Screening의 내부 상태를 가져오기 때문에 캡슐화를 위반한 것처럼 보이기도 하지만
만약 여기서 Screening에게 할인 여부를 판단하는 로직을 넘긴다면 Screening이 기간에 따른 할인 조건을 판단하는 책임을 떠안게 된다.

Screening은 영화를 예매하는 책임을 안고 있다. PeriodCondition은 할인 조건을 판단한다.

여기선 Screening의 캡슐화를 높이는 것보단 Screening의 응집도를 높이고 Screening과 PeriodCondition의 결합도를 낮추는 것이 더 좋은 방법이다.

추가적으로 객체는 내부 구조를 숨겨야 하므로 디미터 법칙을 따르는 것이 좋지만 자료구조라면 디미터 법칙을 적용할 필요가 없다.

소프트웨어 설계에 존재하는 법칙 중 하나는 `경우에 따라 다르다.`이다.

## 명령-쿼리 분리 원칙(CQS)
가끔 필요에 따라 물어야 한다는 사실을 위에서 이야기했기 때문에 이 때 사용할 수 있는 명령-쿼리 분리 원칙을 알아보자.
명령-쿼리 분리 원칙은 퍼블릭 인터페이스에 오퍼레이션을 정의할 때 참고할 수 있는 지침이다.

- 루틴(routine): 절차를 묶어 호출 가능하도록 이름을 부여한 기능 모듈로 프로시저와 함수로 구분된다.
- 프로시저: 정해진 절차에 따라 내부의 상태를 변경하는 루틴의 한 종류
  - 부수효과를 발생시킬 수 있지만 값을 반환할 수 없다.
- 함수: 어떤 절차에 따라 필요한 값을 계산해서 반환하는 루틴의 한 종류
  - 값을 반환할 수 있지만 부수효과를 발생시킬 수 없다.

### 반복 일정의 명령과 쿼리 분리하기

반복되는 이벤트를 쉽게 관리할 수 있는 소프트웨어를 개발한다고 했을 때
이벤트: 특정 일자에 실제로 발생하는 사건
반복 일정: 일주일 단위로 돌아오는 특정 시간 간격에 발생하는 사건 전체를 포괄적으로 지칭하는 용어

<details>
<summary>Event</summary>

```java
public class Event {
    private String subject;
    private LocalDateTime from;
    private Duration duration;

    public Event(String subject, LocalDateTime from, Duration duration) {
        this.subject = subject;
        this.from = from;
        this.duration = duration;
    }

    public boolean isSatisfied(RecurringSchedule schedule) {
        if (from.getDayOfWeek() != schedule.getDayOfWeek() ||
                !from.toLocalTime().equals(schedule.getFrom()) ||
                !duration.equals(schedule.getDuration())) {
            reschedule(schedule);
            return false;
        }

        return true;
    }

    private void reschedule(RecurringSchedule schedule) {
        from = LocalDateTime.of(from.toLocalDate().plusDays(daysDistance(schedule)),
                schedule.getFrom());
        duration = schedule.getDuration();
    }

    private long daysDistance(RecurringSchedule schedule) {
        return schedule.getDayOfWeek().getValue() - from.getDayOfWeek().getValue();
    }
}
```
</details>

<details>
<summary>RecurringSchedule</summary>

```java
public class RecurringSchedule {
    private String subject;
    private DayOfWeek dayOfWeek;
    private LocalTime from;
    private Duration duration;

    public RecurringSchedule(String subject, DayOfWeek dayOfWeek,
                             LocalTime from, Duration duration) {
        this.subject = subject;
        this.dayOfWeek = dayOfWeek;
        this.from = from;
        this.duration = duration;
    }

    public DayOfWeek getDayOfWeek() {
        return dayOfWeek;
    }

    public LocalTime getFrom() {
        return from;
    }

    public Duration getDuration() {
        return duration;
    }
}
```
</details>

여기서 isSatisfied는 명령과 쿼리 두 가지 역할을 동시에 수행하고 있다.
- isSatisfied메서드는 Event가 RecurringSchedule의 조건에 부합하는지 판단한 후 부합하면 true, 부합하지 않으면 false를 반환한다. 개념적으로 쿼리다.
- 하지만 Event가 RecurringSchedule의 조건에 부합하지 않으면 Event의 상태를 조건에 부합하도록 변경한다. isSatisfied는 부수효과를 가지는 쿼리다.

<details>
<summary>Event</summary>

```java
public class Event {
    private String subject;
    private LocalDateTime from;
    private Duration duration;

    public Event(String subject, LocalDateTime from, Duration duration) {
        this.subject = subject;
        this.from = from;
        this.duration = duration;
    }

    public boolean isSatisfied(RecurringSchedule schedule) {
        if (from.getDayOfWeek() != schedule.getDayOfWeek() ||
                !from.toLocalTime().equals(schedule.getFrom()) ||
                !duration.equals(schedule.getDuration())) {
            return false;
        }

        return true;
    }

    public void reschedule(RecurringSchedule schedule) {
        from = LocalDateTime.of(from.toLocalDate().plusDays(daysDistance(schedule)),
                schedule.getFrom());
        duration = schedule.getDuration();
    }

    private long daysDistance(RecurringSchedule schedule) {
        return schedule.getDayOfWeek().getValue() - from.getDayOfWeek().getValue();
    }
}
```
</details>

Event는 명령과 쿼리를 분리해 다음과 같이 구현될 수 있다 명령과 쿼리의 분리로 코드는 예측 가능하고 이해하기 쉬우며 디버깅이 용이하다.

### 명령-쿼리 분리의 참조 투명성

명령과 쿼리를 분리함으로써 명령형 언어의 틀 안에서 `참조 투명성`의 장점을 누릴 수 있게 된다. 참조 투명성이란 어떤 표현식 e가 있을 때 e의 값으로 e가 나타내는 모든 위치를 교체하더라도 결과가 달라지지 않는 특성을 의미한다.   

f(1) + f(1) = 6
f(1) * 2 = 6
f(1) - 1 = 2

이처럼 어떤 값이 변하지 않는 성질을 `불변성`이라고 부른다.

컴퓨터 세계와 수학 세계를 나누는 가장 큰 특징은 `부수효과`의 존재 유무다.  
불변성은 부수효과의 발생을 방지하고 참조 투명성을 만족시킨다.

참조 투명성은 우리에게 두 가지 장점을 제공한다.
- 모든 함수를 이미 알고 있는 하나의 결과값으로 대체할 수 있기 때문에 식을 쉽게 계산할 수 있다.
- 모든 곳에서 함수의 결과값이 동일하기 때문에 식의 순서를 변경하더라도 각 식의 결과는 달라지지 않는다.

객체지향 패러다임은 객체의 상태 변경이라는 부수효과를 기반으로 하기 때문에 참조 투명성과는 거리가 멀지만 명령-쿼리 원칙으로 그 균열을 조금이나마 줄일 수 있다.  
`명령형 프로그래밍`이란 부수효과를 기반으로 하는 프로그래밍 방식으로 대부분의 프로그래밍 언어는 이에 속한다. `함수형 프로그래밍`은 부수 효과가 발생하지 않는 수학적 함수에 기반해 참조투명성의 장점을 극대화할 수 있다.

### 책임에 초점을 맞춰라
위의 모든 원칙을 따르며 인터페이스를 설계하는 쉬운 방법이 책임 주도 설계 원칙을 따르는 것이다. 책임 주도 설계 원칙을 따르면 해당 원칙들에 다음과 같은 긍정적 영향이 있다.
- 디미터 법칙: 객체보다 메시지를 먼저 결정하면 두 객체 사이의 구조적 결합도를 낮추고 수신할 객체를 알지 못한 상태에서 메시지를 선택하기 때문에 객체 내부에 대해 고민할 필요가 없어진다.
- 묻지 말고 시켜라: 메시지를 먼저 선택하기 때문에 클라이언트의 관점에서 메시지를 선택하기 때문에 필요한 정보를 물을 필요 없이 원하는 것을 표현한 메시지를 전송하면 된다.
- 의도를 드러내는 인터페이스: 메시지를 먼저 선택하면 클라이언트 관점에서 메시지의 이름을 정하기 때문에 클라이언트의 의도가 드러나게 된다.
- 명령-쿼리 분리 원칙: 객체가 어떤 일을 하는지뿐만 아니라 협력 속에서 객체의 상태를 예측하고 이해하기 쉽게 만들기 위한 방법에 관해 고민하게 되기 때문에 예측 가능한 협력을 만들기 위해 명령과 쿼리를 분리하게 된다.

