# app/controllers/checkouts_controller.rb
class CheckoutsController < ApplicationController
  before_action :require_customer_login
  before_action :set_cart, only: [:new, :create]

  def new
    if @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
    end
  end

  def create
    if @cart.cart_items.empty?
      return redirect_to cart_path, alert: "Your cart is empty."
    end

    ActiveRecord::Base.transaction do
      @order = Current.customer.orders.create!(
        status: "pending",
        total_cents: @cart.total_cents
      )

      @cart.cart_items.each do |item|
        @order.order_items.create!(
          product: item.product,
          quantity: item.quantity,
          unit_price_cents: item.product.price_cents
        )

        item.product.update!(
          stock_quantity: item.product.stock_quantity - item.quantity
        )
      end

      @cart.cart_items.destroy_all
    end

    redirect_to checkout_path(@order), notice: "Order placed successfully!"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to cart_path, alert: "Could not process order: #{e.message}"
  end

  def show
    @order = Current.customer.orders.find(params[:id])
  end

  private

  def set_cart
    @cart = Current.customer.cart || Current.customer.create_cart!
  end
end