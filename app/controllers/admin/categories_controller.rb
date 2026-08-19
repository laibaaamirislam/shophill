
# class Admin::CategoriesController < Admin::BaseController
#   before_action :set_category, only: [:show, :edit, :update, :destroy]

#   def index
#     @categories = Category.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
#   end

#   def show
#     @products = @category.products.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
#   end

#   def new
#     @category = Category.new
#   end

#   def create
#     @category = Category.new(category_params)
#     if @category.save
#       redirect_to admin_categories_path, notice: "Category created successfully."
#     else
#       render :new, status: :unprocessable_entity
#     end
#   end

#   def edit; end

#   def update
#     if @category.update(category_params)
#       redirect_to admin_categories_path, notice: "Category updated successfully."
#     else
#       render :edit, status: :unprocessable_entity
#     end
#   end

#   def destroy
#     @category.destroy
#     redirect_to admin_categories_path, notice: "Category deleted successfully."
#   end

#   private

#   def set_category
#     @category = Category.find(params[:id])
#   end

#   def category_params
#     params.require(:category).permit(:name, :slug)
#   end
# end

module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: [:edit, :update, :destroy, :show]

    def index
      @categories = Category.left_joins(:products)
                            .select("categories.*, COUNT(products.id) AS products_count")
                            .group("categories.id")
                            .order(name: :asc)
    end

    def show
      @products = @category.products.order(created_at: :desc).paginate(page: params[:page], per_page: 20)
    end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)
      if @category.save
        redirect_to admin_categories_path, notice: "Category '#{@category.name}' created successfully!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category '#{@category.name}' updated successfully!"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if @category.products.any?
        redirect_to admin_categories_path, alert: "Cannot delete category with associated products."
      else
        @category.destroy
        redirect_to admin_categories_path, notice: "Category deleted successfully."
      end
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description)
    end
  end
end