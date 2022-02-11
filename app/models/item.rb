class Item < ApplicationRecord
  validates_presence_of :name, :description, :merchant_id
  validates :unit_price, numericality: { greater_than: 0 }

  belongs_to :merchant
  has_many :invoice_items, dependent: :destroy
  has_many :invoices, through: :invoice_items

  def self.search(search_terms)
    # searches for name/partial name
    if search_terms[:name]
      where('name ILIKE ?', "%#{search_terms[:name]}%").order(:name)

    # searches for items in between the min and max values
    elsif search_terms[:min_price] && search_terms[:max_price]
      where('unit_price > ? and unit_price < ?', search_terms[:min_price], search_terms[:max_price]).order(:unit_price)

    # searches for items that are greater than value
    elsif search_terms[:min_price]
      where('unit_price > ?', search_terms[:min_price]).order(:unit_price)

    # searches for items that are less than value
    elsif search_terms[:max_price]
      where('unit_price < ?', search_terms[:max_price]).order(unit_price: :desc)
    end
  end
end
