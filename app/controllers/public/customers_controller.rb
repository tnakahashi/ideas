class Public::CustomersController < ApplicationController

  # 会員情報の編集・退会を会員本人のみに制限(ensure_customerメソッド参照)
  before_action :ensure_customer, only: [:edit, :update, :destroy]

  def show
    @customer = Customer.find(params[:id])
    @posts = @customer.post
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
    @customer_comments = Comment.where(customer_id: params[:customer_id])
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
