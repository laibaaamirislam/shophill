class CreateInvoices < ActiveRecord::Migration[8.1]
  def change
    create_table :invoices do |t|
      t.references :order, null: false, foreign_key: true
      t.string :stripe_invoice_id
      t.string :status
      t.integer :amount_cents

      t.timestamps
    end
  end
end
