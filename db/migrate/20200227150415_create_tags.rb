class CreateTags < ActiveRecord::Migration[5.1]
  def change
    create_table :tags do |t|
      t.string :name
      t.string :tag_key
      t.integer :tag_type
      t.integer :created_user_id, :limit =>8

      t.timestamps
    end
  end
end
