# User.create(email: 'admin@email.com', password: '123123', confirmed_at: DateTime.now, role: '2')
user = User.new(email: 'admin@email.com', password: '123123', confirmed_at: DateTime.now, role: '2')
profile = user.build_profile(first_name: 'Admin', last_name: 'Admin')
user.save!
