class Goal < ActiveRecord::Base

  belongs_to :category

  validates :category, :value, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  
end
