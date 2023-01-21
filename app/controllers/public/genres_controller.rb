class Public::GenresController < ApplicationController

  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.find(params[:id])
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published
  end

end
