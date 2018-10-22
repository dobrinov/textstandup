class MorningReport
  include ActiveAttr::Model

  attribute :previous_day_report
  attribute :current_day_report

  def user
    current_day_report.user
  end

  def current_date
    current_day_report.date
  end

  def previous_date
    previous_day_report.date
  end

  def delivered
    previous_day_report.delivered
  end

  def in_progress
    previous_day_report.in_progress
  end

  def planned
    current_day_report.planned
  end

  def blockers
    current_day_report.blockers
  end

  def announcements
    current_day_report.announcements
  end
end
