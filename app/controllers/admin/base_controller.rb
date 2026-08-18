# app/controllers/admin/base_controller.rb
module Admin
  class BaseController < ApplicationController
    layout "admin"
    before_action :require_admin_login

    private

    def require_admin_login
      redirect_to admin_login_path, alert: "Admin login required" unless Current.admin
    end
  end
end