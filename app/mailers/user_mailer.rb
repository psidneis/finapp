class UserMailer < ApplicationMailer

  def notify_user_to_installment_due(installment)
    @user = installment.user
    @installment = installment

    mail(to: @user.email, subject: "FinApp - #{I18n.t('models.notification.title_installment')}")
  end

end
