class MorningReportsController < ApplicationController
  def index
    @team = current_user.teams.find params[:team_id]
    @team_morning_report = TeamMorningReport.new team: @team, date: Date.today
  end

  def show
    @report = build_morning_report
  end

  def edit
    @tab = parse_tab
    @render_form = parse_render_form
    @edit_item_id = parse_item_id

    @report = build_morning_report

    build_new_item_for(@report, @tab) if @render_form && @edit_item_id.nil?
  end

  def update
    @tab = parse_tab
    @render_form = parse_render_form
    @edit_item_id = parse_item_id

    @report = build_morning_report

    if @report.update_attributes daily_report_form_params
      redirect_to edit_morning_report_path(tab: @tab)
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
      report.previous_date_report.build_delivered
    when :in_progress
      report.previous_date_report.build_in_progress
    when :planned
      report.current_date_report.build_planned
    when :blockers
      report.current_date_report.build_blockers
    when :announcements
      report.current_date_report.build_announcements
    else
      raise "Invalid tab #{tab}"
    end
  end

  def build_morning_report
    current_date = Date.today
    previous_date = Date.parse(params[:previous_date]) if params[:previous_date].present?

    MorningReportForm.find_by user: current_user, current_date: current_date, previous_date: previous_date
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
