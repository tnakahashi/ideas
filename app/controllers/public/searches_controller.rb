class Public::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザ"
      @customers = Customer.looks(params[:search], params[:word]).where.not(is_deleted: true)
    else
      customer_ids = Customer.where(is_deleted: true).pluck(:id)
      # 新着・いいね・コメント数順の並び替え
      if params[:target] == "favorite"
        @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.looks(params[:search], params[:word]).sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
      elsif params[:target] == 'comment'
        @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.looks(params[:search], params[:word]).sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
      else
        @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.looks(params[:search], params[:word]).order(created_at: :desc)
      end
    end
  end
end
