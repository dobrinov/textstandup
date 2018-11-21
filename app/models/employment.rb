class Employment < ApplicationRecord
  belongs_to :user
  belongs_to :company

  class << self
    def default_scope
      order created_at: :asc
    end
  end
end
