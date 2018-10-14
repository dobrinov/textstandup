class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :team

  class << self
    def default_scope
      order admin: :desc
    end
  end
end
