json.array!(@installments) do |installment|
  json.extract! installment, :id, :value, :date, :paid, :number_installment, :launch_id
  json.url installment_url(installment, format: :json)
end
