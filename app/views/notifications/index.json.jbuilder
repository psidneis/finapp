json.array!(@notifications) do |notification|
  json.extract! notification, :id, :user_id, :title, :description, :url, :check, :icon
  json.url notification_url(notification, format: :json)
end
