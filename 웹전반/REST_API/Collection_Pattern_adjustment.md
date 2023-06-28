- [CQS](#cqs)

# CQS
CQS는 Command Query Separation Pattern이라는 하나의 디자인 패턴으로 어떤 메서드나 HTTP 요청을 구성하는데 있어서 모두 사용되는 패턴이다.  
해당 매서드의 특성에 따라 모든 HTTP 요청과 메서드를 Command와 Query로 구분할 수 있는데

Commands(modifiers): 시스템의 상태를 바꾸지만 값을 return 하지 않는다.  
Queries: 결과를 반환하지만 시스탬의 상태를 변경하지 않는다(사이드 이펙트에서 자유롭다)  

커맨드와 쿼리를 확실하게 분리하면 쿼리는 조금 더 자유롭게 사용할 수 있고 Commands는 상태변화를 일으키는 것들로 분류해서 관리할 수 있기 때문에 장애 상황에 편의성을 준다.  

CQS에는 어긋나지만 편의를 위해 insert 문에는 id를 리턴해주면 조회시 더 편리해진다.  
키워드는 커맨드와 쿼리의 완전한 구분이다.

출처  
[마틴파울러](https://martinfowler.com/bliki/CommandQuerySeparation.html)  
[Su Bak 블로그](https://medium.com/@su_bak/cqs-command-query-separation-pattern-%E1%84%8B%E1%85%B5%E1%84%85%E1%85%A1%E1%86%AB-f701eabf8754)