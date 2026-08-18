# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
  
  before_action :set_current_customer
  before_action :set_current_admin

  private

  def set_current_customer
    Current.customer = Customer.find_by(id: session[:customer_id])
  end

  def set_current_admin
    Current.admin = AdminUser.find_by(id: session[:admin_id])
  end

  def require_customer_login
    redirect_to login_path, alert: "Please log in" unless Current.customer
  end
end
