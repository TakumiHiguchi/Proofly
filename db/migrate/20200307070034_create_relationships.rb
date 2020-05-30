class CreateRelationships < ActiveRecord::Migration[5.1]
  def change
    create_table :relationships do |t|
      t.references :user_detail, foreign_key: true
      t.references :follow, foreign_key: { to_table: :user_details }

      t.timestamps

      t.index [:user_detail_id, :follow_id], unique: true
    end
  end
end
