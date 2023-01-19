class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      ## 会員・投稿から外部キーを取得し保存するカラム
      t.integer :customer_id, null: false
      t.integer :post_id, null: false
      ## コメント本文を保存するカラム
      t.text :body,  null: false
      ## 非表示フラグを保存するカラム
      t.boolean :is_deleted, null: false, default: "FALSE"
      t.timestamps
    end
  end
end
