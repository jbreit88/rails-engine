class Api::V1::ItemMerchantController < ApplicationController
  def index
    item = Item.find(params[:id])
    @merchant = MerchantSerializer.new(Merchant.find(item.merchant_id))

    json_response(@merchant)
  end
end
