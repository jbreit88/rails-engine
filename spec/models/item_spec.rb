require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:description) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
    it { should validate_presence_of(:merchant_id) }
  end

  describe 'relationships' do
    it { should belong_to(:merchant) }
    it { should have_many(:invoice_items).dependent(:destroy) }
    it { should have_many(:invoices).through(:invoice_items) }
  end

  describe 'factory' do
    it 'can create a factory with name, description, unit_price and merchant_id' do
      item = create(:item, name: 'Thing', description: 'It does a thing', unit_price: 1.75)

      expect(item).to be_a(Item)
      expect(item).to have_attributes(name: 'Thing')
      expect(item).to have_attributes(description: 'It does a thing')
      expect(item).to have_attributes(unit_price: 1.75)
      expect(item.merchant).to be_a(Merchant)
    end
  end
end
