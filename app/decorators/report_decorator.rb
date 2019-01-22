class ReportDecorator < ApplicationDecorator
  decorates_association :entries
  delegate_all

  def to_json
    {
      submit_path: h.report_path(id: id),
      submit_method: :patch,
      published_at: created_at.strftime('%d %b %Y at %l:%M%p'),
      user: {
        initials: user.initials,
        full_name: user.full_name
      },
      entries: entries.map(&:to_h)
    }.to_json
  end
end
