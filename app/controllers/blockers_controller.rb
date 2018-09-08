class BlockersController < ApplicationController
  def destroy
    daily_report = current_user.daily_reports.find params[:daily_report_id]
    blockers = daily_report.blockers.find params[:id]

    blockers.destroy

    redirect_back fallback_location: root_path
  end
end
