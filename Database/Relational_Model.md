- [관계 데이터 모델 용어 정리](#관계-데이터-모델-용어-정리)
  - [속성](#속성)
  - [튜플](#튜플)
  - [관계](#관계)
- [관계대수](#관계대수)
  - [Projection](#projection)
  - [Selection](#selection)
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

## Selection 

# Entity Relationship Model

## ERD(Entity-Relationship Model)이란

## Entity

## 데이터베이스 정규화
