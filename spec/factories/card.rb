FactoryGirl.define do

  factory :card do
  	brand 5
  	title 'Cartão ELo'
  	credit_limit 2000
  	billing_day 8
  	payment_day 8

  	trait :with_installments do
  		after(:create) do |card|
  			create_list(:installment, 3, installmentable: card)
  		end
  	end

    factory :card_with_installments, traits: [:with_installments]
  end

end