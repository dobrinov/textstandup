FactoryBot.define do
  factory :invitation_link do
    company
    association :inviting_user, factory: :user
    code {'abc123'}
  end
end
