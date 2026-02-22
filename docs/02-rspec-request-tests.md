# 📘 RSpec: Request/Integration Tests

## What are Request Specs?

Request specs test the full HTTP stack in Rails — routing, controllers, middleware, and responses. They're perfect for testing REST APIs.

---

## Structure

```ruby
RSpec.describe "Api::V1::Users", type: :request do
  describe "GET /api/v1/users" do
    it "returns HTTP 200" do
      get "/api/v1/users"
      expect(response).to have_http_status(:ok)
    end
  end
end
```

---

## HTTP Methods

```ruby
get    "/api/v1/users"
post   "/api/v1/users", params: { user: { name: "Alice", email: "a@b.com" } }
put    "/api/v1/users/1", params: { user: { name: "Updated" } }
patch  "/api/v1/users/1", params: { user: { name: "Updated" } }
delete "/api/v1/users/1"
```

---

## Response Assertions

```ruby
# Status codes
expect(response).to have_http_status(:ok)           # 200
expect(response).to have_http_status(:created)      # 201
expect(response).to have_http_status(:no_content)   # 204
expect(response).to have_http_status(:not_found)    # 404
expect(response).to have_http_status(:unprocessable_entity) # 422

# Body parsing
body = JSON.parse(response.body)
expect(body["name"]).to eq("Alice")
expect(body["errors"]).to be_present
expect(body.size).to eq(3)  # array length
```

---

## Testing with Authentication (JWT example)

```ruby
# spec/support/auth_helpers.rb
module AuthHelpers
  def auth_headers(user)
    token = JsonWebToken.encode(user_id: user.id)
    { "Authorization" => "Bearer #{token}" }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end

# In spec:
describe "GET /api/v1/profile" do
  it "returns current user when authenticated" do
    user = create(:user)
    get "/api/v1/profile", headers: auth_headers(user)
    
    expect(response).to have_http_status(:ok)
    expect(JSON.parse(response.body)["email"]).to eq(user.email)
  end

  it "returns 401 when not authenticated" do
    get "/api/v1/profile"
    expect(response).to have_http_status(:unauthorized)
  end
end
```

---

## Side Effects

```ruby
# Testing DB changes with expect { }.to change
it "creates a user in the DB" do
  expect {
    post "/api/v1/users", params: { user: valid_attributes }
  }.to change(User, :count).by(1)
end

it "does NOT create a user with invalid params" do
  expect {
    post "/api/v1/users", params: { user: { name: "" } }
  }.not_to change(User, :count)
end
```
