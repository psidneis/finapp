FactoryGirl.define do

  factory :invoice do
  	title 'Fatura de junho de 2016'
  	card_id 6
  	payment_day 8

  	trait :with_installments do
  		after(:create) do |invoice|
  			create_list(:installment, invoice: invoice)
  		end
  	end
  end

end