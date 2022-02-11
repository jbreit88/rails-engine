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

  describe 'class methods' do
    let!(:merchant) { Merchant.create!(name: 'Things and Things') }
    let!(:item_1) { merchant.items.create!(name: 'Cell Phone', description: 'Makes calls', unit_price: 100.00) }
    let!(:item_2) { merchant.items.create!(name: 'Watch', description: 'Tells time', unit_price: 150.00) }
    let!(:item_3) { merchant.items.create!(name: 'Pocket book', description: 'Holds things', unit_price: 110.00) }
    let!(:item_4) { merchant.items.create!(name: 'Pocket watch', description: 'Tells time in your pocket', unit_price: 120.00) }
    let!(:item_5) { merchant.items.create!(name: 'Television', description: 'watch it', unit_price: 300.00) }
    describe '::search' do
      it 'returns items by a full name search' do
        expect(Item.search({ name: 'PoCket BooK' })).to match_array([item_3])
      end

      it 'returns all items by a partial search' do
        expect(Item.search({ name: 'PoC' })).to match_array([item_3, item_4])
      end

      it 'returns results in alphabetic order' do
        expect(Item.search({ name: 'watch' }).count).to eq(2)
        expect(Item.search({ name: 'watch' }).first).to eq(item_4)
        expect(Item.search({ name: 'watch' }).last).to eq(item_2)
      end

      it 'returns all items greater than value' do
        expect(Item.search({ min_price: 119.00 })).to match_array([item_2, item_4, item_5])
      end

      it 'returns items from least to most expensive' do
        expect(Item.search({ min_price: 119.00 }).count).to eq(3)
        expect(Item.search({ min_price: 119.00 }).first).to eq(item_4)
        expect(Item.search({ min_price: 119.00 }).last).to eq(item_5)
      end

      it 'returns all items less than value' do
        expect(Item.search({ max_price: 115.00 })).to match_array([item_1, item_3])
      end

      it 'returns items from most to least expensive' do
        expect(Item.search({ max_price: 115.00 }).count).to eq(2)
        expect(Item.search({ max_price: 115.00 }).first).to eq(item_3)
        expect(Item.search({ max_price: 115.00 }).last).to eq(item_1)
      end

      it 'returns all items between min and max values' do
        expect(Item.search({ min_price: 115.00, max_price: 125.00 })).to match_array([item_4])
      end

      it 'returns all items between min and max values' do
        expect(Item.search({ min_price: 109.00, max_price: 151.00 })).to match_array([item_2, item_3, item_4])
        expect(Item.search({ min_price: 109.00, max_price: 151.00 }).count).to eq(3)
        expect(Item.search({ min_price: 109.00, max_price: 151.00 }).first).to eq(item_3)
        expect(Item.search({ min_price: 109.00, max_price: 151.00 }).last).to eq(item_2)
      end
    end
  end
end
