# 📘 Jest: Angular Unit Tests (Services)

## What is Jest?

Jest is a JavaScript testing framework by Meta, commonly used with Angular as a faster alternative to Karma+Jasmine. It supports mocking, spies, and async testing out of the box.

---

## Setup (Angular with Jest)

```bash
# Install jest-preset-angular
npm install --save-dev jest jest-preset-angular @types/jest

# Remove Karma (optional)
npm uninstall karma karma-chrome-launcher karma-coverage karma-jasmine

# Add to package.json
"scripts": {
  "test": "jest",
  "test:watch": "jest --watch",
  "test:coverage": "jest --coverage"
}
```

---

## Key Jest Concepts

### describe / it / expect

```typescript
describe('UserService', () => {
  it('should create the service', () => {
    expect(service).toBeTruthy();
  });
});
```

### beforeEach / afterEach

```typescript
beforeEach(() => {
  // Runs before EACH test in this describe block
  jest.clearAllMocks();
});

afterEach(() => {
  httpMock.verify(); // verify no unexpected HTTP calls
});
```

### Jest Mocks

```typescript
// Mock a function
const mockFn = jest.fn();
mockFn.mockReturnValue('hello');
mockFn.mockReturnValueOnce('first call only');
mockFn.mockImplementation((x) => x * 2);

// Mock with Observable (for Angular services)
import { of, throwError } from 'rxjs';
mockService.getUsers.mockReturnValue(of([user1, user2]));
mockService.getUser.mockReturnValue(throwError(() => new Error('Not found')));

// Spy on a method
const spy = jest.spyOn(service, 'getUsers');
expect(spy).toHaveBeenCalledTimes(1);
expect(spy).toHaveBeenCalledWith(/* args */);
```

---

## Testing HTTP with HttpTestingController

```typescript
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';

describe('UserService HTTP', () => {
  let service: UserService;
  let httpMock: HttpTestingController;

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [UserService]
    });
    service  = TestBed.inject(UserService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    httpMock.verify(); // Ensures no pending requests
  });

  it('should GET users', () => {
    service.getUsers().subscribe(users => {
      expect(users.length).toBe(2);
    });

    // Intercept and respond to the HTTP request
    const req = httpMock.expectOne('/api/v1/users');
    expect(req.request.method).toBe('GET');
    req.flush([{ id: 1, name: 'Alice' }, { id: 2, name: 'Bob' }]);
  });
});
```

---

## Common Jest Matchers

```typescript
expect(value).toBe(5);                    // strict equality (===)
expect(value).toEqual({ a: 1 });          // deep equality
expect(value).toBeTruthy();
expect(value).toBeFalsy();
expect(value).toBeNull();
expect(value).toBeUndefined();
expect(array).toContain('item');
expect(array).toHaveLength(3);
expect(fn).toHaveBeenCalled();
expect(fn).toHaveBeenCalledWith(arg1, arg2);
expect(fn).toHaveBeenCalledTimes(1);
expect(fn).toThrow('error message');
```

---

## Running Tests

```bash
npm test                  # Run once
npm run test:watch        # Watch mode
npm run test:coverage     # With coverage report
npx jest user.service     # Filter by filename
npx jest --verbose        # Detailed output
```
