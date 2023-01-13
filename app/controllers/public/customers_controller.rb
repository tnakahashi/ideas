class Public::CustomersController < ApplicationController
  def show
    @customer = Custmer.find(params[:id])
    @posts = @customer.posts
  end

  def edit
  end
end
