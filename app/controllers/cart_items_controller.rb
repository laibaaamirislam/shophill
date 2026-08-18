# app/controllers/cart_items_controller.rb
class CartItemsController < ApplicationController
  before_action :require_customer_login
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(product: product)
    @cart_item.quantity = (@cart_item.quantity || 0) + (params[:quantity]&.to_i || 1)

    if @cart_item.save
      redirect_to cart_path, notice: "Added #{product.name} to your cart."
    else
      redirect_to product_path(product), alert: "Unable to add item to cart."
    end
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    
    # Extract quantity whether passed nested (params[:cart_item][:quantity]) or flat (params[:quantity])
    new_quantity = (params[:cart_item] ? params[:cart_item][:quantity] : params[:quantity]).to_i

    if new_quantity <= 0
      @cart_item.destroy
      redirect_to cart_path, notice: "Item removed from cart."
    else
      # Ensure requested quantity does not exceed available stock
      max_stock = @cart_item.product.stock_quantity
      final_quantity = [new_quantity, max_stock].min

      if @cart_item.update(quantity: final_quantity)
        redirect_to cart_path, notice: "Cart updated successfully."
      else
        redirect_to cart_path, alert: "Could not update cart item."
      end
    end
  end

  def destroy
    @cart_item = @cart.cart_items.find(params[:id])
    @cart_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def set_cart
    @cart = Current.customer.cart || Current.customer.create_cart!
  end
end