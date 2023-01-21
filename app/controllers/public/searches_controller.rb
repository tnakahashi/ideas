class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザ"
      @customers = Customer.looks(params[:search], params[:word]).where.not(is_deleted: true)
    else
      customer_ids = Customer.where(is_deleted: true).pluck(:id)
      @posts = Post.looks(params[:search], params[:word]).where(is_deleted: false).where.not(customer_id: customer_ids).published
    end
  end
end
