require 'rails_helper'

describe ReportUpdater do
  it 'creates a new item' do
    report = create :report

    items = [{title: 'Title', description: 'Description', type: 'OngoingReportItem'}]

    expect do
      ReportUpdater.execute report, items
    end.to change(report.items, :count).by 1
  end

  it 'updates changed existing items' do
    report = create :report
    item = create :report_item, id: 1, title: 'Title', description: 'Description', report: report
    items = [{id: 1, title: 'New Title', description: 'New Description'}]

    ReportUpdater.execute report, items

    item.reload
    item.should have_attributes title: 'New Title', description: 'New Description'
  end

  it 'deletes missing items' do
    report = create :report
    item = create :report_item, id: 1, title: 'Title', description: 'Description', report: report

    expect do
      ReportUpdater.execute report, []
    end.to change(report.items, :count).by -1
  end

  it 'deletes morning report if all items are deleted from it' do
    report = create :report
    item = create :report_item, id: 1, title: 'Title', description: 'Description', report: report

    expect do
      ReportUpdater.execute report, []
    end.to change(Report, :count).by -1
  end
end
