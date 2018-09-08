class MorningReportForm
  include ActiveAttr::Model

  attribute :current_date_report
  attribute :previous_date_report

  class << self
    def find_by(user:, current_date:, previous_date:)
      current_date_report =
        user.
          daily_reports.
          where(day: current_date.day, month: current_date.month, year: current_date.year).
          first_or_initialize

      previous_date_report =
        if previous_date.present?
          user.
            daily_reports.
            where(day: previous_date.day, month: previous_date.month, year: previous_date.year).
            first_or_initialize

        elsif last_daily_report = user.last_daily_report
          last_daily_report
        else
          last_weekday = current_date.last_weekday

          user.daily_reports.build day: last_weekday.day, month: last_weekday.month, year: last_weekday.year
        end

      new current_date_report: DailyReportForm.new(daily_report: current_date_report),
          previous_date_report: DailyReportForm.new(daily_report: previous_date_report)
    end
  end

  def update_attributes(attributes)
    previous_date_report.assign_attributes attributes.slice(:delivered_attributes, :in_progress_attributes)
    current_date_report.assign_attributes attributes.slice(:planned_attributes, :blockers_attributes, :announcements_attributes)

    ActiveRecord::Base.transaction do
      previous_date_report.save_unsafe && current_date_report.save_unsafe
    end
  end

  def planned
    current_date_report.tasks.select &:planned?
  end

  def in_progress
    previous_date_report.tasks.select &:in_progress?
  end

  def delivered
    previous_date_report.tasks.select &:delivered?
  end

  def blockers
    current_date_report.blockers.order created_at: :desc
  end

  def announcements
    current_date_report.announcements.order created_at: :desc
  end
end
