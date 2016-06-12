require 'rails_helper'

RSpec.describe Launch, type: :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:recurrence_type) }
    it { is_expected.to validate_presence_of(:recurrence) }
    it { is_expected.to validate_presence_of(:launch_type) }
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_numericality_of(:value) }
    it { is_expected.to validate_numericality_of(:amount_installment).only_integer.is_greater_than_or_equal_to(1) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:recurrence_type) }
    it { is_expected.to define_enum_for(:recurrence) }
    it { is_expected.to define_enum_for(:launch_type) }
  end

end
