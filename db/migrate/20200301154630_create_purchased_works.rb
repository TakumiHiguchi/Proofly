class CreatePurchasedWorks < ActiveRecord::Migration[5.1]
  def change
    create_table :purchased_works do |t|
      t.integer :article_id, :limit =>8
      t.integer :user_id, :limit =>8

      t.timestamps
    end
  end
end
