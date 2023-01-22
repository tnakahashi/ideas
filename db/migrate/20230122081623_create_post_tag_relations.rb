class CreatePostTagRelations < ActiveRecord::Migration[6.1]
  def change
    create_table :post_tag_relations do |t|

      t.timestamps
    end
  end
end
