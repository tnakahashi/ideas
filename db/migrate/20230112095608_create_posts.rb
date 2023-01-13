class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|

      t.string :title,  null: false
      t.text :introduction,  null: false
      t.text :selling_point
      t.text :detail
      t.boolean :is_deleted, null: false, default: "FALSE"
      t.timestamps
    end
  end
end
