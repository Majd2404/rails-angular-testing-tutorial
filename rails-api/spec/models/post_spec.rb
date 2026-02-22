# spec/models/post_spec.rb
require "rails_helper"

RSpec.describe Post, type: :model do

  # ─── Associations ───────────────────────────────────────────────────────────
  describe "associations" do
    it { should belong_to(:user) }
  end

  # ─── Validations ───────────────────────────────────────────────────────────
  describe "validations" do
    subject { build(:post) }

    it { should validate_presence_of(:title) }
    it { should validate_length_of(:title).is_at_least(3).is_at_most(100) }

    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content).is_at_least(10) }

    it { should validate_inclusion_of(:status).in_array(%w[draft published archived]) }
  end

  # ─── Scopes ────────────────────────────────────────────────────────────────
  describe "scopes" do
    let!(:user)           { create(:user) }
    let!(:draft_post)     { create(:post, user: user, status: "draft") }
    let!(:published_post) { create(:post, :published, user: user) }
    let!(:archived_post)  { create(:post, :archived, user: user) }

    describe ".published" do
      it "returns only published posts" do
        expect(Post.published).to contain_exactly(published_post)
      end
    end

    describe ".recent" do
      it "orders posts by created_at descending" do
        recent = create(:post, user: user, created_at: 1.day.from_now)
        expect(Post.recent.first).to eq(recent)
      end
    end
  end

  # ─── Instance Methods ───────────────────────────────────────────────────────
  describe "#published?" do
    it "returns true for published posts" do
      post = build(:post, :published)
      expect(post.published?).to be true
    end

    it "returns false for draft posts" do
      post = build(:post)
      expect(post.published?).to be false
    end
  end

  describe "#publish!" do
    it "changes status to published and sets published_at" do
      post = create(:post)
      expect { post.publish! }
        .to change { post.status }.from("draft").to("published")
        .and change { post.published_at }.from(nil)
    end
  end
end
