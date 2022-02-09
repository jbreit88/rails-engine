class Api::V1::ItemsController < ApplicationController
  def index
    @items = ItemSerializer.new(Item.all)
    json_response(@items)
  end

  def show
    @item = ItemSerializer.new(Item.find(params[:id]))
    json_response(@item)
  end

  def create
    @item = ItemSerializer.new(Item.create!(item_params))
    json_response(@item, :created)
  end


  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
