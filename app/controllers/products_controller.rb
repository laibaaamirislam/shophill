class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.where(active: true)
                       .order(created_at: :desc)
                       .paginate(page: params[:page], per_page: 12)

    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end
  end

  def show
    @product = Product.where(active: true).find(params[:id])
  end
end