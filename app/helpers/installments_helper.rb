module InstallmentsHelper

	def format_title_recurrence(installment)
		if installment.launch.recurrence?
			"#{installment.title} - #{t("activerecord.attributes.launch.recurrence_types.#{installment.launch.recurrence_type}")}"
		elsif installment.launch.installments?
			"#{installment.title} #{installment.number_installment}/#{installment.launch.amount_installment}"
    else
      installment.title
		end
	end

end
