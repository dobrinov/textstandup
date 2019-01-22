FactoryBot.define do
  factory :morning_report do
    user
    type { 'MorningReport' }
  end
end

FactoryBot.define do
  factory :delivery_report do
    user
    type { 'DeliveryReport' }
  end
end
