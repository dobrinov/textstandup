class DailyReportsController < ApplicationController
  def show
    @report = current_user.daily_reports.find params[:id]
  end

  def new
    date = parse_date params[:date]

    @report = DailyReport.new user: current_user, day: date.day, month: date.month, year: date.year
  end

  def create
    date = parse_date params[:date]

    @report = DailyReport.create! user: current_user, day: date.day, month: date.month, year: date.year

    redirect_to edit_daily_report_path @report
  end

  def edit
    @tab = parse_tab
    @render_form = parse_render_form
    @edit_item_id = parse_item_id

    @report = DailyReportForm.find current_user, params[:id]

    build_new_item_for(@report, @tab) if @render_form && @edit_item_id.nil?
  end

  def update
    @tab = parse_tab
    @render_form = parse_render_form
    @edit_item_id = parse_item_id

    @report = DailyReportForm.find current_user, params[:id]

    if @report.update_attributes daily_report_form_params
      redirect_to edit_daily_report_path(tab: @tab)
    else
      render :edit
    end
  end

  private

  def parse_tab
    params[:tab]&.to_sym
  end

  def parse_render_form
    params[:render_form].present?
  end

  def parse_item_id
    params[:edit_item_id]&.to_i
  end

  def build_new_item_for(report, tab)
    case tab
    when :delivered
      report.build_delivered
    when :in_progress
      report.build_in_progress
    when :planned
      report.build_planned
    when :blockers
      report.build_blockers
    when :announcements
      report.build_announcements
    else
      raise "Invalid tab #{tab}"
    end
  end

  def daily_report_form_params
    params.
      require(:daily_report_form).
      permit(
        delivered_attributes: %i(id title summary state),
        in_progress_attributes: %i(id title summary state),
        planned_attributes: %i(id title summary state),
        blockers_attributes: %i(id title summary),
        announcements_attributes: %i(id title summary)
      ).to_h
  end
end
