class Report < ApplicationRecord
  belongs_to :user
  has_many :items, class_name: 'ReportItem'

  def item_types
    raise 'Not implemented'
  end
end
