class UserGroup < ActiveRecord::Base

  belongs_to :group
  belongs_to :user

  enum role: %w(admin launcher viewer)

end
