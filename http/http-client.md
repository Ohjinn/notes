# HTTP\_Client

* [TCP/IP 통신, TCP와 UDP](http-client.md#tcpip-통신-tcp와-udp)
  * [TCP(Transmission Control Protocol)](http-client.md#tcptransmission-control-protocol)
  * [UDP(User Datagram Protocol)](http-client.md#udpuser-datagram-protocol)
* [Socket과 Socket API](http-client.md#socket과-socket-api)
* [URI와 URL](http-client.md#uri와-url)
* [URL의 구성](http-client.md#url의-구성)
  * [host](http-client.md#host)
  * [port](http-client.md#port)
  * [path](http-client.md#path)
  * [query](http-client.md#query)
  * [fragment](http-client.md#fragment)
* [DNS(Domain Name System)](http-client.md#dnsdomain-name-system)
* [Java text blocks](http-client.md#java-text-blocks)
* [Java InputStream과 OutputStream, Reader, Writer](http-client.md#java-inputstream과-outputstream-reader-writer)
  * [InputStream과 OutputStream](http-client.md#inputstream과-outputstream)
    * [InputStream()](http-client.md#inputstream)
    * [OutputStream()](http-client.md#outputstream)
  * [Reader와 Writer](http-client.md#reader와-writer)
    * [Reader()](http-client.md#reader)
    * [Writer()](http-client.md#writer)
* [Java try-with-resources](http-client.md#java-try-with-resources)

## TCP/IP 통신, TCP와 UDP

### TCP(Transmission Control Protocol)

* 연결 지향(3way handshake)
  * SYN, SYN+ACK, ACK을 기반으로 데이터를 전송한다
* 데이터 전달 보증
* 순서 보장

### UDP(User Datagram Protocol)

* 기능이 없음
* IP + PORT + checksum 수준으로 애플리케이션단에서의 추가 작업이 필요하다.

## Socket과 Socket API

운영체제 시점의 socket과 socket API를 구분하라는 것으로 이해했다.\
network socket은 컴퓨터 네트워크를 경유하는 프로세스 간 통신의 종착점으로 소켓은 TCP/UDP, IP, PORT 등으로 구성되어 있다.\
이를 이용해 프로그래밍 한 것이 socket API다.\
JAVA에서는 모든 입출력을 Stream으로 다룬다

## URI와 URL

URI(Uniform Resource Identifier)의 안에 URL(Uniform Resource Locator)과 URN(Uniform Resource Name)이 존재한다.

* URL - 리소스가 있는 위치를 지정
* URN - 리소스에 이름을 부여

Location과 Name에서 알 수 있듯 각각의 용도에 맞게 설계됐지만 현재는 URL만 쓰이고 있기 때문에 사실상 URI = URL로 쓰인다

## URL의 구성

아래 URL에 각각의 위치가 존재한다.

**scheme://\[userinfo@]host\[:port]\[/path]\[?query]\[#fragment]**

### host

위의 host위치에 들어가는 것으로 호스트명이라고 한다.\
도메인명 또는 IP주소를 직접 사용할 수도 있다.

### port

접속 포트로 일반적으로 생략한다. 생략시 http는 80, https는 443포트를 사용한다.

### path

리소스의 경로로 계층적 구조를 가진다.

### query

key - value 형태를 가지며 ?로 시작, &로 추가 가능하다\
query parameter, query string으로 불린다.

### fragment

`https://docs.spring.io/spring-boot/docs/current/reference/html/getting- started.html#getting-started-introducing-spring-boot`\
위 주소와 같이 html 내부 북마크 등에 사용한다

## DNS(Domain Name System)

도메인 명을 IP 주소로 변환해주는 역할을 한다.

## Java text blocks

java text blocks은 텍스트를 할당하기 위한 블록을 선언하는 방법을 이야기 하는 것으로 자바 15부터 공식적으로\
_"""_ 를 사용해 텍스트 블록을 선언할 수 있어졌다.

* text blocks 안의 indent는 정상적으로 작동한다.
* newline은 \n을 이용해서만 가능하다.
* 각 line 뒤의 띄어쓰기들을 없애준다
* .formatted를 이용해 포멧팅도 가능하다.

```java
public String getFormattedText(String parameter) {
    return """
            Some parameter: %s
            """.formatted(parameter);
}
```

## Java InputStream과 OutputStream, Reader, Writer

I/O는 JVM기준으로 읽을때 Input을, 쓰거나 전송할때는 Output이라는 용어를 사용한다.

초기 자바에서는 java.io에 있는 클래스를 제공했고 이 패키지는 바이트 기반의 데이터 처리를 위해 스트림이라는 클래스(InputStream, OutputStream)를 제공했다.

바이트가 아닌 char 기반의 문자열로만 되어있는 파일은 Reader와 Writer라는 클래스로 처리한다.

JDK 1.4부터는 보다 빠른 I/O를 위해 NIO라는 것이 추가되었는데 NIO는 스트림 기반이 아니라 버퍼와 채널 기반으로 데이터를 처리한다.

Java 7에서는 NIO2 라는 것이 추가되어 파일 처리를 보완했는데 기존 자바에서 파일을 접근할 때 사용하던 File클래스의 유닉스 명령어 인식 문제를 해결해 java.nio.file패키지의 Files클래스를 추가했다. 기존의 File은 객체를 생성해야 하는 반면 Files는 메소드가 static으로 선언되어 있기 때문에 별도의 객체를 생성할 필요가 없다.

### InputStream과 OutputStream

자바 I/O는 기본적으로 InputStream과 OutputStream이라는 abstract 클래스를 통해 제공된다.\
\


#### InputStream()

inputStream의 선언문을 살펴보면

```java
public abstract class InputStream extends Object implements Closeable
```

다음과 같은데 익숙하지 않은 Closeable은 해당 리소스를 사용하면 close()를 통해 항상 닫아주어야 한다는 것을 의미한다.\
\


| 리턴 타입        | 메소드 이름 및 매개변수                     | 설명                                             |
| ------------ | --------------------------------- | ---------------------------------------------- |
| int          | available()                       | 스트림에서 중단없이 읽을 수 있는 바이트의 개수                     |
| void         | mark(int readlimit)               | 스트림의 현재 위치를 표시해두고 매개변수로 표시의 최대 유효 거리를 지정한다     |
| void         | reset()                           | 현재 위치를 mark() 메소드가 호출되었던 위치로 되돌린다              |
| boolean      | markSupported()                   | mark()나 reset() 메소드가 수행 가능한지 확인한다              |
| abstract int | read()                            | 스트림에서 다음 바이트를 읽는다                              |
| int          | read(byte\[] b)                   | 매개변수로 넘어온 바이트 배열에 데이터를 담고 데이터 갯수를 리턴한다         |
| int          | read(byte\[] b, int off, int len) | 매개변수로 넘어온 바이트 배열에 특정위치부터 지정한 길이만큼 지정한 데이터를 담는다 |
| long         | skip(long n)                      | 매개변수로 넘어온 길이만큼의 데이터를 건너 뛴다                     |
| void         | close()                           | 작업중인 대상을 해제한다                                  |

기본적으로 읽을 땐 read() 사용이 끝나면 close()를 호출해주면 된다.

이를 확장한 주요 클래스는 다음과 같다.

```java
AudioInputStream, ByteArrayInputStream, FileInputStream, FilterInputStream, InputStream, ObjectInputStream, PipedInputStream, SequenceInputStream, StringBufferInputStream
```

많이 쓰이는 클래스는 세 개 정도가 있다.

| 클래스               | 설명                                                 |
| ----------------- | -------------------------------------------------- |
| FileInputStream   | 파일을 읽는데 사용하며 이미지같은 바이트 파일을 읽을 때 주로 사용한다.           |
| FilterInputStream | 다른 입력스트림을 포괄하며 단순히 InputStream 클래스가 Override 되어있다. |
| ObjectInputStream | ObjectOutputStream으로 저장한 데이터를 읽는데 사용한다.            |

\
\


#### OutputStream()

OutputStream의 선언문은

```java
public abstract class OutputStream extends Object implements Closeable, Flushable
```

Flushable이 특이한데 매번 요청마다 저장하면 효율이 안좋으니 buffer에 쌓아두었다가 flush()할 때마다 저장하는 방법이다.

| 리턴 타입         | 메소드 이름 및 매개변수                      | 설명                        |
| ------------- | ---------------------------------- | ------------------------- |
| void          | write(byte\[] b)                   | 매개변수로 받은 바이트배열을 저장        |
| void          | write(byte\[] b, int off, int len) | 바이트배열을 특정위치부터 지정한 길이만큼 지정 |
| abstract void | write(int b)                       | 바이트를 저장                   |
| void          | flush()                            | 버퍼의 데이터를 강제입력             |
| void          | close()                            | 스트림을 해제                   |

\
\


### Reader와 Writer

#### Reader()

위에서 말했듯 Stream은 byte를 위한 것이며 Reader와 Wrtier는 char 기반 문자열 처리를 위한 클래스다.

Reader의 선언문은

```java
public abstract class Reader extends Object implements Reader, closeable
```

| 리턴 타입        | 메소드 이름 및 매개변수                        | 설명                                              |
| ------------ | ------------------------------------ | ----------------------------------------------- |
| boolean      | ready()                              | Reader에서 작업한 대상이 읽을 준비가 되어 있는지 확인               |
| void         | mark(int readAheadLimit)             | Reader의 현재 위치를 표시해두고 매개변수로 표시의 최대 유효 거리를 지정한다   |
| void         | reset()                              | 현재 위치를 mark() 메소드가 호출되었던 위치로 되돌린다               |
| boolean      | markSupported()                      | mark()나 reset() 메소드가 수행 가능한지 확인한다               |
| int          | read()                               | 하나의 char를 읽는다                                   |
| int          | read(byte\[] cbuf)                   | 매개변수로 넘어온 char 배열에 데이터를 담고 데이터 갯수를 리턴한다         |
| abstract int | read(byte\[] cbuf, int off, int len) | 매개변수로 넘어온 char 배열에 특정위치부터 지정한 길이만큼 지정한 데이터를 담는다 |
| int          | read(CharBuffer target)              | CharBuffer 클래스의 객체에 데이터를 담는다                    |
| long         | skip(long n)                         | 매개변수로 넘어온 길이만큼의 데이터를 건너 뛴다                      |
| void         | close()                              | 작업중인 대상을 해제한다                                   |

이를 확장한 주요 클래스는 다음과 같다.

```java
BufferedReader, CharArrayReader, FilterReader, InputStreamReader, PipedReader, StringReader
```

BufferedReader와 InputStreamReader가 많이 사용된다.\
\


#### Writer()

Writer의 선언문은

```java
public abstract class Writer extends Object implements Appendable, Closeable, Flushable
```

다른 클래스에는 없는 Appendable 인터페이스가 구현되어 있다 Java5에 추가되었으며 문자열을 추가하기 위해 선언되었다.

| 리턴 타입         | 메소드 이름 및 매개변수                                | 설명                                                           |
| ------------- | -------------------------------------------- | ------------------------------------------------------------ |
| Writer        | append(char c)                               | 매개변수로 넘어온 char를 추가한다                                         |
| Writer        | append(CharSequence csq)                     | 매개변수로 넘어온 CharSequence를 추가한다                                 |
| Writer        | append(CharSequence csq, int start, int end) | 매개변수로 넘어온 CharSequence를 추가하며 쓰여지는 문자열의 시작 위치와 끝 위치를 지정하면 된다. |
| void          | write(char\[] cbuf)                          | 매개변수로 받은 char의 배열을 추가                                        |
| abstract void | write(byte\[] b, int off, int len)           | 매개변수로 넘어온 char의 배열의 특정 위치부터 특정 길이만큼 추가                       |
| void          | write(int c)                                 | 매개변수로 넘어온 int에 해당하는 char를 추가                                 |
| void          | write(String str)                            | 매개변수로 넘어온 문자열을 쓴다                                            |
| void          | write(String str, int off, int len)          | 매개변수로 넘어온 문자열을 추가, 쓰여지는 문자열의 시작과 끝을 지정                       |
| abstract void | flush()                                      | 버퍼의 데이터를 강제입력                                                |
| abstract void | close()                                      | 스트림을 해제                                                      |

append에 매개변수로 넘어가는 CharSequence는 인터페이스로 이를 구현한 클래스는 String, StringBuffer, StringBuilder 등이 있다. 다시말해 대부분의 문자열을 받을 수 있다는 말이다.

Writer는 자바 1부터 지원 됐던 클래스로 그 때는 write()밖에 존재하지 않았는데 문자열이 String이라면 write()를 써도 되겠지만 매개변수를 생각하면 그 외라면 append()가 더 편할 것이다.

\


## Java try-with-resources

try-with-resources는 종료 시점에 모든 자원들이 종료됨을 보장하는 구문으로 java.io.Closeable을 상속한 모든 객체에 사용할 수 있다.

자바 7 이전에는 finally 블록을 이용해 자원을 해제해줬는데 finally 블록은 메모리 누수의 위험성이 있다.

```java
static String readFirstLineFromFileWithFinallyBlock(String path) throws IOException {
   
    FileReader fr = new FileReader(path);
    BufferedReader br = new BufferedReader(fr);
    try {
        return br.readLine();
    } finally {
        br.close();
        fr.close();
    }
}
```

위의 코드에서 readLine이 exception을 던지고 br.close가 예외를 던지면 fr은 메모리 누수의 대상이 된다.\
또한 try-with-resources 블록에서 만들어진 exception은 suppressed되지만 finally에서 만들어진 exception은 suppressed 되지 않는다.

출처:\
https://www.baeldung.com/java-text-blocks\
https://docs.oracle.com/javase/tutorial/essential/exceptions/tryResourceClose.html\
https://www.inflearn.com/course/http-%EC%9B%B9-%EB%84%A4%ED%8A%B8%EC%9B%8C%ED%81%AC/dashboard\
자바의 신
