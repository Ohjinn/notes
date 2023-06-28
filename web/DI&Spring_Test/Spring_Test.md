- [`@Autowired`](#autowired)
- [TestRestTemplate](#testresttemplate)
- [MockMvc](#mockmvc)
- [`@SpyBean`](#spybean)
- [MockBean](#mockbean)
- [`@WebMvcTest`](#webmvctest)


# `@Autowired`
빈의 필드주입을 위한 어노테이션. 어플리케이션 작성 시에는 생성자주입을 추천한다.
 

# TestRestTemplate
테스트를 위해 실제와 똑같이 포트까지 지정해서 서버를 띄운다

# MockMvc
MockMvc로 HTTP통신을 흉내낼 수 있다.

```java
@SpringBootTest
@AutoConfigureMockMvc
class PostControllerTest {
    @Autowired
    private MockMvc mockMvc;

    @Autowired
    private PostRepository postRepository;

    @Test
    void list() throws Exception {
        mockMvc.perform(get("/posts"))
                .andExpect(status().isOk())
                .andExpect(content().string(
                        containsString("제목")
                ));
    }
}
```
이런식으로 MockMvc를 이용해 실제로 호출할 수도 있지만 이렇게 테스트를 하면 수 많은 가정들이 생긴다. 데이터를 넣고 빼고 어쩌구 저쩌구 하느라고..  

이때 SpyBean을 이용하면 그냥 해당 메서드가 불렸는지만 체크할 수 있다.

# `@SpyBean`

```java
@SpringBootTest
@AutoConfigureMockMvc
class PostControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @SpyBean
    private PostRepository postRepository;

    @Test
    void create() throws Exception {
        String json = """
                {
                  "title": "새 글",
                  "content": "ㅈㄱㄴ"
                }
                """;


        mockMvc.perform(post("/posts")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(json)
                )
                .andExpect(status().isCreated());

        verify(postRepository).save(any());

    }
```
이런식으로 verify를 통해 save()가 불렸는지 알 수 있다.


# MockBean
위의 것들이 IoC 컨테이너를 모두 띄워서 객체를 할당받았다면 MockBean은 그냥 다 가짜다.
@SpringBootTest가 모든 빈들을 IoC 컨테이너에 넣어준다면 @WebMvcTest는 Mock은 제공하지만 그 외의 것들을 제공하지는 않는다.

# `@WebMvcTest`
Spring MVC 컴포넌트에만 초점을 맞춘 테스트로 해당 어노테이션을 사용하면 auto-configuration이 비활성화되고 MVC 테스트와 관련된 구성만 적용된다.
@Component, @Service or @Repository beans을 제외한 
@Controller, @ControllerAdvice, @JsonComponent, Converter/GenericConverter, Filter, WebMvcConfigurer and HandlerMethodArgumentResolver에만 적용된다.

@WebMVCTest 주석을 단 테스트는 Spring Security와 MockMvc도 auto-configurate한다.

전체 애플리케이션 구성을 로드하고 MockMVC를 사용하려는 경우 이 어노테이션 보다는 @SpringBootTest를 @AutoConfigureMockMvc와 결합하는 것을 고려해보자.


출처:  
[javadoc](https://docs.spring.io/spring-boot/docs/current/api/org/springframework/boot/test/autoconfigure/web/servlet/WebMvcTest.html)
