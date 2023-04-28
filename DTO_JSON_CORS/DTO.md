- [DTO](#dto)
    - [네트워크](#네트워크)
    - [레이어드 아키텍쳐](#레이어드-아키텍쳐)
  - [프로세스 간 통신(IPC)](#프로세스-간-통신ipc)
- ["무기력한 도메인 모델"이란, 그리고 안티 패턴인 이유](#무기력한-도메인-모델이란-그리고-안티-패턴인-이유)
  - [무기력한 도메인 모델이란](#무기력한-도메인-모델이란)
  - [무기력한 도메인 모델의 단점](#무기력한-도메인-모델의-단점)
- [자바빈즈(JavaBeans)](#자바빈즈javabeans)
  - [POJO](#pojo)
- [EJB(Enterprise JavaBeans)](#ejbenterprise-javabeans)
- [Java의 record](#java의-record)
- [DAO](#dao)
- [ORM](#orm)

# DTO

내가 모르는 더 많은 관점도 있겠지만 지금 나는 두 가지 관점에서 이야기할 수 있을 것 같다. 첫째, 네트워크 상에서의 DTO, 레이어드 아키텍쳐 상에서의 DTO다.

### 네트워크

네트워크 상에서 DTO는 메서드 콜 횟수를 줄이기 위해 프로세스간 데이터를 운반하는 객체로 DTO를 이용하는 주된 이유는 여러 원격 호출을 단일 호출로 일괄 처리하기 위함이다.  
또한, 데이터를 전송하기 위한 직렬화 매커니즘을 캡슐화하는 것도 또 다른 이점인데 직렬화를 캡슐화하면 DTO는 나머지 코드에서 해당 로직을 제거할 수 있으며 직렬화에 대한 명확한 포인트를 제공한다.

만약 어플리케이션 간의 통신에서 직접 [facade](https://martinfowler.com/eaaCatalog/remoteFacade.html)와 같이 통신하려고 하면 상당히 많은 비용이 든다. 그 순서를 이야기하자면 데이터 마샬링, 시큐리티 체크, 패킷 스위칭 등이 필요하며 모든 데이터를 보내기 위해선 많은 네트워크 자원도 필요해진다. 이걸 해결하기 위해 DTO를 사용한다.

### 레이어드 아키텍쳐
두번째, 레이어드 아키텍쳐 상에서의 DTO는 시스템을 유사한 관심사로 레이어로 나누고 수직적으로 배열하는 아키텍쳐에서 각각의 레이어간의 통신을 위한 DTO다.

## 프로세스 간 통신(IPC)
서로 다른 프로세스, 프로그램이 서로 통신하는 것으로 일반적으로 애플리케이션은 클라이언트 또는 서버로 분류된 IPC를 사용할 수 있는데 클라이언트는 애플리케이션 또는 프로세스에 서비스를 요청하는 프로세스고 서버는 응답하는 프로세스다. 대부분의 애플리케이션은 사오항에 따라 서버와 클라이언트 역할을 모두 한다.

IPC는 종류가 매우 많고 애플리케이션에서 여러 IPC 매커니즘을 사용할 가능성이 높다.  

고려사항은 다음과 같다.
- 컴퓨터 내에서의 커뮤니케이션인가, 다른 컴퓨터와의 커뮤니케이션인가
- 다른 운영체제와 통신해야 하는가
- 사용자가 통신하는 다른 애플리케이션을 선택해야 하는가, 아니면 암시적으로 협력 파트너를 찾을 수 있는가
- 통신 요구사항이 존재하는가
- 성능이 중요한가
- GUI 애플리케이션인가 CLI 애플리케이션인가

IPC에서 쓸 수 있는 기술
- File
  - 가장 기본적인 접근으로 원격 환경에서 활용 어렵다.
- Socket
  - HTTP를 사용하면 쉽다
- 과거 RPC를 위한 RMI가 존재했다.
  - 객체의 전송
  - 원격 함수의 실행
- 메시징 큐
  - 소켓과 비슷하지만 메시지 경계를 보존하는 데이터 스트림
- 쉐어 메모리

이 외에도 운영체제 등의 환경에 따라 다양하다.

# "무기력한 도메인 모델"이란, 그리고 안티 패턴인 이유

## 무기력한 도메인 모델이란
무기력한 도메인 모델이란 도메인 객체들에 비즈니스(검증, 계산 등의) 로직이 거의 없거나 아예 없는 소프트웨어 도메인 모델의 이용이다. 따라서, 비즈니스 로직이 프로그램 아키텍쳐에 박혀있게 되고 유지보수와 리팩토링을 힘들게 만든다. 

무기력한 도메인 모델에서 비즈니스 로직은 일반적으로 도메인 객체의 상태를 변환하는 별도의 클래스로 구현된다. 파울러는 이런 외부 클래스를 transaction scripts라고 부르는데 이 패턴은 초기 버전의 엔티티빈이나 .NET에서 권장된다.

음식 배달 서비스를 예로 들어보자. [출처](https://codeopinion.com/is-an-anemic-domain-model-really-that-bad/)  
각각의 스탑들은 운송중, 도착, 출발의 진행 과정을 거치고 첫 번째 스탑은 두 번째 스탑이 시작하기 전에 통과해야 한다.  
무기력한 도메인 모델은 데이터 구조를 가지고 있지만 행위를 가지고 있지 않음을 의미한다. 아래 코드는 데이터는 세팅하지만 행동은 아니다. 로직은 서비스에 존재한다.

```java
public class Shipment
{
    public int ShipmentId { get; set; }
    public List<Stop> Stops { get; set; }

    public Stop GetStop(int stopId)
    {
        return Stops.Single(x => x.StopId == stopId);
    }

    public List<Stop> GetAllStops()
    {
        return Stops;
    }
}

public class Stop
{
    public int ShipmentId { get; set; }
    public int StopId { get; set; }
    public StopStatus Status { get; set; } = StopStatus.InTransit;
    public DateTime Arrived { get; set; }
    public DateTime? Departed { get; set; }

    public void SetStatus(StopStatus status)
    {
        Status = status;
    }

    public void SetArrivedDateTime(DateTime dateTime)
    {
        Arrived = dateTime;
    }

    public void SetDepartedDateTime(DateTime dateTime)
    {
        Departed = dateTime;
    }
}

public enum StopStatus
{
    InTransit,
    Arrived,
    Departed
}
```
아래 코드를 보면 상태 변경 이전에 필요한 검증 로직이 구성되어 있다. 객체지향 도메인 모델이 아니라 데이터 모델이다.
빈약한 도메인 모델은 트랜잭션 스크립트보다는 더 나아갔지만 도메인 모델에는 완전히 도달하지 못한 중간 단계에 해당한다.
트랜잭션 스크립트는 단일 요청을 처리하기 위한 것으로 훨씬 더 절차적이며 엔티티나 도메인을 가져오기 위한 데이터 엑세스나 검증, 상태변화가 모두 섞여있다.

```java
public class ShipmentService
{
    private readonly ShipmentDbContext _dbContext;

    public ShipmentService(ShipmentDbContext dbContext)
    {
        _dbContext = dbContext;
    }

    public void Arrive(Shipment shipment, int stopId)
    {
        var stop = shipment.GetStop(stopId);

        var previousStopsAreNotDeparted = shipment.GetAllStops().Any(x => x.StopId < stop.StopId && x.Status != StopStatus.Departed);
        if (previousStopsAreNotDeparted)
        {
            throw new InvalidOperationException("Previous stops have not departed.");
        }

        stop.SetStatus(StopStatus.Arrived);
        stop.SetArrivedDateTime(DateTime.UtcNow);
    }

    public void Pickup(Shipment shipment, int stopId)
    {
        var stop = shipment.GetStop(stopId);
        if (stop.Status != StopStatus.Arrived)
        {
            throw new InvalidOperationException("Stop is not yet arrived.");
        }

        stop.SetStatus(StopStatus.Departed);
        stop.SetDepartedDateTime(DateTime.UtcNow);
    }

    public void Deliver(Shipment shipment, int stopId)
    {
        var stop = shipment.GetStop(stopId);
        if (stop.Status != StopStatus.Arrived)
        {
            throw new InvalidOperationException("Stop is not yet arrived.");
        }

        stop.SetStatus(StopStatus.Departed);
        stop.SetDepartedDateTime(DateTime.UtcNow);
    }

    public bool IsComplete(Shipment shipment)
    {
        return shipment.GetAllStops().All(x => x.Status == StopStatus.Departed);
    }
}
```
대부분 트랜젝션 스크립트에서 도메인 모델로 이동하는 시점에 동일한 로직들을 서비스에 넣으면서 무기력한 도메인 모델이 만들어지는데
동작과 데이터를 모두 동일한 객체 모델에 유지하고 데이터를 캡슐화하며 행동을 노출하는 도메인 모델을 사용해야 한다.

## 무기력한 도메인 모델의 단점

도메인 모델의 단점이 비용이 많이 든다는 것인데 무기력한 도메인 모델은 비용이 많이 들지만 이점이 거의 없다.
- OOP 원칙에 위배된다.
  - 모델 내부 상태를 외부에서 변경할 수 있어 모델이 정확하고 유효한 상태인지 확인할 수 없다.
- 모델에서 모든 동작이 제거되어 모델의 표현력이 떨어진다.
- 모델이 유효한 상태인지 보장할 수 없기 때문에 모델을 완전히 테스트할 수 없다.
  

# 자바빈즈(JavaBeans)
빌더 형식의 개발도구에서 가시적으로 조작이 가능하고 재사용 가능한 소프트웨어 컴포넌트로,  
보통 여러 개의 개별 객체가 아닌 단일 빈 객체로 전달하기 위해 많은 객체를 단일 객체로 캡슐화할 때 사용한다

일반적으로 빈즈의 관례는
- 클래스는 직렬화되어야 한다.
- 기본 생성자를 가지고 있어야 한다.
- 속성들은 get, set 혹은 표준 명명법을 따르는 메서드들을 사용해 접근할 수 있어야 한다.
- 필요한 이벤트 처리 메서드들을 포함하고 있어야 한다.


## POJO
POJO란 plain old Java Object를 뜻하는 단어로 자바 언어 명세 이외의 제한을 허용하지 않는 객체를 의미한다.  
이는 어떤 클래스의 상속, 인터페이스의 구현, 어노테이션이 존재하지 않는 것을 의미한다.
```java
public class Foo extends javax.servlet.http.HttpServlet { ...

public class Bar implements javax.ejb.EntityBean { ...

@javax.persistence.Entity public class Baz { ...
```
하지만 기술적 어려움으로 POJO를 주장하는 많은 라이브러리가 미리 지정된 어노테이션을 사용해야 하는데 어노테이션이 추가되기 전 객체가 POJO였다가 어노테이션이 제거되면 다시 POJO가 된다면 그건 POJO로 간주될 수 있다.

자바빈은 POJO에 해당된다. 자바빈의 제약 조건들에 의해 빈의 타입을 신경쓰지 않아도 되며 많은 프레임워크에 의해 범용적으로 사용될 수 있다.

# EJB(Enterprise JavaBeans)
중간 계층 비즈니스 성능을 구현하는 서버 측 프로그램으로 어플리케이션의 비즈니스 로직을 캡슐화한다.  
비즈니스 소프트웨어에서 전형적으로 나타나는 문제들에 대해 해결책을 제시하는 프로그램으로 Jakarta Enterprise Beans은 영속성, 트랜잭션 무결성, 보안 등의 일반적 문제를 표준 방식으로 처리해 프로그래머가 엔터프라이즈 소프트웨어의 특정 부분에만 집중할 수 있게 해줬다. 

# Java의 record
자바의 불변 객체 생성의 불편함을 덜어주기 위한 객체로 자바 14에 처음 등장했다. 여기서 [불변 객체](https://www.baeldung.com/java-immutable-object#benefits-of-immutability)란 완전히 생성된 이후로 내부 상태가 상수인 객체를 의미한다.

많은 경우에서 데이터는 불변이고 불변은 데이터의 동기화 없이 데이터의 유효성을 보장한다. 이를 위해선
- private, final을 포함한 필드들
- 각각의 필드의 getter
- 각 필드의 인자를 포함하는 public 생성자
- 모든 필드가 같을 때 true를 리턴하는 equals 메서드
- 필드가 같을 때 같은 값을 리턴하는 hashCode 메서드
- 클래스의 이름과 각각의 필드를 포함하는 toString 메서드

이 모든 것들을 보장해야 하는데 그러면 대표적으로 두 가지 문제가 있다.

1. 수많은 코드의 생성
2. 모호한 목적의 클래스들의 생성

따라서 record가 존재한다.

record는 불변 데이터 클래스로 필드의 타입과 이름만을 필요로 한다.
equals, hashCode, toString 메서드와 private, final 필드, public 생성자를 자바 컴파일러가 자동으로 생성해준다.

```java
public record Person(String name, String address){}
```
객체 생성은 다음과 같이 해줄 수 있다.

```java
Person person = new Person("hojin jang", "100")
```
나머지 메서드들의 생성은 자동으로 이뤄지는데 생성자에서 커스텀도 가능하다.

만약 모든 항목이 null이 아니었으면 한다면
```java
public record Person(String name, String address) {
    public Person {
        Objects.requireNonNull(name);
        Objects.requireNonNull(address);
    }
}
```
혹은 매개변수에 따라 다른 객체를 만들고 싶다면
```java
public record Person(String name, String address) {
    public Person(String name) {
        this(name, "Unknown");
    }
}
```

static 키워드를 이용해 필드를 선언하거나 스태틱 메서드를 만들 수도 있다.
```java
public record Person(String name, String address) {
    public static String UNKNOWN_ADDRESS = "Unknown";
}

public record Person(String name, String address) {
    public static Person unnamed(String address) {
        return new Person("Unnamed", address);
    }
}
```
정적 팩토리 메서드를 생성자 대신 사용한다면 javadoc에 정리를 잘 하는게 중요할 것 같다.
[1. 생성자 대신 정적 팩터리 메서드를 고려하라](https://ohjinn.tistory.com/112)


# DAO
DAO란 Data Access Object의 약자로 데이터 스토리지에서 데이터를 얻고 저장하고 업데이트 하는 과정을 캡슐화하는데 주로 쓰인다.

# ORM

출처  
[위키피디아](https://ko.wikipedia.org/wiki/%EC%9E%90%EB%B0%94%EB%B9%88%EC%A6%88)  
[baeldung](https://www.baeldung.com/java-record-keyword)  