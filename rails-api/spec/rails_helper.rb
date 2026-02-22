# spec/rails_helper.rb
require "spec_helper"
require File.expand_path("../config/environment", __dir__)
require "rspec/rails"
require "shoulda/matchers"
require "database_cleaner/active_record"
require "capybara/rspec"
require "selenium-webdriver"

Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  # Use transactions to clean DB between tests (faster)
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning { example.run }
  end

  # For feature/system specs using Selenium, use truncation
  config.before(:each, type: :feature) do
    DatabaseCleaner.strategy = :truncation
  end

  config.after(:each, type: :feature) do
    DatabaseCleaner.strategy = :transaction
  end

  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!
end

# Shoulda-Matchers configuration
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

# Capybara / Selenium configuration
Capybara.register_driver :selenium_chrome_headless do |app|
  options = Selenium::WebDriver::Chrome::Options.new
  options.add_argument("--headless")
  options.add_argument("--no-sandbox")
  options.add_argument("--disable-dev-shm-usage")
  options.add_argument("--window-size=1400,900")

  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

Capybara.default_driver    = :rack_test          # Fast for non-JS tests
Capybara.javascript_driver = :selenium_chrome_headless
Capybara.app_host          = "http://localhost:4200"  # Angular app
Capybara.server_port       = 3000
