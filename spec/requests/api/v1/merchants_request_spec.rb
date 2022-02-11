require 'rails_helper'

RSpec.describe 'The Merchants API' do
  let!(:merchants_list) { create_list(:merchant, 5) }
  let(:merchant_id) { merchants_list.first.id }

  context 'GET /merchants' do
    context 'when there are records' do
      it 'returns a list of merchants' do
        get '/api/v1/merchants'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq 5
        expect(response).to have_http_status(200)

        merchants[:data].each do |merchant|
          expect(merchant).to have_key(:id)
          expect(merchant[:id]).to be_an(String)

          expect(merchant[:attributes]).to have_key(:name)
          expect(merchant[:attributes][:name]).to be_a(String)
        end
      end
    end

    context 'when there are no records' do
      let!(:merchants_list) { '' }

      it 'returns an empty array' do
        get '/api/v1/merchants'

        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data]).to be_a(Array)
        expect(merchants[:data]).to be_empty
      end
    end
  end

  context 'GET /merchants/:id' do
    before { get "/api/v1/merchants/#{merchant_id}" }

    context 'when record exists' do
      it 'returns the merchant' do
        merchant = JSON.parse(response.body, symbolize_names: true)
        expect(merchant.count).to eq 1
        expect(response).to have_http_status(200)

        expect(merchant[:data]).to have_key(:id)
        expect(merchant[:data][:id]).to be_an(String)

        expect(merchant[:data][:attributes]).to have_key(:name)
        expect(merchant[:data][:attributes][:name]).to be_a(String)
      end
    end

    context 'when the record does not exist' do
      let(:merchant_id) { 1000 }

      it 'returns error code and message' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end

  describe 'GET /api/v1/merchants/find_all' do
    let!(:new_merchant_1) { create(:merchant, name: 'Axe Slinging Fun Times') }
    let!(:new_merchant_2) { create(:merchant, name: 'Timers R Us') }

    context 'when a full name is passed' do
      before { get '/api/v1/merchants/find_all', params: { name: 'Axe Slinging Fun Times' } }

      it 'returns a list of merchants with that name' do
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(1)
        expect(merchants[:data][0][:attributes][:name]).to eq('Axe Slinging Fun Times')
        expect(response).to have_http_status(200)
      end
    end

    context 'when a partial term is passed' do
      before { get '/api/v1/merchants/find_all', params: { name: 'time' } }

      it 'returns merchants with the term in their name' do
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(2)
        expect(response).to have_http_status(200)

        merchants[:data].each do |merchant|
          expect(merchant[:attributes][:name].downcase.include?('time')).to be true
        end
      end

      it 'returns the merchants in alphabetical order' do
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(200)

        expect(merchants[:data].first[:attributes][:name]).to eq(new_merchant_1.name)
        expect(merchants[:data].last[:attributes][:name]).to eq(new_merchant_2.name)
      end
    end

    context 'when invalid parameters are passed' do
      it 'throws an error for incomplete parameters' do
        get '/api/v1/merchants/find_all?name='

        expect(response).to have_http_status(400)
        expect(response.body).to match(/params error/)
      end
    end
  end

  describe 'GET /api/v1/merchants/find' do
    let!(:new_merchant_1) { create(:merchant, name: 'Slippery Dave') }

    context 'when a full name is passed' do
      before { get '/api/v1/merchants/find', params: { name: 'Slippery Dave' } }

      it 'returns a single merchant with that name' do
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(1)
        expect(merchants[:data][0][:attributes][:name]).to eq('Slippery Dave')
        expect(response).to have_http_status(200)
      end
    end

    context 'when a partial term is passed' do
      let!(:new_merchant_2) { create(:merchant, name: 'Slip n Slide') }

      before { get '/api/v1/merchants/find', params: { name: 'SlI' } }

      it 'returns the first merchant that matches that partial search' do
        merchants = JSON.parse(response.body, symbolize_names: true)

        expect(merchants[:data].count).to eq(1)
        expect(response).to have_http_status(200)
        expect(merchants[:data][0][:attributes][:name]).to eq(new_merchant_2.name)

        merchants[:data].each do |merchant|
          expect(merchant[:attributes][:name].downcase.include?('sli')).to be true
        end
      end

      context 'when invalid parameters are passed' do
        it 'throws an error for incomplete parameters' do
          get '/api/v1/merchants/find?name='

          expect(response).to have_http_status(400)
          expect(response.body).to match(/params error/)
        end
      end
    end
  end
end
