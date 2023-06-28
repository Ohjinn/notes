- [CQS(Command Query Separation)](#cqscommand-query-separation)
- [CQRS(Command and Query Responsibility Segregation)](#cqrscommand-and-query-responsibility-segregation)
  - [기존 아키텍쳐](#기존-아키텍쳐)
  - [CQRS](#cqrs)
    - [CQRS의 장점](#cqrs의-장점)
    - [CQRS의 단점](#cqrs의-단점)
- [SSOT(Single Source Of Truth)](#ssotsingle-source-of-truth)
- [Materialized View](#materialized-view)
- [OLTP(Online Transaction Processing)](#oltponline-transaction-processing)
- [OLAP(Online Analytical Processing)](#olaponline-analytical-processing)
- [Event Sourcing](#event-sourcing)

# CQS(Command Query Separation)
객체의 메서드를 Query와 Command로 정확히 구분해서 사용해야 한다는 원칙으로 Query와 Command가 나눠져 있다면 Query를 사용할 떄 자신감을 얻을 수 있고 Command를 사용할 때는 더 조심할 수 있다.

# CQRS(Command and Query Responsibility Segregation)
읽기와 데이터 저장을 위한 업데이트 구현을 구분하는 패턴으로 퍼포먼스, 확장성, 보안을 극대화할 수 있고 그로 인한 유연성으로 시스템의 도메인 모델과의 충돌을 방지하는 방향으로 발전할 수 있다.

## 기존 아키텍쳐
![traditional model](/CQRS/images/traditional_model.png)  
기존 아키텍쳐는 동일한 모델을 사용해 쿼리와 업데이트를 한다. 이는 기본적 CRUD 작업에 적합하다. 더 복잡한 어플리케이션에서는 읽기 측면에서 다양한 DTO의 형태로 데이터를 리턴하기 때문에 객체 매핑이 복잡해진다. 쓰기 측면에서는 모델이 복잡한 유효성 검사와 비즈니스 로직을 실행하게 됨으로서 할 일이 너무 많아진다.

하지만 읽기와 쓰기는 성능과 규모에 따라 비대칭적인 경우가 많다.
- 작업의 일부로 필요하지 않더라도 추가적인 컬럼이나 속성같이 올바르게 업데이트해야 하는경우가 있다.
- 동일한 데이터 집합에 대해 병렬로 작업을 수행할 때 데이터 경합이 발생할 수 있다.
- 기존의 접근 방식은 데이터 저장과 엑세스 계층의 부하와 정보 검색에 필요한 쿼리의 복잡성으로 성능에 부정적 영향을 미칠 수 있다.
- 각각의 엔티티가 읽기와 쓰기 작업을 모두 수행하기 때문에 잘못된 컨텍스트에 데이터가 노출될 수 있어 보안과 권한 관리가 복잡해질 수 있다.

## CQRS

CQRS는 읽기와 쓰기에 다른 모델을 사용한다.
- 커맨드는 데이터보다는 역할 기반이어야 한다.(setReservationStatus보다는 Book Hoel Room)
- 커맨드는 동기 프로세싱보다는 비동기 프로세싱을 위해 큐에 적재되어야 한다.
- 쿼리는 데이터베이스를 수정하면 안된다. 쿼리는 어떤 도메인 지식도 캡슐화하지 않는 DTO를 반환한다

그럼 모델이 아래 다이어그램처럼 고립된다.  
![command-and-query-responsibility-segregation-cqrs-basic](images/command-and-query-responsibility-segregation-cqrs-basic.png)

쿼리와 업데이트 모델을 분리하면 설계와 구현이 간단해지지만 ORM같은 스캐폴딩 메커니즘을 이용해 CQRS코드를 자동으로 생성할 수 없다.

격리를 강화하기 위해 읽기 데이터와 쓰기 데이터를 물리적으로 분리할 수도 있다. 이런 경우에 데이터베이스는 쿼리에 최적화된 자체 데이터베이스 스키마를 사용할 수 있다. 예를 들어 데이터의 [materialized view](https://learn.microsoft.com/en-us/azure/architecture/patterns/materialized-view)를 사용할 수 있다. 예를 들어 읽기를 위해서는 document database, 쓰기를 위해서는 관계형 데이터베이스를 이용할 수 있다.

만약 읽기와 쓰기 데이터베이스가 분리되어 있다면 싱크를 지속적으로 맞춰줘야 하는데 전형적으로 쓰기 모델이 이벤트를 발행해 이를 수행한다. 이는 event driven architecture라고 한다.


### CQRS의 장점
- 독립적 확장: CQRS는 읽고 쓰는 부하를 독립적으로 주기 때문에 적은 락 중첩이 발생한다.
- 최적화된 데이터 스키마: 읽기 측에서는 쿼리에 최적화된 스키마를 사용할 수 있고 쓰기 측에서는 업데이트에 최적화된 스키마를 사용할 수 있다.
- 보안: 올바른 도메인 엔티티만 데이터에 쓰게 하는게 가능해진다.
- 관심사의 분리; 읽기와 쓰기의 분리는 유지보수의 용이성과 유연성을 증진시킨다. 복잡한 도메인 모델은 쓰기 모델로, 읽기 모델은 비교적 단순해진다.
- 단순한 쿼리: 읽기 데이터베이스의 materialized view로 인해 복잡한 조인을 피할 수 있게된다.

### CQRS의 단점
- 복잡성: CQRS의 아이디어는 단순하지만 이벤트 소싱을 포함한다면 특히 더 복잡한 어플리케이션 디자인을 가지게 된다.
- 메시징: CQRS에는 메시징이 필요하지 않지만 일반적으로 메시징을 사용하는데 애플리케이션은 메시지 실패 또는 중복 메시지를 처리해야 한다.
- 최종 일관성: 만약 읽기와 쓰기를 분리하면 읽기 데이터가 부실해질 수 있다. 사용자가 오래된 읽기 데이터를 기반으로 요청을 발행한 경우 이를 감지하기 어려워질 수 있다.


# SSOT(Single Source Of Truth)
데이터 스키마의 모든 데이터 요소를 한 곳에서만 제어 또는 편집하도록 조직하는 관례로 데이터 요소로의 가능한 연결은 모두 참조로만 이루어진다.  
진실 공급원의 데이터 요소를 갱신하면 수정 사항 반영을 빠뜨릴 데이터의 사본이 존재할 가능성 없이 시스템 전체에 전파되게 된다.

# Materialized View
구체화뷰는 쿼리의 결과를 담고 있는 데이터베이스 오브젝트로 원거리 테이블에 기반한 데이터를 저장하는 것으로 스냅샷이라고도 부른다.

# OLTP(Online Transaction Processing)
트랜잭션 지향 어플리케이션을 손쉽게 관리할 수 있도록 도와주는 정보시스템의 계열로 데이터 기입 및 트랜잭션 처리를 위해 존재한다. 일반적으로 애플리케이션과 긴밀한 관계를 밎는 일반적인 트랜잭션 처리를 OLTP라고 부른다.

# OLAP(Online Analytical Processing)
의사결정에 활용하기 위해 데이터를 분석하는 것을 OLAP라고 한다.

# Event Sourcing
애플리케이션의 현재 상태를 알기 위해서 쿼리할수도 있지만 현재 상태에 어떻게 도달했는지 알고싶을 때도 있다.
이벤트소싱은 이런 모든 변화를 이벤트 시퀀스에 저장한다. 이런 이벤트를 검색할 뿐만이 아니라 과거의 로그를 재구성해서 소급 변경에 대처하기 위해 자동으로 상태를 조정하는 기반으로 사용할 수도 있다.

이벤트 소싱의 기본 개념은 애플리케이션 상태의 모든 변경 사항을 이벤트 객체에 캡쳐하고 애플리케이션 상태와 동일한 라이프타임 안에서 적용된 순서대로 저장되도록 하는 것이다.


[CQS](https://martinfowler.com/bliki/CommandQuerySeparation.html)  
[CQRS](https://learn.microsoft.com/en-us/azure/architecture/patterns/cqrs)  