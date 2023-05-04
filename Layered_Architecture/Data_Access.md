- [DAO](#dao)
- [Collection Framework](#collection-framework)
  - [List](#list)
    - [ArrayList](#arraylist)
      - [생성자](#생성자)
      - [메서드](#메서드)
    - [Stack](#stack)
      - [생성자](#생성자-1)
  - [Set](#set)
    - [HashSet](#hashset)
      - [생성자](#생성자-2)
      - [메서드](#메서드-1)
  - [Queue](#queue)
    - [생성자](#생성자-3)
    - [메서드](#메서드-2)
  - [Map](#map)

# DAO
Data Access Object pattern은 비즈니스(어플리케이션)레이어와 영속성(persistence)레이어를 추상적 API를 이용해 분리하는 패턴을 의미한다. 이렇게 만들면 DB 벤더나 persistence 어플리케이션은 변경해도 DAO만 변경하면 대응 가능해서 유연성이 올라간다.

# Collection Framework
자바의 Collection에 대해 알아보자
![컬렉션 트리](https://data-flair.training/blogs/wp-content/uploads/sites/2/2018/03/hierarchy-of-collection-framework-in-java.webp)

Collection 인터페이스의 명세는

```java
public interface Collection<E> Extends Iterable<E>
```

로 Iterable<E> 인터페이스를 확장하고 있다. Iterable 인터페이스의 메서드는

| 리턴 타입           |    메소드 이름 및 매개변수                 |
| ----------------- | ------------------------------------ |
| Iterator<T>   | iterator() |

iterator() 하나로 Iterator 인터페이스를 이용해 데이터를 순차적으로 가져올 수 있다.

Collection 인터페이스의 메소드 목록은 다음과 같다.

| 리턴 타입           |    메소드 이름 및 매개변수     |  설명  |
| ----------------- | ------------------------ | ----- |
| boolean | add(E e) | 요소를 추가 |
| boolean | addAll(Collection) | 매개변수로 넘어온 컬렉션의 모든 요소를 추가 |
| void | clear | 컬렉션에 있는 모든 요소 데이터를 지운다. |
| boolean | contains(Object) | 매개 변수로 넘어온 객체가 해당 컬렉션에 있는지 확인 |
| boolean | containsAll(Collection) | 매개변수의 객체들이 해당 컬렉션에 모두 있는지 확인 |
| boolean | equals(Object) | 매개 변수로 넘어온 객체와 같은 객체인지 확인 |
| boolean | isEmpty() | 컬렉션이 비어있는지 확인 |
| Iterator | iterator() | 데이터를 한 건씩 처리하기 위한 Iterator 객체를 리턴 |
| boolean | remove(Object) | 매개변수와 동일한 객체를 삭제 |
| boolean | removeAll(Collection) | 매개변수로 넘어온 객체들을 해당 컬렉션에서 삭제 |
| boolean | retainAll(Collection) | 매개변수로 넘어온 객체들만 컬렉션에 남겨둔다 |
| int | size() | 요소의 개수를 리턴 |
| Object[] | toArray() | 컬렉션에 있는 데이터들을 배열로 복사 |
| <T> T[] | toArray() | 컬렉션에 있는 데이터들을 지정한 타입의 배열로 복사 |

----
## List

List에서 많이 쓰이는 클래스들은 java.util 패키지의 ArrayList, Vector, Stack, LinkedList 등이 있다.  
ArrayList는 Thread safe 하지 않고 Vector는 Thread safe하다 Stack은 Vector를 extends해서 만들어졌고 LIFO다.

### ArrayList
ArrayList는
```
java.lang.Object
    java.util.AbstractCollection<E>
        java.util.AbstractList<E>
            java.util.ArrayList<E>
```

AbstractCollection은 Collection의 공통 메서드
AbstractList는 List의 공통 메서드들을 구현해 놓은 것이다.

```java
public class ArrayList<E> extends AbstractList<E> implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```

|  인터페이스  |  용도  |
| --------- | ------- |
| Serializable | 직렬화 가능 |
| Cloneable | Object 클래스의 clone() 메서드가 제대로 수행될 수 있음을 지정 |
| Iterable<E> | 객체가 foreach를 사용할 수 있음을 지정 |
| Collection<E> | 여러 개의 객체를 하나의 객체에 담아서 처리할 때의 메소드 지정 |
| List<E> | 목록형 데이터를 처리하는 것과 관련된 메서드 지정 |
| RandomAccess | 목록형 데이터에 보다 빠르게 접근할 수 있도록 임의로 접근하는 알고리즘이 적용된다는 것을 지정 |

#### 생성자

ArrayList의 생성자는 3가지 종류가 있다.

|  생성자  |  설명  |
| --------- | ------- |
| ArrayList() | 객체를 저장할 공간이 10개인 ArrayList를 만든다 |
| ArrayList(Collection<? extends E> c) | 매개변수로 넘어온 컬렉션 객체가 저장되어 있는 ArrayList를 만든다 |
| ArrayList(int initialCapacity) | 매개변수로 넘어온 initialCapacity 개수만큼의 저장공간을 갖는 ArrayList를 만든다 |

위에 써져 있듯 ArrayList는 초기 크기가 10이기 때문에 10개 이상 데이터가 들어간다면 초기 크기를 지정하는게 낫다.

#### 메서드

|  리턴 타입  |  메서드 이름 및 매개변수 |  설명  |
| --------- | ------- | -------|
| boolean | add(E e) | 매개변수로 넘어온 데이터를 가장 끝에 담는다 |
| void | add(int index, E e) | 매개변수로 넘어온 데이터를 지정된 index에 담는다 |
| boolean | addAll(Collection<? extends E> c) | 매개변수로 넘어온 컬렉션 데이터를 가장 끝에 담는다 |
| boolean | addAll(int index, Collection<? extends E> c) | 매개변수로 넘어온 컬렉션 데이터를 index에 지정된 위치부터 담는다 |
| int | size() | ArrayList 객체에 들어있는 데이터의 개수를 리턴 |
| E | get(int index) | 매개변수에 지정한 위치에 있는 데이터를 리턴 |
| int | indexOf(Object o) | 매개변수로 넘어온 객체와 동일한 데이터의 위치를 리턴 |
| int | lastIndexOf(Object o) | 매개변수로 넘어온 객체와 동일한 마지막 데이터의 위치를 리턴 |
| object[] | toArray() | ArrayList 객체에 있는 값들을 Object[] 타입의 배열로 만든다 |
| <T> T[] | toArray(T[] a) | ArrayList 객체에 있는 값들을 매개변수로 넘어온 T 타입의 배열로 만든다 |

마지만 toArray 두 개의 차이는 첫번째는 Object 타입의 배열로만 리턴해서 제네릭을 이용한 ArrayList 객체를 배열로 생성할 때는 좋지 않다.

toArray를 사용할 때 주의할 점은
```java
public static void main(String[] args) {

    ArrayList<String> list = new ArrayList<>();
    list.add("A");
    list.add("B");
    list.add("C");
    // String[] strList = list.toArray(new String[5]);
    String[] strList = list.toArray(new String[0]);
    for(String temp: strList) {
        System.out.println(temp);
    }
}
```
다음과 같이 타입을 정해줄 때 배열의 갯수를 정해주지 않고 길이를 0으로 지정해주는 게 낫다. 만약 초기 length를 5로 지정해준다면 나머지 두 칸은 null이, Collection의 size가 더 클 경우 모두 null이 들어가게 된다.

|  리턴 타입  |  메서드 이름 및 매개변수 |  설명  |
| --------- | ------- | -------|
| void | clear() | 모든 데이터를 삭제한다 |
| E | remove(int index) | 매개변수에서 지정한 위치에 있는 데이터를 삭제하고 삭제한 데이터를 리턴 |
| boolean | remove(Object o) | 매개변수로 넘어온 객체와 동일한 첫 번째 데이터를 삭제한다 |
| boolean | removeAll(Collection<?> c) | 매개변수로 넘어온 컬렉션 객체에 있는 데이터와 동일한 `모든` 데이터를 삭제한다 |
| E | set(int index, E element) | 지정한 위치에 있는 데이터를 두 번째 매개변수로 넘간 값으로 변경하고 그 위치의 데이터를 리턴한다 |

### Stack
Stack은 Thread에 안전한 LIFO고 ArrayDeque는 Thread에 안전하지 않은 stack이다

```
java.lang.Object
    java.util.AbstractCollection<E>
        java.util.Vector<E>
            java.util.Stack<E>
```
Stack은 Vector 클래스의 자식 클래스로 상속을 잘못 받은 케이스다.

```java
public class Vector<E>
    extends AbstractList<E>
    implements List<E>, RandomAccess, Cloneable, java.io.Serializable
```
벡터는 다음과 같은 인터페이스들은 Implement하고 있다. ArrayList와 동일하다.

#### 생성자

|  생성자  |  설명  |
| --------- | ------- |
| Stack() | 아무 데이터도 없는 Stack 객체를 만든다 |

|  리턴 타입  |  메서드 이름 및 매개변수 |  설명  |
| --------- | ------- | -------|
| boolean | empty() | 객체가 비어있는지 확인 |
| E | peek() | 객체의 가장 위에 있는 데이터를 리턴 |
| E | pop() | 객체의 가장 위에 있는 데이터를 지우고 리턴 |
| E | push(E item) | 매개변수로 넘어온 데이터를 가장 위에 저장 |
| int | search(Object o) | 매개변수로 넘어온 데이터의 위치를 리턴 |

----

## Set
Set은 값의 중복이 없는 순서없는 Collection이다. Set에는 3가지 주요 클래스가 존재하는데  
HashSet: 순서가 필요 없는 데이터를 해시 테이블제 저장하며 Set 중 성능이 가장 좋다
TreeSet: 저장된 데이터의 값에 따라 정렬되는 셋으로 RB트리로 저장된다. Set보다는 살짝 느리다
LinkedHashSet: 연결된 목록 타입으로 구현해서 해시 테이블제 저장되며 저장된 순서에 따라 값이 정렬된다.

### HashSet
```
java.lang.Object
    java.util.AbstractCollection<E>
        java.util.AbstractSet<E>
            java.util.HashSet<E>
```
상속관계는 다음과 같고

```java
public class HashSet<E>
    extends AbstractSet<E>
    implements Set<E>, Cloneable, java.io.Serializable
```

implements들은 위와 같다. 다른것은 Set<E> 하나밖에 없는데 Set은 순서가 없기 때문에 List와 다르게 get(int index), indexOf(Object o) 같은 메서드들이 존재하지 않는다.


#### 생성자

|  생성자  |  설명  |
| --------- | ------- |
| HashSet() | 데이터를 저장할 수 있는 16개의 공강과 0.75의 로드펙터를 갖는 객체를 생성한다 |
| HashSet(Collection<? extends E> c) | 매개변수로 받은 컬렉션 객체의 데이터를 HashSet 공간에 담는다 |
| HashSet(int initialCapacity) | 매개변수로 받은 개수만큼의 데이터 저장공간과 0.75의 로드팩터를 갖는 객체를 생성한다 |
| HashSet(int initialCapacity, float loadFactor) | 첫 매개변수로 받은 개수만큼의 데이터 저장공간과 두 번째 매개변수로 받은 만큼의 로드팰터를 갖는 객체를 생성한다 |

로드팩터란 `데이터의 개수/저장공간`을 의미하는데 만약 개수가 증가해 로드팩터보다 커지면 저장공간의 크기가 커지고 재정리 작업을 해야한다. 데이터가 해시 정리를 시작하면 내부의 자료구조를 다시 생성해야 하므로 성능에 영향이 발생한다 대용량 시스템이 아니라면 굳이 건들 필요는 없다.

#### 메서드

|  리턴 타입  |  메서드 이름 및 매개변수 |  설명  |
| --------- | ------- | ------- |
| boolean | add(E e) | 데이터를 추가한다 |
| void | clear() | 모든 데이터를 삭제한다 |
| Object | clone() | HashSet 객체를 복제한다 데이터는 복제하지 않는다 |
| boolean | contains(Object o) | 지정한 객체가 존재하는지 확인한다 |
| boolean | isEmpty() | 데이터가 있는지 확인한다 |
| Iterator<E> | iterator() | 데이터를 꺼내기 위한 Iterator 객체를 리턴한다 |
| boolean | remove(Object o) | 매개변수로 넘어온 객체를 삭제한다 |
| int | size() | 데이터의 개수를 리턴한다 |

## Queue
Queue는 FIFO로

```java
public class LinkedList<E>
    extends AbstractSequentialList<E>
    implements List<E>, Deque<E>, Cloneable, java.io.Serializable
```
List, Deque, Queue를 모두 상속한다

```
java.lang.Object
    java.util.AbstractCollection<E>
        java.util.AbstractList<E>
            java.util.AbstractSequentialList<E>
                java.util.LinkedList<E>
```

AbstractSequentialList는 add(), set(), remove() 등의 메서드에 대한 구현 내용이 상이하다.

### 생성자

|  생성자  |  설명  |
| --------- | ------- |
| LinkedList() | 비어있는 LinkedList 객체를 생성한다 |
| LinkedList(Collection<? extends E> c) | 매개변수로 받은 컬렉션 객체를 데이터를 LinkedList에 담는다 |

### 메서드

|  리턴 타입  |  메서드 이름 및 매개변수 |  설명  |
| --------- | ------- | ------- |
| void | addFirst(Object) <td rowspan="3"> LinkedList 객체의 가장 앞에 데이터를 추가한다 </td>
| boolean | offerFirst(Object) |
| void | push(Object) |  |
| boolean | add(Object)<td rowspan="4"> LinkedList 객체의 가장 앞에 데이터를 추가한다 </td>
| void | addLast(Object) |  |
| boolean | offer(Object) |  |
| boolean | offerLast(Object) |  |
| void | add(int, Object) | LinkedList 객체의 가장 뒤에 데이터를 추가한다 |
| Object | set(int, Object) | LinkedList 객체의 특정 위치에 있는 데이터를 수정한다. 그리고, 기존에 있던 데이터를 리턴한다 |
| boolean | addAll(Collection) | 매개변수로 넘긴 컬렉션의 데이터를 추가한다 |
| boolean | addAll(int, Collection) | 매개변수로 넘긴 컬렉션의 데이터를 지정한 위치에 추가한다 |

## Map

작업중..

출처:  
[오라클](https://docs.oracle.com/javase/8/docs/api/)  
자바의신