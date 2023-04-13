- [Spring](#spring)
- [Spring Boot](#spring-boot)
- [Web Server와 Web Application Server(WAS)](#web-server와-web-application-serverwas)
  - [Web Server](#web-server)
  - [WAS(Web Application Server)](#wasweb-application-server)
- [Model-View-Controller(MVC) 아키텍처 패턴](#model-view-controllermvc-아키텍처-패턴)
- [관심사의 분리(Seperation of Concern)](#관심사의-분리seperation-of-concern)
- [Spring MVC](#spring-mvc)
- [Java Annotation](#java-annotation)
  - [@Override](#override)
  - [@Deprecated](#deprecated)
  - [@SupressWarning](#supresswarning)
  - [@SafeVarargs](#safevarargs)
  - [@FunctionalInterface](#functionalinterface)
  - [@Target](#target)
  - [@Retention](#retention)
  - [@Documented](#documented)
  - [@Inherited](#inherited)
  - [@interface](#interface)
  - [@Repeatable](#repeatable)
  - [@Native](#native)
- [Spring Annotation](#spring-annotation)
  - [@RestController](#restcontroller)
    - [@Controller](#controller)
    - [@ResponseBody](#responsebody)
  - [@GetMapping](#getmapping)
    - [@RequestMapping](#requestmapping)


# Spring

묘듈화된 프레임워크로 그 중심에는 core container와 configuration 모델, DI 매커니즘이 존재한다  
또한, 다양한 아키텍쳐와 메시징, 데이터 전송, 영속, 서블릿 기반의 Spring MVC, Spring Webflux등을 지원한다.


# Spring Boot

다양한 모듈로 구성된 Spring Framework를 쉽게 구성하고 시작할 수 있게 만들어 주기 위한 퀵 스타터다.

Spring Boot의 주요 목적은
1. Spring 개발에 빠르고 광범위하게 접근 가능한 시작 경험을 준다
2. 기본값과 다른 요구 사항이 발생할때 신속하게 대처할 수 있게 해준다
3. 임베디드 서버, 보안, 계량적 분석, 상태검사, 외부화된 구성 등 대규모 프로젝트에 공통적으로 사용되는 다양한 비기능적 기능 제공한다
4. 코드를 통한 생성이 필요 없고 XML을 제거한다

# Web Server와 Web Application Server(WAS)

## Web Server
- HTTP를 기반으로 동작
- 정적 리소스 제공, 기타 부가기능
- 정적 HTML, CSS, JS, 이미지, 영상
- NGINX, APACHE 등

## WAS(Web Application Server)
- HTTP를 기반으로 동작
- 웹 서버 기능 포함
- 프로그램 코드를 실행해서 애플리케이션 로직 수행
  - 동적 HTML, HTTP API(JSON)
  - 서블릿, JSP, 스프링 MVC
- 톰캣(Tomcat), Jetty, Undertow

자바는 서블릿 컨테이너 기능을 제공하면 WAS라고 한다.

# Model-View-Controller(MVC) 아키텍처 패턴

![util function](https://martinfowler.com/eaaCatalog/mvc-sketch.gif)


Model: 뷰에 출력할 데이터를 담아두는 것으로 뷰는 비즈니스 로직이나 데이터와 상관없이 화면 렌더링에 집중할 수 있다.
View: 모델에 담겨있는 데이터를 사용해 화면에 그린다.
Controller: HTTP 요청을 받아서 파라미터를 검증하고 비즈니스 로직을 실행한다. 그리고 데이터를 전달해 모델에 담는다.

최근에는 복잡한 걸 잘 다룰 수 있는 더 커다란 아키텍쳐가 필요하다는 걸 알게 되므로써 WebFlux에서는 Controller 대신 hander라는 명칭을, Hexagonal Architecture에서는 그냥 Adapter중 하나가 된다.

# 관심사의 분리(Seperation of Concern)

컴퓨터 프로그램을 구별된 부분으로 분리시키는 디자이 원칙으로 각 부분이 개개의 관심사를 해결한다.  
SoC를 구현하는 프로그램은 모듈러 프로그램이라고 한다.  
관심사의 분리를 사용하면 코드의 단순화, 휴지보수에서 더 높은 수준의 자유도를 가져다 준다.

# Spring MVC
공통적으로 요청을 핸들러로 보내는 DispatcherServlet을 중심으로 다양한 RESTful한 웹 사이트 및 애플리케이션을 생성할 수 있게 도와주는 프레임워크  


# Java Annotation

클래스나 메소드등의 선언시 @를 사용하는 것으로 Annotation, 메타데이터 라고도 불리기도 한다. 자바5 이후에 등장했으며
- 컴파일러에게 정보를 주거나
- 컴파일 시와 설치시 작업을 지정하거나
- 실행할 때 별도의 처리가 필요할 때  


사용된다.
어노테이션 관련 클래스들은 java.lang.annotation 패키지에 선언되어 있다.

자바 언어에는 우선은 사용을 위한 어노테이션과 어노테이션 선언을 위한 메타 어노테이션이 있는데 버전을 거듭할수록 늘어나고 있다.

- @Override
- @Deprecated
- @SupressWarning
- @SafeVarargs
- @FunctionalInterface
  
<hr>

## @Override
해당 메소드가 부모 클래스에 있는 메소드를 Override 했다는 것을 명시적으로 선언한다.
매개 변수 등의 실수가 있을 때 컴파일러가 알려주게 시키는 역할을 한다.
    
코드로 함 보자

```java
public class Parent {
    public Parent() {
        System.out.println("Parent Constructor");
    }

    public Parent(String name) {
        System.out.println("Parent(String) constructor");
    }

    public void printName() {
        System.out.println("printName() - Parent");
    }
}
```

다음과 같은 Parent 클래스가 있고

```java
public class ParentOverride extends Parent{
    @Override
    public void printName() {
        System.out.println("printName() - Override");
    }
}
```

다음과 같이 Parent를 Override 한 클래스가 있다면 만약 메소드가 여러가지라면 @Override 어노테이션이 없다면 어떤 것을 Override 했는지 확인이 힘들 것이다.

실제로 @Override를 붙인 채 부모 클래스에 없는 메소드를 만들어서 컴파일 해보면  
`java: method does not override or implement a method from a supertype`

위와 같은 에러가 뜬다. 이처럼 @Override는 제대로 Override 했는지 확인하는 수단으로 쓴다.

<hr>

## @Deprecated
이미 만들어져 있는 클래스나 메소드가 더 이상 사용되지 않는 경우 deprecated라고 한다.

```java
public class AnnotationSample {

    public void useDeprecated() {
        DeprecatedAnnotation deprecatedAnnotation = new DeprecatedAnnotation();
        deprecatedAnnotation.noMoreUser();
    }
}
class DeprecatedAnnotation {
    @Deprecated
    public void noMoreUser() {
    }
}

tation\forUse> javac AnnotationSample.java
Note: AnnotationSample.java uses or overrides a deprecated API.
Note: Recompile with -Xlint:deprecation for details.

```
위와 같이 @Deprecated된 메소드를 사용하려고 하면 컴파일시 -Xlint:deprecation이라는 옵션을 추가하라는 문구가 뜬다.

```java
tation\forUse> javac -Xlint:deprecation AnnotationSample.java
AnnotationSample.java:7: warning: [deprecation] noMoreUser() in DeprecatedAnnotation has been deprecated
        deprecatedAnnotation.noMoreUser();
                            ^
1 warning

```
해당 옵션을 추가해서 컴파일 하면 이제 에러는 안뜨고 warning만 뜨게 된다.

참조가 많은 메소드가 있다면 @Deprecated를 사용해 계도 기간을 거쳐 알림을 준 후에 메소드를 지우면 된다.
<hr>

## @SupressWarning
컴파일러에서 경고를 알리는 경우가 종종 있는데 그럴 때 해당 warning을 잠재우는 역할을 한다.

```java
public class AnnotationSample {

    @SuppressWarnings("deprecation")
    public void useDeprecated() {
        DeprecatedAnnotation deprecatedAnnotation = new DeprecatedAnnotation();
        deprecatedAnnotation.noMoreUser();
    }
}
class DeprecatedAnnotation {
    @Deprecated
    public void noMoreUser() {
    }
}

tation\forUse> javac -Xlint:deprecation AnnotationSample.java

```
위의 코드에서 warning이 떴던 것을 @SupressWarnings 어노테이션을 통해 억제해 줄 수 있다.

하지만 SupressWarning은 남용하면 @Deprecated나 다른 컴파일 warning 의미가 퇴색될 수 있다.

<hr>

## @SafeVarargs
자바 7 이상에서 제네릭 같은 가변인자 매개변수 사용시 나오는 경고를 무시한다.

<hr>

## @FunctionalInterface
자바 8 이상에서 사용 가능하고 함수형 인터페이스라는 것을 알려주는 어노테이션이다.

<hr>

이제 메타 어노테이션에 대해 알아보자.

- @Target
- @Retention
- @Documented
- @Inherited
- @Repeatable
- @Native


## @Target
어노테이션을 어떤 것에 적용할지 선언할 때 사용한다.
```java
@Target(Element.METHOD)
```
대상 목록은 다음과 같다.

| 요소 타입 | 대상 |
| --- | --- |
| CONSTRUCTOR | 생성자 선언시 |
| FIELD | enum 상수를 포함한 필드값 선언시 |
| LOCAL_VARIABLE | 지역 변수 선언시 |
| METHOD | 메소드 선언시 |
| PARAMETER | 매개 변수 선언시 |
| TYPE | 클래스, 인터페이스, enum등 선언시 |

이 외에도 여러가지 존재한다

<hr>

## @Retention
얼마나 오래 어노테이션 정보가 유지되는지를 다음과 같이 선언한다.

```java
@Retention(RetentionPolicy.RUNTIME)
```

적용 가능한 대상은 다음과 같다.

| 요소 타입 | 대상 |
| --- | --- |
| SOURCE | 어노테이션 정보가 컴파일시 사라짐 |
| CLASS | 클래스 파일에 있는 어노테이션 정보가 컴파일러에 의해 참조 가능, JVM에서는 사라짐 |
| RUNTIME | 실행시 어노테이션 정보가 가상머신에 의해 참조 가능 |

<hr>

## @Documented
해당 어노테이션 정보가 Javadocs(API) 문서에 포함된다는 것을 선언

<hr>

## @Inherited
모든 자식 클래스에서 부모 클래스의 어노테이션을 사용 가능하다는 것을 선언

<hr>

## @interface
어노테이션을 선언할 때 사용한다.

<hr>

## @Repeatable
보통 하나의 대상에 한 종류의 어노테이션을 붙이게 되는데 @Repeatable이 붙은 어노테이션은 여러 번 붙일 수 있다.

<hr>

## @Native
JVM이 설치된 OS에 의해 참조되는 상수필드에 붙이는 어노테이션이다.


# Spring Annotation

## @RestController
Controller와 ResponseBody의 조합으로 만들어진 어노테이션으로 이 어노테이션이 있으면 컨트롤러로 취급된다.

### @Controller
주로 View를 반환하기 위해 사용한다. @Component 어노테이션을 가지고 있기 때문에 autodetect의 대상이 되며 어떤 요청을 받을지에 대한 @RequestMapping을 함께 많이 사용한다.

### @ResponseBody
web response body에 객체가 바인딩 되어야 함을 나타낸다. 통짜 웹페이지가 아닌 Json등의 바디를 반환한다.

## @GetMapping
RequestMapping(method = RequestMethod.GET)에 상응하는 역할을 하며 HTTP GET request를 받음을 명시한다.

### @RequestMapping
다양한 메서드 시그니쳐를 매핑하기 위한 어노테이션이다.

출처:  

https://docs.spring.io/spring-boot/docs/current/reference/htmlsingle/
https://docs.spring.io/spring-framework/docs/3.2.x/spring-framework-reference/html/mvc.html
https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/RestController.html  
자바의 신