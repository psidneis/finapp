require 'rails_helper'

RSpec.describe UserGroup, type: :model do
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_presence_of(:group) }
    it { is_expected.to validate_presence_of(:email) }
    # it { is_expected.to validate_uniqueness_of(:group).scoped_to(:email) }
    it { is_expected.to validate_length_of(:email).is_at_least(3).is_at_most(100)  }
    # it { is_expected.to validate_email_of(:email) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:role) }
  end

end
