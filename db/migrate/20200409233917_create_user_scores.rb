class CreateUserScores < ActiveRecord::Migration[5.1]
  def change
    create_table :user_scores do |t|
      t.integer :user_detail_id, :limit =>8
      t.integer :score, :limit =>8, default: 10

      t.timestamps
    end
  end
end
