# app/controllers/admin/orders_controller.rb
class Admin::OrdersController < Admin::BaseController
  before_action :set_order, only: [:show, :update]

  def index
    @orders = Order.includes(:customer).order(created_at: :desc).paginate(page: params[:page], per_page: 20)
  end

  def show; end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: "Order status updated to #{@order.status.titleize}."
    else
      redirect_to admin_order_path(@order), alert: "Failed to update order status."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end