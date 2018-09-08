class Calendar
  attr_reader :year, :month, :today

  Day = Struct.new :number, :date, :daily_report, :enabled?, :today?, :overdue?

  def initialize(user, year, month)
    @user = user
    @year = year
    @month = month
    @today = Date.today
  end

  def weeks
    days.group_by { |day| day.date.strftime('%W') }.values
  end

  def days
    @days ||= previous_month_days + current_month_days + next_month_days
  end

  def month_name
    Date.new(@year, @month).strftime '%B'
  end

  def days_of_week
    %w(Mon Tue Wed Thu Fri Sat Sun)
  end

  private

  def daily_reports
    @daily_reports ||=
      @user.daily_reports.where(year: @year, month: @month).map do |daily_report|
        [daily_report.date, daily_report]
      end.to_h
  end

  def days_in_month
    Time.days_in_month @month, @year
  end

  def previous_month_days
    last_day_of_prev_month = Date.new(@year, @month).prev_month.end_of_month

    return [] if last_day_of_prev_month.wday == 6

    @previous_month_days ||=
      last_day_of_prev_month.downto(last_day_of_prev_month - (last_day_of_prev_month.wday - 1).days).map do |date|
        Day.new date.strftime('%e'), date, nil, false, false, false
      end.reverse
  end

  def current_month_days
    @current_month_days ||=
      (1..days_in_month).map do |day|
        date = Date.new @year, @month, day

        Day.new date.strftime('%e'),
                date,
                daily_reports[date],
                true,
                date == @today,
                date < @today && daily_reports[date].blank?
      end
  end

  def next_month_days
    first_day_of_next_month = Date.new(@year, @month).next_month.beginning_of_month

    return [] if first_day_of_next_month.wday == 1

    @next_month_days ||=
      first_day_of_next_month.upto(first_day_of_next_month + (7 - first_day_of_next_month.wday).days).map do |date|
        Day.new date.strftime('%e'), date, nil, false, false, false
      end
  end
end
