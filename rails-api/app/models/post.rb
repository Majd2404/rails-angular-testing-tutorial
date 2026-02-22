# app/models/post.rb
class Post < ApplicationRecord
  belongs_to :user

  validates :title,   presence: true, length: { minimum: 3, maximum: 100 }
  validates :content, presence: true, length: { minimum: 10 }
  validates :status,  inclusion: { in: %w[draft published archived] }

  scope :published, -> { where(status: "published") }
  scope :recent,    -> { order(created_at: :desc) }

  def published?
    status == "published"
  end

  def publish!
    update!(status: "published", published_at: Time.current)
  end
end
