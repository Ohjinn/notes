- [환경변수(환경변수를 다루는 법)](#환경변수환경변수를-다루는-법)



# 환경변수(환경변수를 다루는 법)

1. application.yml파일에서 환경변수

JAVA_HOME, OS변수등을 application.properties 파일에서 하용하려면 
```
java.home=${JAVA_HOME}

environment.name=${OS}

baeldung.presentation=${HELLO_BAELDUNG}. Java is installed in the folder: ${JAVA_HOME}
```
이렇게 사용하면 된다.


코드상에서 사용하는 방법은
1. @Value 어노테이션 사용

```java
@Value("${baeldung.presentation}")
private String baeldungPresentation;
```

2. 스프링의 Environment 객체 사용
```java
@Autowired
private Environment environment;

environment.getProperty("baeldung.presentation")
```

3. Properties를 @ConfigurationProperties로 그룹화

환경변수에 baeldung으로 시작하는 환경변수들이 존재할 때 이런 식으로 컴포넌트화 해서 환경변수를 객체로 전환하고
```java
@Component
@ConfigurationProperties(prefix = "baeldung")
public class BaeldungProperties {

    private String presentation;

    public String getPresentation() {
        return presentation;
    }

    public void setPresentation(String presentation) {
        this.presentation = presentation;
    }
}
```


```java
@Autowired
private BaeldungProperties baeldungProperties;
```
해당 객체를 주입받아

```java
baeldungProperties.getPresentation()
```
프로퍼티를 얻을 수 있다.