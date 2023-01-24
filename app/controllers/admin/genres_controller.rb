class Admin::GenresController < ApplicationController

  def index
    @genre_new = Genre.new
    @genres = Genre.all
  end

  # ジャンル新規作成ページは作らず、一覧ページにジャンル追加機能を表示する
  def create
    genre_new = Genre.new(genre_params)
    if genre_new.save
      redirect_to request.referer
    else
      @genre_new = Genre.new
      @genres = Genre.all
      render "index"
    end
  end

  def edit
    @genre = Genre.find(params[:id])
  end

  def show
    @genre = Genre.find(params[:id])
    # 新着・いいね・コメント数順の並び替え
    if params[:target] == "favorite"
      @posts = Post.where(genre_id: params[:id]).published.sort {|a,b| b.favorited_customers.size <=> a.favorited_customers.size}
    elsif params[:target] == 'comment'
      @posts = Post.where(genre_id: params[:id]).published.sort {|a,b| b.commented_customers.size <=> a.commented_customers.size}
    else
      @posts = Post.where(genre_id: params[:id]).published.order(created_at: :desc)
    end
  end

  def update
    genre = Genre.find(params[:id])
    if genre.update(genre_params)
      redirect_to admin_genres_path(genre)
    else
      @genre = Genre.find(params[:id])
      render "edit"
    end
  end

  def destroy
    genre = Genre.find(params[:id])
    genre
  end

  private

  def genre_params
    params.require(:genre).permit(:genre_name)
  end
end
