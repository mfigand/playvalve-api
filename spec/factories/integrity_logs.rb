FactoryBot.define do
  factory :integrity_log do
    sequence(:idfa) { |n| "8264148c-be95-4b2b-b260-6ee98dd53bf#{n}" }
    ban_status { 0 }
    ip { "192.168.1.1" }
    rooted_device { nil }
    country { "ES" }
    proxy { nil }
    vpn { nil }
  end
end
