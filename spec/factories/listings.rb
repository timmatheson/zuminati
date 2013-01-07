# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :listing do
    title "MyString"
    description "MyString"
    category_id 1
    price "9.99"
    spam false
    source "MyString"
    url "MyString"
    featured false
    address "MyString"
    city "MyString"
    state "MyString"
    country "MyString"
    zipcode "MyString"
    phone "MyString"
    email "MyString"
  end
end
