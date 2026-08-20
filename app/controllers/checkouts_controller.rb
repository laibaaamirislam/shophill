
class CheckoutsController < ApplicationController
  before_action :require_customer_login
  before_action :set_cart

  def new
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    customer = Current.customer

    @order = customer.orders.build(
      shipping_address: customer.address,
      city: customer.city,
      postal_code: customer.postal_code,
      phone: customer.phone
    )
  end

  def create
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    total_cents = @cart.cart_items.sum { |item| item.product.price_cents.to_i * item.quantity }

    @order = Current.customer.orders.build(order_params)
    @order.total_cents = total_cents
    @order.status = "pending"

    if @order.save
      line_items = @cart.cart_items.map do |item|
        {
          price_data: {
            currency: "usd",
            product_data: { name: item.product.name },
            unit_amount: item.product.price_cents.to_i
          },
          quantity: item.quantity
        }
      end

      session = Stripe::Checkout::Session.create(
        payment_method_types: ["card"],
        line_items: line_items,
        mode: "payment",
        customer_email: Current.customer.email,
        client_reference_id: @order.id,
        success_url: success_checkouts_url + "?session_id={CHECKOUT_SESSION_ID}",
        cancel_url: cancel_checkouts_url
      )

      @cart.cart_items.each do |item|
        @order.order_items.create!(
          product: item.product,
          quantity: item.quantity,
          unit_price_cents: item.product.price_cents
        )
      end

      @order.update!(stripe_session_id: session.id)

      # Added status: :see_other for external POST redirects
      redirect_to session.url, allow_other_host: true, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  rescue Stripe::StripeError => e
    redirect_to cart_path, alert: "Payment error: #{e.message}"
  end

  def success
    @session = Stripe::Checkout::Session.retrieve(params[:session_id])
    @order = Order.find_by(stripe_session_id: @session.id)
  end

  def cancel
    redirect_to cart_path, alert: "Checkout was cancelled."
  end

  private

  def set_cart
    @cart = Current.customer&.cart
  end

  def order_params
    params.require(:order).permit(:shipping_address, :city, :postal_code, :phone)
  end
end