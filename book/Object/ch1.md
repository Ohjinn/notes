- [00 들어가며](#00-들어가며)
- [01 객체, 설계](#01-객체-설계)
  - [01. 티켓 판매 애플리케이션 구현하기](#01-티켓-판매-애플리케이션-구현하기)
    - [클래스의 구현](#클래스의-구현)
    - [클래스 다이어그램](#클래스-다이어그램)
  - [02. 무엇이 문제인가](#02-무엇이-문제인가)
    - [예상을 빗나가는 코드](#예상을-빗나가는-코드)
    - [변경에 취약한 코드](#변경에-취약한-코드)
  - [03. 설계 개선하기](#03-설계-개선하기)
    - [자율성을 높이자](#자율성을-높이자)
    - [개선점](#개선점)
    - [한 일](#한-일)
    - [캡슐화와 응집도](#캡슐화와-응집도)
    - [절차지향과 객체지향](#절차지향과-객체지향)
    - [책임의 이동](#책임의-이동)
    - [추가개선](#추가개선)
    - [실세계와 객체지향](#실세계와-객체지향)
  - [04. 객체지향 설계](#04-객체지향-설계)
    - [설계가 왜 필요한가](#설계가-왜-필요한가)
    - [객체지향 설계](#객체지향-설계)

# 00 들어가며
프로그래밍 패러다임은 개발자 공동체가 동일한 프로그래밍 스타일과 모델을 공유할 수 있게 함으로써 불필요한 부분에 대한 의견 충돌을 방지한다. 또한, 프로그래밍 패러다임을 교육시킴으로써 동일한 규칙과 방법을 공유하는 개발자로 성장할 수 있도록 준비시킬 수 있다.

각 프로그래밍 언어가 제공하는 특징과 프로그래밍 스타일은 해당 언어가 채택하는 프로그래밍 패러다임에 따라 달라지며 자바는 객체지향 패러다임을 기반으로 한다.

# 01 객체, 설계
프로그래밍 안에서도 분야별로 이론과 실무의 발전속도가 다르지만 적어도 `소프트웨어 설계`와 `소프트웨어 유지보수`는 실무가 이론보다 앞서있다.  
이 책은 훌륭한 객체지향 프로그램을 설계하고 유지보수 하는데 필요한 원칙과 기법을 설명하는데 그 방법으로 추상적인 개념이나 이론이 아닌 코드 그 자체로 설명한다.

## 01. 티켓 판매 애플리케이션 구현하기
작은 소극장의 티켓 판매 어플리케이션을 구축할 때 이벤트를 한다고 생각해보자. 추첨을 통해 선정된 관람객은 공연을 무료로 관람할 수 있다.

각 클래스들의 구현과 다이어그램은 아래와 같다.

### 클래스의 구현

<details>
  <summary>Invitation</summary>

  ```java
  public class Invitation {
    private LocalDateTime when;
}
  ```

</details>

<details>
  <summary>Ticket</summary>

  ```java
  public class Ticket {
    private Long fee;

    public Long getFee() {
        return fee;
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

    public Bag(Long amount) {
        this(null, amount);
    }

    public Bag(Invitation invitation, long amount) {
        this.invitation = invitation;
        this.amount = amount;
    }

    public boolean hasInvitation() {
        return invitation != null;
    }

    public boolean hasTicket() {
        return ticket != null;
    }

  //    이 권한을 왜 너가가져감
    public void setTicket(Ticket ticket) {
        this.ticket = ticket;
    }

  //    amount는 vo로 가져가야될 것 같다.
    public void minusAmount(Long amount) {
        this.amount -= amount;
    }

    public void plusAmount(Long amount) {
        this.amount = amount;
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

    public Bag getBag() {
        return bag;
    }
}

  ```

</details>

<details>
  <summary>TicketOffice</summary>

  ```java
  public class TicketOffice {
    private Long amount;
    private List<Ticket> tickets = new ArrayList<>();

    public TicketOffice(Long amount, Ticket ...tickets) {// zero or more Ticket parameters
        this.amount = amount;
        this.tickets.addAll(Arrays.asList(tickets));
    }

    public Ticket getTicket() {
        return tickets.remove(0);
    }

    public void minusAmount(Long amount) {
        this.amount -= amount;
    }

    public void plusAmount(Long amount) {
        this.amount = amount;
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

    public TicketOffice getTicketOffice() {
        return ticketOffice;
    }
}

  ```

</details>

  <summary>Theater</summary>

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


### 클래스 다이어그램
![다이어그램](Images/1-1.jpeg)

## 02. 무엇이 문제인가
문제가 많다. 읽기 전 내 생각을 적어보자면. Theater에게 모든 기능이 의존하고 있다. 객체지향의 기본 개념인 객체의 협력이 아닌 객체의 통제로 느껴진다.

로버트 마틴은 <클린 소프트웨어: 애자일 원칙과 패턴, 그리고 실천 방법>에서 소프트웨어 모듈이 가져야 하는 세 가지 기능에 대해 설명한다.
1. 실행 중에 제대로 동작하는 것
2. 변경을 위해 존재하는 것
3. 코드를 읽는 사람과 의사소통 하는 것

위의 코드는 2, 3은 만족하지 못한다.
<br><br>

### 예상을 빗나가는 코드
이해 가능한 코드란 그 동작이 우리의 예상에서 크게 벗어나지 않는 코드지만 해당 예제는 우리의 예상을 벗어난다.  
`소극장이 가방을 열어 초대장이 있는지 확인하고 초대장이 있다면 티켓 소매넣기, 없다면 현금 소매치기 후 티켓 소매넣기`

현실은 관람객이 초대장을 판매원에게 넘기고 티켓을 받는다.

따라서 기능 `3. 코드를 읽는 사람과 의사소통 하는 것` 을 만족하지 못한다.  
<br><br>

### 변경에 취약한 코드
관람객이 가방을 가지고 있다는 가정이 바뀌면 Audience 클래스에서 Bag을 제거해야 하는데 이 때 Theater의 enter 메서드도 수정해야 한다. 다른 클래스다 Audience에 Bag이라는 내부 사정을 많이 알 수록 코드의 변경이 어려워진다. Theater는 너무 많은 클래스에 의존한다.

객체 사이의 의존성(dependency)와 관련된 문제로 최소한의 의존성을 유지하는 것이 중요하다.

의존성의 비슷한 말로 결합도가 있다. 객체 사이의 의존성이 과한 경우 결합도(coupling)가 높다고 말하는데 두 객체 사이의 결합도가 높을 수록 하나의 변경에 다른 객체도 변경될 가능성이 높아진다. 해당 코드는 결합도가 너무 높다.
<hr>

## 03. 설계 개선하기
Theater가 원하는 것은 관람객이 소극장에 입장하는 것이고 관람객과 판매원 사이의 상호작용은 몰라도 된다.  
관람객과 판매원을 자율적인 존재로 만들면 비교적 코드를 이해하기 쉬워진다.
<br><br>

### 자율성을 높이자
Audience와 TicketSeller가 각자 Bag과 TicketOffice를 처리하는 자율적 존재가 되도록 설계를 변경해보자.

1. Theater의 enter 메서드에서 TicketOffice에 접근하는 코드를 TicketSeller 내부로 옮겨보자
   Theater의 로직을 모두 TicketSeller의 sellTo 메서드에 옮기면
    <details>
    <summary>이전 TicketSeller</summary>

    ```java
    public class TicketSeller {
        private TicketOffice ticketOffice;

        public TicketSeller(TicketOffice ticketOffice) {
            this.ticketOffice = ticketOffice;
        }

        public TicketOffice getTicketOffice() {
            return ticketOffice;
        }
    }

    ```
    </details>

    <details>
    <summary>이후 TicketSeller</summary>

    ```java
    public class TicketSeller {
        private TicketOffice ticketOffice;

        public TicketSeller(TicketOffice ticketOffice) {
            this.ticketOffice = ticketOffice;
        }

        public void sellTo(Audience audience) {
            if(audience.getBag().hasInvitation()) {
                Ticket ticket = ticketOffice.getTicket();
                audience.getBag().setTicket(ticket);
            } else {
                Ticket ticket = ticketOffice.getTicket();
                audience.getBag().minusAmount(ticket.getFee());
                ticketOffice.plusAmount(ticket.getFee());
                audience.getBag().setTicket(ticket);
            }
        }
    }
    ```
    </details>
    
    - getTicketOffice가 사라져 ticketOffice에 대한 접근은 오직 TicketSeller 안에서만 가능해진다.
    내부로의 접근을 제한하면 객체 사이의 결합도를 낮출 수 있다고 하며 이는 `캡슐화`이다.
    - Theater는 오직 TicketSeller의 인터페이스에만 의존하며 TicketSeller가 내부에 TicketOffice 인스턴스를 포함하고 있다는 사실은 구현(implementation)의 영역에 속한다.
    - 객체를 인터페이스와 구현으로 나누고 인터페이스만 공개하는 것은 결합도를 낮추기 위한 기본 설계 원칙이다.
2. TicketSeller에게 넘어간 Audience의 의존성을 개선해보자
    <details>
    <summary>이전 Audience</summary>

    ```java
    public class Audience {
      private Bag bag;

      public Audience(Bag bag) {
          this.bag = bag;
      }

      public Bag getBag() {
          return bag;
      }
    }
    ```
    </details>

    <details>
    <summary>이후 Audience</summary>

    ```java
    public class Audience {
        private Bag bag;

        public Audience(Bag bag) {
            this.bag = bag;
        }
        
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

    - Audience는 자신의 가방 안에 초대장이 들어있는지 스스로 확인한다.
    - TicketSeller와 Audience 사이의 결합도가 낮아졌다.

### 개선점
- Audience와 TicketSeller가 자신이 가지고 있는 소지품을 스스로 관리한다. - `3. 코드는 읽는 사람과 의사소통하는 것`을 개선했다.
- Audience나 TicketSeller의 내부 구현 변경에도 Theater를 변경하지 않아도 된다. - `2. 변경을 위해존재하는 것`을 개선했다.

### 한 일
- 각 객체가 자기 자신의 일을 스스로 해결하도록 변경했다.
- 객체의 자율성을 높였다.

### 캡슐화와 응집도
- 객체 내부의 상태를 캡슐화하고 객체 간에 메시지를 통해 상호작용하도록 만드는 것이 핵심이다.
- 밀접하게 연관된 작업만을 수행하고 연관성 없는 작업은 다른 객체에게 위임하는 객체를 `응집도`가 높다고 말한다.

### 절차지향과 객체지향
- 처음의 enter() 메서드는 프로세스이며 Audience, TicketSeller, Bag, TicketOffice는 데이터로 프로세스와 데이터를 별도의 모듈에 위치시키는 방식을 `절차적 프로그래밍`이라고 부른다.
  - 데이터의 변경으로 인한 영향을 지역적으로 고립시키기 어렵다.
- 데이터와 프로세스가 동일한 모듈 내부에 위치하도록 프로그래밍하는 방식을 `객체지향 프로그래밍`이라고 부른다.

### 책임의 이동
절차와 객체의 근본적인 차이가 책임의 이동이다. 처음 코드는 Theater에 책임이 집중되어 있었지만 개선된 코드는 제어 흐름이 각 객체에 분산되어 있었다.

설계를 어렵게 만드는 것은 `의존성`이고, 불필요한 의존성을 제거해 객체 사이의 `결합도`를 낮추는 것이 중요한다. 결함도를 낮추기 위한 방식으로 Theater가 몰라도 되는 세부 사항을 Audience와 TicketSeller 내부로 감추고 `캡슐화` 했다. `캡슐화`는 객체의 자율성을 높이고 `응집도` 높은 객체들의 공동체를 창조한다.

### 추가개선
1. Bag의 객체화
    <details>
    <summary>Bag에 hold() 추가</summary>

    ```java
    public class Bag {
        private Long amount;
        private Invitation invitaion;
        private Ticket ticket;

        public Bag(Long amount) {
            this(null, amount);
        }

        public Bag(Invitation invitaion, long amount) {
            this.invitaion = invitaion;
            this.amount = amount;
        }

        public Long hold(Ticket ticket) {
            if (hasInvitation()) {
                setTicket(ticket);
                return 0L;
            } else {
                setTicket(ticket);
                minusAmount(ticket.getFee());
                return ticket.getFee();
            }
        }

        public boolean hasInvitation() {
            return invitaion != null;
        }

        public void setTicket(Ticket ticket) {
            this.ticket = ticket;
        }

        public void minusAmount(Long amount) {
            this.amount -= amount;
        }

    }

    ```
    </details>
2. Audience 수정
    <details>
    <summary>Audience에서 bag의 hold 인터페이스 사용</summary>

    ```java
    public class Audience {
        private Bag bag;

        public Audience(Bag bag) {
            this.bag = bag;
        }

        public Long buy(Ticket ticket) {
            return bag.hold(ticket);
        }
    }
    ```
    </details>

3. TicketOffice 수정
    <details>
    <summary>sellTicketTo 메서드 추가</summary>

    ```java
    public class TicketOffice {
        public void sellTicketTo(Audience audience) {
            plusAmount(audience.buy(getTicket()));
        }

        public Ticket getTicket() {
            return tickets.remove(0);
        }

        public void plusAmount(Long amount) {
            this.amount = amount;
        }
    }
    ```
    </details>

4. TicketSeller 수정
    <details>
    <summary>sellTo 메서드 수정</summary>

    ```java
    public class TicketSeller {
        private TicketOffice ticketOffice;

        public TicketSeller(TicketOffice ticketOffice) {
            this.ticketOffice = ticketOffice;
        }

        public void sellTo(Audience audience) {
            ticketOffice.sellTicketTo(audience);
        }
    }
    ```
    </details>

하지만 해당 변경은 TicketOffice와 Audience 사이에 의존성을 만들어버렸다. 이전에는 TicketSeller가 직접 TicketOffice에서 getTicket()을 통해 티켓을 가져와 audience에게 사게 만들었다면 이제는 Audience에게 직접 팔기 때문에 Audience에 대해 알아야 한다. 새로운 의존성이다. TicketOffice의 자율성은 높아졌지만 결함도가 상승했다.

- 기능을 설계하는 방법은 한 가지 이상일 수 있다.
- 동일한 기능을 한가지 이상의 방법으로 설계할 수 있기 때문에 트레이드오프의 산물이다. 모든사람을 만족시킬순 없다.

### 실세계와 객체지향
Theater와 Bag, TicketOffice는 실세계에서 자율적 존재가 아니지만 객체지향에서는 자율적 존재로 취급한다.  
이를 의인화(anthropomorphism)이라고 한다.

## 04. 객체지향 설계

### 설계가 왜 필요한가
설계란 코드의 배치다. 설계는 코드 작성의 일부며 코드를 작성하지 않고서는 검증할 수 없다.

설계는 두 가지 요구사항을 만족시켜야 한다.
1. 오늘 완성해야 하는 기능을 구현하는 코드를 짜야 하는 동시에 내일 쉽게 변경할 수 있는 코드를 짜야 한다.
2. 좋은 설계란 요구하는 기능을 온전히 수행하면서 내일의 변경을 매끄럽게 수용할 수 있는 설계

요구사항은 항상 변경되기 때문이다.

### 객체지향 설계
- 객체지향 프로그래밍은 의존성을 효율적으로 통제할 수 있는 다양한 방법을 제공해 요구사항 변경에 수월하게 대응할 수 있다.
- 변경 가능한 코드란 이해하기 쉬운 코드다.
- 훌륭한 객체지향 설계란 협력하는 객체 사이의 의존성을 적절하게 관리하는 설계다.