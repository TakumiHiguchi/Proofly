class ChangeDataTagToArticle < ActiveRecord::Migration[5.1]
  def change
      change_column :post_tag_relations, :article_id,'bigint USING CAST(article_id AS bigint)'
      change_column :post_tag_relations, :tag_id,'bigint USING CAST(tag_id AS bigint)'
  end
end
