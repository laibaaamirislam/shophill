# app/models/current.rb
class Current < ActiveSupport::CurrentAttributes
  attribute :customer, :admin
end