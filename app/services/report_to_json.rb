module ReportToJson
  extend self

  def execute(report, viewer, edited: false)
    {
      id: report.id,
      submit_path: submit_path(report),
      submit_method: submit_method(report),
      published_at: published_at(report, viewer),
      user: {
        initials: report.user.initials,
        full_name: report.user.full_name,
      },
      type: report.type,
      item_types: report.item_types,
      items: items(report),
      editable: report.user == viewer,
      edited: edited,
      locales: locales
    }.to_json
  end

  private

  def items(report)
    report.items.map do |item|
      {
        id: item.id,
        title: item.title,
        url: item.url,
        description: item.description,
        type: item.type,
      }
    end
  end

  def submit_path(report)
    if report.persisted?
      Rails.application.routes.url_helpers.report_path(id: report.id)
    else
      Rails.application.routes.url_helpers.reports_path
    end
  end

  def submit_method(report)
    report.persisted? ? :patch : :post
  end

  def published_at(report, viewer)
    report.persisted? ? report.created_at.in_time_zone(viewer.time_zone).strftime('%d %b %Y at %l:%M%p') : nil
  end

  def locales
    {
      'DeliveredReportItem' => {
        heading: 'Delivered',
        title: {
          placeholder: 'Summarize what was delivered'
        },
        url: {
          placeholder: 'Link to place containing more information about the task'
        },
        description: {
          placeholder: 'Provide some information on what was delivered and what was the need for it'
        },
        newItem: {
          tooltip: 'Add a completed item'
        }
      },
      'OngoingReportItem' => {
        heading: 'Current progress',
        title: {
          placeholder: 'Few words describing the task on which you are working'
        },
        url: {
          placeholder: 'Link to place containing more information about the task'
        },
        description: {
          placeholder: 'What is your progress on this task and what is left of it?'
        },
        newItem: {
          tooltip: 'Add a task in progress'
        }
      },
      PlannedReportItem: {
        heading: 'Plan for the day',
        title: {
          placeholder: 'Few words describing the task on which you are planning to work'
        },
        url: {
          placeholder: 'Link to place containing more information about the task'
        },
        description: {
          placeholder: 'What do you plan to achieve today?'
        },
        newItem: {
          tooltip: 'Add a planned task'
        }
      },
      BlockerReportItem: {
        heading: 'Blockers',
        title: {
          placeholder: 'Few words describing a blocked task'
        },
        url: {
          placeholder: 'Link to place containing more information about the task'
        },
        description: {
          placeholder: 'What is blocking your progress and what needs to happen to unblock it?'
        },
        newItem: {
          tooltip: 'Add a blocker'
        }
      },
      AnnouncementReportItem: {
        heading: 'Announcements',
        title: {
          placeholder: 'Few words summarising your announcement e.g. "Vacation"'
        },
        url: {
          placeholder: 'Link to place containing more information about the task'
        },
        description: {
          placeholder: 'What do you want to announce?'
        },
        newItem: {
          tooltip: 'Add an announcement'
        }
      }
    }
  end
end
