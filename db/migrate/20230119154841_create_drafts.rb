class CreateDrafts < ActiveRecord::Migration[6.1]
  def change
    create_table :drafts do |t|
      t.integer :customer_id, null: false
      t.integer :genre_id, null: false
      t.string :title,  null: false
      t.text :introduction,  null: false
      t.text :selling_point
      t.text :detail
      t.timestamps
    end
  end
end
