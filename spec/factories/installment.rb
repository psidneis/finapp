FactoryGirl.define do

  factory :installment do
    title 
    value
    date
   	paid
   	launch_type
   	installmentable_id
   	installmentable_type
   	category_id
   	user_id
   	launch_id
  end

end