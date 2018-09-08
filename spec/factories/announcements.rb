FactoryBot.define do
  factory :announcement do
    day { 20 }
    month { 8 }
    year { 2018 }
    title { 'Announcement title' }
    summary { 'Announcement description' }
  end
end
