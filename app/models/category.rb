class Category < ActiveRecord::Base

  has_many :launches
  has_one :goal
  belongs_to :user

end
