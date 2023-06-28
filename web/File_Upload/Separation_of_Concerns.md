- [IOException](#ioexception)
- [`FileOutputStream`](#fileoutputstream)
- [Mockito  `verify`](#mockito--verify)
- [@SpyBean 과 @MockBean 차이](#spybean-과-mockbean-차이)
  - [SpyBean](#spybean)
  - [MockBean](#mockbean)




# IOException
주로 파일 시스템 내에서 파일을 읽고 쓸 때나 네트워크를 통해 파일을 읽고 쓸 때 일어나는 오류

# `FileOutputStream`
File 또는 FileDescriptor에 데이터를 쓰기 위한 출력 스트림으로 플랫폼에 따라 한 번에 하나의 FileOutputStream을 제한하는 경우도 있다.

| 생성자 | 설명 |
| ----- | ---------- |
| FileOutputStream(File file) | 해당 File 객체에 쓰기 위한 FileOutputStream을 생성한다. |
| FileOutputStream(File file, boolean append) | 해당 File 객체에 쓰기 위한 FileOutputStream을 생성한다. |
| FileOutputStream(FileDescriptor fdObj) | file descriptor를 위한 FileOutputStream을 생성한다. | 
| FileOutputStream(String name) | 이름지어진 파일을 쓰기 위한 FileOutputStream을 생성 |
| FileOutputStream(String name, boolean append) | 이름지어진 파일을 쓰기 위한 FileOutputStream을 생성 |


| 리턴 타입 | 메소드 이름 및 매개변수 | 설명 |
| --- | --- | --- |
| void() | close() | FileOutputStream을 종료하고 stream과 관련된 시스템 리소스를 release한다. |
| protected void | finalize() | file과의 커넥션을 정리하고 더이상의 stream 관련 참조가 없다면 close()가 호출됨을 보장한다 |
| FileChannel | getChannel() | FileOutputStream과 연관된 유니크한 FileChannel 을 리턴한다 |
| FileDescriptor | getFD() | stream과 관련된 FileDescriptor를 리턴한다. |
| void | write(byte[] b) |  |
| void | write(byte[] b, int off, int len) |  |
| void | write(int b) |  |

# Mockito  `verify`
verify()는 mock 객체의 메서드가 특정 조건이 실행되었는지 검증하는데 쓰인다.

```java
List<String> mockedList = mock(MyList.class);
mockedList.size();

verify(mockedList).size();
```
발동을 검사한다.

```java
List<String> mockedList = mock(MyList.class);
mockedList.size();
verify(mockedList, times(1)).size();
```
상호작용 횟수를 검사한다.

```java
List<String> mockedList = mock(MyList.class);
verifyNoInteractions(mockedList);
```
상호작용이 되지 않았음을 검사한다.

```java
List<String> mockedList = mock(MyList.class);
verify(mockedList, times(0)).size();
```

특정 메서드가 실행되지 않았음을 검사한다.

```java
List<String> mockedList = mock(MyList.class);
mockedList.size();
mockedList.clear();

verify(mockedList).size();
assertThrows(NoInteractionsWanted.class, () -> verifyNoMoreInteractions(mockedList));
```

예상치 못한 상호작용이 없음

```java
List<String> mockedList = mock(MyList.class);
mockedList.size();
mockedList.add("a parameter");
mockedList.clear();

InOrder inOrder = Mockito.inOrder(mockedList);
inOrder.verify(mockedList).size();
inOrder.verify(mockedList).add("a parameter");
inOrder.verify(mockedList).clear();
```

메서드 실행의 순서

```java
List<String> mockedList = mock(MyList.class);
mockedList.size();

verify(mockedList, never()).clear();
```

상호작용이 일어나지 않았음

```java
List<String> mockedList = mock(MyList.class);
mockedList.clear();
mockedList.clear();
mockedList.clear();

verify(mockedList, atLeast(1)).clear();
verify(mockedList, atMost(10)).clear();
```

최소한 특정 횟수만큼 일어났음

```java
List<String> mockedList = mock(MyList.class);
mockedList.add("test");

verify(mockedList).add("test");
```

정확한 매개변수로 상호작용이 있어났음을

```java
List<String> mockedList = mock(MyList.class);
mockedList.add("test");

verify(mockedList).add(anyString());
```

유연한 매개변수와 상호작용이 일어났음을

```java
List<String> mockedList = mock(MyList.class);
mockedList.addAll(Lists.<String> newArrayList("someElement"));

ArgumentCaptor<List<String>> argumentCaptor = ArgumentCaptor.forClass(List.class);
verify(mockedList).addAll(argumentCaptor.capture());

List<String> capturedArgument = argumentCaptor.getValue();
assertThat(capturedArgument).contains("someElement");
```

매개변수 캡쳐를 사용해 상호작용이 일어났음을





# @SpyBean 과 @MockBean 차이

테스트 더블: 테스트를 진행하기 어려운 경우 이를 대신해 테스트를 진행할 수 있도록 만들어주는 객체

테스트 더블의 종류: Dummy, Fake, Stub, Spy, Mock

1. Dummy:
가장 기본적인 테스트 더블로 인스턴스화된 객체가 필요하지만 기능은 필요하지 않은 경우에 사용한다.
2. Fake:
복잡한 로직이나 객체 내부에서 필요로 하는 다른 외부 객체들의 동작을 단순화해 구현한 객체
3. Stub:
Dummy 객체가 실제로 동작하는 것처럼 보이게 만들어놓은 객체로 인터페이스 또는 기본 클래스가 최소한으로 구현된 상태
4. Spy:
Stub의 역할을 가지면서 호출된 내용에 대해 약간의 정보를 기록한다.

5. Mock
호출에 대한 기대를 명세하고 내용에 따라 동작하도록 프로그래밍된 객체


## SpyBean
테스트에 실제 객체를 이용하는 어노테이션으로  
Given에서 선언한 코드 외에는 전부 실제 객체를 사용한다.

## MockBean
스프링 Bean이 아닌 Mock Bean을 주입해 내부의 구현은 사용자에게 위임한다.  
Given에서 선언한 코드 외에는 사용할 수 없다

출처:  
[오라클](https://docs.oracle.com/javase/8/docs/api/java/io/FileOutputStream.html)  
[테코블](https://tecoble.techcourse.co.kr/post/2020-09-19-what-is-test-double/)