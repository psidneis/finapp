class Group < ActiveRecord::Base

  has_many :user_groups, dependent: :destroy
  has_many :users, through: :user_groups
  has_many :launches
  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id }, length: { in: 2..100 }
  
end
