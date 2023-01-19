class CreateFavorites < ActiveRecord::Migration[6.1]
  def change
    create_table :favorites do |t|
      ## 会員・投稿から外部キーを取得し保存するカラム
      t.integer :customer_id, null: false
      t.integer :post_id, null: false

      t.timestamps
    end
  end
end
