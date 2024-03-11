FactoryBot.define do
  factory :user do
    sequence(:idfa) { |n| "8264148c-be95-4b2b-b260-6ee98dd53bf#{n}" }
    ban_status { 0 }
  end
end
