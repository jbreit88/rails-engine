class Api::V1::MerchantItemsController < ApplicationController
  def index
    merchant = Merchant.find(params[:id])
    @items = ItemSerializer.new(merchant.items)

    render json: @items
    # json_response(@items)
  end
end
