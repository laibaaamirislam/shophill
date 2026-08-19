module Admin
  class DashboardController < BaseController
    def index
      @total_revenue_cents = Order.where(status: ["completed", "shipped"]).sum(:total_cents)
      @total_orders = Order.count
      @pending_orders_count = Order.where(status: "pending").count
      @total_customers = Customer.count
      @low_stock_products = Product.where("stock_quantity <= ?", 5).order(stock_quantity: :asc)
      @recent_orders = Order.includes(:customer).order(created_at: :desc).limit(5)
    end
  end
end