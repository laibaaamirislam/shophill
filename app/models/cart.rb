
# app/models/cart.rb
class Cart < ApplicationRecord
  belongs_to :customer, optional: :true
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  def total_cents
    cart_items.sum { |i| i.quantity * i.product.price_cents }
  end
end

