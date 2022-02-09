class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices

  def self.search(search_term)
    where("name ILIKE ?", "%#{search_term}%")
  end
end
