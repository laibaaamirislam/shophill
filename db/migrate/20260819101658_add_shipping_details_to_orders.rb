class AddShippingDetailsToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :shipping_address, :string
    add_column :orders, :city, :string
    add_column :orders, :postal_code, :string
    add_column :orders, :phone, :string
  end
end
