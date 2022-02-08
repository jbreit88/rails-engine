require 'rails_helper'

RSpec.describe 'The Items API' do
  let!(:items_list) { create_list(:item, 10) }
  let(:item_id) { items_list.first.id }

  context 'GET /items' do
    context 'when there are records' do
      it 'returns a list of items' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq 10
        expect(response).to have_http_status(200)

        items[:data].each do |item|
          expect(item).to have_key(:id)
          expect(item[:id]).to be_an(String)

          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes][:name]).to be_a(String)

          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes][:description]).to be_a(String)

          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes][:unit_price]).to be_a(Float)

          expect(item[:attributes]).to have_key(:merchant_id)
          expect(item[:attributes][:merchant_id]).to be_a(Integer)
        end
      end
    end

    context 'when there are no records' do
      let!(:items_list) { '' }

      it 'returns an empty array' do
        get '/api/v1/items'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data]).to be_a(Array)
        expect(items[:data]).to be_empty
      end
    end
  end

  context 'GET /items/:id' do
    before { get "/api/v1/items/#{item_id}" }

    context 'when record exists' do
      it 'returns the item' do
        item = JSON.parse(response.body, symbolize_names: true)
        expect(item.count).to eq 1
        expect(response).to have_http_status(200)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_an(String)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
      end
    end

    context 'when the record does not exist' do
      let(:item_id) { 1000 }

      it 'returns error code and message' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end
end
