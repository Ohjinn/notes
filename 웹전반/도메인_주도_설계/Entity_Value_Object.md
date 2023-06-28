- [전술적 설계 (Tactical Design)](#전술적-설계-tactical-design)
- [엔티티 (Entity) vs 일반적으로 이야기하는 개체 (Entity)](#엔티티-entity-vs-일반적으로-이야기하는-개체-entity)
- [값 객체 (Value Object, VO)](#값-객체-value-object-vo)
- [동일성(Identity)과 동등성(Equality)](#동일성identity과-동등성equality)


# 전술적 설계 (Tactical Design)
전술적 설계만 다룰 경우 DDD Lite, Model Driven Design이라고 불린다. 커다란 시스템을 만들 때 중요하고 매우 큰 주제로 간단하게 정리해보면 대표적인 패턴 몇 가지로 다룰 수 있다.

1. Entity
2. Value Object
3. Aggregate
4. Repository

# 엔티티 (Entity) vs 일반적으로 이야기하는 개체 (Entity)
DDD에서는 엔티티는 식별자가 존재해서 이를 통해 동일성을 확인한다면 Entity라고 할 수 있다.
OOP에서 객체는 속성이 아니라 연속성, 식별성에 따라 정의된다. 

# 값 객체 (Value Object, VO)
모든 객체가 연속성, 식별성이 중요한 것은 아니다. Value Object는 속성을 통해 동등성을 파악한다. 개발하고자 하는 비즈니스 도메인에 따라 지폐의 일련번호가 중요할수도 안 중요할 수도 있기 때문에 Value Object는 항상 equals 메서드를 구현해야 한다.

예측 가능성을 높이고 혼란을 막기 위해 가능하면 불변 객체로 만들어야 하는데 Java 14 이상이라면 record가 이를 지원한다

# 동일성(Identity)과 동등성(Equality)