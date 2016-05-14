FactoryGirl.define do
  factory :system_default, class: :System do
    target_from 2015-01-01
    target_to 2015-12-01
    term 2015
  end
  factory :system_test, class: :System do
    target_from 2016-01-01
    target_to 2016-12-01
    term 2016
  end
end
