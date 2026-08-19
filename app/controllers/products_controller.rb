class ProductsController < ApplicationController
  def index
    @categories = Category.all
    @products = Product.all

    # Filter by category
    if params[:category_id].present?
      @products = @products.where(category_id: params[:category_id])
    end

    # Filter by search query
    if params[:query].present?
      @products = @products.where("name LIKE ?", "%#{params[:query]}%")
    end

    @products = @products.order(created_at: :desc)
  end

  def show
    @product = Product.find(params[:id])
  end
end