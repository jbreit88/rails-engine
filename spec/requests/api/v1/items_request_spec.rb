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

      it 'returns error code and message' do # sad path
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Item/)
      end
    end
  end

  describe 'POST /items' do
    let!(:merchant) { Merchant.create(name: 'Sellthings') }

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
      let(:valid_attributes_and_extra) do
        { name: 'New Item', description: 'This is an item', unit_price: 12.12, merchant_id: merchant.id, title: 'something' }
      end

      before { post '/api/v1/items', params: valid_attributes_and_extra }

      it 'ignores invalid params' do
        item = JSON.parse(response.body, symbolize_names: true)

        expect(item[:data]).not_to have_key(:title)
      end
    end

    context 'when request is invalid' do # sad path
      before { post '/api/v1/items', params: { name: 'thing' } }

      it 'returns an error message and status' do
        expect(response).to have_http_status(422)
        expect(response.body).to match(/Validation failed:/)
      end
    end
  end

  describe 'PUT /api/v1/items/:id' do
    context 'when the record exists' do
      let!(:merchant) { Merchant.create(name: 'Sellthings') }

      let(:valid_attributes) { { name: 'Updated Name', description: 'Updated description', unit_price: 13.13, merchant_id: merchant.id } }

      before { put "/api/v1/items/#{item_id}", params: valid_attributes }

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

    context 'when bad merchant_id is passed' do # sad path
      let(:bad_id) { { name: 'Updated Name', description: 'Updated description', unit_price: 13.13, merchant_id: '12345678' } }

      before { put "/api/v1/items/#{item_id}", params: bad_id }

      it 'returns error message and status' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end

    context 'when no merchant id is passed' do
      let(:valid_attributes) { { name: 'Updated Name', description: 'Updated description' } }

      before { put "/api/v1/items/#{item_id}", params: valid_attributes }

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

  describe 'DELETE /api/v1/item/:id' do
    it 'returns status code 204 and deletes other dependent data' do
      merchant = Merchant.create!(name: 'Silly Things')

      item_1 = Item.create!(name: 'An Item', description: 'It does things', unit_price: 10.50, merchant_id: merchant.id)
      item_2 = Item.create!(name: 'Another Item', description: 'It does other things', unit_price: 10.50, merchant_id: merchant.id)

      customer = Customer.create!(first_name: 'Bob', last_name: 'Keely')

      invoice_1 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id)

      invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, quantity: 2, unit_price: item_1.unit_price)

      invoice_2 = Invoice.create!(customer_id: customer.id, merchant_id: merchant.id)

      invoice_item_2 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_2.id, quantity: 2, unit_price: item_1.unit_price)
      invoice_item_3 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_2.id, quantity: 2, unit_price: item_2.unit_price)

      delete "/api/v1/items/#{item_1.id}"

      expect(response).to have_http_status(204)
      expect(response.body).to be_empty
      expect(Item.where(id: item_1.id)).not_to exist

      expect(InvoiceItem.where(id: invoice_item_1.id)).not_to exist
      expect(InvoiceItem.where(id: invoice_item_2.id)).not_to exist
      expect(InvoiceItem.where(id: invoice_item_3.id)).to exist

      expect(Invoice.where(id: invoice_1.id)).not_to exist
      expect(Invoice.where(id: invoice_2.id)).to exist
    end
  end

  describe 'GET /api/v1/items/find_all' do
    let!(:new_item_1) { create(:item, name: 'Test Item', unit_price: 4.55) }
    let!(:new_item_2) { create(:item, name: 'tasertestic Thing', unit_price: 1000.78) }

    context 'when a full name is passed' do
      before { get '/api/v1/items/find_all', params: { name: 'Test Item' } }

      it 'returns a list of items with that name' do
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(1)
        expect(items[:data][0][:attributes][:name]).to eq('Test Item')
        expect(response).to have_http_status(200)
      end
    end

    context 'when a partial term is passed' do
      before { get '/api/v1/items/find_all', params: { name: 'test' } }

      it 'returns items with the term in their name' do
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(2)
        expect(response).to have_http_status(200)

        items[:data].each do |item|
          expect(item[:attributes][:name].downcase.include?('test')).to be true
        end
      end

      it 'returns items in alphabetical order' do # edge case testing
        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)
        expect(items[:data].last[:attributes][:name]).to eq(new_item_2.name)
      end
    end

    context 'params are passed for price selection' do
      it 'returns all items with a unit price over 4.54' do
        get '/api/v1/items/find_all', params: { min_price: 4.54 }

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(items[:data].first[:attributes][:unit_price]).to eq(new_item_1.unit_price)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)

        items[:data].each do |item|
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes]).to have_key(:merchant_id)
        end

        expect(items[:data].count).to be >= 2
      end

      it 'returns all items with a unit price less than 1000.79' do
        get '/api/v1/items/find_all', params: { max_price: 1000.79 }

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(items[:data].first[:attributes][:unit_price]).to eq(new_item_2.unit_price)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_2.name)

        items[:data].each do |item|
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes]).to have_key(:merchant_id)
        end

        expect(items[:data].count).to be >= 2
      end

      it 'returns the items in range when both min_price and max_price parameters are sent' do
        get '/api/v1/items/find_all', params: { min_price: 4.54, max_price: 1000.79 }

        items = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(items[:data].first[:attributes][:unit_price]).to eq(new_item_1.unit_price)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)

        expect(items[:data].last[:attributes][:unit_price]).to eq(new_item_2.unit_price)
        expect(items[:data].last[:attributes][:name]).to eq(new_item_2.name)

        items[:data].each do |item|
          expect(item[:attributes]).to have_key(:name)
          expect(item[:attributes]).to have_key(:unit_price)
          expect(item[:attributes]).to have_key(:description)
          expect(item[:attributes]).to have_key(:merchant_id)
        end

        expect(items[:data].count).to be >= 2
      end

      it 'returns an error message when price and name params are passed together' do #edge case
        get '/api/v1/items/find_all', params: { name: 'test', min_price: 4.99, max_price: 11.76 }

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end

      it 'returns an error message when no params are passed' do #edge case
        get '/api/v1/items/find_all'

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end

      it 'returns an error message when a param is passed in without a value' do #edge case
        get '/api/v1/items/find_all?name='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)

        get '/api/v1/items/find_all?min_price='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)

        get '/api/v1/items/find_all?max_price='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end
    end
  end

  describe 'GET /api/v1/items/find' do
    let!(:new_item_1) { create(:item, name: 'Test Item', unit_price: 5.00) }
    let!(:new_item_2) { create(:item, name: 'tasertestic Thing', unit_price: 11.75) }

    context 'when a full name is passed' do
      before { get '/api/v1/items/find', params: { name: 'Test Item' } }

      it 'returns a single item with that name' do
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(1)
        expect(items[:data][0][:attributes][:name]).to eq('Test Item')
        expect(response).to have_http_status(200)
      end
    end

    context 'when a partial term is passed' do
      before { get '/api/v1/items/find', params: { name: 'test' } }

      it 'returns the first item that matches that partial search' do
        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(1)
        expect(response).to have_http_status(200)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)

        items[:data].each do |item|
          expect(item[:attributes][:name].downcase.include?('test')).to be true
        end
      end

      it 'returns an item when params are passed in the URI' do
        get '/api/v1/items/find?name=test'

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(1)
        expect(response).to have_http_status(200)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)

        items[:data].each do |item|
          expect(item[:attributes][:name].downcase.include?('test')).to be true
        end
      end
    end

    context 'params are passed for price selection' do
      it 'returns the first item with a unit price over 4.99' do
        get '/api/v1/items/find', params: { min_price: 4.99 }

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(1)
        expect(response).to have_http_status(200)
        expect(items[:data].first[:attributes][:unit_price]).to eq(new_item_1.unit_price)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)
      end

      it 'returns the first item with a unit price less than 11.76' do
        get '/api/v1/items/find', params: { max_price: 11.76 }

        items = JSON.parse(response.body, symbolize_names: true)
        expect(items[:data].count).to eq(1)
        expect(response).to have_http_status(200)
        expect(items[:data].first[:attributes][:unit_price]).to eq(new_item_2.unit_price)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_2.name)
      end

      it 'returns the cheapest item when both min_price and max_price parameters are sent' do
        get '/api/v1/items/find', params: { min_price: 4.99, max_price: 11.76 }

        items = JSON.parse(response.body, symbolize_names: true)

        expect(items[:data].count).to eq(1)
        expect(response).to have_http_status(200)
        expect(items[:data].first[:attributes][:unit_price]).to eq(new_item_1.unit_price)
        expect(items[:data].first[:attributes][:name]).to eq(new_item_1.name)
      end

      it 'returns an error message when price and name params are passed together' do #edge case
        get '/api/v1/items/find', params: { name: 'test', min_price: 4.99, max_price: 11.76 }

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end

      it 'returns an error message when no params are passed' do
        get '/api/v1/items/find'

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end

      it 'returns an error message when a param is passed in without a value' do
        get '/api/v1/items/find?name='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)

        get '/api/v1/items/find?min_price='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)

        get '/api/v1/items/find?max_price='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end
    end
  end
end
