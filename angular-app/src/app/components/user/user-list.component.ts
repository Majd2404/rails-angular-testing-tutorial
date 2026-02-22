// src/app/components/user/user-list.component.ts
import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { RouterModule } from '@angular/router';
import { UserService, User } from '../../services/user.service';

@Component({
  selector: 'app-user-list',
  standalone: true,
  imports: [CommonModule, FormsModule, RouterModule],
  template: `
    <div class="container">
      <h1>{{ users.length }} Users</h1>

      <!-- Search -->
      <input
        type="text"
        [(ngModel)]="searchTerm"
        placeholder="Search users..."
        data-testid="search-input"
      />

      <!-- Loading / Error states -->
      <div *ngIf="loading" data-testid="loading-spinner">Loading...</div>
      <div *ngIf="errorMessage" class="error" data-testid="error-message">
        {{ errorMessage }}
      </div>

      <!-- User Table -->
      <table *ngIf="!loading && filteredUsers.length > 0">
        <thead>
          <tr>
            <th>Name</th>
            <th>Email</th>
            <th>Age</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr *ngFor="let user of filteredUsers" [attr.data-testid]="'user-row-' + user.id">
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>{{ user.age ?? 'N/A' }}</td>
            <td>
              <a [routerLink]="['/users', user.id, 'edit']">Edit</a>
              <button
                [attr.data-testid]="'delete-user-' + user.id"
                (click)="deleteUser(user)"
              >Delete</button>
            </td>
          </tr>
        </tbody>
      </table>

      <p *ngIf="!loading && filteredUsers.length === 0" data-testid="no-users">
        No users found.
      </p>

      <!-- Success message -->
      <div *ngIf="successMessage" class="success" data-testid="success-message">
        {{ successMessage }}
      </div>
    </div>
  `
})
export class UserListComponent implements OnInit {
  users: User[] = [];
  searchTerm = '';
  loading = false;
  errorMessage = '';
  successMessage = '';

  constructor(private userService: UserService) {}

  ngOnInit(): void {
    this.loadUsers();
  }

  get filteredUsers(): User[] {
    if (!this.searchTerm.trim()) return this.users;
    const term = this.searchTerm.toLowerCase();
    return this.users.filter(u =>
      u.name.toLowerCase().includes(term) ||
      u.email.toLowerCase().includes(term)
    );
  }

  loadUsers(): void {
    this.loading = true;
    this.userService.getUsers().subscribe({
      next: (users) => {
        this.users = users;
        this.loading = false;
      },
      error: (err: Error) => {
        this.errorMessage = err.message;
        this.loading = false;
      }
    });
  }

  deleteUser(user: User): void {
    if (!confirm(`Delete ${user.name}?`)) return;

    this.userService.deleteUser(user.id!).subscribe({
      next: () => {
        this.users = this.users.filter(u => u.id !== user.id);
        this.successMessage = 'User deleted successfully!';
        setTimeout(() => this.successMessage = '', 3000);
      },
      error: (err: Error) => {
        this.errorMessage = err.message;
      }
    });
  }
}
