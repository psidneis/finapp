FactoryGirl.define do

  factory :user do
    sequence(:email, 'a') { |n| "finapp#{n}@gmail.com" }
    password '12345678'
    name 'FinApp'
  end

end
