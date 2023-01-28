class Public::DraftsController < ApplicationController

  # 編集・削除を投稿者のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit]

  def index
    @all_drafts = Post.draft.where(customer_id: params[:customer_id] )
  end

  def edit
    @post = Post.find(params[:id])
    @genres = Genre.all
    
    # タグ追加用
    if params[:tag]
      Tag.create(name: params[:tag])
      redirect_to edit_customer_draft_path(@post)
    end
  end

  def update
    if @post.update(post_params)
      redirect_to post_path(@post), notice: "You have updated post successfully."
    else
      render :edit
    end
  end
  
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to customer_drafts_path(current_customer)
  end
    
  

  private
    # ストロングパラメータ
    def post_params
      params.require(:post).permit(:id, :genre_id, :image, :title, :introduction, :selling_point, :detail, :status, tag_ids: [])
    end

    # 編集・削除を投稿者のみに制限
    def ensure_customer
      @posts = current_customer.post
      @post = @posts.find_by(id: params[:id])
      redirect_to posts_path unless @post
    end
end
