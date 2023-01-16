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

end
