class Draft < ApplicationRecord
  belongs_to :customer
  belongs_to :genre
  has_one_attached :image
end
