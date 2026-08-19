class AddProfileFieldsToCustomers < ActiveRecord::Migration[8.1]
  def change
    add_column :customers, :phone, :string
    add_column :customers, :address, :string
    add_column :customers, :city, :string
    add_column :customers, :postal_code, :string
  end
end
