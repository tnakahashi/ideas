class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.integer :customer_id, null: false
      t.integer :genre_id, null: false
      t.string :title,  null: false
      t.text :introduction,  null: false
      t.text :selling_point,  null: false
      t.text :detail,  null: false
      t.integer :status, null: false, default: 0
      t.boolean :is_deleted, null: false, default: "FALSE"
      t.timestamps
    end
  end
end
