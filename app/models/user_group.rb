class UserGroup < ActiveRecord::Base

  belongs_to :group
  belongs_to :user

  validates :role, :group, :email, presence: true
  validates :group, uniqueness: { scope: :email }
  validates :email, length: { in: 3..100 }
  validate :validate_email

  enum role: %w(admin launcher viewer)

  def validate_email
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
      errors.add(:email, "não é um e-mail")
    end
  end

  def search_user
    user = User.find_by(email: self.email)
    self.user = user
  end

end
