- [Relationship Mapping](#relationship-mapping)
  - [단방향 연관관계](#단방향-연관관계)
- [DDD의 Aggregate](#ddd의-aggregate)
- [CascadeType.ALL](#cascadetypeall)
- [orphanRemoval](#orphanremoval)
- [Event Sourcing](#event-sourcing)
- [JPA annotation](#jpa-annotation)
  - [@OneToMany](#onetomany)
  - [@JoinColumn](#joincolumn)

# Relationship Mapping
데이터 모델 Entity의 관계를 객체 참조로 간단히 활용할 수 있게 해준다. 일반적으로 DDD의 Aggregate를 구현하기 위해 CascadeType.ALL과 orphanRemoval=true를 함께 사용하는 것이 권장된다.

일정 규모 이상의 시스템이라면 Command와 Query를 구분해서 전자는 JPA Entity와 Relationship Mapping을 활용하고 후자는 JdbcTemplate같은 매퍼를 활용하는 방식이 추천된다.

엔티티들은 대부분 다른 엔티티와 연관관계가 있는데 연관관계의 키워드는 다음과 같다.
- 방향: 단방향, 양방향이 있다. 어떤 한 관계에서 둘 중 한쪽만 참조하는 것을 단방향 관계라 하고, 양쪽 모두 서로 참조하는 것을 양방향 관계라 한다. 방향은 객체관계에만 존재하고 테이블 관계는 항상 양방향이다
- 다중성: N:1, 1:N, 1:1 다중성이 있다. 회원과 팀이 있을 때 여러 회원은 한 팀에 속하므로 회원과 팀은 다대일 관계다.
- 연관관계의 주인: 객체를 양방향 연관관계로 만들면 연관관계의 주인을 정해야 한다.

## 단방향 연관관계
예를 들어
- 회원과 팀이 존재하고 
- 회원은 하나의 팀에만 소속될 수 있고
- 회원과 팀은 다대일관계이다.
# DDD의 Aggregate

# CascadeType.ALL
특정 엔티티를 영속 상태로 만들 때 연관된 엔티티도 영속 상태로 만들고 싶다면 영속성 전이를 사용하면 된다.

```java
@Entity
public class Parent {
  @Id @GeneratedValue
  private Long id;

  @OneToMany(mappedBy = "parent")
  private List<Child> children = new ArrayList<Child>();
  ...
}

@Entity
public class Child {
  @Id @GeneratedValue
  private Long id

  @ManyToOne
  private Parent parent;

  ...
}
```
다음과 같이 부모와 자식 객체가 있고 OneToMany로 연관되어 있고 Parent와 연관된 Child의 객체를 모두 한번에 영속화 하고 싶다면

```java
@Entity
public class Parent {
  @Id @GeneratedValue
  private Long id;

  @OneToMany(mappedBy = "parent", cascade = CascadeType.ALL)
  private List<Child> children = new ArrayList<Child>();
  ...
}
```

이렇게 영속화 설정을 해주면 연관된 자식들도 함께 영속화할 수 있다.
영속성 전이는 연관관계와 상관 없이 엔티티를 영속화할 때 연관된 엔티티도 같이 영속화하는 편리함을 제공해준다.

CASCADE 종류는 ALL, PERSIST, MERGE, REMOVE, REFRESH, DETACH 등이 있다.

# orphanRemoval
JPA는 부모 엔티티와 연관관계가 끊어진 자식 엔티티를 자동으로 삭제하는 기능을 제공하는데 이것을 고아객체 제거라고 한다. 이 기능을 사용해 부모 엔티티의 컬렉션에서 자식 엔티티의 참조만 제거하면 자식 엔티티가 자동으로 삭제되도록 할 수 있다.

```java
@Entity
public class Parent {
  @Id @GeneratedValue
  private Long id;

  @OneToMany(mappedBy = "parent", orphanRemoval = true)
  private List<Child> children = new ArrayList<Child>();
  ...
}

Parent parent = em.find(Parent.class, id);
parent.getChildren().remove(0)
```
위의 코드를 실행하면 컬렉션에서 첫 번째 자식을 삭제했는데 orphanRemoval 옵션이 true라면 컬렉션에서 엔티티를 제거하면 데이터베이스의 데이터도 삭제된다.

고아 객체 제거는 참조가 제거된 엔티티는 다른 곳에서 참조하지 않는 고아 객체로 보고 삭제하는 기능이다. 이 기능은 참조하는 곳이 하나일 때만 사용해야 한다. 따라서, @OneToOne, @OneToMany에만 사용할 수 있다.

개념적으로 볼 때 부모를 제거하면 자식도 고아가 되기 때문에 부모를 제거해도 자식이 같이 제거된다.

만약 CascadeType.ALL과 orphanRemoval = true를 동시에 사용하면 부모 엔티티를 통해 자식의 생명주기를 관리할 수 있다.

```java
Parent parent = em.find(Parent.class, parentId);
parent.addChild(child)

Parent parent = em.find(Parent.class, parentId);
parent.getChildren().remove(removeObject);
```
# Event Sourcing

# JPA annotation

## @OneToMany

## @JoinColumn

출처:  
[자바 ORM 표준 JPA 프로그래밍](http://www.yes24.com/Product/Goods/19040233)