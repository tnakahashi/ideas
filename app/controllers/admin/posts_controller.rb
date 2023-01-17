class Admin::PostsController < ApplicationController
  def index
    @all_posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:genre_id, :image, :title, :introduction, :selling_point, :detail)
    end
end
