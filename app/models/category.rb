class Category < ActiveRecord::Base

  has_many :launches
  has_one :goal
  belongs_to :user

  validates :title, presence: true, uniqueness: { scope: :user_id }, length: { in: 2..100 }

end
