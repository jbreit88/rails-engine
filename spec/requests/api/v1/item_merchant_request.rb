require 'rails_helper'

RSpec.describe 'The MerchantItems API' do
  let!(:merchants_list) { create_list(:merchant, 2) }
  let(:merchant_id) { merchants_list.first.id }

  let!(:item_1) { Item.create!(name: 'thing', description: 'does a thing', unit_price: 3.45, merchant_id: merchant_id)}
  let(:item_id) { item_1.id }

  describe 'GET /api/v1/items/:id/merchant' do
    before { get "/api/v1/items/#{item_id}/merchant" }

    context 'when there is an associated merchant record' do
      it 'returns merchant information for the associated item' do
        item_merchant = JSON.parse(response.body, symbolize_names: true)

        expect(item_merchant.count).to eq(1)
        expect(response).to have_http_status(200)


        expect(item_merchant[:data][:attributes]).to have_key(:name)
      end
    end
  end
end
