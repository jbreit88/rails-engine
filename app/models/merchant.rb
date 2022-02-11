class Merchant < ApplicationRecord
  validates_presence_of :name

  has_many :items
  has_many :invoices
  has_many :invoice_items, through: :invoices

  def self.search(search_term)
    # Searches for the merchant name by partial case-insensitive search
    where('name ILIKE ?', "%#{search_term}%").order(:name)
  end
end
