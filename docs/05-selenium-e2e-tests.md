# 📘 Selenium: End-to-End Tests

## What is Selenium?

Selenium WebDriver controls a real browser programmatically, letting you simulate exactly what a user does: clicking buttons, filling forms, navigating pages. In Rails we use **Capybara** as a high-level DSL that wraps Selenium.

---

## Architecture in This Project

```
[ RSpec / Capybara ] ──► [ Selenium WebDriver ] ──► [ Chrome Browser ]
                                                         │
                                                    [ Angular App ]
                                                    localhost:4200
                                                         │
                                                    [ Rails API ]
                                                    localhost:3000
```

---

## Setup

```ruby
# Gemfile
gem "capybara"
gem "selenium-webdriver"
gem "webdrivers"  # Auto-downloads ChromeDriver to match your Chrome version

# rails_helper.rb
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver    = :rack_test
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.app_host          = "http://localhost:4200"
```

---

## Capybara DSL Reference

### Navigation
```ruby
visit "/"
visit "/users/new"
visit "/users/#{user.id}/edit"
```

### Finding Elements
```ruby
find("h1")
find("[data-testid='search-input']")
find_button("Create User")
find_link("Edit")
all("tr")   # returns array of all matching elements
```

### Interactions
```ruby
click_button "Create User"
click_link "Edit"
click_on "Save"          # button or link

fill_in "Name",   with: "Alice"
fill_in "Email",  with: "alice@example.com"

select "Published", from: "Status"
check "Active"
uncheck "Active"
```

### Assertions
```ruby
expect(page).to have_content("Alice Johnson")
expect(page).not_to have_content("Deleted User")
expect(page).to have_current_path("/users")
expect(page).to have_css("table tr", count: 3)
expect(page).to have_button("Save")
expect(page).to have_field("Name", with: "Alice")
```

### Handling JS Dialogs
```ruby
accept_confirm { click_button "Delete" }
dismiss_confirm { click_button "Delete" }
accept_prompt(with: "Confirmed!") { click_button "Confirm" }
```

---

## Running Feature Specs

```bash
# Start Angular app first
cd angular-app && ng serve &

# Start Rails API
cd rails-api && rails server &

# Run feature specs
bundle exec rspec spec/features

# Run with visible browser (for debugging)
# Change headless → headed in rails_helper.rb
```

---

## Debugging Tips

```ruby
# Take a screenshot on failure
after(:each) do |example|
  if example.exception
    page.save_screenshot("tmp/screenshots/#{example.description}.png")
  end
end

# Pause test execution (opens byebug)
byebug  # or binding.pry

# Print page source
puts page.html

# Slow down Selenium
Capybara.default_max_wait_time = 10  # Wait up to 10s for elements
```

---

## Best Practices

1. **Use `data-testid` attributes** for test selectors — they survive CSS/class refactors
2. **Seed data before tests** using FactoryBot, not UI flows (faster!)
3. **Reset DB** between tests using `DatabaseCleaner` with truncation strategy for JS tests
4. **Keep E2E tests coarse-grained** — test critical user paths, not every edge case (use unit tests for those)
5. **Run headless in CI** — visible browser mode for local debugging only
