class Admin::SearchesController < ApplicationController
  def search
    @range = params[:range]
    @word = params[:word]

    if @range == "ユーザ"
      @customers = Customer.looks(params[:search], params[:word])
    else
      # 新着・いいね・コメント数順の並び替え
      if params[:target] == "favorite"
        @posts = Post.where(is_deleted: false).published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
      elsif params[:target] == 'comment'
        @posts = Post.where(is_deleted: false).published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
      else
        @posts = Post.where(is_deleted: false).published.order(created_at: :desc)
      end
    end
  end
end
