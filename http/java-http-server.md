# JAVA\_HTTP\_Server

* [Java HTTP Server](java-http-server.md#java-http-server)
* [Java NIO](java-http-server.md#java-nio)
  * [NIO와 Channel, Buffer](java-http-server.md#nio와-channel-buffer)
* [Java Lambda expression(람다식)](java-http-server.md#java-lambda-expression람다식)
  * [Nested 클래스](java-http-server.md#nested-클래스)
  * [람다](java-http-server.md#람다)
  * [Java Functional interface(함수형 인터페이스)](java-http-server.md#java-functional-interface함수형-인터페이스)

\
\


## Java HTTP Server

Java HTTP Server는 HTTP 요청을 처리하는 서버로 HTTP 요청을 받기에 더 편리한 클래스다.\
ServerSocket과 달리 Provider에 의해 생성, 관리되며 create() 메서드를 호출해 할당받을 수 있다.

| 리턴 타입                                     | 메소드 이름 및 매개변수                                  | 설명                                                     |
| ----------------------------------------- | ---------------------------------------------- | ------------------------------------------------------ |
| static HttpServer                         | create()                                       | bind되지 않은 HttpServer를 return 한다                        |
| static HttpServer                         | create(InetSocketAddress addr, int backlog)    | 특정 IP 주소와 port가 지정되고 backlog 갯수가 지정된 HttpServer를 반환한다. |
| void                                      | bind()                                         | 연결되지 않은 HttpServer를 해당 주소와 port에 Bind한다                |
| abstract HttpContext                      | createContext(String path)                     | hadler 없이 HttpContext를 생성한다                            |
| abstract HttpContext                      | createContext(String path, HttpHandler hander) | HttpContext를 생성한다                                      |
| abstract InetSocketAddress()              | getAddress()                                   | server가 기다리고 있는 주소를 리턴                                 |
| 등등이 있고 위의 메서드들을 이용해서 HttpServer를 만들 수 있다. |                                                |                                                        |

\
\


* HttpServer 예시

```java
public class App {

    public static void main(String[] args) throws IOException {
        App app = new App();
        app.run();
    }

    private void run() throws IOException {
        InetSocketAddress address = new InetSocketAddress(8080);
        HttpServer httpServer = HttpServer.create(address, 0);

        httpServer.createContext("/", exchange -> {
            // 1. Request
            String method = exchange.getRequestMethod();
            System.out.println(method);

            URI uri = exchange.getRequestURI();
            String path = uri.getPath();
            System.out.println(path);

            Headers headers = exchange.getRequestHeaders();
            for (String key : headers.keySet()) {
                System.out.print(key + ": ");
                System.out.println(headers.get(key));
            }

            InputStream inputStream = exchange.getRequestBody();
            String body = new String(inputStream.readAllBytes());

            // 2. Response

            String content = "Hello, world!";
            byte[] bytes = content.getBytes();

            exchange.sendResponseHeaders(200, bytes.length);

            OutputStream outputStream = exchange.getResponseBody();
            outputStream.write(bytes);
            outputStream.flush();

        });

        httpServer.start();
    }
}

```

\
\


## Java NIO

### NIO와 Channel, Buffer

자바 4에서 NIO가 추가되었다.

NIO는 스트림을 사용하지 않고 채널과 버퍼를 사용한다.

```java
public static void main(String[] args) {
    NIOSample sample = new NIOSample();
    sample.basicWriteAndRead();
}

public void basicWriteAndRead() {
    String fileName = "dumpFile" + separator + "text1.txt";
    try {
        writeFile(fileName, "NIO sample");
        readFile(fileName);
    } catch (Exception e) {
        e.printStackTrace();
    }
}

public void writeFile(String fileName, String data) throws Exception {
    FileChannel channel = new FileOutputStream(fileName).getChannel(); // FileChannel 객체를 만들려면 FileOutputStream 클래스에 선언된 getChannel을 호출한다.
    byte[] bytes = data.getBytes();
    ByteBuffer buffer = ByteBuffer.wrap(bytes); // ByteBuffer 클래스에 static으로 선언된 wrap() 메소드를 호출하면 ByteBuffer 객체가 생성되고 매개변수로 저장할 byte 배열을 넘겨주면 된다.
    channel.write(buffer); // FileChannel에 선언된 write() 메소드를 buffer에 넘겨주면 파일에 쓰게된다.
    channel.close();
}

public void readFile(String fileName) throws Exception {
    FileChannel channel = new FileInputStream(fileName).getChannel(); // FileInputStream 클래스에 선언된 getChannel() 메소드를 호출한다.
    ByteBuffer buffer = ByteBuffer.allocate(1024); // ByteBuffer의 allocate() 메소드를 통해 buffer 객체를 만들고 데이터가 기본적으로 저장되는 크기를 지정한다
    channel.read(buffer); // 채널에 버퍼를 넘겨 담을 버퍼를 알려준다.
    buffer.flip(); // buffer에 담겨있는 데이터의 가장 앞으로 이동한다
    while (buffer.hasRemaining()) { // 데이터가 더 남아 있는지 확인한다
        System.out.println((char)buffer.get()); // 한 바이트씩 데이터를 읽는다
    }
    channel.close();
}
```

Buffer에 대해 살펴보자\
Buffer는 java.nio.Buffer 클래스를 확장해서 사용하는데 CharBuffer, DoubleBuffer, FloatBuffer, IntBuffer, LongBuffer, ShortBuffer 등이 존재하는데 이 안의 메소드들은 다음과 같다.

| 리턴 타입 | 메소드        | 설명                      |
| ----- | ---------- | ----------------------- |
| int   | capacity() | 버퍼에 담을 수 있는 크기 리턴       |
| int   | limit()    | 버퍼에서 읽거나 쓸 수 없는 첫 위치 리턴 |
| int   | position() | 현재 버퍼의 위치 리턴            |

* capacity는 버퍼의 크기
* position은 현재의 위치
* limit은 읽거나 쓸 수 없는 위치

| 리턴 타입   | 메소드            | 설명                                            |
| ------- | -------------- | --------------------------------------------- |
| Buffer  | flip()         | limit 값을 현재 position으로 지정한 후 position을 0으로 이동 |
| Buffer  | mark()         | 현재 position을 mark                             |
| Buffer  | reset()        | 버퍼의 position을 mark한 곳으로 이동                    |
| Buffer  | rewind()       | 현재 버퍼의 position을 0으로 이동                       |
| int     | remaining()    | limit-position 계산 결과를 리턴                      |
| boolean | hasRemaining() | position과 limit 값에 차이가 있을 경우 true             |
| Buffer  | clear()        | 버퍼를 지우고 position을 0으로 이동하며 limit을 버퍼의 크기로 변경  |

\
\
\


## Java Lambda expression(람다식)

익명 클래스를 사용하면 가독성도 떨어지고 직접 일일이 써야하는 코드량이 늘어난다. 이런 단점을 보완하기 위해 람다식이 만들어졌다. 람다식은 익명 클래스로 전환 가능하며 익명 클래스는 람다 표현식으로 전환 가능하다. 그럼 람다 표현식 전에 익명 클래스부터 알아보자.

### Nested 클래스

클래스 안의 클래스를 Nested 클래스라고 불린다. Nested class는 static nested 클래스와 내부 클래스로 구분되는데 이 둘은 static 여부로 구분된다.

![innerclass](https://user-images.githubusercontent.com/67143721/203054534-1fc7ba29-5840-4a21-a997-bca26845085f.jpg)

내부 클래스는 또 다시 두 가지로 나뉘는데 이름이 있는 내부 클래스를 Local Class, 이름이 없는 클래스를 익명 클래스로 불린다.

```java
public class OuterOfStatic {
    static class StaticNested {
        private int value = 0;
        public int getValue() {
            return value;
        }
        public void setValue(int value) {
            this.value = value;
        }
    }
}
```

위와 같은 static 내부 클래스를 가지는 OuterOfStatic 클래스가 있다고 생각해보자. 위의 코드는 컴파일하면 두개의 클래스가 만들어진다.

```
OuterOfStatic.class
OuterOfStatic$StaticNested.class
```

이렇게 선언된 static 클래스를 사용하고 싶다면

```java
public class NestedSample {
    public static void main(String[] args) {
        NestedSample sample = new NestedSample();
        sample.makeStaticNestedObject();
    }

    public void makeStaticNestedObject() {
        OuterOfStatic.StaticNested staticNested = new OuterOfStatic.StaticNested();
        staticNested.setValue(3);
        System.out.println(staticNested.getValue());
    }
}
```

위와 같이 따로 객체를 할당하지 않고 바로 사용하면 된다.

```java
FileChannel channel = new FileOutputStream(fileName).getChannel(); // FileChannel 객체를 만들려면 FileOutputStream 
```

이렇게 만드는 이유는 클래스는 묶어서 용도를 명확하게 하기 위함이다.

구분에서 봤듯이 Static Nested Class와 Inner Class의 차이는 static 하나다. static으로 선언한 클래스를 Inner Class로 선언해보자.

```java
public class OuterOfInner {
    class Inner {
        private int value = 0;
        public int getValue() {
            return value;
        }
        public void setValue(int value) {
            this.value = value;
        }
    }
}
// static만 빠졌다.
```

Inner Class를 사용해보자.

```java
public class InnerSample {
    public static void main(String[] args) {
        InnerSample sample = new InnerSample();
        sample.makeInnerObject();
    }
    public void makeInnerObject() {
        OuterOfInner outer = new OuterOfInner();
        OuterOfInner.Inner inner = outer.new Inner();
        inner.setValue(3);
        System.out.println(inner.getValue());
    }
}
```

다소 복잡해졌다. 객체를 생성하기 위해서 outer 객체를 만들고 그 객체를 통해 inner를 만들 수 있다.

이렇게 내부 클래스를 만들었던 이유는 캡슐화 때문이고 대부분 자바 GUI 때문이었다. 특정 버튼이 눌렸을 때 이벤트를 발생하는데 그 때의 작업을 정의하기 위해서 내부 클래스를 사용했다. 하지만 대부분의 버튼 하나당 작업은 하나로 귀결되기 때문에 `익명 클래스`를 만드는 것이 편하다. 익명 클래스는 Inner 클래스인데 개중 이름이 없는 클래스다.

안드로이드에서도 자주 있었던 패턴인데

```java
public class AnonymousSample {
    public static void main(String[] args) {
        AnonymousSample sample = new AnonymousSample();
        sample.setButtonListener();
    }
    public void setButtonListener() {
        MagicButton button = new MagicButton();
        MagicButtonListener listener = new MagicButtonListener();
        button.setListener(listener);
        button.onClickProcess();
    }
}

public class MagicButton {
    public MagicButton() {
    }
    public EventListener listener;
    public void setListener(EventListener listener) {
        this.listener = listener;
    }
    public void onClickProcess() {
        if(listener != null) {
            listener.onClick();
        }
    }
}


public class MagicButtonListener implements EventListener{
    public void onClick() {
        System.out.println("Magic Button Clicked !!!");
    }
}


```

다음과 같은 부분이 있다고 하자.\
main에서는 MagicButton이 있고 버튼에 대한 리스너를 만들어서 버튼에 리스너를 설정해주고 눌리는 상황을 가정했다. 이런 패턴은 익명함수로 대체가 가능한데

```java
public void setButtonListenerAnonymous() {
    MagicButton button = new MagicButton();
    EventListener listener = new EventListener() {
        @Override
        public void onClick() {
            System.out.println("Magic Button Clicked !!!");
        }
    };
    button.setListener(listener);
    button.onClickProcess();
}
```

이렇게 익명함수로 만들어버리면 MagicButtonListener를 만들지 않아도 된다.\
익명함수는 메모리에 로드하는 클래스 갯수를 줄일 수 있기 때문에 속도 면에서 유리하다고 할 수 있다.\
내부 클래스는 모두 다른 클래스에서 재사용할 일이 없을 때만 만들어 줘야 한다.

### 람다

람다는 익명클래스의 단점을 보완하기 위해 만들어 졌다. 다시말해 인터페이스에 메소드가 하나인 것들만 적용 가능하다.

자바에 있는 인터페이스 중 메소드가 하나인 것은 다음과 같다.

```
java.lang.Runnable
java.util.Comparator
java.io.FileFilter
java.util.concurrent.Callable
java.security.PrivilegedAction
java.nio.file.PathMatcher
java.lang.reflect.InvocationHandler
```

물론 이 인터페이스 외의 사용을 위해선 인터페이스를 만들어서 사용하면 된다.

```java
public interface Calculate {
    int operation(int a, int b);
}
```

다음과 같이 메소드가 하나인 인터페이스가 있을 때 위에서 본 익명 클래스란 다음과 같다.

```java
public class CalculateSample {
    public static void main(String[] args) {
        Calculate calculate = new Calculate() {
            @Override
            public int operation(int a, int b) {
                return a + b;
            }
        };
        System.out.println(calculate.operation(1, 2));
    }
}
```

굳이 객체를 생성하지 않아도 이렇게 사용할 수 있다는 말이다.\
이걸 다시 람다로 사용해주면 위의 코드는 아래와 같은 말이다.

```java
public class CalculateSample {
    public static void main(String[] args) {
        Calculate calculate = (a, b) -> a + b;
        System.out.println(calculate.operation(1, 2));
    }
}
```

기본 람다 표현식은 3부분으로 구성돼있고

| 매개 변수 목록       | 화살표 토큰 | 처리 식  |
| -------------- | ------ | ----- |
| (int x, int y) | ->     | x + y |

위에 대입해보면 이해 될것이다.

메소드가 여러개인 인터페이스를 람다로 사용하려 하면

```java
public interface Calculate {
    int operation(int a, int b);
    int operationSub(int a, int b);
}

Operator '+' cannot be applied to '<lambda parameter>', '<lambda parameter>'
```

메소드가 여러개라고 에러가 나온다. 작성자가 여럿이라면 충분히 일어날 수 있는 상황인데\
이런 혼동을 피하기 위해

```java
@FunctionalInterface
interface Calculate {
    int operation(int a, int b);
}
```

@FunctionalInterface를 사용하면 이 인터페이스는 하나의 메소드만 선언할 수 있고 그 이상에선 컴파일 에러가 뜬다.

Runnable을 사용해서 람다를 사용해보면

```java
@FunctionalInterface
public interface Runnable {
    /**
     * When an object implementing interface <code>Runnable</code> is used
     * to create a thread, starting the thread causes the object's
     * <code>run</code> method to be called in that separately executing
     * thread.
     * <p>
     * The general contract of the method <code>run</code> is that it may
     * take any action whatsoever.
     *
     * @see     java.lang.Thread#run()
     */
    public abstract void run();
}
```

Runnable의 정의 는 다음과 같고

```java
public class CalculateSample {
    public static void main(String[] args) {
        CalculateSample calculateSample = new CalculateSample();
        calculateSample.runCommonThread();
    }

    private void runCommonThread() {
        Runnable runnable = new Runnable() {
            @Override
            public void run() {
                System.out.println(Thread.currentThread().getName());
            }
        };
        new Thread(runnable).start();
    }
}
```

Runnable은 인터페이스, Thread는 Runnable에 부가 기능을 더한 클래스다.\
따라서 Runnable을 실행하기 위해선 new Thread().start()를 해줬어야 했다.

이걸 람다로 표현해보면

```java
private void runCommonThread() {
    Runnable runnable = () -> System.out.println(Thread.currentThread().getName());
    new Thread(runnable).start();
}
```

\->

```java
private void runCommonThread() {
    new Thread(() -> System.out.println(Thread.currentThread().getName())).start();
}
```

요러게 되시겠다.

익명클래스는 람다로 대체되지만 완전히 같은 것은 아니다. 람다의 내부는 익명클래스의 내부와 다르다.

```java
public class LambdaThis {
    public static void main(String[] args) {
        new LambdaThis().test();
    }
    public void test() {
        Runnable anonymous = new Runnable() {
            @Override
            public void run() {
                check(this);
            }
        };
        anonymous.run();

        Runnable lambda = () -> check(this);
        lambda.run();
    }
    private void check(Object obj) {
        System.out.println(obj instanceof Runnable);
    }
}
```

```java
L1
LINENUMBER 15 L1
ALOAD 1
INVOKEINTERFACE java/lang/Runnable.run ()V (itf)
L2
LINENUMBER 17 L2
ALOAD 0
INVOKEDYNAMIC run(Lcom/company/stream/LambdaThis;)Ljava/lang/Runnable; [
```

가져온 바이트코드는 anonymous.run(), lambda.run() 부분인데 간단하게 이야기하면 명령어가 다르다 대체하기 위함이지만 명령어는 다르다는 뜻이다.

### Java Functional interface(함수형 인터페이스)

java8에서 제공하는 주요 Functional interface는 java.util.function 패키지에 정리되어 있다.

![util function](https://user-images.githubusercontent.com/67143721/203553046-93536101-af82-480c-820c-3c8b7c41a1fe.PNG)

몇개만 알아보면 다음과 같다.

* Predicate\
  test()라는 메소드가 있으며 두 객체를 비교할 때 사용한다. boolean을 리턴. and(), negate(), or()이라는 default 메소드가 구현되어 있으며 isEqual()이라는 static 메소드도 존재한다.
* Supplier\
  get()메소드가 있으며 리턴은 generic으로 선언된 타입을 리턴한다. 추가 메소드는 없다.
* Consumer\
  accept()라는 매개변수를 갖는 메소드 리턴이 없다. andThen()이라는 default 메소드가 구현되어 있는데 순차 작업을 할 떄 유용하다.
* Function\
  apply()라는 하나의 매개 변수를 갖는 메소드, 리턴 존재. 변환을 할 필요가 있을 때 이 인터페이스를 사용하는데 Function\<T, R>로 정의되어 있어 앞은 입력, 뒤는 리턴이다.
* UnaryOperation\
  apply()라는 하나의 매개변수를 갖는 메소드, 리턴 존재. 한 가지 타입에 대해 결과도 같은 타입일 경우 사용한다.
* BinaryOperation apply()라는 두 개의 매개변수를 갖는 메소드, 리턴존재

```java
public class PredicateExample {
    public static void main(String[] args) {
        PredicateExample sample = new PredicateExample();

        Predicate<String> predicateLength5 = (a) -> a.length() < 8;
        Predicate<String> predicateContains = (a) -> a.contains("ho");
        Predicate<String> predicateStart = (a) -> a.startsWith("jang");

        String janghojin = "janghojin";
        String jangjin = "jangjin";

        sample.predicateTest(predicateLength5, janghojin);
        sample.predicateTest(predicateLength5, jangjin);

        sample.predicateNegate(predicateLength5, janghojin);
        sample.predicateNegate(predicateLength5, jangjin);

        sample.predicateAnd(predicateLength5, predicateContains, janghojin);
        sample.predicateAnd(predicateLength5, predicateContains, jangjin);

        sample.predicateOr(predicateLength5, predicateStart, janghojin);
        sample.predicateOr(predicateLength5, predicateStart, jangjin);
    }

    private void predicateTest(Predicate<String> p, String data) {
        System.out.println(p.test(data));
    }

    private void predicateAnd(Predicate<String> p1, Predicate<String> p2, String data) {
        System.out.println(p1.and(p2).test(data));
    }

    private void predicateOr(Predicate<String> p1, Predicate<String> p2, String data) {
        System.out.println(p1.or(p2).test(data));
    }

    private void predicateNegate(Predicate<String> p, String data) {
        System.out.println(p.negate().test(data));
    }
}
```

* predicateTest(): 데이터가 해당 조건에 맞는지 확인
* predicateAnd(): 데이터가 두개의 조건에 모두 맞는지 확인
* predicateOr(): 데이터가 두개의 조건 중 하나라도 맞는지 확인
* predicateNegate(): 데이터가 조건과 다른지 확인

출처:\
https://docs.oracle.com/javase/8/docs/jre/api/net/httpserver/spec/com/sun/net/httpserver/HttpServer.html#HttpServer--\
자바의신
