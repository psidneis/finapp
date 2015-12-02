json.array!(@invoices) do |invoice|
  json.extract! invoice, :id, :billing_day, :datetime,, :value, :decimal,, :paid
  json.url invoice_url(invoice, format: :json)
end
