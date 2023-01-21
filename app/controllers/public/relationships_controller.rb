class Public::RelationshipsController < ApplicationController
  # フォローするとき
  def create
    current_customer.follow(params[:customer_id])
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
    current_customer.unfollow(params[:customer_id])
    redirect_to request.referer  
  end
  # フォロー一覧
  def followings
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    customer = Customer.find(params[:customer_id])
    @customers = customer.followings.where.not(id: customer_ids)
  end
  # フォロワー一覧
  def followers
    customer_ids = Customer.where(is_deleted: true).pluck(:id)
    customer = Customer.find(params[:customer_id])
    @customers = customer.followers.where.not(id: customer_ids)
  end
end
