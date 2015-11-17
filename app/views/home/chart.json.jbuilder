json.array!(@categories) do |category|
  json.extract! category, :title, :color
  
  total_category = category.calculate_total_period(current_user, @search_period)
  json.total_value number_to_currency(total_category)
  json.percentage category.percentage_period(@total_period, total_category)
end