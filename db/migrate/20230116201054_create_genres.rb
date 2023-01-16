class CreateGenres < ActiveRecord::Migration[6.1]
  def change
    create_table :genres do |t|

      ## ジャンル名を保存するカラム
      t.string :genre_name
      t.timestamps
    end
  end
end
