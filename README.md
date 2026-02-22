# 🧪 Rails + Angular Testing Tutorial

A full-stack testing tutorial covering **RSpec** (Rails API), **Jest** (Angular), and **Selenium** (E2E).

## 📁 Project Structure

```
rails-angular-testing-tutorial/
├── rails-api/          # Ruby on Rails API backend
│   ├── app/
│   │   ├── models/     # User, Post models
│   │   └── controllers/
│   └── spec/
│       ├── models/     # RSpec unit tests
│       ├── requests/   # RSpec API/integration tests
│       └── features/   # Selenium/Capybara E2E tests
├── angular-app/        # Angular frontend
│   └── src/app/
│       ├── components/ # UserList component with Jest tests
│       └── services/   # UserService with Jest tests
└── docs/               # Detailed guides
```

## 🚀 Quick Start

### Rails API
```bash
cd rails-api
bundle install
rails db:create db:migrate db:seed
bundle exec rspec        # Run all tests
```

### Angular App
```bash
cd angular-app
npm install
ng test                  # Run Jest tests
ng e2e                   # Run Selenium E2E tests
```

---

## 🔬 Testing Stack

| Tool | Purpose | Layer |
|------|---------|-------|
| **RSpec** | Unit & Integration tests | Rails backend |
| **FactoryBot** | Test data factories | Rails backend |
| **Shoulda-Matchers** | Model validation matchers | Rails backend |
| **Jest** | Unit & Component tests | Angular frontend |
| **Angular Testing Library** | DOM testing utilities | Angular frontend |
| **Selenium WebDriver** | Browser automation | E2E (full-stack) |
| **Capybara** | High-level E2E DSL | E2E (full-stack) |

---

## 📚 Tutorial Sections

1. [RSpec - Rails Unit Tests](docs/01-rspec-unit-tests.md)
2. [RSpec - Rails Request/Integration Tests](docs/02-rspec-request-tests.md)
3. [Jest - Angular Unit Tests](docs/03-jest-unit-tests.md)
4. [Jest - Angular Component Tests](docs/04-jest-component-tests.md)
5. [Selenium - E2E Tests](docs/05-selenium-e2e-tests.md)

---

## 🛠️ Prerequisites

- Ruby 3.2+ & Rails 7+
- Node.js 18+ & Angular CLI 17+
- Chrome/Chromium (for Selenium)
- PostgreSQL or SQLite

---

## 📤 Pushing to GitHub/GitLab

```bash
# Initialize git
git init
git add .
git commit -m "Initial commit: Rails/Angular Testing Tutorial"

# GitHub
git remote add github https://github.com/YOUR_USERNAME/rails-angular-testing-tutorial.git
git push github main

# GitLab
git remote add gitlab https://gitlab.com/YOUR_USERNAME/rails-angular-testing-tutorial.git
git push gitlab main

# Push to BOTH at once (optional - set up multiple remotes)
git remote set-url --add --push origin https://github.com/YOUR_USERNAME/rails-angular-testing-tutorial.git
git remote set-url --add --push origin https://gitlab.com/YOUR_USERNAME/rails-angular-testing-tutorial.git
git push origin main
```
