class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      ## 会員・投稿から外部キーを取得し保存するカラム
      t.references :customer, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      ## コメント本文を保存するカラム
      t.text :body,  null: false
      ## 非表示フラグを保存するカラム
      t.boolean :is_deleted, null: false, default: "FALSE"
      t.timestamps
    end
  end
end
