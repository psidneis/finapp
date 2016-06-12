require 'rails_helper'

RSpec.describe Installment, type: :model do
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_presence_of(:date) }
    it { is_expected.to validate_presence_of(:number_installment) }
    it { is_expected.to validate_presence_of(:launch) }
    it { is_expected.to validate_presence_of(:user) }
    it { is_expected.to validate_numericality_of(:value) }
    it { is_expected.to validate_numericality_of(:number_installment).only_integer.is_greater_than_or_equal_to(1) }
    # it { is_expected.to validate_validate_mandatory_updates_group_of(:value) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:launch_type) }
    # it { is_expected.to define_enum_for(:update_options) }
    # it { is_expected.to define_enum_for(:cancel_options) }
  end

end
