module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:edit, :update, :destroy, :toggle_active]

    def index
      @products = Product.includes(:category, images_attachments: :blob)
                         .order(created_at: :desc)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_products_path, notice: "Product '#{@product.name}' created successfully!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: "Product '#{@product.name}' updated successfully!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def toggle_active
      @product.toggle!(:active)
      status = @product.active? ? "activated and restored to the storefront" : "archived and hidden"
      redirect_to admin_products_path, notice: "Product '#{@product.name}' was #{status}."
    end

    def destroy
      @product.update(active: false)
      redirect_to admin_products_path, notice: "Product '#{@product.name}' was archived."
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      # Note images: [] permits multiple file uploads
      params.require(:product).permit(:name, :description, :price_cents, :stock_quantity, :category_id, :active, images: [])
    end
  end
end