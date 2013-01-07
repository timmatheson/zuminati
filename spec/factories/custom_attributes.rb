# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :custom_attribute do
    name "MyString"
    value "MyString"
    owner_id 1
  end
end
