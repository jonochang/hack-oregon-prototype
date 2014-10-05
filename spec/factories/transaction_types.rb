# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :transaction_type do
    title "MyString"
    direction 1
  end
end
