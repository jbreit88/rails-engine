class Api::V1::ItemsController < ApplicationController

  def index
    @items = ItemSerializer.new(Item.all)
    json_response(@items)
  end

  def show
    @item = ItemSerializer.new(Item.find(params[:id]))
    json_response(@item)
  end
end
