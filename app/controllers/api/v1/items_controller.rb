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
    elsif Merchant.find(params[:merchant_id]).nil?
      json_response({ message: e.message }, 404)
    end
  end

  def destroy
    @item = Item.find(params[:id])

    @item.invoices.each do |invoice|
      # require "pry"; binding.pry
      invoice.destroy if invoice.invoice_items.count <= 1
    end

    @item.destroy

    json_response(@item, 204)
  end

  def find
    if params[:name] && params[:min_price] || params[:name] && params[:max_price]
      json_response({ error: 'params error - please only search for name or price' }, 400)
    elsif params[:name].nil? && params[:min_price].nil? && params[:max_price].nil?
      json_response({ error: 'params error - please submit a query for search' }, 400)
    elsif params[:name] == '' || params[:min_price] == '' || params[:max_price] == ''
      json_response({ error: 'params error - query cannot be empty' }, 400)
    else
      search_terms = { name: params[:name], min_price: params[:min_price], max_price: params[:max_price] }
      @item = ItemSerializer.new(Item.search(search_terms).limit(params[:limit]))

      json_response(@item)
    end
  end

  private

  def item_params
    params.permit(:name, :description, :unit_price, :merchant_id)
  end
end
