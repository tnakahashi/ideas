class Public::PostsController < ApplicationController
  def index
    @all_posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.save
    redirect_to post_path(@post.id)
  end

  def edit
  end


  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:image, :title, :introduction, :selling_point, :detail)
    end
end
