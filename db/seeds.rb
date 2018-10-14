employee = User.create! email: 'employee@example.com', first_name: 'John', last_name: 'Doe', password: 'qweqwe'
team = Team.create! name: 'Navy Seals'

team.members << employee
team.admins << employee
