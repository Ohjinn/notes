
## ETCD backup
백업에는 두 가지 방법이 있다.

### 1. 리소스 설정 백업
kubectl을 이용해서 클러스터 리소스들을 yaml파일로 추출 가능하다.

```bash
kubectl get all --all-namespaces -o yaml > all-backup.yaml
```

개별 리소스 단위 관리와 git을 이용한 관리가 가능하지만 누군가 명령어를 kubectl create 명령어로 만들었다면 yaml파일이 존재하지 않을 가능성이 있음

## 2. etcd 전체 백업
etcd CLI를 사용해 전체 데이터를 스냅샷으로 백업

1. kube-apiserver 중지
2. etcdctl snapshot restore snapshot.db
3. 복원된 **데이터 디렉토리 설정**
4. etcd 재시작
5. API 서버 재시작

클러스터 전체 상태 복구가 가능하고 단순하고 빠르다.

하지만 인증서 경로와 etcd endpoint를 정확히 지정해야 하고
EKS 등의 매니지드 서비스에서는 etcd 접근이 제한된다.


/etc/kubernetes/pki/etcd/server-certificate.crt


clusterRole: 리소스 대한 클러스 전체 범위의 권ㄴ 정의
Role: 특정 네임스페이스 안에서만 유효