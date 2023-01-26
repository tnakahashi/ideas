class Admin::CustomersController < ApplicationController
  
  def index
    @all_customers = Customer.all
  end
  
  def show
    @customer = Customer.find(params[:id])
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    @followings = Relationship.where(follower_id: params[:id]).where.not(followed_id: customer_ids)
    @followers = Relationship.where(followed_id: params[:id]).where.not(follower_id: customer_ids)
  end

  # 会員のコメント一覧を表示する
  def customer_comments
    @customer_comments = Comment.where(customer_id: params[:customer_id], is_deleted: false)
    @customer = Customer.find(params[:customer_id])
  end

  # 会員のいいね一覧を表示する
  def customer_favorites
    @customer_favorites = Favorite.where(customer_id: params[:customer_id])
    @customer = Customer.find(params[:customer_id])
  end

  # 会員を退会させる
  def unsubscribe
    @customer = Customer.find(params[:id])
    @customer.update(is_deleted: true)
    flash[:notice] = "退会処理を実行いたしました"
    redirect_to request.referer
  end

  # 会員を復帰させる
  def subscribe
    @customer = Customer.find(params[:id])
    @customer.update(is_deleted: false)
    flash[:notice] = "復帰処理を実行いたしました"
    redirect_to request.referer
  end

    
private
  # ストロングパラメータ
  def customer_params
    params.require(:customer).permit(:profile_image, :name, :introduction)
  end

end
