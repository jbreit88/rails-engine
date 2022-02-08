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
      let (:merchant_id) { 1000 }

      it 'returns error code and message' do
        expect(response).to have_http_status(404)
        expect(response.body).to match(/Couldn't find Merchant/)
      end
    end
  end
end
