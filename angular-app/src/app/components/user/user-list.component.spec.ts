// src/app/components/user/user-list.component.spec.ts
import { ComponentFixture, TestBed, fakeAsync, tick } from '@angular/core/testing';
import { of, throwError } from 'rxjs';
import { UserListComponent } from './user-list.component';
import { UserService, User } from '../../services/user.service';
import { RouterTestingModule } from '@angular/router/testing';

// ─── Mock Data ──────────────────────────────────────────────────────────────
const mockUsers: User[] = [
  { id: 1, name: 'Alice Johnson', email: 'alice@example.com', age: 30 },
  { id: 2, name: 'Bob Smith',     email: 'bob@example.com',   age: 25 },
];

// ─── Mock Service ────────────────────────────────────────────────────────────
const mockUserService = {
  getUsers:   jest.fn(),
  deleteUser: jest.fn(),
};

describe('UserListComponent', () => {
  let component: UserListComponent;
  let fixture: ComponentFixture<UserListComponent>;

  beforeEach(async () => {
    // Reset mock calls before each test
    jest.clearAllMocks();
    mockUserService.getUsers.mockReturnValue(of(mockUsers));

    await TestBed.configureTestingModule({
      imports: [UserListComponent, RouterTestingModule],
      providers: [{ provide: UserService, useValue: mockUserService }]
    }).compileComponents();

    fixture   = TestBed.createComponent(UserListComponent);
    component = fixture.componentInstance;
    fixture.detectChanges(); // triggers ngOnInit
  });

  // ─── Component Creation ────────────────────────────────────────────────
  it('should create the component', () => {
    expect(component).toBeTruthy();
  });

  // ─── Initialization ────────────────────────────────────────────────────
  describe('on initialization', () => {
    it('loads users via UserService.getUsers()', () => {
      expect(mockUserService.getUsers).toHaveBeenCalledTimes(1);
      expect(component.users).toEqual(mockUsers);
    });

    it('renders the user count in the heading', () => {
      const heading = fixture.nativeElement.querySelector('h1');
      expect(heading.textContent).toContain('2 Users');
    });

    it('renders each user in the table', () => {
      const rows = fixture.nativeElement.querySelectorAll('[data-testid^="user-row-"]');
      expect(rows.length).toBe(2);
      expect(rows[0].textContent).toContain('Alice Johnson');
      expect(rows[1].textContent).toContain('Bob Smith');
    });
  });

  // ─── Loading State ─────────────────────────────────────────────────────
  describe('loading state', () => {
    it('shows loading spinner while fetching users', () => {
      // Reset and re-create with a delayed observable
      mockUserService.getUsers.mockReturnValue(of(mockUsers));
      component.loading = true;
      fixture.detectChanges();

      const spinner = fixture.nativeElement.querySelector('[data-testid="loading-spinner"]');
      expect(spinner).toBeTruthy();
      expect(spinner.textContent).toBe('Loading...');
    });
  });

  // ─── Error State ───────────────────────────────────────────────────────
  describe('error handling', () => {
    it('displays an error message when the API fails', () => {
      mockUserService.getUsers.mockReturnValue(
        throwError(() => new Error('Server error'))
      );
      component.ngOnInit();
      fixture.detectChanges();

      const errorEl = fixture.nativeElement.querySelector('[data-testid="error-message"]');
      expect(errorEl).toBeTruthy();
      expect(errorEl.textContent).toContain('Server error');
    });
  });

  // ─── Search / Filter ───────────────────────────────────────────────────
  describe('filteredUsers getter', () => {
    it('returns all users when searchTerm is empty', () => {
      component.searchTerm = '';
      expect(component.filteredUsers.length).toBe(2);
    });

    it('filters users by name (case-insensitive)', () => {
      component.searchTerm = 'alice';
      expect(component.filteredUsers.length).toBe(1);
      expect(component.filteredUsers[0].name).toBe('Alice Johnson');
    });

    it('filters users by email', () => {
      component.searchTerm = 'bob@';
      expect(component.filteredUsers.length).toBe(1);
      expect(component.filteredUsers[0].name).toBe('Bob Smith');
    });

    it('returns empty array when no user matches', () => {
      component.searchTerm = 'zzznomatch';
      expect(component.filteredUsers.length).toBe(0);
    });

    it('updates the DOM when searchTerm changes', () => {
      component.searchTerm = 'alice';
      fixture.detectChanges();

      const rows = fixture.nativeElement.querySelectorAll('[data-testid^="user-row-"]');
      expect(rows.length).toBe(1);
    });
  });

  // ─── Delete User ───────────────────────────────────────────────────────
  describe('deleteUser()', () => {
    beforeEach(() => {
      mockUserService.deleteUser.mockReturnValue(of(void 0));
      // Spy on window.confirm and make it return true
      jest.spyOn(window, 'confirm').mockReturnValue(true);
    });

    it('calls UserService.deleteUser with correct ID', () => {
      component.deleteUser(mockUsers[0]);
      expect(mockUserService.deleteUser).toHaveBeenCalledWith(1);
    });

    it('removes the user from the local array', () => {
      component.deleteUser(mockUsers[0]);
      expect(component.users.length).toBe(1);
      expect(component.users[0].name).toBe('Bob Smith');
    });

    it('shows a success message after deletion', fakeAsync(() => {
      component.deleteUser(mockUsers[0]);
      fixture.detectChanges();

      const msg = fixture.nativeElement.querySelector('[data-testid="success-message"]');
      expect(msg.textContent).toContain('User deleted successfully!');

      // Message should disappear after 3 seconds
      tick(3000);
      fixture.detectChanges();
      expect(component.successMessage).toBe('');
    }));

    it('does NOT delete if user cancels confirm dialog', () => {
      jest.spyOn(window, 'confirm').mockReturnValue(false);
      component.deleteUser(mockUsers[0]);
      expect(mockUserService.deleteUser).not.toHaveBeenCalled();
    });
  });
});
