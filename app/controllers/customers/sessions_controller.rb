# app/controllers/customers/sessions_controller.rb
module Customers
  class SessionsController < ApplicationController
    def new; end

    def create
      customer = Customer.find_by(email: params[:email]&.downcase)
      if customer&.authenticate(params[:password])
        session[:customer_id] = customer.id
        redirect_to root_path, notice: "Logged in"
      else
        flash.now[:alert] = "Invalid email or password"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session.delete(:customer_id)
      redirect_to root_path, notice: "Logged out"
    end
  end
end