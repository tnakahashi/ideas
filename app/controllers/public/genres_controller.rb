class Public::GenresController < ApplicationController

  def index
    @genres = Genre.all
  end

  def show
    @genre = Genre.find(params[:id])
    @posts = Post.where(genre_id: params[:id], is_deleted: false)
  end

end
