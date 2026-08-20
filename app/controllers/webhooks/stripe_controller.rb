module Webhooks
  class StripeController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def create
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
      endpoint_secret = Rails.application.credentials.dig(:stripe, :webhook_secret) || ENV["STRIPE_WEBHOOK_SECRET"]

      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError, Stripe::SignatureVerificationError
        return head :bad_request
      end

      case event.type
      when "checkout.session.completed"
        checkout_session = event.data.object
        fulfill_order(checkout_session)
      end

      head :ok
    end

    private

    def fulfill_order(checkout_session)
      order = Order.find_by(id: checkout_session.client_reference_id) || Order.find_by(stripe_session_id: checkout_session.id)
      return unless order

      # Idempotency guard: Stop execution if this order was already processed
      return if order.status == "paid"

      ActiveRecord::Base.transaction do
        order.update!(status: "paid")

        # Safely decrement stock quantity
        order.order_items.each do |item|
          item.product.decrement!(:stock_quantity, item.quantity) if item.product.stock_quantity.present?
        end

        # Clear cart items for the customer
        order.customer&.cart&.cart_items&.destroy_all

        # Create Invoice record
        Invoice.find_or_create_by!(stripe_checkout_session_id: checkout_session.id) do |inv|
          inv.order = order
          inv.stripe_payment_intent_id = checkout_session.payment_intent
          inv.stripe_invoice_id = checkout_session.invoice
          inv.amount_cents = checkout_session.amount_total
          inv.status = "paid"
          inv.customer_email = checkout_session.customer_details&.email || checkout_session.customer_email
        end
      end
    end
  end
end