- [Collection Pattern](#collection-pattern)

# Collection Pattern
여러 리소스를 하나의 그룹으로 묶는 것을 말하는 것이다.  
리소스 URI는 명사를 기반으로 해야 하며 DB 설계에 따른 엔티티 구분을 할 필요는 없다

    customers
위는 고객 컬렉션의 경로이고

    customers/5
위는 5번 고객의 경로다

    /customers/1/orders/99/products
처럼 여러 관계 수준의 URI 제공보다는  

    /customer/1/orders
로 주문을 찾은 후 

    /orders/99/products
로 바꿔서 주문의 제품을 찾을 수 있다.

    /session
세션 확인

    /users/me
    
user ID를 me라고 쓰면 현재 사용자의 UserId로 처리하게 하고 문서에 기록하면 된다.



출처  
[Azure](https://learn.microsoft.com/ko-kr/azure/architecture/best-practices/api-design#organize-the-api-design-around-resources)