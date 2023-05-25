- [Aggregate Mapping](#aggregate-mapping)
- [Value Object](#value-object)
- [JPA annotations](#jpa-annotations)
  - [@Entity](#entity)
    - [속성](#속성)
  - [@Table](#table)
  - [@Id](#id)
  - [@Embeddable](#embeddable)
  - [@Embedded](#embedded)

# Aggregate Mapping
OOP에선 의미가 드러나지 않는 Primitive Type 대신 Value Object를 활용하는걸 권하는데 JPA에서는 Aggregate Mapping을 통해 이를 지원할 수 있다.

예를 들어 Person객체가 있고 필드로 name, age, gender를 갖는다고 해보자.

각 필드의 타입을 String으로 가져간다면 필드의 특성을 반영하기 힘들다. Gender타입을 선언해 gender를 사용해보자.

기존의 객체 생성이 다음과 같았다면
```java
Person person = new Person("Mr.Big", 35, "남");
```

```java
@Embeddable
public class Gender {
    @Column(name = "gender")
    private String value;

    private Gender() {
    }

    private Gender(String value) {
        this.value = value;
    }

    public static Gender male() {
        return new Gender("남");
    }

    public static Gender female() {
        return new Gender("여");
    }

    @Override
    public String toString() {
        return value;
    }
    ... equals(), hashCode()
}
```
Embeddable 어노테이션을 
정적 팩토리 메서드를 사용하면 다음과 같이 명시적으로 선언이 가능하다.

```java
Person person = new Person("Mr.Big", 35, Gender.male());
```

이런 식으로 하나의 Value Object를 만들어서 Gender에 대한 모든 처리를 위임했을 때 Person 객체가 SRP를 따르고 단순해질 거란 것 알 수 있다.

# Value Object

# JPA annotations

## @Entity
JPA를 사용해서 테이블과 매핑할 클래스는 @Entity 어노테이션을 필수로 붙여야 한다.

### 속성
name

주의 사항은
- 기본 생성자는 필수로 만들어줘야 한다.(파라미터가 없는 public 또는 protected 생성자)
- final클래스, enum, interface, inner클래스에는 사용할 수 없다.
- 저장할 필드에 final을 사용하면 안된다.


## @Table
엔티티와 매핑할 테이블을 지정한다. 생략하면 매핑한 엔티티 이름을 테이블 이름으로 사용한다.

## @Id

## @Embeddable

## @Embedded

출처:  
[자바 ORM 표준 JPA 프로그래밍](http://www.yes24.com/Product/Goods/19040233)