# Application Lifecycle management



```bash
kubectl set image deployment-definition.yaml
# config 파일 대신 명령어를 통한 iamge 변경

kubectl rollout undo deployment/myapp-deployment
# deployment를 rollback 
```

이 과정에서 rollout처럼 새로운 Replicaset을 만들고 이전의 ReplicaSet에서 Pod 하나를 내리고 새로운 ReplicaSet에서 Pod 하나를 새로 올리는 방식으로 진행된다.

## Commands and Arguments

### Docker

기본적으로 docker를 실행할 때 CMD와 Entrypoint에도 차이가 있는데
예를 들어 CMD sleep 5를 입력하면 

```bash
docker run ubuntu-sleeper sleep 5
```

다음과 같이 명령어 두 개를 입력해주는 것과 똑같은 효과를 가지며

ENTRYPOINT ["sleep"]을 입력하면
```bash
docker run ubuntu-sleeper 10
```

sleep 뒤에 10이 들어가서 작동하게 된다.

### kubernetes
쿠버네티스에서 도커처럼 Entrypoint 뒤에 argument를 넣고싶다면 아래와 같이 args에 세팅하면 된다.

```bash
apiVersion: v1
kind: Pod
metadata:
  name: ubuntu-sleeper-pod
spec:
  containers:
    - name: ubuntu-sleeper
    - image: ubuntu-sleeper
	  command: ["sleep2.0"]
	  args: ["10"]
```

만약 args가 아닌 Entrypoint를 교체하고 싶다면 command: ["sleep2.0"]같은 방식으로 진행해야 한다.

