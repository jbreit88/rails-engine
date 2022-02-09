require 'rails_helper'

RSpec.describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
  end

  describe 'relationships' do
    it { should have_many(:invoices) }
    it { should have_many(:items) }
  end

  describe 'factory' do
    it 'can create a factory with name' do
      merchant = create(:merchant, name: 'Seller of things')

      expect(merchant).to be_a(Merchant)
      expect(merchant).to have_attributes(name: 'Seller of things')
    end
  end
end
