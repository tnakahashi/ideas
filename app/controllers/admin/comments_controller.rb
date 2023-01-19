class Admin::CommentsController < ApplicationController
  def hide
    @comment = Comment.find(params[:comment_id])
    @comment.update(is_deleted: true)
    redirect_to request.referer
  end

  def display
    @comment = Comment.find(params[:comment_id])
    @comment.update(is_deleted: false)
    redirect_to request.referer
  end
end
