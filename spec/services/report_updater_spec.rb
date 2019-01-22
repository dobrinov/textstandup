require 'rails_helper'

describe ReportUpdater do
  let(:user) { create :user }

  it 'creates a new item' do
    report = create :morning_report, user: user

    attributes =
      {
        items: [
          {title: 'Title', description: 'Description', type: 'OngoingReportItem'}
        ]
      }

    expect do
      ReportUpdater.execute user, report.id, attributes
    end.to change(report.items, :count).by 1
  end

  it 'updates changed existing items' do
    report = create :morning_report, user: user
    item = create :report_item, id: 1, title: 'Title', description: 'Description', report: report

    attributes =
      {
        items: [
          {id: 1, title: 'New Title', description: 'New Description'}
        ]
      }

    ReportUpdater.execute user, report.id, attributes

    item.reload
    item.should have_attributes title: 'New Title', description: 'New Description'
  end

  it 'deletes missing items' do
    report = create :morning_report, user: user
    item = create :report_item, id: 1, title: 'Title', description: 'Description', report: report
    attributes = {items: []}

    expect do
      ReportUpdater.execute user, report.id, attributes
    end.to change(report.items, :count).by -1
  end

  it 'deletes morning report if all items are deleted from it' do
    report = create :morning_report, user: user
    item = create :report_item, id: 1, title: 'Title', description: 'Description', report: report
    attributes = {items: []}

    expect do
      ReportUpdater.execute user, report.id, attributes
    end.to change(Report, :count).by -1
  end
end
