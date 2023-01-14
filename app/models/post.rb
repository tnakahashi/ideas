class Post < ApplicationRecord
  belongs_to :customer
  has_one_attached :image
  has_many :comments, dependent: :destroy

  # titleの文字数は、1文字から10文字まで
  validates :title, length: { minimum: 1, maximum: 10 }
end
