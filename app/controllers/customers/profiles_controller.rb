# app/controllers/customers/profiles_controller.rb
module Customers
  class ProfilesController < ApplicationController
    before_action :require_customer_login
    before_action :set_customer

    def show; end

    def update
      if @customer.update(customer_params)
        redirect_to profile_path, notice: "Profile updated successfully!"
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_customer
      @customer = Current.customer
    end

    def customer_params
      params.require(:customer).permit(:name, :email, :phone, :address, :city, :postal_code)
    end
  end
end