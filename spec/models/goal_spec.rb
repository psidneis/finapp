require 'rails_helper'

RSpec.describe Goal, type: :model do
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:category) }
    it { is_expected.to validate_presence_of(:value) }
    # it { is_expected.to validate_uniqueness_of(:category) }
    it { is_expected.to validate_numericality_of(:value) }
  end

end
