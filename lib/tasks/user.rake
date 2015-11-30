namespace :user do

  desc "notify user to installment due"
  task :notify_user_to_installment_due => :environment do
    Installment.notify_user_to_installment_due
  end

end