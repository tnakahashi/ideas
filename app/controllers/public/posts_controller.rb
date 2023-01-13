class Public::PostsController < ApplicationController
  def index
    @all_posts = Post.all
  end

  def show
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to root_path
  end

  def edit
  end


  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:title, :introduction, :selling_point, :detail)
    end
end
