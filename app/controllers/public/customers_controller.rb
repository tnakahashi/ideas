class Public::CustomersController < ApplicationController

  # 会員情報の編集・退会を会員本人のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit, :update, :unsubscribe]

  def show
    @customer = Customer.find(params[:id]) 
    if @customer.is_deleted == true
      redirect_to posts_path
      return
    end
    @posts = @customer.post
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    @followings = Relationship.where(follower_id: params[:id]).where.not(followed_id: customer_ids)
    @followers = Relationship.where(followed_id: params[:id]).where.not(follower_id: customer_ids)
    
  end

  def edit
  end

  def update
    if @customer.update(customer_params)
      redirect_to customer_path(@customer), notice: "You have updated your information successfully."
    else
      render :edit, notice: "You have not updated your information."
    end
  end

  # 会員のコメント一覧を表示する
  def customer_comments
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    post_ids = Post.where(customer_id: customer_ids)
    @customer_comments = Comment.where(customer_id: params[:customer_id]).where.not(post_id: post_ids)
    @customer = Customer.find(params[:customer_id])
  end

  # 会員のいいね一覧を表示する
  def customer_favorites
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    post_ids = Post.where(customer_id: customer_ids)
    @customer_favorites = Favorite.where(customer_id: params[:customer_id]).where.not(post_id: post_ids)
    @customer = Customer.find(params[:customer_id])
  end

  def confirm
    @customer = current_customer
  end

  def unsubscribe
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to root_path
  end

private
  # ストロングパラメータ
  def customer_params
    params.require(:customer).permit(:profile_image, :name, :introduction)
  end

  # 会員情報の編集・退会を会員本人のみに制限
  def ensure_customer
    @customer = Customer.find(params[:id])
    redirect_to customer_path(@customer) unless current_customer==@customer
  end
end
