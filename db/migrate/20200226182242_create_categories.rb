class CreateCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :cate_key
      t.integer :parent_id, :limit =>8

      t.timestamps
    end
  end
end
