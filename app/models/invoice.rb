class Invoice < ActiveRecord::Base

	belongs_to :card

	validates :title, :payment_day, presence: true
  validates :title, length: { in: 2..100 }
  validates :value, numericality: true

  def value= value
    if value =~ /^R\$ ([\d.,]+)$/
      write_attribute :value, $1.gsub('.', '').gsub(',', '.').to_d
    else
      write_attribute :value, value
    end
  end

  def self.human_model_name
    self.model_name.human
  end

  def installments
    invoice_installments = []
    installments = self.card.installments.where("date < ?", self.payment_day)
    installments.each do |installment|
      invoice_installments << installment if installment.date.month == self.payment_day.month and installment.date.day <= self.payment_day.day
    end
    invoice_installments
  end

end
