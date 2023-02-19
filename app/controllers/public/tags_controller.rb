class Public::TagsController < ApplicationController
  def index
  end

  # def show
  #   # 退会済みの会員の投稿を非表示に
  #   customer_ids = Customer.where(is_deleted: true).pluck(:id)
  #   # 新着・いいね・コメント数順の並び替え
  #   if params[:target] == "favorite"
  #     @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
  #   elsif params[:target] == 'comment'
  #     @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
  #   else
  #     @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.order(created_at: :desc)
  #   end
    
  #   # タグ検索用
  #   if params[:tag_ids]
  #     if params[:type] == "OR検索"
  #       @posts = []
  #       params[:tag_ids].each do |key, value|
  #         @posts += Tag.find_by(name: key).posts.where.not(customer_id: customer_ids).published if value == "1"
  #       end
  #       @posts.uniq!
  #     else
  #       @posts = []
  #       params[:tag_ids].each do |key, value|
  #         if value == "1"
  #           tag_posts = Tag.find_by(name: key).posts.where.not(customer_id: customer_ids).published
  #           @posts = @posts.empty? ? tag_posts : @posts & tag_posts
  #         end
  #       end
  #     end
  #   end
  # end
end
