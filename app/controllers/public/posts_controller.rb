class Public::PostsController < ApplicationController

  # 編集・削除を投稿者のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit, :update, :destroy]

  def index
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    
    # タグ検索用
    if params[:tag_ids] == nil || params[:tag_ids].include?("null") 
      @posts = Post.hidden.published.order(created_at: :desc)
    else
      if params[:tag_ids].class == String
        params[:tag_ids] = JSON.parse(params[:tag_ids])
      end
      if params[:type] == "OR検索"
        @posts = []
        params[:tag_ids].each do |key, value|
          @posts += Tag.find_by(name: key).posts.where.not(customer_id: customer_ids).published if value == "1"
        end
        @posts.uniq!# .page(params[:page])
      else
        @posts = []
        params[:tag_ids].each do |key, value|
          if value == "1"
            tag_posts = Tag.find_by(name: key).posts.where.not(customer_id: customer_ids).published
            @posts = @posts.empty? ? tag_posts : @posts & tag_posts
            @posts = @posts.page(params[:page])
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
    @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(8)
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
      if Tag.create(name: params[:tag])
        redirect_to new_post_path
      else
        render :new, notice: "投稿に失敗しました。"
      end
    end
  end

  def create
    @post = Post.new(post_params)
    @post.customer_id = current_customer.id
    if @post.save
      redirect_to post_path(@post.id), notice: "投稿に成功しました。"
    else
      @genres = Genre.all
      render :new, notice: "投稿に失敗しました。"
    end
  end

  def edit
    @genres = Genre.all
    
    # タグ追加用
    if params[:tag]
      Tag.create(name: params[:tag])
      redirect_to edit_post_path(@post)
    end
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post.id), notice: "投稿の更新に成功しました。"
    else
      @genres = Genre.all
      render :edit, notice: "投稿の更新に失敗しました。"
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path
  end

  def customer_posts
    @customer = Customer.find(params[:customer_id])
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @customer_posts = Post.where(customer_id: params[:customer_id]).hidden.published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @customer_posts = Post.where(customer_id: params[:customer_id]).hidden.published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @customer_posts = Post.where(customer_id: params[:customer_id]).hidden.published.order(created_at: :desc)
    end
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
