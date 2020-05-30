class CreateUserDetails < ActiveRecord::Migration[5.1]
  def change
    create_table :user_details do |t|
      t.string :user_key
      t.string :name
      t.string :bio
      t.string :location
      t.string :website
      t.string :thum1
      t.string :thum2
      t.integer :user_id, :limit =>8
      t.string :status
      
      
      
      t.timestamps
    end
  end
end
