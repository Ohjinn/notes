# Karpenter: 지능적이며 고성능이 필요한 Kubernetes 클러스터 자원 프로비저닝 및 관리 솔루션(AWS에서 만든 오픈소스 솔루션)

- [Karpenter: 지능적이며 고성능이 필요한 Kubernetes 클러스터 자원 프로비저닝 및 관리 솔루션(AWS에서 만든 오픈소스 솔루션)](#karpenter-지능적이며-고성능이-필요한-kubernetes-클러스터-자원-프로비저닝-및-관리-솔루션aws에서-만든-오픈소스-솔루션)
  - [NodePools 정의를 위한 전략: Single, Multiple, Weighted](#nodepools-정의를-위한-전략-single-multiple-weighted)
  - [Node Consolidation](#node-consolidation)
  - [설치방법](#설치방법)

[karpenter.sh](https://karpenter.sh/)  
장단점: AWS의 다양한 인스턴스 타입까지 대응하면서 관리 가능하지만, 초기 설정파일 준비에 품이 든다.  
경쟁사: GKE Autopilot

```bash
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: default
spec:
  requirements:
    - key: karpenter.k8s.aws/instance-family
      operator: In
      values: ["c5", "m5", "r5"]
    - key: topology.kubernetes.io/zone
      operator: In
      values: ["us-west-2a", "us-west-2b"]
    - key: kubernetes.io/arch
      operator: In
      values: ["amd64", "arm64"]
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["spot", "on-demand"]
limits:
  cpu: 100
```

## NodePools 정의를 위한 전략: Single, Multiple, Weighted  

- Single: 단일 NodePool은 여러 팀과 워크로드에 대한 컴퓨팅을 관리(x86, arm을 혼합한 NodePool)
- Multiple: 다양한 목적을 위한 컴퓨팅 격리(비싼 하드웨어, 보안 격리, 팀 격리, 다른 AMI)
- Weighted: NodePool 전체에서 순서를 정의하여 Node 스케줄러가 다른 NodePool보다 먼저 한 NodePool로 스케줄을 점유하도록 구성(RI 및 Savings Plane을 다른 인스턴스 유형보다 우선시)

## Node Consolidation

- Node 삭제: Pod가 클러스터의 다른 Node의 여유 용량에서 실행될 수 있는 경우
- Node 삭제: Node가 비어있는 경우
- Node 교체: Pod가 클러스터의 다른 Node의 여유 용량 + 더 효율적인 교체 Node의 조합에서 실행될 수 있는 경우

`CA를 쓰면 트래픽에 따라 새로운 Node Group을 만들어 줄 수도 있다. 반면, Karpenter를 사용하면 Group의 개념이 사라진다. Pod별로 필요한 Instance들을 Mapping 가능하다. 즉 CA, ASG에 대한 고려가 없어도 된다. Nodepool, EC2 Node Pool 두 가지만 작성해주면 된다.`

Karpenter가 포함하는 것들 - `Cluster Autoscaler, Node groups, Node Termination Handler, Descheduler`

## 설치방법

```plain 설치 방법
설치 권고: AWS 퍼블릭 ECR에서 Karpenter Helm 차트로 설치  
주의: Karpenter 제어 Node에서 Karpenter 실행 금지  
권고: EKS Fargate 또는 작업자 Node의 Karpenter 컨트롤러 위치(Fargate를 사용한다면 그 곳에 위치하는 것을 권장)
```

karpenter를 사용하면 논리적 tenant를 나눠줘야 하기 때문에 설계 전에 고려해야 한다.
