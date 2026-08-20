module Admin
  class SessionsController < ActionController::Base
    layout "admin"

    def new
      redirect_to admin_root_path if Current.admin
    end

    def create
      admin = AdminUser.find_by(email: params[:email]&.downcase&.strip)

      if admin&.authenticate(params[:password])
        session[:admin_id] = admin.id
        Current.admin = admin
        redirect_to admin_root_path, notice: "Welcome back, #{admin.name}!"
      else
        flash.now[:alert] = "Invalid email or password."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:admin_id)
      Current.admin = nil
      redirect_to admin_login_path, notice: "Logged out successfully"
    end
  end
end