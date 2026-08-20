class AddStripeDetailsToInvoices < ActiveRecord::Migration[8.1]
  def change
    add_column :invoices, :stripe_checkout_session_id, :string
    add_column :invoices, :stripe_payment_intent_id, :string
    add_column :invoices, :customer_email, :string
  end
end
