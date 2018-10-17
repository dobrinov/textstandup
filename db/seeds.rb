simpsons = Team.create! name: 'The Simpsons'

homer  = User.create! email: 'homer@example.com',  first_name: 'Homer',  last_name: 'Simpson', password: 'qweqwe'
marge  = User.create! email: 'marge@example.com',  first_name: 'Marge',  last_name: 'Simpson', password: 'qweqwe'
bart   = User.create! email: 'bart@example.com',   first_name: 'Bart',   last_name: 'Simpson', password: 'qweqwe'
lisa   = User.create! email: 'lisa@example.com',   first_name: 'Lisa',   last_name: 'Simpson', password: 'qweqwe'
maggie = User.create! email: 'maggie@example.com', first_name: 'Maggie', last_name: 'Simpson', password: 'qweqwe'

Membership.create! user: homer, team: simpsons, admin: true
Membership.create! user: marge, team: simpsons
Membership.create! user: bart, team: simpsons
Membership.create! user: lisa, team: simpsons
Membership.create! user: maggie, team: simpsons
