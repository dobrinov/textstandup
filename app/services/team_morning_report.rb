class TeamMorningReport
  def initialize(team:, date:)
    @team = team
    @date = date
  end

  def each(&block)
    members.each do |member|
      yield member, morning_reports[member.id]
    end
  end

  def members
    @team.members
  end

  def morning_reports
    daily_reports.group_by(&:user_id).map do |user_id, reports|
      ordered_reports = reports.sort_by { |r| -"#{r.year}#{r.month}#{r.day}".to_i }
      [user_id, MorningReport.new(current_day_report: ordered_reports[0], previous_day_report: ordered_reports[1])]
    end.to_h
  end

  private

  def daily_reports
    DailyReport.where(id: daily_report_ids).to_a
  end

  def daily_report_ids
    morning_reports_sql = <<~SQL
      WITH morning_reports AS (
        SELECT user_id,
               day,
               month,
               year,
               id AS current_day_report_id,
               LEAD(id) OVER (PARTITION BY user_id
                              ORDER BY year DESC, month DESC, day DESC
                              ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS previous_day_report_id
        FROM daily_reports
      )

      SELECT user_id, current_day_report_id, previous_day_report_id
      FROM morning_reports
      WHERE day = #{@date.day}
        AND month = #{@date.month}
        AND year = #{@date.year}
        AND user_id IN (#{members.pluck(:id).join(',')});
    SQL

    ActiveRecord::Base.
      connection.
      exec_query(morning_reports_sql).
      map { |row| [row['current_day_report_id'], row['previous_day_report_id']] }.
      flatten
  end
end
