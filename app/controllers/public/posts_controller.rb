class Public::PostsController < ApplicationController

  # 編集・削除を投稿者のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit, :update, :destroy]

  def index
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    @all_posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published
  end

  def show
    # 退会済みの会員の投稿をアクセス不可に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    # whereで記述したい時は配列のように番号を記す。findにも変更可能。
    @post = Post.where(id: params[:id]).where.not(customer_id: customer_ids)[0] 
    if @post.blank?
      redirect_to posts_path
      return 
    end
    # @post = Post.find(params[:id])
    @comment = Comment.new
    @customer = Customer.find(@post.customer_id)
  end

  def new
    # 非ログイン時は新規投稿を制限
    redirect_to posts_path unless current_customer
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
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    @customer_posts = Post.where(customer_id: params[:customer_id], is_deleted: false).where.not(customer_id: customer_ids).published
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
