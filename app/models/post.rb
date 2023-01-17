class Post < ApplicationRecord
  belongs_to :customer
  belongs_to :genre
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  # titleの文字数は、1文字から10文字まで
  validates :title, length: { minimum: 1, maximum: 10 }


  # いいね済みか否かを確認する
  def favorited_by?(customer)
    favorites.exists?(customer_id: customer.id)
  end
  
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all
    end
  end
  
end
