# app/controllers/customers/registrations_controller.rb
module Customers
  class RegistrationsController < ApplicationController
    def new
      @customer = Customer.new
    end

    def create
      @customer = Customer.new(customer_params)
      if @customer.save
        @customer.create_cart!
        session[:customer_id] = @customer.id
        redirect_to root_path, notice: "Welcome!"
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def customer_params
      params.require(:customer).permit(:name, :email, :password, :password_confirmation)
    end
  end
end