# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	user = User.create(name: 'Finapp Admin', email: 'finapp.fatec@gmail.com', password: Rails.application.secrets.messages_email_password, confirmed_at: Time.now)
	role = Role.create(title: 'Admin', description: 'Administrador do sistema')
	user_role = UserRole.create(user: user, role: role, enabled: true)

	User.create(name: 'Sidnei Pereira', email: 'p.sidneis@gmail.com', password: '123456', confirmed_at: Time.now)
	User.create(name: 'Éverton Braz', email: 'evertonb_rocha@hotmail.com', password: '123456', confirmed_at: Time.now)
