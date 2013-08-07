# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :regel do
    variable_id 1
    zeitfenster 1
    name "MyString"
    ist_aktiv false
    kommentar "MyString"
    grenze_maximum "MyString"
    grenze_minimum "MyString"
  end
end
