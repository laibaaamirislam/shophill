# app/models/order.rb
class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_items, dependent: :destroy
  has_one :invoice, dependent: :destroy

  enum :status, { pending: "pending", paid: "paid", shipped: "shipped", cancelled: "cancelled", completed: "completed" }
end