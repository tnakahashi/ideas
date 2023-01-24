class Admin::PostsController < ApplicationController
  
  def index
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @posts = Post.published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @posts = Post.published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @posts = Post.published.order(created_at: :desc)
    end
    
    # タグ検索用
    if params[:tag_ids]
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
    @customer_posts = Post.where(customer_id: params[:customer_id]).published
  end
  

  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:genre_id, :image, :title, :introduction, :selling_point, :detail)
    end
end
