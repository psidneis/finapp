require 'rails_helper'

RSpec.describe Invoice, type: :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }    
    it { is_expected.to validate_presence_of(:payment_day) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_numericality_of(:value) }
  end

end