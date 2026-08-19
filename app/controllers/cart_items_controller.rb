class CartItemsController < ApplicationController
  before_action :require_customer_login
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    @cart_item = @cart.cart_items.find_or_initialize_by(product: product)

    add_quantity = params[:quantity]&.to_i || 1
    requested_quantity = (@cart_item.quantity || 0) + add_quantity

    if requested_quantity > product.stock_quantity.to_i
      redirect_back fallback_location: products_path, alert: "Cannot add more. Only #{product.stock_quantity} available in stock."
    else
      @cart_item.quantity = requested_quantity
      if @cart_item.save
        redirect_to cart_path, notice: "Added #{product.name} to your cart."
      else
        redirect_to product_path(product), alert: "Unable to add item to cart."
      end
    end
  end

  def update
    @cart_item = @cart.cart_items.find(params[:id])
    
    # Extract quantity whether passed nested (params[:cart_item][:quantity]) or flat (params[:quantity])
    new_quantity = (params[:cart_item] ? params[:cart_item][:quantity] : params[:quantity]).to_i
    max_stock = @cart_item.product.stock_quantity.to_i

    if new_quantity <= 0
      @cart_item.destroy
      redirect_to cart_path, notice: "Item removed from cart."
    elsif new_quantity > max_stock
      redirect_to cart_path, alert: "Cannot exceed available stock limit (#{max_stock})."
    else
      if @cart_item.update(quantity: new_quantity)
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