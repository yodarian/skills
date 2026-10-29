# Testing Patterns Reference (CakePHP/Laravel)

Quick reference for common PHP testing patterns in CakePHP and Laravel. Both frameworks use PHPUnit; prefer their testing helpers for framework boundaries and ordinary PHPUnit assertions for application behavior.

## Test Naming

Name every test method `test<MethodUnderTest>_Given<Scenario>_<ExpectedResult>`. Name the production method, state the relevant precondition, and make the result observable and specific.

For example: `testPublish_GivenDraftArticle_SetsPublishedStatus`.

## Choose the Test Boundary

| Test type | Exercise | Use it for |
|---|---|---|
| Unit | A class or pure behavior, with collaborators supplied directly | Domain rules, transformations, and validation |
| Integration | Framework services, persistence, or a full HTTP request | Routes, middleware, ORM behavior, and application wiring |

Use the smallest boundary that proves the behavior. For framework-level behavior, prefer a framework integration test over manually recreating framework internals.

## CakePHP

### Test a Controller Through the Application

Use `IntegrationTestTrait` to send requests through the application and assert on the response. Fixtures provide a known database state; include only the data the test needs.
Assume the `app.Articles` fixture contains an article titled `Example article`.

```php
use Cake\TestSuite\IntegrationTestTrait;
use Cake\TestSuite\TestCase;

class ArticlesControllerTest extends TestCase
{
    use IntegrationTestTrait;

    protected array $fixtures = ['app.Articles'];

    public function testIndex_GivenArticlesExist_ReturnsOkAndShowsArticle(): void
    {
        $this->get('/articles');

        $this->assertResponseOk();
        $this->assertResponseContains('Example article');
    }
}
```

For write requests, assert the response and the resulting persisted state. Enable CSRF and security tokens in the test when the route uses those middleware checks.

```php
public function testAdd_GivenValidArticle_CreatesArticle(): void
{
    $this->enableCsrfToken();
    $this->enableSecurityToken();
    $this->post('/articles/add', ['title' => 'Example article']);

    $this->assertResponseSuccess();
    $this->assertFlashMessage('The article has been saved.');
    $this->assertSame(
        1,
        $this->getTableLocator()->get('Articles')
            ->find()
            ->where(['title' => 'Example article'])
            ->count(),
    );
}
```

### Keep Database Tests Isolated

Configure CakePHP's `test` database connection separately from development data. Use fixtures for shared baseline records and create scenario-specific records in the test. The fixture extension creates and resets fixture tables for the test run.

### Replace External Services at the Container Boundary

When an integration test would otherwise call an external service, replace the container-bound service with a stub or mock. Keep domain logic and framework behavior real; double only the external boundary.

## Laravel

### Use Feature Tests for HTTP and Persistence

Use `RefreshDatabase` to isolate database state and model factories to arrange records. Authenticate with `actingAs`, then assert on the HTTP response and persisted data.

```php
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CreatePostTest extends TestCase
{
    use RefreshDatabase;

    public function testStore_GivenAuthenticatedUserWithValidInput_CreatesPost(): void
    {
        $user = User::factory()->create();

        $response = $this->actingAs($user)->postJson('/api/posts', [
            'title' => 'Example post',
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.title', 'Example post');

        $this->assertDatabaseHas('posts', [
            'title' => 'Example post',
            'user_id' => $user->id,
        ]);
    }
}
```

Use `assertJsonValidationErrors()` for invalid JSON input and `assertDatabaseMissing()` when absence of a record is the expected result.

### Fake External Effects

Use framework fakes for HTTP, mail, queues, events, notifications, and storage. Set up the fake before exercising the code, then assert the outgoing request or dispatched effect rather than reaching a real external system.

```php
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Http;

public function testSync_GivenRemoteServiceResponds_RequestsExpectedEndpoint(): void
{
    Http::fake([
        'api.example.test/*' => Http::response(['status' => 'ok'], 200),
    ]);

    $this->syncService->sync();

    Http::assertSent(
        fn (Request $request) => $request->url() === 'https://api.example.test/items'
    );
}
```

Laravel's `Mail::fake()`, `Queue::fake()`, `Event::fake()`, `Notification::fake()`, and `Storage::fake()` follow the same setup-act-assert pattern.

## Doubles and Assertions

- Prefer real application code and framework test helpers for behavior under test.
- Use fakes or stubs for slow, nondeterministic, or externally owned boundaries.
- Mock interactions only when the interaction itself is the contract; otherwise assert on output or persisted state.
- Assert meaningful outcomes: response status and payload, database state, or an externally visible effect.

## Official References

- [CakePHP testing](https://book.cakephp.org/5.x/en/development/testing.html)
- [Laravel HTTP tests](https://laravel.com/docs/12.x/http-tests)
- [Laravel database testing](https://laravel.com/docs/12.x/database-testing)
- [Laravel mocking](https://laravel.com/docs/12.x/mocking)
- [Laravel HTTP client testing](https://laravel.com/docs/12.x/http-client#testing)