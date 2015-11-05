module InstallmentsHelper

	def check_recurrence(installment)
		if installment.launch.recurrence?
			t("activerecord.attributes.launch.recurrence_types.#{installment.launch.recurrence_type}")
		else
			"#{installment.number_installment} / #{installment.launch.amount_installment}"
		end
		
	end

end
