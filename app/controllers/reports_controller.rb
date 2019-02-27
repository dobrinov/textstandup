class ReportsController < ApplicationController
  before_action :redirect_if_no_company

  def index
    @feed = Feed.new user: current_user, selected_date: params[:date]
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
      permit(:type, items: [:id, :title, :url, :description, :type]).
      to_h
  end
end
