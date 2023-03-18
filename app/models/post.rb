class Post < ApplicationRecord
  belongs_to :customer
  belongs_to :genre
  has_one_attached :image
  has_many :comments, dependent: :destroy
  has_many :commented_customers, through: :comments, source: :customer
  has_many :favorites, dependent: :destroy
  has_many :favorited_customers, through: :favorites, source: :customer
  # postsテーブルから中間テーブルに対する関連付け
  has_many :post_tag_relations, dependent: :destroy
  # postsテーブルから中間テーブルを介してPostsテーブルへの関連付け
  has_many :tags, through: :post_tag_relations, dependent: :destroy

  # titleの文字数は、1文字から50文字まで
  validates :title, length: { minimum: 1, maximum: 50 }
  # introductionの文字数は、1文字から200文字まで
  validates :introduction, length: { minimum: 1, maximum: 200 }
  validates :genre_id, presence: true
  # 投稿のステータスとして、下書き、投稿済みがある
  enum status: { draft: 0, published: 1 }
  validates :status, inclusion: { in: Post.statuses.keys }


 # 削除済みの投稿or退会済みの会員の投稿を非表示に
 def self.hidden
   customer_ids = Customer.where(is_deleted: true).pluck(:id)
   @posts = Post.where(is_deleted: false).where.not(customer_id: customer_ids)
 end

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
  
  # 一週間のいいね数で並び替え
  def self.last_week
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    
    self.includes(:favorites).
      sort_by {|x|
        x.favorites.where(created_at: from...to).size
      }.reverse.take(5)
  end
  
end
