class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP

  before_destroy :ensure_last_one_standing

  private

    def ensure_last_one_standing
      unless User.count > 1
        errors.add :base, "At least one user must remain"
        throw :abort
      end
    end
end
