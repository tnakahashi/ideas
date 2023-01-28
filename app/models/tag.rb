class Tag < ApplicationRecord
  #Tagsテーブルから中間テーブルに対する関連付け
  has_many :post_tag_relations, dependent: :destroy
  #Tagsテーブルから中間テーブルを介してPostテーブルへの関連付け
  has_many :posts, through: :post_tag_relations, dependent: :destroy
  # nameの文字数は、1文字から15文字まで
  validates :name, length: { minimum: 1, maximum: 15 }
end
