# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
User.create(name: 'Finapp Admin', email: 'finapp.fatec@gmail.com', password: Rails.application.secrets.messages_email_password)
user = User.create(name: 'Sidnei Pereira', email: 'p.sidneis@gmail.com', password: '123456')
user2 = User.create(name: 'Éverton Braz', email: 'evertonb_rocha@hotmail.com', password: '123456')
user3 = User.create(name: 'Lucas Oliveira', email: 'lucas.oliveira2609@gmail.com', password: '123456')

Category.create(user: user, title: 'Alimentação', description: 'Gastos com Alimentação', color: '#d91717')
Category.create(user: user, title: 'Moradia', description: 'Gastos com Moradia', color: '#390e0e')
Category.create(user: user, title: 'Educação', description: 'Gastos com Educação', color: '#2c63a8')
Category.create(user: user, title: 'Grupo', description: 'Gastos com Grupo', color: '#0d1a2a')
Category.create(user: user2, title: 'Alimentação', description: 'Gastos com Alimentação', color: '#d91717')
Category.create(user: user2, title: 'Moradia', description: 'Gastos com Moradia', color: '#390e0e')
Category.create(user: user2, title: 'Educação', description: 'Gastos com Educação', color: '#2c63a8')
Category.create(user: user2, title: 'Grupo', description: 'Gastos com Grupo', color: '#0d1a2a')

account = Account.create(user: user, account_type: 1, title: 'Caixa', description: 'Valor conta corrente', value: BigDecimal.new('2200'))
account2 = Account.create(user: user, account_type: 2, title: 'Caixa Poupança', description: 'Valor conta oupança', value: BigDecimal.new('4000'))
account3 = Account.create(user: user, account_type: 0, title: 'Carteira', description: 'Valor em carteira', value: BigDecimal.new('300'))
account4 = Account.create(user: user2, account_type: 1, title: 'Bradesco', description: 'Valor conta corrente', value: BigDecimal.new('2200'))
account5 = Account.create(user: user2, account_type: 0, title: 'Carteira', description: 'Valor em carteira', value: BigDecimal.new('300'))

Card.create(user: user, brand: 0, title: 'Master Caixa', credit_limit: BigDecimal.new('2000'), billing_day: 10, payment_day: 15, account: account)
Card.create(user: user, brand: 0, title: 'Visa Caixa Poupança', credit_limit: BigDecimal.new('1000'), billing_day: 10, payment_day: 15, account: account2)
Card.create(user: user, brand: 0, title: 'C&A', credit_limit: BigDecimal.new('500'), billing_day: 10, payment_day: 15)
Card.create(user: user2, brand: 0, title: 'Visa Electron', credit_limit: BigDecimal.new('2000'), billing_day: 10, payment_day: 15, account: account4)

group = Group.create(user: user, title: 'Fatec', description: 'Grupo da fatec para despesas')
group2 = Group.create(user: user, title: 'Família', description: 'Grupo da família para despesas')
group3 = Group.create(user: user, title: 'Trabalho', description: 'Grupo da trabalho para despesas')
group4 = Group.create(user: user2, title: 'Fatec', description: 'Grupo da fatec para despesas')
group5 = Group.create(user: user2, title: 'Família', description: 'Grupo da família para despesas')
group6 = Group.create(user: user2, title: 'Trabalho', description: 'Grupo da trabalho para despesas')

UserGroup.create(user: user, group: group, enabled: true, role: 0, email: user.email)
UserGroup.create(user: user2, group: group, enabled: true, role: 1, email: user2.email)
UserGroup.create(user: user3, group: group, enabled: true, role: 1, email: user3.email)
UserGroup.create(user: user, group: group4, enabled: true, role: 0, email: user.email)
UserGroup.create(user: user2, group: group4, enabled: true, role: 1, email: user2.email)
UserGroup.create(user: user3, group: group4, enabled: true, role: 1, email: user3.email)
