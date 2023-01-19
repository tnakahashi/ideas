class Public::DraftsController < ApplicationController
  def index
    @all_drafts = Post.draft
  end

  def edit
    @post = Post.find(params[:id])
    @genres = Genre.all
  end
end
