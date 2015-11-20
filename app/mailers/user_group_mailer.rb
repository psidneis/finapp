class UserGroupMailer < ApplicationMailer

  def invite_user_to_group(user, user_group)
    @user = user
    @user_group = user_group
    @group = @user_group.group
    mail(to: @user_group.email, subject: 'FinApp - Solicitação para Grupo')
  end

end
