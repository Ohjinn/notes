
- [SOLID (객체 지향 설계)](#solid-객체-지향-설계)
  - [SRP (Single Responsibility Principle, 단일 책임 원칙)](#srp-single-responsibility-principle-단일-책임-원칙)
  - [OCP (Open-Closed Principle, 개방-폐쇄 원칙)](#ocp-open-closed-principle-개방-폐쇄-원칙)
  - [LSP (Liskov Substitution Principle, 리스코프 치환 원칙)](#lsp-liskov-substitution-principle-리스코프-치환-원칙)
  - [ISP (Interface Segregation Principle, 인터페이스 분리 원칙)](#isp-interface-segregation-principle-인터페이스-분리-원칙)
  - [DIP (Dependency Inversion Principle, 의존관계 역전 원칙)](#dip-dependency-inversion-principle-의존관계-역전-원칙)



# SOLID (객체 지향 설계)
엉클 밥이 2003년 <클린 소프트웨어>에서 5가지 설계 원칙을 정리했다.

## SRP (Single Responsibility Principle, 단일 책임 원칙)
1979년 톰 드마르코와 페이지 존스가 언급한 응집도(cohesion)을 다루는 설계 원칙

AddProductToCartService는 언제 수정해야 할까?
1. 장바구니에 상품을 담는 방식이 변경 되었을 때
2. 장바구니 상태를 DB에 담는 방식이 변경 되었을 떄

정답은 둘 다 아니다.  
1 -> Domain Model에서 처리  
2 -> Repository, DAO 등에서 처리

이렇게 구현해주면 테스트하기 쉽고, 재사용하기 편하며, 더 작고 이해하기 쉬운 클래스를 얻게 된다.

## OCP (Open-Closed Principle, 개방-폐쇄 원칙)
1988년 버트런드 마이어가 제안한 설계 원칙으로 `소프트웨어 개체는 확장에 열려 있어야 하고, 수정에 대해서는 닫혀 있어야 한다.`

이 목표는 추상화를 통해 달성 가능하고, Java에서는 interface를 활용한다.

1. Open: 모듈의 기능을 변경할 수 있어야 한다.
2. Close: 변경이 다른 곳으로 퍼져나가지 않아야 한다.

서비스 레이어에서 Spring Data Jpa의 save()를 호출할 때 DBMS가 변해도 서비스 레이어는 그저 save()만 호출하면 된다.

## LSP (Liskov Substitution Principle, 리스코프 치환 원칙)
바버라 리스코프가 1988년 타입의 관계에 대해 이야기했는데  
정리하면 `서브타입은 그것의 기반 타입으로 치환 가능해야 한다`

LSP를 지키고 있는지 파악하는 방법 중 하나는 상속이 '행위' 측면에서 IS-A 관계인지 파악하는 것으로 

## ISP (Interface Segregation Principle, 인터페이스 분리 원칙)
응집력이 없는 커다란 인터페이스를 여러 개의 작은 인터페이스로 나누는 것

## DIP (Dependency Inversion Principle, 의존관계 역전 원칙)
엉클 밥은 DIP에 대해

1. 상위 수준의 모듈은 하위 수준의 모듈에 의존해서는 안된다. 둘 다 추상화에 의존해야 한다.
2. 추상화는 구체적인 사항에 의존해서는 안된다. 구체적인 사항은 추상화에 의존해야 한다.

