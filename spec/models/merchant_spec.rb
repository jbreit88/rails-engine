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

  describe 'class methods' do
    describe '::search' do
      let!(:merchant_1) { Merchant.create!(name: 'Teddy Bears') }
      let!(:merchant_2) { Merchant.create!(name: 'Michael Stewart') }
      let!(:merchant_3) { Merchant.create!(name: 'Infinininiout Burger') }
      let!(:merchant_4) { Merchant.create!(name: 'Silly Things') }
      let!(:merchant_5) { Merchant.create!(name: 'Things r Us') }

      it 'returns results for full name search' do
        expect(Merchant.search('Things r Us')).to match_array([merchant_5])
      end

      it 'returns results for full name search with random capitalization' do
        expect(Merchant.search('ThINgs R Us')).to match_array([merchant_5])
      end

      it 'returns results for partial matches' do
        expect(Merchant.search('Thing')).to match_array([merchant_4, merchant_5])
      end

      it 'returns results in alphabetic order' do
        expect(Merchant.search('Thing')).to match_array([merchant_4, merchant_5])
        expect(Merchant.search('Thing').first).to eq(merchant_4)
        expect(Merchant.search('Thing').last).to eq(merchant_5)
      end
    end
  end
end
