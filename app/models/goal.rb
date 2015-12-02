class Goal < ActiveRecord::Base

  belongs_to :category

  validates :category, :value, presence: true
  validates :category, uniqueness: true
  validates :value, numericality: true

  def value= value
    if value =~ /^R\$ ([\d.,]+)$/
      write_attribute :value, $1.gsub('.', '').gsub(',', '.').to_d
	  else
      write_attribute :value, value
    end
  end

  def calculate_total_period(start_date, end_date)
    self.category.installments.where(launch_type: 'expense', date: start_date..end_date).sum("installments.value")
  end
  
end
