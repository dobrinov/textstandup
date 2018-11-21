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
