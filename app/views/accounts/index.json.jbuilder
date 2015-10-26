json.array!(@accounts) do |account|
  json.extract! account, :id, :type, :title, :description, :value, :user_id
  json.url account_url(account, format: :json)
end
