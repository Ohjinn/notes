- [집합체 (Aggregate)](#집합체-aggregate)
- [불변식](#불변식)
- [트랜잭션적 일관성과 결과적 일관성](#트랜잭션적-일관성과-결과적-일관성)


# 집합체 (Aggregate)
Aggregate는 불변식을 유지하고 여러 도메인 객체를 사용하기 좋게 만들어준다. 개별 객체에 접근하므로써 불변식을 깨뜨리고 일관성을 파괴하는 일이 없도록 지켜주면서 우리가 다뤄야 할 도메인 객체의 개수를 적절하게 조절해준다.

# 불변식
우리가 지켜야 할 제약 조건, 규칙이라고 할 수 있다. Order로 예를 들어보자.

Order
    - Identifier: order-123
    - List<LineItem>
      - LineItem
        - Identifier: item-234
        - Product: Guitar
        - Quantity: 2
        - Unit Price: 30만원
        - Total Price: 60만원
      - LineItem
        - Identifier: item-345
        - Product: Microphone
        - Quantity: 3
        - Unit Price: 20만원
        - Total Price: 60만원

만약 개별 Line Item에 직접 접근 가능하고 동시에 여러 처리를 할 수 있다면 총 주문액이 조건을 넘어도 체크할 수 없다. 하지만 Order라는 Entity를 Order라는 Aggregate의 Root로 삼고 하나의 객체에 동시에 접근할 수 없다는 제어를 통해 불변식을 지킬 수 있게 된다.

Line Item에 개별적으로 접근하는 경우
```java
LineItem lineItem = lineItemRepository.findById("item-234").get();
lineItem.changeQuantity(2);

LineItem lineItem = lineItemRepository.findById("item-345").get();
lineItem.changeQuantity(3);
```

Aggregate를 사용하는 경우
```java
LineItem lineItem = lineItemRepository.findById("item-234").get();
lineItem.changeQuantity(2);

LineItem lineItem = lineItemRepository.findById("item-345").get();
lineItem.changeQuantity(3);
```

Aggregate의 동작에 집중한 경우
```java
Order order = orderRepository.findById("order-123").get();
order.addItem("Guitar", 1);
order.addItem("Microphone", 2);
```
Aggregate는 OOP의 협력하는 객체를 더 잘 구성할 수 있게 도와준다.

Vaughn Vernon의 4가지 경험 법칙
1. 불변식을 통해 일관성 경계를 찾아서 모델링한다. Aggregate는 트랜잭션적 일관성 경계와 동일어다
2. 작은 Aggregate로 설계한다.
3. ID로 다른 Aggregate를 참조한다
4. 경계 밖에선 결과적 일관성을 사용한다. 도메인 이벤트 등을 사용할 수 있다.

# 트랜잭션적 일관성과 결과적 일관성
트랜잭션성 일관성을 트랜잭션을 수행하는 단위에서의 일관성이 지켜져야 한다는 의미이고 결과적 일관성은 그 이후의 결과에서만 일관성이 지켜지면 된다는 의미이다.