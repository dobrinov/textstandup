FactoryBot.define do
  factory :invitation_link do
    team 
    association :inviting_user, factory: :user
    code {'abc123'}
  end
end
