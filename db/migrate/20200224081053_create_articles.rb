class CreateArticles < ActiveRecord::Migration[5.1]
  def change
    create_table :articles do |t|
      t.integer :user_detail_id, :limit =>8
      t.string :key
      t.string :title
      t.string :description
      t.text :content
      t.text :paidcontent
      t.string :article_status
      t.string :thum

      t.timestamps
    end
  end
end
