class Public::PostsController < ApplicationController

  # 編集・削除を投稿者のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit, :update, :destroy]

  def index
    @all_posts = Post.published
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def new
    @post = Post.new
    @genres = Genre.all
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      redirect_to post_path(@post.id), notice: "You have created post successfully."
    else
      @all_posts = Post.all
      render :index, notice: "You have not created post successfully."
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "You have updated post successfully."
    else
      render :edit
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  def customer_posts
    @customer_posts = Post.where(customer_id: params[:customer_id]).published
  end


  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:genre_id, :image, :title, :introduction, :selling_point, :detail, :status)
    end

    # 編集・削除を投稿者のみに制限
    def ensure_customer
      @posts = current_customer.post
      @post = @posts.find_by(id: params[:id])
      redirect_to posts_path unless @post
    end
end
