require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }    
    it { is_expected.to validate_presence_of(:payment_day) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_numericality_of(:value) }
  end

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