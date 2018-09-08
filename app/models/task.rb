class Task < ApplicationRecord
  enum state: {delivered: 'delivered', in_progress: 'in_progress', planned: 'planned'}

  belongs_to :daily_report

  validates :title, :summary, presence: true
end
