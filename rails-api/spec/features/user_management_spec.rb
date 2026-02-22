# spec/features/user_management_spec.rb
#
# These tests use Capybara + Selenium to drive a real Chrome browser
# against the Angular frontend (http://localhost:4200).
#
# Run Angular first:  cd angular-app && ng serve
# Then run:           bundle exec rspec spec/features --tag selenium
#
require "rails_helper"

RSpec.describe "User Management", type: :feature, js: true do
  # Use Selenium Chrome (headless) for all tests in this file
  before do
    Capybara.current_driver = :selenium_chrome_headless
  end

  after do
    Capybara.use_default_driver
  end

  # ─── List Users ────────────────────────────────────────────────────────────
  describe "User List page" do
    before do
      # Seed test data directly into the DB
      create(:user, name: "Alice Johnson", email: "alice@example.com")
      create(:user, name: "Bob Smith",    email: "bob@example.com")
    end

    it "displays all users on the list page" do
      visit "/"

      expect(page).to have_content("Alice Johnson")
      expect(page).to have_content("Bob Smith")
    end

    it "shows the number of users in the header" do
      visit "/"

      expect(page).to have_content("2 Users")
    end
  end

  # ─── Create User ───────────────────────────────────────────────────────────
  describe "Creating a new user" do
    it "allows a user to fill in the form and submit" do
      visit "/users/new"

      fill_in "Name",  with: "Charlie Brown"
      fill_in "Email", with: "charlie@example.com"
      fill_in "Age",   with: "28"

      click_button "Create User"

      # After successful creation, redirect to user list
      expect(page).to have_current_path("/")
      expect(page).to have_content("Charlie Brown")
      expect(page).to have_content("User created successfully!")
    end

    it "shows validation errors for missing fields" do
      visit "/users/new"

      # Submit without filling in required fields
      click_button "Create User"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Email can't be blank")
    end
  end

  # ─── Edit User ─────────────────────────────────────────────────────────────
  describe "Editing a user" do
    let!(:user) { create(:user, name: "Original Name") }

    it "updates the user's name" do
      visit "/users/#{user.id}/edit"

      fill_in "Name", with: "Updated Name"
      click_button "Update User"

      expect(page).to have_content("Updated Name")
      expect(page).to have_content("User updated successfully!")
    end
  end

  # ─── Delete User ───────────────────────────────────────────────────────────
  describe "Deleting a user" do
    let!(:user) { create(:user, name: "To Be Deleted") }

    it "removes the user from the list after confirmation" do
      visit "/"

      expect(page).to have_content("To Be Deleted")

      # Accept the confirm dialog when clicking delete
      accept_confirm do
        find("[data-testid='delete-user-#{user.id}']").click
      end

      expect(page).not_to have_content("To Be Deleted")
      expect(page).to have_content("User deleted successfully!")
    end
  end

  # ─── Search ────────────────────────────────────────────────────────────────
  describe "Searching for users" do
    before do
      create(:user, name: "Alice Wonder")
      create(:user, name: "Bob Builder")
    end

    it "filters users by name in real-time" do
      visit "/"

      fill_in "Search users...", with: "Alice"

      expect(page).to have_content("Alice Wonder")
      expect(page).not_to have_content("Bob Builder")
    end
  end
end
