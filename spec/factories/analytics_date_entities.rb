# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :analytics_date_entity, :class => 'Analytics::DateEntity' do
    full_date "2014-10-05"
  end
end
