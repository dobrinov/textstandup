class TasksController < ApplicationController
  def destroy
    daily_report = current_user.daily_reports.find params[:daily_report_id]
    task = daily_report.tasks.find params[:id]

    task.destroy

    redirect_back fallback_location: root_path
  end
end
