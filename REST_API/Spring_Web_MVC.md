- [@RequestMapping](#requestmapping)
  - [@GetMapping, @PostMapping, @PatchMapping, @DeleteMapping](#getmapping-postmapping-patchmapping-deletemapping)
  - [@PathVariable](#pathvariable)
- [@RequestBody](#requestbody)
- [@ExceptionHandler](#exceptionhandler)
- [@ResponseStatus](#responsestatus)

---

# @RequestMapping
web requests를 메서드에 매핑하기 위한 시그니쳐로 클래스와 메서드 레벨 모두에서 사용될 수 있다.  

## @GetMapping, @PostMapping, @PatchMapping, @DeleteMapping
@RequestMapping(method=requestMethod.GET, POST, PATCH, DELETE)의 줄임으로 특정 핸들러 메서드의 GET 요청을 매핑한다.

## @PathVariable
URI 템플릿 변수와 연동되는 어노테이션으로 
```java
@GetMapping("/api/employees/{id}")
@ResponseBody
public String getEmployeesById(@PathVariable String id){
  return "ID: " + id;
}
```
다음과 같이 사용할 수 있다.

# @RequestBody
매서드 파라미터가 웹 리퀘스트의 바디에 매핑되어야 함을 알려주는 어노테이션으로 request body는 HttpMessageConverter를 통해 변환된다. @Valid 어노테이션을 통해 변수들이 validate될 수 있다.

```java
@PostMapping("/request")
public ResponseEntity postController(
  @RequestBody LoginForm loginForm) {
 
    exampleService.fakeAuthenticate(loginForm);
    return ResponseEntity.ok(HttpStatus.OK);
}
```

# @ExceptionHandler
특정 핸들러 클래스나 메서드에 대한 예외를 처리하기 위한 어노테이션으로 해당 예외 클래스를 명시해주면 된다.

# @ResponseStatus
메서드나 예외 클래스를 상태 code()와 reason()으로 마크한다.
예외 클래스에서 사용할 때나 reason 항목을 세팅할 때 HttpServletResponse.sendError 메서드가 사용된다.



출처  
[스프링독](https://docs.spring.io/spring-framework/docs/current/javadoc-api/org/springframework/web/bind/annotation/PathVariable.html)
[Baeldung](https://www.baeldung.com/spring-request-response-body)