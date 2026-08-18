# app/controllers/admin/sessions_controller.rb
module Admin
  class SessionsController < ApplicationController
    layout "admin"

    def new; end

    def create
      admin = AdminUser.find_by(email: params[:email]&.downcase)
      if admin&.authenticate(params[:password])
        session[:admin_id] = admin.id
        redirect_to admin_root_path, notice: "Logged in"
      else
        flash.now[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:admin_id)
      redirect_to admin_login_path
    end
  end
end