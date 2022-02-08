class InvoiceItem < ApplicationRecord
  validates_presence_of :item_id, :invoice_id, :quantity, :unit_price

  belongs_to :invoice
  belongs_to :item
end
