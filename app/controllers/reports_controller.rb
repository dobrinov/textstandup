class ReportsController < ApplicationController
  before_action :redirect_if_no_company

  def index
    @reports = ReportSubscriptions.all current_user
    @morning_report = ReportToJson.execute MorningReport.new(user: current_user), current_user, edited: true
    @delivery_report = ReportToJson.execute DeliveryReport.new(user: current_user), current_user, edited: true
  end

  def create
    report = ReportCreator.execute current_user, report_params

    render json: ReportToJson.execute(report, current_user)
  end

  def update
    report = ReportUpdater.execute current_user, params[:id], report_params

    render json: ReportToJson.execute(report, current_user)
  end

  private

  def report_params
    params.
      require(:report).
      permit(:type, items: [:id, :title, :description, :type]).
      to_h
  end
end
