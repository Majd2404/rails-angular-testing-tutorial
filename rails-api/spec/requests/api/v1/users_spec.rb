# spec/requests/api/v1/users_spec.rb
require "rails_helper"

RSpec.describe "Api::V1::Users", type: :request do
  let(:valid_attributes)   { attributes_for(:user) }
  let(:invalid_attributes) { { name: "", email: "bad-email" } }

  # ─── GET /api/v1/users ─────────────────────────────────────────────────────
  describe "GET /api/v1/users" do
    it "returns all users with HTTP 200" do
      create_list(:user, 3)
      get "/api/v1/users"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end

    it "returns an empty array when no users exist" do
      get "/api/v1/users"

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq([])
    end
  end

  # ─── GET /api/v1/users/:id ─────────────────────────────────────────────────
  describe "GET /api/v1/users/:id" do
    context "when the user exists" do
      it "returns the user with HTTP 200" do
        user = create(:user)
        get "/api/v1/users/#{user.id}"

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)
        expect(body["email"]).to eq(user.email)
        expect(body["name"]).to eq(user.name)
      end
    end

    context "when the user does not exist" do
      it "returns HTTP 404 with error message" do
        get "/api/v1/users/99999"

        expect(response).to have_http_status(:not_found)
        expect(JSON.parse(response.body)["error"]).to eq("User not found")
      end
    end
  end

  # ─── POST /api/v1/users ────────────────────────────────────────────────────
  describe "POST /api/v1/users" do
    context "with valid parameters" do
      it "creates a new user and returns HTTP 201" do
        expect {
          post "/api/v1/users", params: { user: valid_attributes }
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body["email"]).to eq(valid_attributes[:email].downcase)
      end
    end

    context "with invalid parameters" do
      it "does NOT create a user and returns HTTP 422" do
        expect {
          post "/api/v1/users", params: { user: invalid_attributes }
        }.not_to change(User, :count)

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        expect(body["errors"]).to be_present
      end
    end
  end

  # ─── PUT /api/v1/users/:id ─────────────────────────────────────────────────
  describe "PUT /api/v1/users/:id" do
    let(:user) { create(:user) }

    context "with valid parameters" do
      it "updates the user and returns HTTP 200" do
        put "/api/v1/users/#{user.id}", params: { user: { name: "Updated Name" } }

        expect(response).to have_http_status(:ok)
        expect(user.reload.name).to eq("Updated Name")
      end
    end

    context "with invalid parameters" do
      it "returns HTTP 422 with validation errors" do
        put "/api/v1/users/#{user.id}", params: { user: { email: "invalid" } }

        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  # ─── DELETE /api/v1/users/:id ──────────────────────────────────────────────
  describe "DELETE /api/v1/users/:id" do
    it "destroys the user and returns HTTP 204" do
      user = create(:user)

      expect {
        delete "/api/v1/users/#{user.id}"
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
