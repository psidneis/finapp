require 'rails_helper'

RSpec.describe Group, type: :model do
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user_id) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(100) }
  end

end
