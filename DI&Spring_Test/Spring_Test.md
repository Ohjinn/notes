- [`@Autowired`](#autowired)
- [TestRestTemplate](#testresttemplate)
- [MockMvc](#mockmvc)
- [`@SpyBean`](#spybean)
- [MockBean](#mockbean)
- [`@WebMvcTest`](#webmvctest)


# `@Autowired`
빈의 필드주입을 위한 어노테이션. 어플리케이션 작성 시에는 생성자주입을 추천하지만 여기선 필드주입을 한다.
 

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
