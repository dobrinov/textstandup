require 'rails_helper'

describe ReportToJson do
  let(:user) { create :user }

  it 'generates JSON' do
    report = create :delivery_report, id: 1
    create :report_item, report: report, id: 1

    json = JSON.parse ReportToJson.execute report, user

    json['submit_path'].should eq '/reports/1'
    json['submit_method'].should eq 'patch'
    json['published_at'].should eq report.created_at.strftime('%d %b %Y at %l:%M%p')
    json['user']['full_name'].should eq 'John Doe'
    json['user']['initials'].should eq 'JD'
    json['items'].should eq [
                              {
                                'id' => 1,
                                'title' => 'Title',
                                'description' => 'Description',
                                'type' => 'DeliveredReportItem',
                              },
                            ]
  end

  it 'uses POST for unpersisted reports' do
    report = build :morning_report

    json = JSON.parse ReportToJson.execute(report, user)

    json['submit_path'].should eq '/reports'
    json['submit_method'].should eq 'post'
  end

  it 'uses PATCH for persisted reports' do
    report = create :morning_report, id: 1

    json = JSON.parse ReportToJson.execute(report, user)

    json['submit_path'].should eq '/reports/1'
    json['submit_method'].should eq 'patch'
  end
end
