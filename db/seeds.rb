# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

	user = User.create(email: 'finapp.fatec@gmail.com', password: Rails.application.secrets.messages_email_password)
	role = Role.create(title: 'Admin', description: 'Administrador do sistema')
	user_role = UserRole.create(user: user, role: role, enabled: true)

	User.create(email: 'p.sidneis@gmail.com', password: '123456', password_confirmation: '123456')
