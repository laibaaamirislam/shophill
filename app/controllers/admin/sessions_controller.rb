
# app/controllers/admin/sessions_controller.rb
class Admin::SessionsController < ApplicationController
  layout "admin"

  def new; end

  def create
    admin = AdminUser.find_by(email: params[:email]&.strip&.downcase)
    if admin&.authenticate(params[:password])
      session[:admin_id] = admin.id
      redirect_to admin_products_path, notice: "Logged in successfully"
    else
      flash.now[:alert] = "Invalid email or password"
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:admin_id)
    Current.admin = nil
    redirect_to new_admin_session_path, notice: "Logged out successfully"
  end
end