# 📘 Jest: Angular Component Tests

## What are Component Tests?

Component tests check how the UI renders and responds to user interactions, without a real browser. They use Angular's `TestBed` to create a virtual DOM environment.

---

## TestBed Setup

```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { UserListComponent } from './user-list.component';

beforeEach(async () => {
  await TestBed.configureTestingModule({
    imports: [UserListComponent],         // For standalone components
    // OR declarations: [UserListComponent]  // For module-based components
    providers: [
      { provide: UserService, useValue: mockUserService }
    ]
  }).compileComponents();

  fixture   = TestBed.createComponent(UserListComponent);
  component = fixture.componentInstance;
  fixture.detectChanges(); // triggers ngOnInit + initial render
});
```

---

## Querying the DOM

```typescript
const compiled = fixture.nativeElement as HTMLElement;

// By CSS selector
compiled.querySelector('h1')?.textContent

// By data-testid (recommended - survives CSS refactors)
compiled.querySelector('[data-testid="search-input"]')

// By attribute prefix
compiled.querySelectorAll('[data-testid^="user-row-"]')

// Multiple elements
compiled.querySelectorAll('tr').length
```

---

## Simulating User Events

```typescript
// Click a button
const button = compiled.querySelector('button');
button?.click();
fixture.detectChanges();  // re-render after state change

// Type in an input
const input = compiled.querySelector('input') as HTMLInputElement;
input.value = 'search text';
input.dispatchEvent(new Event('input'));
fixture.detectChanges();

// Change select
const select = compiled.querySelector('select') as HTMLSelectElement;
select.value = 'option1';
select.dispatchEvent(new Event('change'));
fixture.detectChanges();
```

---

## Testing Async Operations (fakeAsync)

```typescript
import { fakeAsync, tick } from '@angular/core/testing';

it('clears success message after 3 seconds', fakeAsync(() => {
  component.successMessage = 'Saved!';
  fixture.detectChanges();

  // Fast-forward time by 3000ms (no real waiting!)
  tick(3000);
  fixture.detectChanges();

  expect(component.successMessage).toBe('');
}));
```

---

## Testing with Spies on Built-ins

```typescript
// Mock window.confirm
jest.spyOn(window, 'confirm').mockReturnValue(true);

// Mock console.error (suppress noise in tests)
jest.spyOn(console, 'error').mockImplementation(() => {});

// Mock Date
jest.spyOn(Date, 'now').mockReturnValue(new Date('2024-01-01').getTime());
```

---

## Component Output Events (@Output)

```typescript
it('emits userDeleted event when delete is called', () => {
  const emitSpy = jest.spyOn(component.userDeleted, 'emit');
  component.deleteUser(mockUser);
  expect(emitSpy).toHaveBeenCalledWith(mockUser.id);
});
```

---

## Input Changes (@Input)

```typescript
it('updates when @Input changes', () => {
  component.userId = 42;
  fixture.detectChanges();

  const title = compiled.querySelector('h2')!;
  expect(title.textContent).toContain('User #42');
});
```
