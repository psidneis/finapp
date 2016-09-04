FactoryGirl.define do

  factory :user do
    sequence(:email) { |n| "finapp#{n}@test.com" }
    password '12345678'
    name 'FinApp'
  end

end
