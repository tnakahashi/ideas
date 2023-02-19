class Admin::PostsController < ApplicationController
  
  def index
    # タグ検索用
    if params[:tag_ids] == nil || params[:tag_ids].include?("null") 
      @posts = Post.published.order(created_at: :desc)
    else
      if params[:tag_ids].class == String
        params[:tag_ids] = JSON.parse(params[:tag_ids])
      end
      if params[:type] == "OR検索"
        @posts = []
        params[:tag_ids].each do |key, value|
          @posts += Tag.find_by(name: key).posts.published if value == "1"
        end
        @posts.uniq!
      else
        @posts = []
        params[:tag_ids].each do |key, value|
          if value == "1"
            tag_posts = Tag.find_by(name: key).posts.published
            @posts = @posts.empty? ? tag_posts : @posts & tag_posts
          end
        end
      end
    end
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @posts = @posts.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @posts = @posts.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @posts
    end
  end

  def show
    @post = Post.find(params[:id])
  end
  
  def hide
    @post = Post.find(params[:id])
    @post.update(is_deleted: true)
    redirect_to request.referer
  end

  def display
    @post = Post.find(params[:id])
    @post.update(is_deleted: false)
    redirect_to request.referer
  end

  def customer_posts
    @customer = Customer.find(params[:customer_id])
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @customer_posts = Post.where(customer_id: params[:customer_id]).published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @customer_posts = Post.where(customer_id: params[:customer_id]).published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @customer_posts = Post.where(customer_id: params[:customer_id]).published.order(created_at: :desc)
    end
  end
  

  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:genre_id, :image, :title, :introduction, :selling_point, :detail)
    end
end
