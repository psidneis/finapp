json.array!(@launches) do |launch|
  json.extract! launch, :id, :title, :description, :value, :date, :paid, :launchable_id, :launchable_type, :recurrence_type, :amount_installment, :recurrence, :type, :category_id, :user_id
  json.url launch_url(launch, format: :json)
end
