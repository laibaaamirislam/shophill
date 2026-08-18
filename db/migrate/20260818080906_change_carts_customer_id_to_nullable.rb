
class ChangeCartsCustomerIdToNullable < ActiveRecord::Migration[8.1]
  def change
    change_column_null :carts, :customer_id, true
  end
end