FactoryGirl.define do
  factory :installment do
    sequence(:title) { |n| "Expense #{n}" }
    value 26
    date '2016-05-20'
    paid '1'
    launch_type 0
    number_installment 1
    installmentable_id 1
    installmentable_type 'Card'
    category
    user
    launch    
  end
end
