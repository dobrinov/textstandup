FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password { 'secret#123' }
    password_confirmation { 'secret#123' }
  end
end
