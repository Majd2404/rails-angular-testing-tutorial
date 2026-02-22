# app/models/user.rb
class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  validates :name,  presence: true, length: { minimum: 2, maximum: 50 }
  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :age,   numericality: { greater_than: 0, less_than: 120 }, allow_nil: true

  before_save :downcase_email

  def full_info
    "#{name} (#{email})"
  end

  private

  def downcase_email
    self.email = email.downcase
  end
end
