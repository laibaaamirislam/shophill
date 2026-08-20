
class Invoice < ApplicationRecord
  belongs_to :order

  validates :stripe_checkout_session_id, presence: true, uniqueness: true

  def amount
    (amount_cents || 0) / 100.0
  end
end