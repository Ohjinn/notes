- [Spring AOP(Aspect Oriented Programming)](#spring-aopaspect-oriented-programming)
  - [Factory](#factory)
  - [Plugin](#plugin)
- [싱글턴 패턴](#싱글턴-패턴)
- [IoC(Inversion of Control), DI(Dependency Injection)](#iocinversion-of-control-didependency-injection)
- [Spring Bean](#spring-bean)
- [BeanFactory](#beanfactory)


# Spring AOP(Aspect Oriented Programming)
IoC/DI, 서비스 추상화와 더불어 스프링의 3대 기반기술의 하나로 애플리케이션 코드에 산재해서 나타나는 부가적인 기능을 독립적으로 모듈화하는 프로그래밍 모델이다. 


## Factory
객체지향 프로그래밍에서 팩토리는 다른 객체를 만드는 객체로 형식적으로 다양한 프로토타입이나 클래스의 객체를 반환하는 함수 혹은 메서드다.
객체를 직접 만들지 않고, 객체의 생성하는 책임만 가진 객체를 만들어 쓴다.

디자인 패턴에는 팩토리 패턴이 없지만 팩토리를 사용하는 두 가지 패턴(팩토리 메서드 패턴, 추상 팩토리 패턴) 등이 있다.

## Plugin
분산된 인터페이스는 애플리케이션 코드가 여러 런타임 환경에서 실행되고 각각 동작에 대해 서로 다른 구현이 필요한 경우에 자주 사용되는데, 대부분의 개발자는 팩토리메서드를 작성해 올바른 구현을 제공한다. 하지만, 팩토리가 추가될수록 여러 조건문을 편집, 빌드, 배포해야한다. 플러그인은 중앙 집중형 런타임 구성을 제공해 위 문제를 해결한다.

# 싱글턴 패턴
생성자가 여러 차례 호출되더라도 실제로 생성되는 객체는 하나이고 생성된 후 호출된 생성자는 최초의 생성자가 생성한 객체를 리턴하는 것으로 자바로 구현하면 다음과 같다.

```java
public class Coin {

    private static final int ADD_MORE_COIN = 10;
    private int coin;
    private static Coin instance = new Coin(); // eagerly loads the singleton

    private Coin() {
        // private to prevent anyone else from instantiating
    }

    public static Coin getInstance() {
        return instance;
    }

    public int getCoin() {
        return coin;
    }

    public void addMoreCoin() {
        coin += ADD_MORE_COIN;
    }

    public void deductCoin() {
        coin--;
    }
}

public class Singleton {

    private static final Singleton INSTANCE = new Singleton();

    private Singleton() {}

    public static Singleton getInstance() {
        return INSTANCE;
    }
}
```

# IoC(Inversion of Control), DI(Dependency Injection)
IoC는 제어의 역전이라는 용어로 프레임워크와 라이브러리를 나누는 기준이 되기도 한다. 프레임워크는 애플리케이션 코드가 프레임워크에 의해 사용되는 제어의 역전이 일어나는 반면 라이브러리를 사용하는 애플리케이션 코드는 애플리케이션의 흐름을 직접 제어한다.


# Spring Bean
DI를 진행할 때 주입하는 것이 Bean으로 스프링에서는 Spring IoC 컨테이너에 의해 관리되는 중추적인 객체를 Bean이라고 한다.

# BeanFactory
org.springframework.beans, org.springframework.context 패키지는 스프링 IoC 컨테이너의 기초로 BeanFactory 인터페이스는 모든 유형의 객체를 관리할 수 있는 고급 구성 매커니즘을 제공한다. ApplicationContext는 BeanFactory의 하위 구성으로 BeanFactory가 프레임워크 설정과 기본적 기능을 제공한다면 ApplicationContext는 BeanFactory의 확장판이다.

