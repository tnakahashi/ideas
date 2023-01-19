class Public::DraftsController < ApplicationController
  def index
    @all_drafts = Draft.where(customer_id: params[:id])
  end

  def edit
  end
end
