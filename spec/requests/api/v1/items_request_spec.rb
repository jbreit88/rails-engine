require 'rails_helper'

RSpec.describe 'The Items API' do
  let!(:items_list) { create_list(:item, 10) }
  let(:item_id) { items_list.first.id }

  describe 'GET /items' do
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

  describe 'GET /items/:id' do
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

  describe 'POST /items' do
    let!(:merchant) { Merchant.create(name: 'Sellthings')}

    let(:valid_attributes) { { name: 'New Item', description: 'This is an item', unit_price: 12.12, merchant_id: merchant.id } }

    context 'when the request is valid' do
      before { post '/api/v1/items', params: valid_attributes }

      it 'creates an item' do
        item = JSON.parse(response.body, symbolize_names: true)

        expect(item.count).to eq 1
        expect(response).to have_http_status(201)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_an(String)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq('New Item')

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq('This is an item')

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        expect(item[:data][:attributes][:unit_price]).to eq(12.12)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    context 'when uneccessary params are passed' do
      let(:valid_attributes_and_extra) { { name: 'New Item', description: 'This is an item', unit_price: 12.12, merchant_id: merchant.id, title: 'something' } }

      before { post '/api/v1/items', params: valid_attributes_and_extra }

      it 'ignores invalid params' do
        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).not_to have_key(:title)
      end
    end

    context 'when request is invalid' do
      before { post '/api/v1/items', params: { name: 'thing'} }

      it 'returns an error message and status' do
        expect(response).to have_http_status(422)
        expect(response.body).to match(/Validation failed:/)
      end
    end
  end

  describe 'PUT /api/v1/items/:id' do
    context 'when the record exists' do
      let!(:merchant) { Merchant.create(name: 'Sellthings')}

      let(:valid_attributes) { {name: 'Updated Name', description: 'Updated description', unit_price: 13.13, merchant_id: merchant.id } }

      before { put "/api/v1/items/#{item_id}", params: valid_attributes}

      it 'updates the record and returns success code' do

        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_an(String)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq('Updated Name')

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq('Updated description')

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)
        expect(item[:data][:attributes][:unit_price]).to eq(13.13)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
        expect(item[:data][:attributes][:merchant_id]).to eq(merchant.id)
      end
    end

    context 'when bad merchant_id is passed' do
      let(:bad_id) { {name: 'Updated Name', description: 'Updated description', unit_price: 13.13, merchant_id: '12345678' } }

      before { put "/api/v1/items/#{item_id}", params: bad_id}

      it 'returns error message and status' do
        # require "pry"; binding.pry
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end

    context 'when no merchant id is passed' do
      let(:valid_attributes) { {name: 'Updated Name', description: 'Updated description' } }

      before { put "/api/v1/items/#{item_id}", params: valid_attributes}

      it 'updates the record and returns success code' do

        item = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(item[:data]).to have_key(:id)
        expect(item[:data][:id]).to be_an(String)

        expect(item[:data][:attributes]).to have_key(:name)
        expect(item[:data][:attributes][:name]).to be_a(String)
        expect(item[:data][:attributes][:name]).to eq('Updated Name')

        expect(item[:data][:attributes]).to have_key(:description)
        expect(item[:data][:attributes][:description]).to be_a(String)
        expect(item[:data][:attributes][:description]).to eq('Updated description')

        expect(item[:data][:attributes]).to have_key(:unit_price)
        expect(item[:data][:attributes][:unit_price]).to be_a(Float)

        expect(item[:data][:attributes]).to have_key(:merchant_id)
        expect(item[:data][:attributes][:merchant_id]).to be_a(Integer)
      end
    end
  end
end
