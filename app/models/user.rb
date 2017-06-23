class User < ApplicationRecord
  before_save :downcase_email

  has_secure_password

  attr_readonly :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, presence: true,
    length: {maximum: Settings.name_length_maximum}
  validates :email, presence: true,
    length: {maximum: Settings.email_length_maximum},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  validates :password, presence: true,
    length: {minimum: Settings.password_length_minimum}

  class << self
    include BCrypt
    include ActiveModel

    def digest string
      if cost = SecurePassword.min_cost
        Engine.MIN_COST
      else
        Engine.cost
      end
      Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def forget
    update_attributes remember_digest: nil
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticate?
    return false unless remember_digest
    Password.new(remember_digest).is_password? :remember_token
  end

  private
  def downcase_email
    self.email = email.downcase
  end
end
