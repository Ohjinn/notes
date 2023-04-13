# http-server

* [Java ServerSocket](http-server.md#java-serversocket)
* [Blocking vs Non-Blocking](http-server.md#blocking-vs-non-blocking)

## Java ServerSocket

| 생성자                                                       | 설명                                                             |
| --------------------------------------------------------- | -------------------------------------------------------------- |
| ServerSocket()                                            | 서버 소켓 객체만 생성한다                                                 |
| ServerSocket(int port)                                    | 지정된 포트를 사용하는 서버 포트를 생성한다                                       |
| ServerSocket(int port, int backlog)                       | 지정된 포트와 backlog 개수를 가지는 소켓을 생성한다                               |
| ServerSocket(int port, int backlog, InetAddress bindAddr) | 지정된 포트와 backlog 개수를 가지는 소켓을 생성하며, bindAddr에 있는 주소에서의 접근만을 허용한다 |

backlog은 ServerSocket 객체가 바빠서 연결을 못하고 대기시킬 수 있는데 그 때의 최대 대기 갯수로 지정하지 않으면 50이 default가 된다.\
InetAddress의 bindAddr은 특정 주소만 연결 가능하도록 지정할 때 가능하다.

| 리턴 타입  | 메소드 이름 및 매개변수 | 설명                                   |
| ------ | ------------- | ------------------------------------ |
| Socket | accept()      | 새로운 소켓 연결을 기다리고 연결이 되면 Socket 객체를 리턴 |
| void   | close()       | 소켓 연결을 종료                            |

\
\


* 서버소켓 예시

```java
public static void main(String[] args) throws IOException {
    App app = new App();
    app.run();
}

private void run() throws IOException {
    // 1. Listen

    ServerSocket listener = new ServerSocket(8080, 0);
    System.out.println("Listen!");

    // 2. Accept
    while (true) {

        Socket socket = listener.accept();
        System.out.println("Accept!");

        // 3. Request
        Reader reader = new InputStreamReader(socket.getInputStream());

        CharBuffer charBuffer = CharBuffer.allocate(1_000_000);
        reader.read(charBuffer);

        charBuffer.flip();
        System.out.println(charBuffer.toString());

        // 4. Response
        String body = "Hello!";
        byte[] bytes = body.getBytes();
        String message = "" +
                "HTTP/1.1 200 OK\n" +
                "Content-Type: text/html; charset=UTF-8\n" +
                "Content-Length: " + bytes.length + "\n" +
                "\n" +
                body;

        Writer writer = new OutputStreamWriter(socket.getOutputStream());
        writer.write(message);
        writer.flush();

        // 5. Close
        socket.close();
    }

}
```

## Blocking vs Non-Blocking

* Blocking과 Non-Blocking\
  제어권에 따라 달라진다. Blocking은 A 함수가 B 함수를 호출할 때 B 함수가 작업이 종료될 때 까지 제어권을 돌려주지 않는 것을 뜻한다. Non-Blocking은 B가 A에게 바로 제어권을 넘겨주면서 A함수가 다른 일을 처리할 수 있도록 만들어 준다.
* Sync와 Async\
  호출된 함수의 종료 주체가 어디 있느냐를 뜻한다 Sync는 A 함수가 B 함수를 호출 할 때 결과를 A 함수가 처리하는 것을 뜻하고\
  Async는 B 함수의 결과를 콜백으로 B 함수가 직접 처리하는 것을 뜻한다

출처:\
자바의신
