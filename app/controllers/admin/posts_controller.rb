class Admin::PostsController < ApplicationController
  def index
    @all_posts = Post.published
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
