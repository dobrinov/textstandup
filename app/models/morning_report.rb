class MorningReport < Report
  def item_types
    %w(OngoingReportItem PlannedReportItem BlockerReportItem AnnouncementReportItem)
  end
end
