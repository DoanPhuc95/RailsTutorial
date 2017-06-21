class User < ApplicationRecord
  before_save :downcase_email

  has_secure_password

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
    length: {maximum: Settings.name_length_maximum}
  validates :email, presence: true,
    length: {maximum: Settings.email_length_maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password_length_minimum}

  private
  def downcase_email
    self.email = email.downcase
  end
end
