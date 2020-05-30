class CreateArticleIndexResults < ActiveRecord::Migration[5.1]
  def change
    create_table :article_index_results do |t|
      t.integer :article_id, :limit =>8
      t.boolean :result, default: false
      t.string  :reason
      t.timestamps
    end
  end
end
