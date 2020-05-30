class CreateArticleIndices < ActiveRecord::Migration[5.1]
  def change
    create_table :article_indices do |t|
      t.integer :article_id, :limit =>8, default: 0
      t.integer :applicant_id, :limit =>8, default: 0

      t.timestamps
    end
  end
end
