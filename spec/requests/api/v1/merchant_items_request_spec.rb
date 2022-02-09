require 'rails_helper'

RSpec.describe 'The MerchantItems API' do
  let!(:merchants_list) { create_list(:merchant, 2) }
  let(:merchant_id) { merchants_list.first.id }

  let!(:item_1) { Item.create!(name: 'thing', description: 'does a thing', unit_price: 3.45, merchant_id: merchant_id)}
  let!(:item_2) { Item.create!(name: 'button', description: 'buttons things', unit_price: 2.78, merchant_id: merchant_id)}
  let!(:item_3) { Item.create!(name: 'car', description: 'you drive it', unit_price: 100.98, merchant_id: merchant_id)}

  describe 'GET /api/v1/merchants/:id/items' do
    before { get "/api/v1/merchants/#{merchant_id}/items" }

    context 'when there are associated item records' do
      it 'returns a list of items associated with the merchant' do
        merchant_items = JSON.parse(response.body, symbolize_names: true)

        expect(merchant_items[:data].count).to eq(3)
        expect(response).to have_http_status(200)

        merchant_items[:data].each do |item|
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes]).to have_key(:merchant_id)
        end
      end
    end

    context 'when there are no associated item records' do
      it 'returns an empty array' do
        get "/api/v1/merchants/#{merchants_list.last.id}/items"
        merchant_items = JSON.parse(response.body, symbolize_names: true)

        expect(merchant_items[:data].count).to eq(0)
        expect(merchant_items[:data]).to be_empty
        expect(merchant_items[:data]).to be_a Array
        expect(response).to have_http_status(200)
      end
    end

    context 'when a string is passed for merchant id' do
      it 'returns an error message and status code' do
        get "/api/v1/merchants/string-instead-of-integer/items"
        merchant_items = JSON.parse(response.body, symbolize_names: true)

        require "pry"; binding.pry
        expect(response).to have_http_status(404)
      end
    end
  end
end
