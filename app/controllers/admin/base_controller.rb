
# app/controllers/admin/base_controller.rb
class Admin::BaseController < ApplicationController
  layout "admin"
  before_action :require_admin_login

  private

  def require_admin_login
    unless Current.admin
      redirect_to new_admin_session_path, alert: "Admin login required"
    end
  end
end

