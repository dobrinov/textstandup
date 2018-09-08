class DailyReportForm
  include ActiveAttr::Model

  attribute :daily_report

  class << self
    def find(user, id)
      new daily_report: user.daily_reports.find(id)
    end
  end

  def id
    daily_report.id
  end

  def date
    daily_report.date
  end

  def update_attributes(attributes)
    assign_attributes attributes
    save
  end

  def save
    ActiveRecord::Base.transaction do
      save_unsafe
    end
  end

  def save_unsafe
    [
      delivered,
      in_progress,
      planned,
      blockers,
      announcements,
      [daily_report]
    ].flatten.map(&:save).all?
  end

  def blockers
    daily_report.blockers
  end

  def announcements
    daily_report.announcements
  end

  def tasks
    daily_report.tasks
  end

  def delivered
    tasks.select &:delivered?
  end

  def in_progress
    tasks.select &:in_progress?
  end

  def planned
    tasks.select &:planned?
  end

  def build_delivered(attributes={})
    tasks.delivered.build(attributes)
  end

  def build_in_progress(attributes={})
    tasks.in_progress.build(attributes)
  end

  def build_planned(attributes={})
    tasks.planned.build(attributes)
  end

  def build_blockers(attributes={})
    blockers.build(attributes)
  end

  def build_announcements(attributes={})
    announcements.build(attributes)
  end

  def delivered_attributes=(indexed_attributes)
    apply_item_attributes :tasks, indexed_attributes
  end

  def in_progress_attributes=(indexed_attributes)
    apply_item_attributes :tasks, indexed_attributes
  end

  def planned_attributes=(indexed_attributes)
    apply_item_attributes :tasks, indexed_attributes
  end

  def blockers_attributes=(indexed_attributes)
    apply_item_attributes :blockers, indexed_attributes
  end

  def announcements_attributes=(indexed_attributes)
    apply_item_attributes :announcements, indexed_attributes
  end

  def apply_item_attributes(collection_name, indexed_attributes)
    collection = public_send collection_name

    indexed_attributes.each do |_, attributes|
      id = attributes.delete :id

      next if attributes.empty?

      if id.nil?
        collection.build attributes
      else
        item = collection.find { |item| item.id == id.to_i }
        item.assign_attributes attributes
      end
    end
  end
end
