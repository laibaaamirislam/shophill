class CartsController < ApplicationController
  before_action :require_customer_login

  def show
    @cart = Current.customer.cart || Current.customer.create_cart!
  end
end