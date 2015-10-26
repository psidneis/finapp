json.array!(@groups) do |group|
  json.extract! group, :id, :title, :description, :manager
  json.url group_url(group, format: :json)
end
