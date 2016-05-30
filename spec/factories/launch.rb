FactoryGirl.define do

  factory :launch do
    sequence(:title) { |n| "Expense #{n}" }
    value 26
    date '2016-05-20'
   	paid '1'
   	launch_type 0
   	launchable_id 1
   	launchable_type 'Card'
   	category
   	user
  end

end