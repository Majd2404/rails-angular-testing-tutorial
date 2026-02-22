# spec/models/user_spec.rb
require "rails_helper"

RSpec.describe User, type: :model do

  # ─── Associations ───────────────────────────────────────────────────────────
  describe "associations" do
    it { should have_many(:posts).dependent(:destroy) }
  end

  # ─── Validations (using Shoulda-Matchers) ──────────────────────────────────
  describe "validations" do
    subject { build(:user) }   # Build a valid user from FactoryBot

    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(50) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }

    it { should allow_value("user@example.com").for(:email) }
    it { should_not allow_value("invalid-email").for(:email) }
    it { should_not allow_value("missing@").for(:email) }

    it { should validate_numericality_of(:age).is_greater_than(0).is_less_than(120) }
    it { should allow_value(nil).for(:age) }
  end

  # ─── Callbacks ──────────────────────────────────────────────────────────────
  describe "callbacks" do
    it "downcases the email before saving" do
      user = create(:user, email: "UPPERCASE@EXAMPLE.COM")
      expect(user.reload.email).to eq("uppercase@example.com")
    end
  end

  # ─── Instance Methods ───────────────────────────────────────────────────────
  describe "#full_info" do
    it "returns name and email in the correct format" do
      user = build(:user, name: "Alice Smith", email: "alice@example.com")
      expect(user.full_info).to eq("Alice Smith (alice@example.com)")
    end
  end

  # ─── Scopes ────────────────────────────────────────────────────────────────
  describe "edge cases" do
    it "is invalid with a duplicate email (case-insensitive)" do
      create(:user, email: "test@example.com")
      duplicate = build(:user, email: "TEST@EXAMPLE.COM")
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been taken")
    end

    it "destroys associated posts when user is deleted" do
      user = create(:user)
      create_list(:post, 3, user: user)

      expect { user.destroy }.to change(Post, :count).by(-3)
    end
  end
end
