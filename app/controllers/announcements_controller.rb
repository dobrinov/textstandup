class AnnouncementsController < ApplicationController
  def destroy
    daily_report = current_user.daily_reports.find params[:daily_report_id]
    announcements = daily_report.announcements.find params[:id]

    announcements.destroy

    redirect_back fallback_location: root_path
  end
end
