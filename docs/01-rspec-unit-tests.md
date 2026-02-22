# 📘 RSpec: Unit Tests (Model Specs)

## What is RSpec?

RSpec is the de-facto testing framework for Ruby/Rails. It uses a **BDD (Behavior-Driven Development)** style with `describe`, `context`, and `it` blocks.

---

## Setup

```bash
# Add to Gemfile (already done in this project)
gem "rspec-rails"
gem "factory_bot_rails"
gem "shoulda-matchers"
gem "faker"

# Install RSpec
bundle exec rails generate rspec:install
```

This creates:
- `spec/spec_helper.rb` – base RSpec config
- `spec/rails_helper.rb` – Rails-specific config
- `.rspec` – default CLI flags

---

## Key Concepts

### describe / context / it blocks

```ruby
RSpec.describe User, type: :model do
  # describe → WHAT you're testing
  describe "#full_info" do
    # context → WHEN / GIVEN some condition
    context "when user has a name and email" do
      # it → expected behavior (should/does/returns...)
      it "returns formatted string" do
        user = User.new(name: "Alice", email: "alice@example.com")
        expect(user.full_info).to eq("Alice (alice@example.com)")
      end
    end
  end
end
```

### let vs let! vs before

```ruby
# let → lazy evaluation (created only when first used)
let(:user) { create(:user) }

# let! → eager evaluation (created immediately in before block)
let!(:user) { create(:user) }

# before → runs before each example
before { create(:user, name: "Admin") }
```

### subject

```ruby
# Implicit subject = described class instance
describe User do
  it { is_expected.to validate_presence_of(:name) }
end

# Explicit subject
subject { build(:user, email: "test@example.com") }
it { is_expected.to be_valid }
```

---

## FactoryBot

Factories are reusable test data blueprints:

```ruby
# spec/factories/users.rb
FactoryBot.define do
  factory :user do
    name  { Faker::Name.full_name }
    email { Faker::Internet.unique.email }
    
    trait :admin do
      name { "Admin User" }
    end
  end
end
```

Using factories in tests:

```ruby
user  = build(:user)          # Build in memory (no DB hit)
user  = create(:user)         # Save to DB
users = create_list(:user, 5) # Create 5 users
admin = create(:user, :admin) # Use trait
```

---

## Shoulda-Matchers

One-liner validations and associations:

```ruby
# Validations
it { should validate_presence_of(:name) }
it { should validate_uniqueness_of(:email).case_insensitive }
it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }
it { should validate_numericality_of(:age).is_greater_than(0) }
it { should allow_value("user@example.com").for(:email) }

# Associations
it { should have_many(:posts).dependent(:destroy) }
it { should belong_to(:user) }
```

---

## Running Tests

```bash
bundle exec rspec                           # All tests
bundle exec rspec spec/models/              # All model specs
bundle exec rspec spec/models/user_spec.rb  # Single file
bundle exec rspec spec/models/user_spec.rb:15  # Single line
bundle exec rspec --format documentation    # Verbose output
bundle exec rspec --tag focus               # Only :focus tagged
```

---

## Common Matchers

```ruby
expect(value).to eq(expected)
expect(value).to be_truthy
expect(value).to be_nil
expect(array).to include("item")
expect(array).to contain_exactly(a, b, c)
expect { action }.to change(User, :count).by(1)
expect { action }.to raise_error(ActiveRecord::RecordNotFound)
expect(object).to be_valid
expect(object).not_to be_valid
expect(object.errors[:field]).to include("can't be blank")
```
