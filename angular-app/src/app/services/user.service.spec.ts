// src/app/services/user.service.spec.ts
import { TestBed } from '@angular/core/testing';
import {
  HttpClientTestingModule,
  HttpTestingController
} from '@angular/common/http/testing';
import { UserService, User } from './user.service';

describe('UserService', () => {
  let service: UserService;
  let httpMock: HttpTestingController;
  const API_URL = 'http://localhost:3000/api/v1/users';

  // Mock data
  const mockUsers: User[] = [
    { id: 1, name: 'Alice Johnson', email: 'alice@example.com', age: 30 },
    { id: 2, name: 'Bob Smith',     email: 'bob@example.com',   age: 25 },
  ];

  // ─── Setup ───────────────────────────────────────────────────────────────
  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [UserService]
    });

    service  = TestBed.inject(UserService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    // Verify no unexpected HTTP requests were made
    httpMock.verify();
  });

  // ─── Service Creation ────────────────────────────────────────────────────
  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  // ─── getUsers() ──────────────────────────────────────────────────────────
  describe('getUsers()', () => {
    it('should return an Observable of users via GET', () => {
      service.getUsers().subscribe(users => {
        expect(users.length).toBe(2);
        expect(users).toEqual(mockUsers);
      });

      const req = httpMock.expectOne(API_URL);
      expect(req.request.method).toBe('GET');
      req.flush(mockUsers);
    });

    it('should return an empty array when no users exist', () => {
      service.getUsers().subscribe(users => {
        expect(users).toEqual([]);
      });

      httpMock.expectOne(API_URL).flush([]);
    });
  });

  // ─── getUser() ───────────────────────────────────────────────────────────
  describe('getUser(id)', () => {
    it('should return a single user by ID', () => {
      service.getUser(1).subscribe(user => {
        expect(user).toEqual(mockUsers[0]);
      });

      const req = httpMock.expectOne(`${API_URL}/1`);
      expect(req.request.method).toBe('GET');
      req.flush(mockUsers[0]);
    });

    it('should handle 404 error gracefully', () => {
      service.getUser(9999).subscribe({
        next:  () => fail('Expected error'),
        error: (err: Error) => {
          expect(err.message).toBe('User not found');
        }
      });

      httpMock.expectOne(`${API_URL}/9999`).flush(
        { error: 'User not found' },
        { status: 404, statusText: 'Not Found' }
      );
    });
  });

  // ─── createUser() ────────────────────────────────────────────────────────
  describe('createUser()', () => {
    it('should POST and return the created user', () => {
      const newUser = { name: 'Charlie', email: 'charlie@example.com', age: 28 };
      const createdUser: User = { id: 3, ...newUser };

      service.createUser(newUser).subscribe(user => {
        expect(user).toEqual(createdUser);
        expect(user.id).toBe(3);
      });

      const req = httpMock.expectOne(API_URL);
      expect(req.request.method).toBe('POST');
      expect(req.request.body).toEqual({ user: newUser });
      req.flush(createdUser);
    });

    it('should handle validation errors (422)', () => {
      const invalidUser = { name: '', email: 'bad-email' };

      service.createUser(invalidUser).subscribe({
        next:  () => fail('Expected error'),
        error: (err: Error) => {
          expect(err.message).toContain('Validation failed');
        }
      });

      httpMock.expectOne(API_URL).flush(
        { errors: ['Name can\'t be blank', 'Email is invalid'] },
        { status: 422, statusText: 'Unprocessable Entity' }
      );
    });
  });

  // ─── updateUser() ────────────────────────────────────────────────────────
  describe('updateUser()', () => {
    it('should PUT and return the updated user', () => {
      const updatedData = { name: 'Alice Updated' };
      const updatedUser = { ...mockUsers[0], ...updatedData };

      service.updateUser(1, updatedData).subscribe(user => {
        expect(user.name).toBe('Alice Updated');
      });

      const req = httpMock.expectOne(`${API_URL}/1`);
      expect(req.request.method).toBe('PUT');
      req.flush(updatedUser);
    });
  });

  // ─── deleteUser() ────────────────────────────────────────────────────────
  describe('deleteUser()', () => {
    it('should DELETE the user and return void', () => {
      service.deleteUser(1).subscribe(result => {
        expect(result).toBeUndefined();
      });

      const req = httpMock.expectOne(`${API_URL}/1`);
      expect(req.request.method).toBe('DELETE');
      req.flush(null);
    });
  });
});
