module ApplicationHelper

	def human_boolean(boolean)
    boolean ? t('simple_form.yes') : t('simple_form.yes')
	end

end
