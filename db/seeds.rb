# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
User.create(name: 'Finapp Admin', email: 'finapp.fatec@gmail.com', password: Rails.application.secrets.messages_email_password)
User.create(name: 'Sidnei Pereira', email: 'p.sidneis@gmail.com', password: '123456')
User.create(name: 'Éverton Braz', email: 'evertonb_rocha@hotmail.com', password: '123456')
User.create(name: 'Lucas Oliveira', email: 'lucas.oliveira2609@gmail.com', password: '123456')
