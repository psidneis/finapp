json.array!(@cards) do |card|
  json.extract! card, :id, :brand, :title, :credit_limit, :billing_day, :payment_day, :account_id
  json.url card_url(card, format: :json)
end
