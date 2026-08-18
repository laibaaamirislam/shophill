
# app/models/customer.rb

class Customer < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :password, confirmation: true, allow_blank: true
  normalizes :email, with: ->(e) { e.strip.downcase }

  has_many :orders, dependent: :destroy
  has_one :cart, dependent: :destroy
end

