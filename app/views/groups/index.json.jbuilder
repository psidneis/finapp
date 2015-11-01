json.array!(@groups) do |group|
  json.extract! group, :id, :title, :description, :manager_id
  json.url group_url(group, format: :json)
end
