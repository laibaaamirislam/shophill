# # app/controllers/checkouts_controller.rb
# class CheckoutsController < ApplicationController
#   before_action :require_customer_login
#   before_action :set_cart, only: [:new, :create]

#   def new
#     if @cart.cart_items.empty?
#       redirect_to cart_path, alert: "Your cart is empty."
#     end
#   end

#   def create
#     if @cart.cart_items.empty?
#       return redirect_to cart_path, alert: "Your cart is empty."
#     end

#     ActiveRecord::Base.transaction do
#       @order = Current.customer.orders.create!(
#         status: "pending",
#         total_cents: @cart.total_cents
#       )

#       @cart.cart_items.each do |item|
#         @order.order_items.create!(
#           product: item.product,
#           quantity: item.quantity,
#           unit_price_cents: item.product.price_cents
#         )

#         item.product.update!(
#           stock_quantity: item.product.stock_quantity - item.quantity
#         )
#       end

#       @cart.cart_items.destroy_all
#     end

#     redirect_to checkout_path(@order), notice: "Order placed successfully!"
#   rescue ActiveRecord::RecordInvalid => e
#     redirect_to cart_path, alert: "Could not process order: #{e.message}"
#   end

#   def show
#     @order = Current.customer.orders.find(params[:id])
#   end

#   private

#   def set_cart
#     @cart = Current.customer.cart || Current.customer.create_cart!
#   end
# end

class CheckoutsController < ApplicationController
  before_action :require_customer_login
  before_action :set_cart

  def new
    if @cart.nil? || @cart.cart_items.empty?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    @order = Current.customer.orders.build
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