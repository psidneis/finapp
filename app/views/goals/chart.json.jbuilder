json.array!(@goals) do |goal|
  json.extract! goal, :id, :value
  total_value = goal.calculate_total_period(@start_date, @end_date)
  json.installment_value total_value
  json.title goal.category.title
  json.format_total_value number_to_currency(total_value)
end