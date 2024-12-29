# Kafka(Distributed Message Platform)

목적: Event/Message 전송을 위해 사용된다.
장점: 고가용성, 빠른 처리
단점: 순서보장이 어렵다, 아주 작게 사용이 어렵다 작은 규모가 필요한 경우 MQ를 많이 사용한다.

서버, 인스턴스는 카프카 브로커라고 불리며, 주키퍼가 브로커 간의 분산처리 정보를 가지고 있어서 브로커를 관장한다.

zookeeper: cluster 및 하위요소에 대한 전반적인 메타정보, Controller 정보, 선출, Broker 정보들을 가지고 있다.
Broker: 실제 data를 받아 저장하고 있다.
Controller: broker 대장 = 리더 선정, topic 생성, partition 생성, 복제본 정리

