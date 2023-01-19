class Admin::CustomersController < ApplicationController
  
  def index
    @all_customers = Customer.all
  end
  
  def show
    @customer = Customer.find(params[:id])
  end

  # 会員のコメント一覧を表示する
  def customer_comments
    @customer_comments = Comment.where(customer_id: params[:customer_id])
    @customer = Customer.find(params[:customer_id])
  end

  # 会員のいいね一覧を表示する
  def customer_favorites
    @customer_favorites = Favorite.where(customer_id: params[:customer_id])
    @customer = Customer.find(params[:customer_id])
  end
    
private
  # ストロングパラメータ
  def customer_params
    params.require(:customer).permit(:profile_image, :name, :introduction)
  end

end
