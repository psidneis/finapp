json.array!(@categories) do |category|
  json.extract! category, :title, :color
  json.total_value number_to_currency(category.total_category)
  json.percentage (category.total_category * 100) / @total_period
end