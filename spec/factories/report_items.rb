FactoryBot.define do
  factory :report_item do
    type { 'DeliveredReportItem' }
    title { 'Title' }
    description { 'Description' }
  end
end
