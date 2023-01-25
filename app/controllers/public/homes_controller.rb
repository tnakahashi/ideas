class Public::HomesController < ApplicationController
  def top
    # Postモデル記載のself.last_week参照
    # @ranks = Post.last_week
    to  = Time.current.at_end_of_day
    from  = (to - 6.day).at_beginning_of_day
    
    # ゲームの直近1週間のいいねランキングを取得
    @posts_game = Post.where(genre_id: 1).includes(:favorited_customers).limit(5).
      sort {|a,b| 
        b.favorited_customers.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_customers.includes(:favorites).where(created_at: from...to).size
      }
    
    # 漫画の直近1週間のいいねランキングを取得
    @posts_manga = Post.where(genre_id: 2).includes(:favorited_customers).limit(5).
      sort {|a,b| 
        b.favorited_customers.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_customers.includes(:favorites).where(created_at: from...to).size
      }
    
    # アプリの直近1週間のいいねランキングを取得
    @posts_application = Post.where(genre_id: 3).includes(:favorited_customers).limit(5).
      sort {|a,b| 
        b.favorited_customers.includes(:favorites).where(created_at: from...to).size <=> 
        a.favorited_customers.includes(:favorites).where(created_at: from...to).size
      }
  end
  
end
