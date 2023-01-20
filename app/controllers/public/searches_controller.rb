class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザ"
      @customers = Customer.looks(params[:search], params[:word])
    else
      @posts = Post.looks(params[:search], params[:word]).where(is_deleted: false).published
    end
  end
end
