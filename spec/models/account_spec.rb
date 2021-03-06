require 'rails_helper'

RSpec.describe Account, type: :model do

  describe 'validations' do
    it { is_expected.to validate_presence_of(:account_type) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:value) }
    it { is_expected.to validate_uniqueness_of(:title).scoped_to(:user_id) }
    it { is_expected.to validate_length_of(:title).is_at_least(2).is_at_most(100) }
    it { is_expected.to validate_numericality_of(:value) }
  end

  describe 'enums' do
    it { is_expected.to define_enum_for(:account_type) }
  end

  describe '#value' do 
    subject { create(:account) }

    it "does converting to bigdecimal" do
      expect(subject.value).to eq(1589.95)
    end
  end

  describe '#human_model_name' do 

    it "does human model name" do
      expect(Account.human_model_name).to eq('Conta')
    end
  end

  describe '.sum_of_values' do 
    accounts = FactoryGirl.create_list(:account, 3, value: 150)

    it "does sum of values" do
      expect(Account.where(id: accounts.map(&:id)).sum_of_values).to eq(450.0)
    end
  end

  describe '.sum_of_values_by_period' do
    accounts = FactoryGirl.create_list(:account, 3, value: 150)

    it "does sum of values by period" do
      expect(Account.where(id: accounts.map(&:id)).sum_of_values_by_period(DateTime.now - 1.minute)).to eq(450)
    end
  end

  describe '#total_value_by_period' do
    account = FactoryGirl.create(:account, value: 500)
    FactoryGirl.create_list(:installment, 3, installmentable: account, user: account.user, value: 100, paid: true, date: DateTime.now + 1.minute)

    it "does return total value by a period" do
      expect(account.total_value_by_period(DateTime.now - 1.minute)).to eq(800)
    end
  end

end
