class Admin::CustomersController < ApplicationController
    def index
      @all_customers = Customer.all
    end
end
