require 'rails_helper'

RSpec.describe Account, type: :model do

  describe '#value' do 
    subject { create(:account) }

    it "does converting to bigdecimal" do
      expect(subject.value).to eq(1589.95)
    end
  end

end
