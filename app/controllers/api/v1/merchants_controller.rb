class Api::V1::MerchantsController < ApplicationController
  def index
    @merchants = MerchantSerializer.new(Merchant.all)
    json_response(@merchants)
  end

  def show
    @merchant = MerchantSerializer.new(Merchant.find(params[:id]))
    json_response(@merchant)
  end
end
