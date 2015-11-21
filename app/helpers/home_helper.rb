module HomeHelper

	def date_format  
		date_format = l(@search_period, format: :long_day_month_year) if @search_period_type == 'day'
		date_format = l(@search_period, format: :long_month_year) if @search_period_type == 'month'
		date_format = "#{l(@start_date, format: :long_week_month)} à #{l(@end_date, format: :long_week_month)}" if @search_period_type == 'week'
		date_format = "#{l(@start_date.to_date, format: :default)} à #{l(@end_date.to_date, format: :default)}" if @search_period_type == 'period'
		date_format
	end

end
