require 'rails_helper'

RSpec.describe Card, type: :model do
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:brand) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:credit_limit) }
    it { is_expected.to validate_presence_of(:billing_day) }
    it { is_expected.to validate_presence_of(:payment_day) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user_id) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_numericality_of(:credit_limit) }
    it { is_expected.to validate_numericality_of(:billing_day).only_integer.is_greater_than_or_equal_to(1).is_less_than_or_equal_to(30) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:brand) }
  end

end
