# app/controllers/customers/accounts_controller.rb
module Customers
  class AccountsController < ApplicationController
    before_action :require_customer_login

    def edit
      @customer = Current.customer
    end

    def update
      if Current.customer.update(account_params)
        redirect_to edit_account_path, notice: "Account updated"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def account_params
      params.require(:customer).permit(:name, :email, :password, :password_confirmation).compact_blank
    end
  end
end