- [관계 데이터 모델 용어 정리](#관계-데이터-모델-용어-정리)
  - [속성](#속성)
  - [튜플](#튜플)
  - [관계](#관계)
- [관계대수](#관계대수)
  - [Projection](#projection)
  - [Selection](#selection)
  - [Cartesian Product](#cartesian-product)
- [Entity Relationship Model](#entity-relationship-model)
  - [ERD(Entity-Relationship Model)이란](#erdentity-relationship-model이란)
  - [Entity](#entity)
  - [데이터베이스 정규화](#데이터베이스-정규화)

# 관계 데이터 모델 용어 정리

## 속성
이름과 타입으로 구성되며 집합 안에서 유일해야 한다. Column이다.

## 튜플
속성, 값 쌍의 집합으로 하나의 집합에서 속성 이름은 유일하기 때문에 속성 이름은 겹치지 않는다. Row, Record이다.

## 관계
속성의 집합, 튜플의 집합 쌍으로 속성의 집합을 heading, 튜플의 집합을 body라고 구분한다.
```
(
	// Heading
	{ 이름/문자열, 나이/정수, 성별/문자 },

	// Body
	{
		{ (이름/문자열, 견우), (나이/정수, 13), (성별/문자, 남) },
		{ (이름/문자열,직녀), (나이/정수, 12), (성별/문자, 여) }
	}
)
```
다음과 같다.

# 관계대수
하나 이상의 Relation으로 새로운 Relation을 만드는 것

## Projection
원하는 Attribute를 포함하는 Pair로 Tuple을 구성하는 것으로 select 절 뒤의 속성을 나열하므로써 표현 가능하다.

```sql
SELECT name, age, gender
FROM people
```

## Selection 
주어진 조건을 만족하는 Tuple만 선택, where절로 표현 가능
```sql
SELECT name, age, gender
FROM people
WHERE age < 13;
```

## Cartesian Product
곱집합으로 원래는 각 요소의 쌍을 요소로 취하는데 관계대수에서는 Tuple을 합친다 SQL에서는 FROM 뒤의 테이블 이름 나열로 표현 가능하다.

```sql
SELECT *
FROM r1, r2;
```
대부분이 Join을 이용한다.

```sql
SELECT people.name, age, gender, items.name AS item_name, usage
FROM people, items
WHERE people.name = items.person_name;
```


# Entity Relationship Model
가장 인기 있는 개념적 데이터 모델로 Entity는 개별적으로 다룰 수 있는 데이터를 의미하며 Entity Type은 같은 Attribute를 가진 Entity의 집합이다.

Entity Relationship Model에서의 Entity와 OOP에서의 Entity는 의미가 다르다. OOP에서는 연속성과 식별성이 있는 객체로, 여기서는 개별적으로 다룰 수 있는 데이터다.

## ERD(Entity-Relationship Model)이란
ER 모델을 시각화하는 방법으로 논리적 설계에 들어가기 전에 그려보면 도움이 된다.

## Entity

## 데이터베이스 정규화
