class Installment < ActiveRecord::Base

  belongs_to :launch

  validates :value, :date, :number_installment, :launch, presence: true
  validates :value, numericality: { greater_than_or_equal_to: 0 }
  validates :number_installment, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
  
end
