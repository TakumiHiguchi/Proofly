class CreatePostCategoryRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :post_category_relations do |t|
      t.integer :article_id, :limit =>8
      t.integer :category_id, :limit =>8

      t.timestamps
    end
  end
end
