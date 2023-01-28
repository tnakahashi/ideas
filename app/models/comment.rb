class Comment < ApplicationRecord

  belongs_to :customer
  belongs_to :post
  
  # bodyの文字数は、1文字から100文字まで
  validates :body, length: { minimum: 1, maximum: 100 }
end
