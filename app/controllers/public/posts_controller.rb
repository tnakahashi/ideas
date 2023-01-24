class Public::PostsController < ApplicationController

  # 編集・削除を投稿者のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit, :update, :destroy]

  def index
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.order(created_at: :desc)
    end
    
    # タグ追加用
    if params[:tag]
      Tag.create(name: params[:tag])
    end
    
    # タグ検索用
    if params[:tag_ids]
      if params[:type] == "OR検索"
        @posts = []
        params[:tag_ids].each do |key, value|
          @posts += Tag.find_by(name: key).posts.where.not(customer_id: customer_ids).published if value == "1"
        end
        @posts.uniq!
      else
        @posts = []
        params[:tag_ids].each do |key, value|
          if value == "1"
            tag_posts = Tag.find_by(name: key).posts.where.not(customer_id: customer_ids).published
            @posts = @posts.empty? ? tag_posts : @posts & tag_posts
          end
        end
      end
    end
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
    
    # タグ追加用
    if params[:tag]
      Tag.create(name: params[:tag])
      redirect_to new_post_path
    end
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
      params.require(:post).permit(:genre_id, :image, :title, :introduction, :selling_point, :detail, :status, tag_ids: [])
    end

    # 編集・削除を投稿者のみに制限
    def ensure_customer
      @posts = current_customer.post
      @post = @posts.find_by(id: params[:id])
      redirect_to posts_path unless @post
    end
end
