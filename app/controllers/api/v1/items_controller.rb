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

  def destroy
    @item = Item.find(params[:id])

    @item.invoices.each do |invoice|
      # require "pry"; binding.pry
      if invoice.invoice_items.count <= 1
        invoice.destroy
      end
    end

    @item.destroy

    json_response(@item, 204)
  end

  def find_all
    search_term = params[:name]
    @items = ItemSerializer.new(Item.search(search_term))

    json_response(@items)
  end

  def find
    search_term = params[:name]
    @item = ItemSerializer.new(Item.search(search_term).limit(1))

    json_response(@item)
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
