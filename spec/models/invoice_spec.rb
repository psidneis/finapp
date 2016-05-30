require 'rails_helper'

RSpec.describe Invoice, type: :model do

	describe '#gettings invoice installments' do
		let(:invoice) do
			card = create(:card_with_installments)
			FactoryGirl.create(:invoice, card: card)
		end

		subject do
			invoice.installments
		end

		it 'does get the invoice intallments' do
			expect(subject).not_to be_empty
		end
	end

end