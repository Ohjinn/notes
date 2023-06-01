- [리파지터리 (Repository)](#리파지터리-repository)
- [Application Layer와 UI Layer](#application-layer와-ui-layer)


# 리파지터리 (Repository)
Repository는 Aggregate를 관리하는 Collection처럼 작동한다.
1. 오직 Aggregate만 Repository를 갖는다.
2. Repository는 영속화 방법 및 기술을 감춘다.

Spring Data JPA는 Aggregate에 대해서만 Repository를 만들어도 CascadeType.ALL과 orphanRemoval = true 같은 기능을 제공하고 있고 Persistence Context를 통해 Collection처럼 사용하는게 가능하면 인터페이스만 만들면 나머지는 크게 신경 쓰지 않아도 되는 기능까지 제공한다

따라서, 우리는 적절한 Aggregate를 발견하고 적절히 책임을 나눌 수 있도록 Entity와 Value Object로 구성하고 이를 위한 Repository를 만듦으로써 비즈니스 도메인에만 집중할 수 있게 된다.

이렇게 비즈니스 도메인에 집중한 코드를 모아둔 곳은 Domain Layer라고 부르면, Repository와 Aggregate를 사용하는 코드가 모인 곳을 Application Layer, Web등 구체적인 기술로 사용자와 소통하는 코드가 모인 곳을 UI Layer라고 부른다.

# Application Layer와 UI Layer