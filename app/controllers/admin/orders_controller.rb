module Admin
  class OrdersController < BaseController
    before_action :set_order, only: [:show, :update]

    def index
      @status = params[:status]
      @orders = Order.includes(:customer).order(created_at: :desc)
      @orders = @orders.where(status: @status) if @status.present? && @status != "all"
    end

    def show
      @order_items = @order.order_items.includes(:product)
    end

    def update
      if @order.update(order_params)
        redirect_to admin_order_path(@order), notice: "Order ##{@order.id} updated to #{@order.status.capitalize}."
      else
        render :show, status: :unprocessable_entity
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
end