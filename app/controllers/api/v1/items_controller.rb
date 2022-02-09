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

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      @item.update(item_params)
      json_response(ItemSerializer.new(@item))
    elsif Merchant.find(params[:merchant_id]) == nil
      json_response({ message: e.message }, 404)
    end
  end


  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
