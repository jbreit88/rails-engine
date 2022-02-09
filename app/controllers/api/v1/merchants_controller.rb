class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = MerchantSerializer.new(Merchant.all)
    json_response(@merchants)
  end

  def show
    @merchant = MerchantSerializer.new(Merchant.find(params[:id]))
    json_response(@merchant)
  end

  def find_all
    search_term = params[:name]
    @merchants = MerchantSerializer.new(Merchant.search(search_term))

    json_response(@merchants)
  end

  def find
    search_term = params[:name]
    @merchant = MerchantSerializer.new(Merchant.search(search_term).limit(1))

    json_response(@merchant)
  end
end
