company = Company.create! name: 'The Simpsons'

homer  = User.create! email: 'homer@example.com',  first_name: 'Homer',  last_name: 'Simpson', password: 'qweqwe'
marge  = User.create! email: 'marge@example.com',  first_name: 'Marge',  last_name: 'Simpson', password: 'qweqwe'
bart   = User.create! email: 'bart@example.com',   first_name: 'Bart',   last_name: 'Simpson', password: 'qweqwe'
lisa   = User.create! email: 'lisa@example.com',   first_name: 'Lisa',   last_name: 'Simpson', password: 'qweqwe'
maggie = User.create! email: 'maggie@example.com', first_name: 'Maggie', last_name: 'Simpson', password: 'qweqwe'

Employment.create! user: homer, company: company, admin: true
Employment.create! user: marge, company: company
Employment.create! user: bart, company: company
Employment.create! user: lisa, company: company
Employment.create! user: maggie, company: company

Subscription.create! follower: homer, followee: marge

Report.create! do |report|
  report.user = marge
  report.type = MorningReport

  OngoingReportItem.create! title: 'Libero mollis ultricies',
                            description: 'Lorem ipsum dolor sit amet, ipsum egestas quo, mauris consequat nulla sed aliquet lacinia morbi, ullamcorper in turpis et lacinia curabitur sit, rutrum malesuada duis purus morbi. Enim sed sed volutpat enim, id consectetuer, lorem feugiat semper montes eget facilisis.',
                            report: report

  PlannedReportItem.create! title: 'Libero mollis ultricies',
                            description: 'Lorem ipsum dolor sit amet, blandit fusce ornare feugiat eros, dictum magnam nisl eu pellentesque erat nulla, ac non magna sollicitudin, viverra donec. Facilisis sit lacus tellus ut aliquam, id suspendisse lacus qui felis, pellentesque massa pharetra lacinia.',
                            report: report

  BlockerReportItem.create! title: 'Non id vestibulum',
                            description: 'Lorem ipsum dolor sit amet, et vestibulum sit leo elementum eget, sed lobortis at diam porttitor etiam et, non metus eros elit, sem aliquam, enim dui leo neque augue elit mauris. Fermentum velit metus penatibus, nibh semper.',
                            report: report

  AnnouncementReportItem.create! title: 'Tristique dictumst imperdiet',
                                 description: 'Lorem ipsum dolor sit amet, a turpis eleifend. Dui posuere neque sollicitudin quisquam dui, eget pede, aliquet donec sit voluptatum nec bibendum, non vitae sem sed quam est.',
                                 report: report
end

Report.create! do |report|
  report.user = homer
  report.type = MorningReport

  OngoingReportItem.create! title: 'Sed convallis dapibus',
                            description: 'Lorem ipsum dolor sit amet, vestibulum eget et, magna fames mattis ante, sed erat suspendisse erat wisi aliquam. Sapien ante molestie at eu nunc justo.',
                            report: report

  PlannedReportItem.create! title: 'Pellentesque porta ultrices',
                            description: 'Lorem ipsum dolor sit amet, lectus sit. Aliquam libero lorem.',
                            report: report
end

Report.create! do |report|
  report.user = homer
  report.type = MorningReport
  report.created_at = 1.day.ago

  OngoingReportItem.create! title: 'Lectus donec fusce',
                            description: 'Lorem ipsum dolor sit amet, arcu enim bibendum fermentum fringilla nunc vehicula. Elit consectetuer aenean est, wisi non massa libero imperdiet, integer blandit mollis purus porttitor vitae, porta semper adipiscing, interdum netus leo lectus viverra.',
                            report: report
end

Report.create! do |report|
  report.user = bart
  report.type = MorningReport
  report.created_at = 1.day.ago

  OngoingReportItem.create! title: 'Bart\'s yesterdays task',
                            description: 'This is a task in progress',
                            report: report
end
