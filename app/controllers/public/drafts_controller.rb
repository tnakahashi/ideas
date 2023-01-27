class Public::DraftsController < ApplicationController
  def index
    @all_drafts = Post.draft
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
end
