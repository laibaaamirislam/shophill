class Product < ApplicationRecord
  belongs_to :category
  has_many_attached :images
  has_many :cart_items, dependent: :destroy

  validates :name, :price_cents, presence: true
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }

  def price
    price_cents / 100.0
  end
end