
class CheckoutsController < ApplicationController
  before_action :require_customer_login
  before_action :set_cart

  def new
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    customer = Current.customer

    # Pre-fill order fields using saved profile information
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

    # Wrap order placement in a transaction to safely deduct stock
    ActiveRecord::Base.transaction do
      total_cents = @cart.cart_items.sum { |item| item.product.price_cents.to_i * item.quantity }
      
      @order = Current.customer.orders.build(order_params)
      @order.total_cents = total_cents
      @order.status = "pending"

      if @order.save
        @cart.cart_items.each do |item|
          # Verify stock again before committing
          if item.quantity > item.product.stock_quantity.to_i
            raise ActiveRecord::Rollback, "Insufficient stock for #{item.product.name}"
          end

          @order.order_items.create!(
            product: item.product,
            quantity: item.quantity,
            unit_price_cents: item.product.price_cents
          )

          # Deduct purchased inventory
          item.product.update!(stock_quantity: item.product.stock_quantity - item.quantity)
        end

        # Empty cart after order is confirmed
        @cart.cart_items.destroy_all

        redirect_to order_path(@order), notice: "Order placed successfully!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  rescue ActiveRecord::Rollback => e
    redirect_to cart_path, alert: e.message
  end

  private

  def set_cart
    @cart = Current.customer.cart
  end

  def order_params
    params.require(:order).permit(:shipping_address, :city, :postal_code, :phone)
  end
end