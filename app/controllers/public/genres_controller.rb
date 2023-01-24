class Public::GenresController < ApplicationController

  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.find(params[:id])
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @posts = Post.where(genre_id: params[:id], is_deleted: false).where.not(customer_id: customer_ids).published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @posts = Post.where(genre_id: params[:id], is_deleted: false).where.not(customer_id: customer_ids).published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @posts = Post.where(genre_id: params[:id], is_deleted: false).where.not(customer_id: customer_ids).published.order(created_at: :desc)
    end
  end

end
