class Admin::TagsController < ApplicationController
  def index
  end

  def destroy
    Tag.find(params[:id]).destroy
    redirect_to request.referer
  end
end
