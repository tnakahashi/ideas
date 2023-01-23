class Public::RanksController < ApplicationController
  def rank
    @posts = Post.find(Favorite.group(:post_id).order('count(post_id) desc').pluck(:post_id))
  end
end
