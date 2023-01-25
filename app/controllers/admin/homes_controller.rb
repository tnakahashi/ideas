class Admin::HomesController < ApplicationController
  def top
    # Postモデル記載のself.last_week参照
    # @ranks = Post.last_week
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    
    # 退会済みの会員の投稿を非表示に
    customer_ids = Customer.where(is_deleted: true).pluck
    
    # 全ての投稿からランダムに5件を取得
    @posts_random = Post.where(is_deleted: false).where.not(customer_id: customer_ids).published.order("RANDOM()").limit(5)
    
    # ゲームの直近1週間のいいねランキングを取得
    @posts_game = Post.where(genre_id: 1, is_deleted: false).where.not(customer_id: customer_ids).includes(:favorited_customers).published.limit(5).
      sort {|a,b| 
        b.favorited_customers.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_customers.includes(:favorites).where(created_at: from...to).size
      }
      
    # ジャンル：ゲームに属する投稿からランダムに5件を取得
    @posts_game_random = Post.where(genre_id: 1, is_deleted: false).where.not(customer_id: customer_ids).published.order("RANDOM()").limit(5)
    
    # 漫画の直近1週間のいいねランキングを取得
    @posts_manga = Post.where(genre_id: 2, is_deleted: false).where.not(customer_id: customer_ids).includes(:favorited_customers).published.limit(5).
      sort {|a,b| 
        b.favorited_customers.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_customers.includes(:favorites).where(created_at: from...to).size
      }
      
    # ジャンル：漫画に属する投稿からランダムに5件を取得
    @posts_manga_random = Post.where(genre_id: 2, is_deleted: false).where.not(customer_id: customer_ids).order("RANDOM()").limit(5)
    
    # アプリの直近1週間のいいねランキングを取得
    @posts_application = Post.where(genre_id: 3, is_deleted: false).where.not(customer_id: customer_ids).includes(:favorited_customers).limit(5).
      sort {|a,b| 
        b.favorited_customers.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_customers.includes(:favorites).where(created_at: from...to).size
      }
      
    # ジャンル：アプリに属する投稿からランダムに5件を取得
    @posts_application_random = Post.where(genre_id: 3, is_deleted: false).where.not(customer_id: customer_ids).published.order("RANDOM()").limit(5)
  end
  
end
