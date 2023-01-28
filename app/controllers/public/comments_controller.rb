class Public::CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = current_customer.comments.new(comment_params)
    @comment.post_id = @post.id
    @comment.save
    redirect_to post_path(@post)
    # if @comment.save
    #   redirect_to post_path(@post)
    # else
    #   @customer = Customer.find(@post.customer_id)
    #   render 'public/posts/show'
    # end
  end

  def destroy
    Comment.find(params[:id]).destroy
    redirect_to request.referer
  end


  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end
