- [Jackson ObjectMapper란](#jackson-objectmapper란)
- [@JsonProperty](#jsonproperty)


# Jackson ObjectMapper란
자바용 JSON 라이브러리로 주로 쓰이지만 xml, yaml, csv 등의 다양한 데이터 직렬화를 제공하는 툴

자바 어플리케이션에서 단일로 사용한다면 객체를 생성해서 사용하면 되고
```java
public class Car {
    private String color;
    private String type;
    // standard getters setters
}

public static void main() {
    ObjectMapper objectMapper = new ObjectMapper();
    Car car = new Car("yellow", "renault");
    objectMapper.writeValue(new File("target/car.json"), car);
}
```

스프링을 사용한다면 스프링 웹에 기본으로 포함되어 있어서

```java
public class PostController {
	private final ObjectMapper objectMapper;
	
	public PostController(ObjectMapper objectMapper) {
		this.objectMapper = objectMapper;
	}
}

@GetMapping("/{id}")
public String detail(@PathVariable String id) throws JacksonException {
    PostDto postDto = new PostDto(id, "제목", "내용");
    
    return objectMapper.writeValueAsString(postDto);
}
```
의존성 주입으로 바로 사용할 수 있다. 물론 이렇게 사용해서 JSON을 변환할 수도 있지만 컨트롤러에 쓰는 어노테이션을 다시보면

```java
@CrossOrigin
@RestController
@RequestMapping("posts")
```
이 세가지 중 @RestController에는 

```java
@Target(ElementType.TYPE)
@Retention(RetentionPolicy.RUNTIME)
@Documented
@Controller
@ResponseBody
```

@ResponseBody가 존재하는데 이 어노테이션은 컨트롤러에게 객체가 자동으로 JSON으로 변환되어 돌아가도록 명령한다.

물론 
```java
@PostMapping(value = "/content", produces = MediaType.APPLICATION_XML_VALUE)
```
위와 같이 리턴 타입을 지정할 수도 있다.

# @JsonProperty
자바 객체를 직렬화할 때 이름을 지정해주기 위한 어노테이션으로 기본적으로 직렬화된 JSON 객체는
get메서드의 이름을 따르는데

```java
public class PostDto {
    private String id;
    private String title;
    private String content;

    public PostDto() {
    }

    public PostDto(String id, String title, String content) {
        this.id = id;
        this.title = title;
        this.content = content;
    }

    public String getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String gethelloContent() {
        return content;
    }
}

```
실제로 DTO를 위와 같이 만들고 요청을 보내면
```json
demo-rest-api % curl -X POST localhost:8080/posts -d '{"title": "제목"}' -H 'Content-Type: application/json'
{"id":null,"title":"제목","helloContent":null}%     
```

get에 맞춘 다음과 같은 응답이 오게 된다. 이걸 명시하려면
```java
private String id;
private String title;
@JsonProperty("modifiedHelloContent")
private String content;
```
필드에 @JsonProperty를 적어주면 된다.

그럼 응답이 이렇게 온다.

```json
demo-rest-api % curl -X POST localhost:8080/posts -d '{"title": "제목"}' -H 'Content-Type: application/json'
{"id":null,"title":"제목","modifiedHelloContent":null}%   
```

출처  
[baeldung](https://www.baeldung.com/jackson-object-mapper-tutorial)