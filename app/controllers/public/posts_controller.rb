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
    @post.customer_id = current_customer.id
    if @post.save
      redirect_to post_path(@post.id), notice: "You have created post successfully."
    else
      @all_posts = Post.all
      render :index, notice: "You have not created post successfully."
    end
  end

  def edit
    @post = Post.find(params[:id])
    customer_id = @post.customer_id
    login_customer_id = current_customer.id
    if(customer_id != login_customer_id)
      redirect_to posts_path
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "You have updated post successfully."
    else
      render "edit"
    end
  end


  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:image, :title, :introduction, :selling_point, :detail)
    end
end
