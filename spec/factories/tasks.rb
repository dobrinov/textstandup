FactoryBot.define do
  factory :task do
    state { 'planned' }
    title { 'Task title' }
    summary { 'Task description' }
  end
end
