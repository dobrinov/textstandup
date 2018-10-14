team = Team.create! name: 'The Simpsons'

homer  = User.create! email: 'homer@example.com',  first_name: 'Homer',  last_name: 'Simpsons', password: 'qweqwe'
marge  = User.create! email: 'marge@example.com',  first_name: 'Marge',  last_name: 'Simpsons', password: 'qweqwe'
bart   = User.create! email: 'bart@example.com',   first_name: 'Bart',   last_name: 'Simpsons', password: 'qweqwe'
lisa   = User.create! email: 'lisa@example.com',   first_name: 'Lisa',   last_name: 'Simpsons', password: 'qweqwe'
maggie = User.create! email: 'maggie@example.com', first_name: 'Maggie', last_name: 'Simpsons', password: 'qweqwe'

team.members << homer
team.members << marge
team.members << bart
team.members << lisa
team.members << maggie

team.admins << homer 
