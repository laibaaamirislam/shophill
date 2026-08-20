# app/controllers/orders_controller.rb
class OrdersController < ApplicationController
  before_action :require_customer_login

  def index
    @orders = Current.customer.orders.order(created_at: :desc).paginate(page: params[:page], per_page: 10)
  end

  def show
    @order = Current.customer.orders.includes(:order_items, :invoice).find(params[:id])
  end
end
