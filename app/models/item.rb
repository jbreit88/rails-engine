class Item < ApplicationRecord
  validates_presence_of :name, :description, :merchant_id
  validates :unit_price, numericality: { greater_than: 0 }

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items
end
