context 'getting invoice installments' do
	subject(:invoice) do
		Invoice.new(title: "Fatura de junho de 2016", card_id: 6, payment_day: 8)
	end

	before

	it 'does get the invoice intallments' do
		expect(invoice.installments).not_to be_empty
	end
end