- [Aggregate Mapping](#aggregate-mapping)
- [Value Object](#value-object)
- [JPA annotations](#jpa-annotations)
  - [@Entity](#entity)
    - [속성](#속성)
  - [@Table](#table)
    - [DDL-auto](#ddl-auto)
  - [@Id](#id)
  - [@GenerationType](#generationtype)
    - [대리키 전략](#대리키-전략)
    - [IDENTITY](#identity)
    - [SEQUENCE](#sequence)
    - [TABLE](#table-1)
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
| 속성  | 기능                | 기본값
| ---- | ------------------ | -------- |
| name | JPA에서 사용할 엔티티 이름을 지정한다 보통 기본값인 클래스 이름을 사용한다 | 설정하지 않으면 클래스 이름 그대로 사용한다. |


주의 사항은
- 기본 생성자는 필수로 만들어줘야 한다.(파라미터가 없는 public 또는 protected 생성자)
- final클래스, enum, interface, inner클래스에는 사용할 수 없다.
- 저장할 필드에 final을 사용하면 안된다.


## @Table
엔티티와 매핑할 테이블을 지정한다. 생략하면 매핑한 엔티티 이름을 테이블 이름으로 사용한다.
| 속성  | 기능                | 기본값     |
| ---- | ------------------ | -------- |
| name | 매핑할 테이블 이름 | 엔티티 이름을 사용한다. |
| catalog | catalog 기능이 있는 데이터베이스에서 catalog 매핑 |  |
| schema | schema 기능이 있는 데이터베이스에서 매핑 |  |

### DDL-auto
Data Definition Language에는 여러 설정이 있는데 주로 초기 개발단계에서 사용한다.
| 옵션  | 설명                |
| ---- | ------------------ |
| create | 기존 테이블을 삭제하고 새로 생성한다 DROP + CREATE |
| create-drop | 애플리케이션 종료시 생성한 테이블을 삭제한다 DROP + CREATE + DROP |
| update | 데이터베이스 테이블과 엔티티 매핑 정보를 비교해 변경사항만 수정한다 |
| validate | DB 테이블과 엔티티 매핑 정보에 차이가 있으면 경고를 남기고 애플리케이션 실행을 취소한다 DDL을 수정하지 않는다 |
| none | 자동 생성 기능을 사용하지 않는다 이런 설정은 없고 그냥 설정을 안하면 none이다 |

## @Id
기본 키를 직접 할당하려면 @Id로 매피하면 된다.

@Id 적용 가능 자바 타입은 다음과 같다.
- 자바 기본형
- 자바 래퍼형
- String
- java.util.Date
- java.sql.Date
- java.math.BigDecimal
- java.math.BigInteger

## @GenerationType
데이터베이스의 종류도 많고 기본 키를 만드는 방법도 다양한다. GenerationType.AUTO를 선택한 데이터베이스는 방언에 따라 IDENTITY, SEQUENCE, TABEl 전략 중 하나를 자동으로 선택하는데 ORACLE은 SEQUNCE를 MySQL은 IDENTITY를 사용한다.

### 대리키 전략
Id 어노테이션을 단독으로 사용하면 기본 키를 애플리케이션에서 직접 할당해줘야 한다. 대신 데이터베이스가 생성해주는 값을 사용하려면   
### IDENTITY
기본 키 생성을 데이터베이스에 위임하는 전략으로 MySQL, PostgreSQL, SQL Server, DB2에서 사용한다
  ```java
  @Entity
  public class Board {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
  }
  ```

  - Identity 전략은 데이터베이스에 INSERT를 날린 후에 기본 키 값을 조회할 수 있는데 Statement.getGeneratedKey()를 사용하면 저장과 동시에 한번의 통신으로 키 값도 가져올 수 있다.
  - 엔티티가 영속 상태가 되려면 식별자가 필요하기 때문에 INSERT 쿼리시 쓰기 지연은 동작하지 않는다
### SEQUENCE
데이터베이스 시퀀스라는 기본 키를 할당하는 특별한 데이터 오브젝트를 사용하는 전략으로 ORACLE, PostgresSQL, DB2, H2데이터베이스에서 사용할 수 있다
  ```sql
  CREATE TABLE BOARD (
    ID BIGINT NOT NULL PRIMARY KEY
    DATA VARCHAR(255)
  )
  // 시퀀스 생성
  CREATE SEQUENCE BOARD_SEQ START WITH 1 INCREMENT BY 1;
  ```
  ```java
  @Entity
  @SequenceGenerator(
    name = "BOARD_SEQ_GENERATOR",
    sequenceName = "BOARD_SEQ", // 매핑할 데이터베이스 시퀀스 이름
    initialValue = 1, allocationSize = 1
    )
  public class Board {
    @Id
    @GeneratedValue(strategy = GenerationType.SEQUENCE,
                    generator = "BOARD_SEQ_GENERATOR")
    private Long id;
  }
  ```
  - SEQUENCE 사용 코드는 IDENTITY 전략과 같이만 내부 동작 방식에는 차이가 있다. SEQUENCE는 em.persist() 타이밍에 시퀀스를 사용해 식별자를 조회한다.
### TABLE
키 생성 테이블을 이용, 키 생성 전용 테이블을 하나 만들고 여기에 이름과 값으로 사용할 컬럼을 만들어 데이터베이스 시퀀스를 흉내내는 전략이다. 모든 DB에 사용 가능하다
등의 대리키 전략이 있다
  - 테이블 전략을 위해서는 키 생성 용도로 사용할 테이블을 만들어야 한다.
  ```sql
  create table MY_SEQUENCE (
    sequence_name varchar(255) not null,
    next_val bigint,
    primary key (sequence_name)
  )
  ```
  sequence_name 컬럼을 시퀀스 이름으로 사용하고 next_val 컬럼을 시퀀스 값으로 사용한다
  ```java
  @Entity
  @TableGenerator(
    name = "BOARD_SEQ_GENERATOR",
    table = "MY_SEQUENCES",
    pkColumnValue = "BOARD_SEQ", allocationSize = 1
  )
  public class Board {
    @Id
    @GeneratedValue(strategy = GenerationType.TABLE,
                    generator = "BOARD_SEQ_GENERATOR")
    private Long id;
  }
  ```
  - TABLE 전략은 시퀀스 대신에 테이블을 사용한다는 것만 제외하면 SEQUENCE 전략과 내부 동작방식이 같다.

## @Embeddable

## @Embedded

출처:  
[자바 ORM 표준 JPA 프로그래밍](http://www.yes24.com/Product/Goods/19040233)