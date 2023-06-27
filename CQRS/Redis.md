- [Redis](#redis)
- [in-memory](#in-memory)
- [NoSQL](#nosql)


# Redis
레디스는 오픈소스 인메모리 데이터 구조 저장소로 데이터베이스, 캐시, 메시지브로커, 스트리밍 엔진 등으로 쓰인다. 레디스는 strings, hashes, lists, sets, sorted sets등의 데이터 포멧을 range queries, bitmaps, hyperloglogs, geospatial indexes, stream 등의 방법으로 제공한다. 레디스는 내장 replication, lua scripting, LRU eviction, transactions 등을 지원하며 다른 레벨의 on-disk persistence, 고가용성의 Redis Sentinel과 Redis Cluster와 함께 자동 파티셔닝을 제공한다.

# in-memory
HDD, SDD등의 보조 기억장치가 아닌 RAM을 저장매체로 사용하는 데이터베이스를 in memory database라고 하는데 RAM의 특성상 휘발성이다. 프로세스가 종료되면 데이터가 유실된다. 

# NoSQL
관계형 데이터가 아닌 비정형데이터를 저장하기 위한 데이터베이스로 기존의 관계형데이터베이스보다 더 융통성 잇는 데이터 모델을 사용하고 데이터의 저장 및 검색을 위한 특화된 매커니즘을 제공한다. 기존 관계형 데이터베이스와 차이점은 다음과 같다.

- 관계형 모델을 사용하지 않으며 테이블간 조인이 없다.
- 비 SQL 인터페이스를 이용한 데이터 엑세스
- 여러대의 데이터베이스 서버를 묶어서 하나의 데이터베이스를 구성
- RDBMS에서 제공하는 ACID 미보장
- 데이터의 스키마와 속성을 다양하게 수용 및 동적 정의
- 중단 없는 서비스와 자동 복구 기능 지원
- 확장성, 사용성, 고성능

NoSQL의 종류는 다음과 같다.
- key value DB
key value 쌍으로 데이터가 저장되는 가장 단순한 형태의 솔루션으로 Amazon Dynamo Paper에서 유래

- Document DB
Lotus Notes에서 유래되었으며, JSON, XML같은 Collection 데이터 모델 구조 채택, MongoDB, CoughDB가 이 종류에 해당

- Wide Columnar Store
Big Table DB라고도 하며 Key value에서 발전된 형태의 column family 데이터 모델을 사용하며 HBase, Cassandra등이 이에 해당

- Graph DB
Euler & Graph Theory에서 유래한 DB로 Nodes, Relationship, Key-value 데이터 모델을 채택하고 Neo4J 등이 있다.

[sds](https://www.samsungsds.com/kr/insights/1232564_4627.html)