class Category < ActiveRecord::Base

  has_many :launches
  belongs_to :user

end
