---
name: java-coding-standards
description: "Java coding standards for Spring Boot and Quarkus services: naming, immutability, Optional usage, streams, exceptions, generics, CDI, reactive patterns, and project layout. Automatically applies framework-specific conventions."
metadata:
  origin: ECC
  adapted_for: Hermes Agent
---

# Java Coding Standards

Standards for readable, maintainable Java (17+) code in Spring Boot and Quarkus services.

## When to Use

- Writing or reviewing Java code in Spring Boot or Quarkus projects
- Enforcing naming, immutability, or exception handling conventions
- Working with records, sealed classes, or pattern matching (Java 17+)
- Reviewing use of Optional, streams, or generics
- Structuring packages and project layout
- **[QUARKUS]**: Working with CDI scopes, Panache entities, or reactive pipelines

## How It Works

### Framework Detection

Before applying standards, determine the framework from the build file:

- Build file contains `quarkus` → apply **[QUARKUS]** conventions
- Build file contains `spring-boot` → apply **[SPRING]** conventions
- Neither detected → apply shared conventions only

## Core Principles

- Prefer clarity over cleverness
- Immutable by default; minimize shared mutable state
- Fail fast with meaningful exceptions
- Consistent naming and package structure
- **[QUARKUS]**: Favor build-time over runtime processing; avoid runtime reflection where possible

## Examples

The sections below show concrete Spring Boot, Quarkus, and shared Java examples
for naming, immutability, dependency injection, reactive code, exceptions,
project layout, logging, configuration, and tests.

## Naming

```java
// PASS: Classes/Records: PascalCase
public class MarketService {}
public record Money(BigDecimal amount, Currency currency) {}

// PASS: Methods/fields: camelCase
private final MarketRepository marketRepository;
public Market findBySlug(String slug) {}

// PASS: Constants: UPPER_SNAKE_CASE
private static final int MAX_PAGE_SIZE = 100;

// PASS: [QUARKUS] JAX-RS resources named as *Resource, not *Controller
public class MarketResource {}

// PASS: [SPRING] REST controllers named as *Controller
public class MarketController {}
```

## Immutability

```java
// PASS: Favor records and final fields
public record MarketDto(Long id, String name, MarketStatus status) {}

public class Market {
  private final Long id;
  private final String name;
  // getters only, no setters
}

// PASS: [QUARKUS] Panache active-record entities use public fields (Quarkus convention)
@Entity
public class Market extends PanacheEntity {
  public String name;
  public MarketStatus status;
  // Panache generates accessors at build time; public fields are idiomatic here
}

// PASS: [QUARKUS] Panache MongoDB entities
@MongoEntity(collection = "markets")
public class Market extends PanacheMongoEntity {
  public String name;
  public MarketStatus status;
}
```

## Optional Usage

```java
// PASS: Return Optional from find* methods
// [SPRING]
Optional<Market> market = marketRepository.findBySlug(slug);

// [QUARKUS] Panache
Optional<Market> market = Market.find("slug", slug).firstResultOptional();

// PASS: Map/flatMap instead of get()
return market
    .map(MarketResponse::from)
    .orElseThrow(() -> new EntityNotFoundException("Market not found"));
```

## Streams Best Practices

```java
// PASS: Use streams for transformations, keep pipelines short
List<String> names = markets.stream()
    .map(Market::name)
    .filter(Objects::nonNull)
    .toList();

// FAIL: Avoid complex nested streams; prefer loops for clarity
```

## Dependency Injection

```java
// PASS: [SPRING] Constructor injection (preferred over @Autowired on fields)
@Service
public class MarketService {
  private final MarketRepository marketRepository;

  public MarketService(MarketRepository marketRepository) {
    this.marketRepository = marketRepository;
  }
}

// PASS: [QUARKUS] Constructor injection
@ApplicationScoped
public class MarketService {
  private final MarketRepository marketRepository;

  @Inject
  public MarketService(MarketRepository marketRepository) {
    this.marketRepository = marketRepository;
  }
}

// PASS: [QUARKUS] Package-private field injection (acceptable in Quarkus — avoids proxy issues)
@ApplicationScoped
public class MarketService {
  @Inject
  MarketRepository marketRepository;
}

// FAIL: [SPRING] Field injection with @Autowired
@Autowired
private MarketRepository marketRepository; // use constructor injection

// FAIL: [QUARKUS] @Singleton when interception or lazy init is needed
@Singleton // non-proxyable — use @ApplicationScoped instead
public class MarketService {}
```

## Reactive Patterns [QUARKUS]

```java
// PASS: Return Uni/Multi from reactive endpoints
@GET
@Path("/{slug}")
public Uni<Market> findBySlug(@PathParam("slug") String slug) {
  return Market.find("slug", slug)
      .<Market>firstResult()
      .onItem().ifNull().failWith(() -> new MarketNotFoundException(slug));
}

// PASS: Non-blocking pipeline composition
public Uni<OrderConfirmation> placeOrder(OrderRequest req) {
  return validateOrder(req)
      .chain(valid -> persistOrder(valid))
      .chain(order -> notifyFulfillment(order));
}

// FAIL: Blocking call inside a Uni/Multi pipeline
public Uni<Market> find(String slug) {
  Market m = Market.find("slug", slug).firstResult(); // BLOCKING — breaks event loop
  return Uni.createFrom().item(m);
}

// FAIL: Subscribing more than once to a shared Uni
Uni<Market> shared = fetchMarket(slug);
shared.subscribe().with(m -> log(m));
shared.subscribe().with(m -> cache(m)); // double subscribe — use Uni.memoize()
```

## Exceptions

- Use unchecked exceptions for domain errors; wrap technical exceptions with context
- Create domain-specific exceptions (e.g., `MarketNotFoundException`)
- Avoid broad `catch (Exception ex)` unless rethrowing/logging centrally

```java
throw new MarketNotFoundException(slug);
```

### Centralised Exception Handling

```java
// [SPRING]
@RestControllerAdvice
public class GlobalExceptionHandler {
  @ExceptionHandler(MarketNotFoundException.class)
  public ResponseEntity<ErrorResponse> handle(MarketNotFoundException ex) {
    return ResponseEntity.status(404).body(ErrorResponse.from(ex));
  }
}

// [QUARKUS] Option A: ExceptionMapper
@Provider
public class MarketNotFoundMapper implements ExceptionMapper<MarketNotFoundException> {
  @Override
  public Response toResponse(MarketNotFoundException ex) {
    return Response.status(404).entity(ErrorResponse.from(ex)).build();
  }
}

// [QUARKUS] Option B: @ServerExceptionMapper (RESTEasy Reactive)
@ServerExceptionMapper
public RestResponse<ErrorResponse> handle(MarketNotFoundException ex) {
  return RestResponse.status(Status.NOT_FOUND, ErrorResponse.from(ex));
}
```

## Generics and Type Safety

- Avoid raw types; declare generic parameters
- Prefer bounded generics for reusable utilities

```java
public <T extends Identifiable> Map<Long, T> indexById(Collection<T> items) { ... }
```

## Project Structure

### [SPRING] Maven/Gradle

```
src/main/java/com/example/app/
  config/
  controller/
  service/
  repository/
  domain/
  dto/
  util/
src/main/resources/
  application.yml
src/test/java/... (mirrors main)
```

### [QUARKUS] Maven/Gradle

```
src/main/java/com/example/app/
  config/              # @ConfigMapping, @ConfigProperty beans, Producers
  resource/            # JAX-RS resources (not "controller")
  service/
  repository/          # PanacheRepository implementations (if not using active record)
  domain/              # JPA/Panache entities, MongoDB entities
  dto/
  util/
  mapper/              # MapStruct mappers (if used)
src/main/resources/
  application.properties   # Quarkus convention (YAML supported with quarkus-config-yaml)
  import.sql               # Hibernate auto-import for dev/test
src/test/java/... (mirrors main)
```

## Formatting and Style

- Use 2 or 4 spaces consistently (project standard)
- One public top-level type per file
- Keep methods short and focused; extract helpers
- Order members: constants, fields, constructors, public methods, protected, private

## Code Smells to Avoid

- Long parameter lists → use DTO/builders
- Deep nesting → early returns
- Magic numbers → named constants
- Static mutable state → prefer dependency injection
- Silent catch blocks → log and act or rethrow
- **[QUARKUS]**: `@Singleton` where `@ApplicationScoped` is intended — breaks proxying and interception
- **[QUARKUS]**: Mixing `quarkus-resteasy-reactive` and `quarkus-resteasy` (classic) — pick one stack
- **[QUARKUS]**: Panache active-record + repository pattern in the same bounded context — pick one

## Logging

```java
// [SPRING] SLF4J
private static final Logger log = LoggerFactory.getLogger(MarketService.class);
log.info("fetch_market slug={}", slug);
log.error("failed_fetch_market slug={}", slug, ex);

// [QUARKUS] JBoss Logging (default, zero-cost at build time)
private static final Logger log = Logger.getLogger(MarketService.class);
log.infof("fetch_market slug=%s", slug);
log.errorf(ex, "failed_fetch_market slug=%s", slug);

// [QUARKUS] Alternative: simplified logging with @Inject
@Inject
Logger log; // CDI-injected, scoped to declaring class
```

## Null Handling

- Accept `@Nullable` only when unavoidable; otherwise use `@NonNull`
- Use Bean Validation (`@NotNull`, `@NotBlank`) on inputs
- **[QUARKUS]**: Apply `@Valid` on `@BeanParam`, `@RestForm`, and request body parameters

## Configuration

```java
// [SPRING] @ConfigurationProperties
@ConfigurationProperties(prefix = "market")
public record MarketProperties(int maxPageSize, Duration cacheTtl) {}

// [QUARKUS] @ConfigMapping (type-safe, build-time validated)
@ConfigMapping(prefix = "market")
public interface MarketConfig {
  int maxPageSize();
  Duration cacheTtl();
}

// [QUARKUS] Simple values with @ConfigProperty
@ConfigProperty(name = "market.max-page-size", defaultValue = "100")
int maxPageSize;
```

## Testing Expectations

### Shared
- JUnit 5 + AssertJ for fluent assertions
- Mockito for mocking; avoid partial mocks where possible
- Favor deterministic tests; no hidden sleeps

### [SPRING]
- `@WebMvcTest` for controller slices, `@DataJpaTest` for repository slices
- `@SpringBootTest` reserved for full integration tests
- `@MockBean` for replacing beans in Spring context

### [QUARKUS]
- Plain JUnit 5 + Mockito for unit tests (no `@QuarkusTest`)
- `@QuarkusTest` reserved for CDI integration tests
- `@InjectMock` for replacing CDI beans in integration tests
- Dev Services for database/Kafka/Redis — avoid manual Testcontainers setup when Dev Services suffice
- `@QuarkusTestResource` for custom external service lifecycle

```java
// [SPRING] Controller test
@WebMvcTest(MarketController.class)
class MarketControllerTest {
  @Autowired MockMvc mockMvc;
  @MockBean MarketService marketService;
}

// [QUARKUS] Integration test
@QuarkusTest
class MarketResourceTest {
  @InjectMock
  MarketService marketService;

  @Test
  void should_return_404_when_market_not_found() {
    given().when().get("/markets/unknown").then().statusCode(404);
  }
}

// [QUARKUS] Unit test (no CDI, no @QuarkusTest)
@ExtendWith(MockitoExtension.class)
class MarketServiceTest {
  @Mock MarketRepository marketRepository;
  @InjectMocks MarketService marketService;
}
```

**Remember**: Keep code intentional, typed, and observable. Optimize for maintainability over micro-optimizations unless proven necessary.

---

## Hermes Agent Integration / Hermes Agent 集成

本节说明如何在 Hermes Agent 中使用工具来执行 Java 项目的构建、测试和验证操作。

### 框架检测 / Framework Detection

在应用标准前，先读取构建文件确定框架：

```bash
# 使用 search_files 检测 Quarkus
search_files(pattern="quarkus", file_glob="pom.xml")
search_files(pattern="quarkus", file_glob="build.gradle*")

# 使用 search_files 检测 Spring Boot
search_files(pattern="spring-boot", file_glob="pom.xml")
search_files(pattern="spring-boot", file_glob="build.gradle*")
```

### Maven 操作 / Maven Operations

```bash
# 编译项目
terminal: mvn compile -q

# 运行测试
terminal: mvn test -q

# 打包（跳过测试）
terminal: mvn package -DskipTests -q

# 代码格式检查（如有 spotless 插件）
terminal: mvn spotless:check

# 静态分析
terminal: mvn checkstyle:check

# 全量验证
terminal: mvn verify -q
```

### Gradle 操作 / Gradle Operations

```bash
# 编译项目
terminal: gradle compileJava -q

# 运行测试
terminal: gradle test -q

# 打包
terminal: gradle build -x test -q

# 代码格式检查
terminal: gradle spotlessCheck

# 静态分析
terminal: gradle checkstyleMain
```

### Quarkus Dev 模式 / Quarkus Dev Mode

```bash
# 启动开发模式（后台运行）
terminal(background=true, notify_on_complete=true): mvn quarkus:dev
# 或
terminal(background=true, notify_on_complete=true): gradle quarkusDev

# 运行测试（Quarkus 测试模式）
terminal: mvn test -Dquarkus.test.profile.tags=integration
```

### Spring Boot Dev 模式 / Spring Boot Dev

```bash
# 启动应用（后台运行）
terminal(background=true, notify_on_complete=true): mvn spring-boot:run
# 或
terminal(background=true, notify_on_complete=true): gradle bootRun
```

### 验证代码标准 / Verifying Code Standards

当审查 Java 代码时，按以下流程操作：

1. **读取构建文件** — 使用 `read_file` 读取 `pom.xml` 或 `build.gradle` 确定框架（Spring Boot / Quarkus）
2. **检查项目结构** — 使用 `search_files(target='files', pattern='*.java')` 列出 Java 文件
3. **审查代码** — 使用 `read_file` 读取并对照本技能的标准检查
4. **运行构建** — 使用 `terminal` 执行 `mvn compile` 或 `gradle compileJava` 验证编译
5. **运行测试** — 使用 `terminal` 执行 `mvn test` 或 `gradle test` 验证测试通过

### 常用代码审查搜索 / Common Code Review Searches

```bash
# 查找 @Autowired 字段注入反模式（Spring 项目）
search_files(pattern="@Autowired\\s+private", file_glob="*.java")

# 查找裸 catch 块
search_files(pattern="catch\\s*\\(Exception", file_glob="*.java")

# 查找 Optional.get() 使用（应该用 orElseThrow）
search_files(pattern="\\.get\\(\\)", file_glob="*.java")

# 查找 @Singleton（Quarkus 项目中应为 @ApplicationScoped）
search_files(pattern="@Singleton", file_glob="*.java")

# 查找原始类型（raw types）
search_files(pattern="List\\s+\\w+\\s*=", file_glob="*.java")
```

### 常用检查清单 / Common Checks

- [ ] 命名规范：类名 PascalCase，方法/字段 camelCase，常量 UPPER_SNAKE_CASE
- [ ] 不可变性：优先使用 record 和 final 字段
- [ ] Optional：find* 方法返回 Optional，避免 .get()
- [ ] 依赖注入：Spring 用构造器注入，Quarkus 可用包级字段注入
- [ ] 异常处理：使用领域异常，避免裸 catch
- [ ] 日志：Spring 用 SLF4J，Quarkus 用 JBoss Logging
- [ ] 项目结构：符合框架约定的包布局
- [ ] 测试：单元测试用 JUnit 5 + Mockito，集成测试用框架特定注解

### 注意事项 / Notes

- 长时间运行的命令（如 `quarkus:dev`、`spring-boot:run`）使用 `background=true`
- 构建失败时检查 `terminal` 输出的错误信息，定位问题文件
- 对于多模块项目，在正确的子模块目录执行命令（使用 `workdir` 参数）
- 使用 `search_files` 快速定位代码模式，如查找 `@Autowired` 字段注入反模式
- 使用 `patch` 工具进行代码修改，比 sed/awk 更安全可靠
- Java 17+ 特性（record、sealed class、pattern matching）可自动应用
