class Goal < ActiveRecord::Base

  belongs_to :category

  validates :category, :value, presence: true
  validates :value, numericality: true

  def value= value
    if value =~ /^R\$ ([\d.,]+)$/
      write_attribute :value, $1.gsub('.', '').gsub(',', '.').to_d
    end
  end
  
end
