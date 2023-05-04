- [Domain Model 이란](#domain-model-이란)
- [Repository](#repository)
- [VO(Value Object)](#vovalue-object)


# Domain Model 이란
Layered Architecture는 여러 층으로 구성될 수 있는데 많이 쓰이던 형태는 해당 장의 첫번째 장에 있던 

![layered architecture](https://www.oreilly.com/api/v2/epubs/9781491971437/files/assets/)

다음과 같은 계층 구조를 가지고 있다.

![도메인 모델](https://wikibook.co.kr/images/readit/20141002/figure4.png)

도메인 모델은 기존의 Layered Architecture에 도메인(모델 계층)을 더한 것으로 도메인 계층은 응용 계층을
- 얇게 유지하고
- 업무 규칙이나 지식이 포함되지 않으며
- 오직 작업을 조정하고
- 도메인 객체의 협력자에게 작업을 위임한다

응집력 있고 오직 아래 계층에만 의존하는 각 계층을 발전시키고 사용자의 인터페이스 코드나 애플리케이션 코드를 인프라스트럭처 코드와 격리하면 도메인 객체는 도메인 모델을 표현하는 것에만 집중할 수 있다. 이로써 모델은 본질적인 업무 지식을 포착해 해당 업무 지식이 효과를 발휘할 수 있도록 풍부하고 명확해진다.

# Repository

DAO가 데이터를 관리한다면 Repository는 도메인 모델을 관리한다. DAO는 DB 중심, Repository는 도메인 모델 중심이다.
복잡한 도메인 모델을 사용하는 시스템에서는 데이터 매퍼를 제공하는 것과 같이 도메인 객체를 데이터베이스 액세스 코드의 세부 사항으로부터 분리하는 계층을 사용하는 것이 유용하다. 이 계층을 추가함으로써 중복 쿼리 로직을 최소화할 수 있다.

Repository는 도메인과 데이터 매핑 레이어 사이를 연결시킨다. 또한, 데이터 저장소에 유지되는 객체 집합과 그 객체에 대해 수행되는 작업을 캡슐화해 영속성 계층에 보다 객체지향적인 시각을 제공한다.

# VO(Value Object)

