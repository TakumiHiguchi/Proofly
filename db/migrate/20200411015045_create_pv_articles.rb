class CreatePvArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :pv_articles do |t|
      t.integer :article_id, :limit =>8, default: 0
      t.integer :count, :limit =>8, default: 0
      t.string :last_hash

      t.timestamps
    end
  end
end
