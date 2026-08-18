
# app/models/admin_user.rb
class AdminUser < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  normalizes :email, with: ->(e) { e.strip.downcase }
end