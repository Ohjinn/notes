# Logging & Monitoring
## Metric Server

인메모리 경량 모니터링 솔루션으로 데이터가 디스크에 저장되지 않아 이전 데이터를 확인 못한다.
따라서 Datadog, Dynatree 같은 솔루션이나 Prometheus, ELK 등을 이용해서 모니터링을 이용해야 한다.


- kubelet
	- 각 노드에서 실행되는 에이전트로 Kubernetes API 서버와 통신
	- cAdviser를 통해 성능 메트릭 수집
- cAdviser
	- Pod의 성능 메트릭을 수집해 kubelet에 전송
	- kubelet은 이 정보를 Metric Server에 전달
