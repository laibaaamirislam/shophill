module Customers
  class SessionsController < ApplicationController
    def new; end

    def create
      email = (params.dig(:session, :email) || params[:email])&.strip&.downcase
      password = params.dig(:session, :password) || params[:password]

      customer = Customer.find_by(email: email)

      if customer&.authenticate(password)
        session[:customer_id] = customer.id
        redirect_to root_path, notice: "Logged in successfully!"
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