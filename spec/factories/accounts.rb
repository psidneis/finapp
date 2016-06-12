FactoryGirl.define do

  factory :account do
    account_type 1
    sequence(:title) { |n| "Conta #{n}" }
    value 'R$ 1.589,95'
    user
  end

end