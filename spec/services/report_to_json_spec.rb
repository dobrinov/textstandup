require 'rails_helper'

describe ReportToJson do
  it 'generates JSON' do
    report = create :report, id: 1
    create :report_item, report: report, id: 1

    json = JSON.parse ReportToJson.execute report

    json.should eq 'submit_path' => '/reports/1',
                   'submit_method' => 'patch',
                   'published_at' => report.created_at.strftime('%d %b %Y at %l:%M%p'),
                   'user' => {
                     'full_name' => 'John Doe',
                     'initials' => 'JD'
                   },
                   'items' => [
                     {
                       'id' => 1,
                       'title' => 'Title',
                       'description' => 'Description',
                       'type' => 'DeliveredReportItem'
                     }
                   ]
  end

  it 'uses POST for unpersisted reports' do
    report = build :report

    json = JSON.parse ReportToJson.execute(report)

    json['submit_path'].should eq '/reports'
    json['submit_method'].should eq 'post'
  end

  it 'uses PATCH for persisted reports' do
    report = create :report, id: 1

    json = JSON.parse ReportToJson.execute(report)

    json['submit_path'].should eq '/reports/1'
    json['submit_method'].should eq 'patch'
  end
end
